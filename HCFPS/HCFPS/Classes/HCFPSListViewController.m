//
//  HCFPSListViewController.m
//  BigFan
//
//  Created by hechao on 16/12/2.
//  Copyright © 2016年 hc. All rights reserved.
//

#import "HCFPSListViewController.h"
#import "UIViewController+FPS.h"
#import "HCFPSDetailViewController.h"
#import "HCFPSHelper.h"

@interface HCFPSListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *fpsTable;
@property (strong, nonatomic) NSArray <HCFPSModel *>*fpsList;

@end

@implementation HCFPSListViewController

#pragma mark - Life Cycle

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Action



#pragma mark - Http



#pragma mark - DZNEmptyDataSetDelegate

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _fpsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fps_cell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"fps_cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    HCFPSModel *model = _fpsList[indexPath.row];
    cell.textLabel.text = model.vcName;
    if (model.minFps < 40.0)
    {
        cell.textLabel.textColor = [UIColor redColor];
        cell.detailTextLabel.textColor = [UIColor redColor];
    }else
    {
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"最小:%.1f 平均:%.1f",model.minFps,model.averageFps];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HCFPSModel *model = _fpsList[indexPath.row];
    HCFPSDetailViewController *detailVC = [[HCFPSDetailViewController alloc] init];
    detailVC.params = @{@"model":model};
    if (self.navigationController)
    {
        [self.navigationController pushViewController:detailVC animated:YES];
    }else
    {
        [self presentViewController:detailVC animated:YES completion:nil];
    }
}

#pragma mark - Private Methods

- (void)loadData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _fpsList = [[HCFPSHelper sharedInstance] fps];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_fpsTable reloadData];
        });
    });
}

#pragma mark - UI

- (void)setupUI
{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.title = @"最小fps小于40会标记红色";
    
    [self loadTable];
}

- (void)loadTable
{
    _fpsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    _fpsTable.dataSource = self;
    _fpsTable.delegate = self;
    _fpsTable.rowHeight = 60;
    _fpsTable.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:_fpsTable];
    
}

#pragma mark - Getter && Setter




@end
