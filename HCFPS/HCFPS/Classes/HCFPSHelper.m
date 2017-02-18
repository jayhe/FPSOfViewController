//
//  HCFPSHelper.m
//  BigFan
//
//  Created by hechao on 16/12/2.
//  Copyright © 2016年 hc. All rights reserved.
//

#import "HCFPSHelper.h"
#import <QuartzCore/QuartzCore.h>

NSString *const HC_FPS_MIN_KEY  = @"min_fps";
NSString *const HC_FPS_KEY      = @"all_fps";

@interface HCFPSHelper()

@property (strong, nonatomic) CADisplayLink *link;
@property (assign, nonatomic) NSUInteger screenRefreshCount;//1s屏幕刷新的次数
@property (assign, nonatomic) NSTimeInterval lastTime;
@property (strong, nonatomic) NSMutableDictionary *fpsDic;
@property (strong, nonatomic) NSMutableString *fpsString;
@property (assign, nonatomic) float minFps;

@end

@implementation HCFPSHelper

static id singleton;
static dispatch_once_t onceToken;

+ (instancetype)sharedInstance
{
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initDisplayLink];
        [self initData];
    }
    return self;
}

- (void)initDisplayLink
{
    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)initData
{
    _fpsDic = [NSMutableDictionary dictionary];
    
}

- (void)tick:(CADisplayLink *)link
{
    //iPhone 默认是60HZ，每秒刷新60次
    if (_lastTime == 0)
    {
        _lastTime = link.timestamp;
        return;
    }
    
    _screenRefreshCount++;
    //每两次屏幕刷新的时间间隔
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) return;
    _lastTime = link.timestamp;
    float fps = _screenRefreshCount / delta;
    _screenRefreshCount = 0;
    [self.fpsString appendString:[NSString stringWithFormat:@"%.1f,",fps]];
    self.minFps = ((self.minFps < fps)? self.minFps : fps);
}

- (void)enterPage:(NSString *)pageClass
{
    self.fpsString = [[NSMutableString alloc] init];
    self.minFps = 60;
}

- (void)leavePage:(NSString *)pageClass
{
    //onceToken = 0;//将onceToken置为非－1的值，就还会执行once里面的代码
    //一个界面只统计一次，如果要追加统计需要每次取出上一次的统计，然后做追加。
    if (self.fpsDic[pageClass])
    {
        return;
    }else
    {
        [self.fpsDic setValue:@{HC_FPS_KEY:self.fpsString,HC_FPS_MIN_KEY:[NSString stringWithFormat:@"%.1f",self.minFps]} forKey:pageClass];
        [self wirteToFile];
    }
}

- (void)wirteToFile
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.fpsDic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSMutableString *filePath = [self fpsCachePath];
        
        [jsString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    });
}

- (NSMutableString *)fpsCachePath
{
    NSMutableString *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0].mutableCopy;
    [filePath appendString:@"/fps.txt"];
    
    return filePath;
}

- (NSArray<HCFPSModel *> *)fps
{
    NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
    NSString *jsString = [NSString stringWithContentsOfFile:[self fpsCachePath] encoding:NSUTF8StringEncoding error:nil];
    if (jsString && jsString.length)
    {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[jsString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSDictionary *obj, BOOL * _Nonnull stop) {
            HCFPSModel *model = [[HCFPSModel alloc] init];
            model.vcName = key;
            [model setModelWithDic:obj];
            [tmpArray addObject:model];
        }];
    }
    
    return tmpArray;
}

@end

@implementation HCFPSModel

- (void)setModelWithDic:(NSDictionary *)dic
{
    self.minFps = [dic[HC_FPS_MIN_KEY] floatValue];
    NSMutableString *fpsString = ((NSString *)dic[HC_FPS_KEY]).mutableCopy;
    if (fpsString.length > 1)
    {
        fpsString = [fpsString substringToIndex:fpsString.length - 1].mutableCopy;
        NSArray *fpsArray = [fpsString componentsSeparatedByString:@","];
        self.items = fpsArray;
        __block CGFloat total;
        [fpsArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            total += obj.floatValue;
        }];
        self.averageFps = total/self.items.count;
    }
}

@end
