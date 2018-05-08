//
//  ZJCarInfoView.h
//  YUDOApp
//
//  Created by zitang on 2018/5/7.
//

#import <UIKit/UIKit.h>

@interface ZJCarInfoView : UIView

/**
 底部虚线显示颜色
 */
@property (nonatomic, strong) UIColor *dottedColor;

/**
 显示实线的颜色
 */
@property (nonatomic, strong) UIColor *fullColor;

#pragma mark -绘制仪表盘的初始颜色和结束颜色以及文字颜色,
/**
 开始颜色
 */
@property (nonatomic, strong) UIColor *startColor;

/**
 结束颜色
 */
@property (nonatomic, strong) UIColor *endColor;

/**
 仪表盘显示的文字的颜色
 */
@property (nonatomic, strong) UIColor *textColor;

/**
 汽车剩余电量（范围是0-360，如果是百分数 * 360 在赋值）
 */
@property (nonatomic, assign) CGFloat battery;

/**
 汽车可行驶里程数 接收百分数，除以总公里数 设置stokeEnd显示
 */
@property (nonatomic, assign) CGFloat mileage;



@end
