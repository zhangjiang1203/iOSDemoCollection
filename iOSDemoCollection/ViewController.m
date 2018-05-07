//
//  ViewController.m
//  iOSDemoCollection
//
//  Created by zitang on 2018/5/7.
//  Copyright © 2018年 zitang. All rights reserved.
//

#import "ViewController.h"
#import "ZJCarInfoView.h"
//#import "EnergyPieView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setMyCustomLayer];
    
}

- (void)setMyCustomLayer{
    ZJCarInfoView *layer = [[ZJCarInfoView alloc]initWithFrame:CGRectZero];
    layer.frame = self.view.bounds;
    [self.view addSubview:layer];
    layer.battery = 300;

    layer.mileage = 0.8;
    //    [UIView animateWithDuration:1.5 animations:^{
////        layer.angle = 300;
//    }];
//    EnergyPieView *indicatorView = [[EnergyPieView alloc] init];
//    indicatorView.frame = CGRectMake(10, 100, 300, 400);
//    [self.view addSubview:indicatorView];
//    [self.cycleView addSubview:indicatorView];
//    [indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view.mas_centerX);
//        make.centerY.equalTo(self.view.mas_centerY).offset(-5);
//        make.width.height.equalTo([NSNumber numberWithInteger: centerViewWidth]);
//    }];
//    indicatorView = indicatorView;
//    indicatorView.backgroundColor = [UIColor clearColor];
//    indicatorView.radius = 84;
//    indicatorView.angle = 300 ;
//    indicatorView.clockwise = 1;
//    indicatorView.startColor = [UIColor colorWithRed:255/255.0 green:214/255.0 blue:159/255.0 alpha:0.1];
//    indicatorView.endColor = [UIColor colorWithRed:224/255.0 green:197/255.0 blue:159/255.0 alpha:0.8];
}

@end
