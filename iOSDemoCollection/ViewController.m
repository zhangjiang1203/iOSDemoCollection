//
//  ViewController.m
//  iOSDemoCollection
//
//  Created by zitang on 2018/5/7.
//  Copyright © 2018年 zitang. All rights reserved.
//

#import "ViewController.h"
#import "ZJCarInfoView.h"

@interface ViewController ()
/**
 layer
 */
@property (nonatomic, strong) ZJCarInfoView *showView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showView = [[ZJCarInfoView alloc]initWithFrame:CGRectMake(40, 200, 200, 200)];
    self.showView.dottedColor = [UIColor redColor];
    self.showView.textColor = [UIColor redColor];
    [self.view addSubview:self.showView];
    
}
- (IBAction)addLayer:(id)sender {
    
    self.showView.battery = 300;
    self.showView.mileage = 0.8;

}

@end
