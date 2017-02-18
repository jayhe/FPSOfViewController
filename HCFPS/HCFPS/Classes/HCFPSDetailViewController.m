//
//  HCFPSDetailViewController.m
//  BigFan
//
//  Created by hechao on 16/12/2.
//  Copyright © 2016年 hc. All rights reserved.
//

#import "HCFPSDetailViewController.h"
#import "UIViewController+FPS.h"
#import "HCFPSHelper.h"
#import "SCChart.h"

@interface HCFPSDetailViewController ()<SCChartDataSource>

@property (strong, nonatomic) HCFPSModel *model;
@property (strong, nonatomic) UIScrollView *containerView;
@property (strong, nonatomic) SCChart *chartView;

@end

@implementation HCFPSDetailViewController

#pragma mark - Life Cycle

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
    [self setupUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Action



#pragma mark - Http



#pragma mark - DZNEmptyDataSetDelegate

#pragma mark - SCChartDataSource

- (NSArray *)getXTitles:(NSInteger)num
{
    NSMutableArray *xTitles = [NSMutableArray array];
    for (int i = 0; i < num; i++)
    {
        NSString *str = [NSString stringWithFormat:@"%d",i+1];
        [xTitles addObject:str];
    }
    return xTitles;
}

//横坐标标题数组
- (NSArray *)SCChart_xLableArray:(SCChart *)chart
{
    return [self getXTitles:_model.items.count];
}

//数值多重数组
- (NSArray *)SCChart_yValueArray:(SCChart *)chart
{
    NSMutableArray *ary = [NSMutableArray array];
    for (NSInteger i = 0; i < _model.items.count; i++)
    {
        NSString *str = _model.items[i];
        [ary addObject:str];
    }
    return @[ary];
}

#pragma mark 折线图专享功能
//标记数值区域
- (CGRange)SCChartMarkRangeInLineChart:(SCChart *)chart
{
    return CGRangeZero;
}

//判断显示横线条
- (BOOL)SCChart:(SCChart *)chart ShowHorizonLineAtIndex:(NSInteger)index
{
    return YES;
}

//判断显示最大最小值
- (BOOL)SCChart:(SCChart *)chart ShowMaxMinAtIndex:(NSInteger)index
{
    return NO;
}

#pragma mark - Private Methods

- (void)loadData
{
    _model = self.params[@"model"];
}

#pragma mark - UI

- (void)setupUI
{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.title = _model.vcName;
    
    [self.view addSubview:self.containerView];
    
    CGFloat width = (_model.items.count * 20.0 > (self.view.frame.size.width - 20))?_model.items.count * 20.0:(self.view.frame.size.width - 20);
    _chartView = [[SCChart alloc] initwithSCChartDataFrame:CGRectMake(10, 0, width, 150)
                                               withSource:self
                                                withStyle:SCChartLineStyle];
    [_chartView showInView:self.containerView];
    
    _containerView.contentSize = CGSizeMake(_chartView.frame.size.width + 20, 150);
}

#pragma mark - Getter && Setter

- (UIScrollView *)containerView
{
    if (!_containerView)
    {
        _containerView = [[UIScrollView alloc] init];
        _containerView.frame = CGRectMake(0, (self.view.frame.size.height - 150) / 2, [UIScreen mainScreen].bounds.size.width, 150);
    }
    return _containerView;
}

@end
