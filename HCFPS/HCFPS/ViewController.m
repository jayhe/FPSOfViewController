//
//  ViewController.m
//  HCFPS
//
//  Created by hechao on 16/12/7.
//  Copyright © 2016年 hc. All rights reserved.
//

#import "ViewController.h"
#import "HCFPSListViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.title = @"FPS";
    NSInteger j = 0;
    for (NSInteger i = 0; i < 100000; i ++)
    {
        j += i*i;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)fpsAction:(UIButton *)sender
{
    HCFPSListViewController *listVC = [[HCFPSListViewController alloc] init];
    [self.navigationController pushViewController:listVC animated:YES];
}

@end
