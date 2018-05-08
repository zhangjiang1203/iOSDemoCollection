//
//  EnergyPieView.h
//  YUDOApp
//
//  Created by 高宇飞 on 2017/11/21.
//

#import <UIKit/UIKit.h>

@interface EnergyPieView : UIView
@property (nonatomic, assign) CGFloat radius;           //半径
@property (nonatomic, strong) UIColor *startColor;      //渐变开始颜色
@property (nonatomic, strong) UIColor *endColor;        //渐变结束颜色
@property (nonatomic, assign) CGFloat angle;            //渐变角度
@property (nonatomic, assign) BOOL clockwise;           //是否顺时针
@property (nonatomic, assign) CGFloat progress;
@end
