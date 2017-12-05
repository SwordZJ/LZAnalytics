//
//  ViewController.m
//  LZAnalyticsKit
//
//  Created by LeoZ on 2017/12/4.
//  Copyright © 2017年 LZAnalytics. All rights reserved.
//

#import "ViewController.h"




@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)rightItemClick:(id)sender {
    NSLog(@"导航Item点击事件");
}

- (IBAction)buttonClick:(id)sender {
    NSLog(@"按钮点击事件");
}


- (IBAction)sliderAction:(id)sender {
    NSLog(@"进度条滚动事件");
}

- (IBAction)stepperChange:(id)sender {
    NSLog(@"添加or减少事件");
}

- (IBAction)segmentChange:(id)sender {
    NSLog(@"segment切换事件");
}

- (IBAction)switchClick:(id)sender {
    NSLog(@"开关事件");
}

- (IBAction)editStateChange:(id)sender {
    NSLog(@"输入事件");
}

@end
