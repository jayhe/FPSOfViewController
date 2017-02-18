//
//  HCFPSHelper.h
//  BigFan
//
//  Created by hechao on 16/12/2.
//  Copyright © 2016年 hc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class HCFPSModel;

@interface HCFPSHelper : NSObject

+ (instancetype)sharedInstance;

- (void)enterPage:(NSString *)pageClass;

- (void)leavePage:(NSString *)pageClass;

- (void)wirteToFile;

/**
 返回已经统计的fps数据

 @return fps array
 */
- (NSArray <HCFPSModel *>*)fps;

@end

@interface HCFPSModel : NSObject

@property (strong, nonatomic) NSArray *items;
@property (assign, nonatomic) CGFloat averageFps;
@property (assign, nonatomic) CGFloat minFps;
@property (copy, nonatomic) NSString *vcName;

- (void)setModelWithDic:(NSDictionary *)dic;

@end
