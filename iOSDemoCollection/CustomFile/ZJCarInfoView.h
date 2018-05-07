//
//  ZJCarInfoView.h
//  YUDOApp
//
//  Created by zitang on 2018/5/7.
//

#import <UIKit/UIKit.h>

@interface ZJCarInfoView : UIView

/**
 汽车剩余电量（范围是0-360，如果是百分数 * 360 在赋值）
 */
@property (nonatomic, assign) CGFloat battery;

/**
 汽车可行驶里程数 接收百分数，除以总公里数 设置stokeEnd显示
 */
@property (nonatomic, assign) CGFloat mileage;

@end
