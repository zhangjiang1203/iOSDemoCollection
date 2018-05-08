//
//  ZJCarInfoView.m
//  YUDOApp
//
//  Created by zitang on 2018/5/7.
//

#import "ZJCarInfoView.h"
#import <math.h>

#define KInnerRadio 100
#define KOutterRadio 120
#define KTextRadio 140
#define KPadding 10
#define KStartColor [UIColor colorWithRed:255/255.0 green:214/255.0 blue:159/255.0 alpha:0.1]
#define KEndColor [UIColor colorWithRed:224/255.0 green:197/255.0 blue:159/255.0 alpha:0.8]

@interface ZJCarInfoView()
@property (nonatomic, assign) CGFloat radius;           //半径

/**
 显示可行驶公里数
 */
@property (nonatomic, strong) CAShapeLayer *topLayer;

/**
 添加遮罩图层
 */
@property (nonatomic, strong) CAShapeLayer *maskLayer;

@end

@implementation ZJCarInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)setBattery:(CGFloat)battery{
    _battery = battery;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setCircleShowPresent:1 layer:self.maskLayer path:@"strokeStart" duration:2.5];
    });
}

-(void)setMileage:(CGFloat)mileage{
    _mileage = mileage;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setCircleShowPresent:self.mileage layer:self.topLayer path:@"strokeEnd" duration:2.5];
    });
}

#pragma mark -添加显示的外环虚线和实线
- (void)addOutCircle{
    CAShapeLayer *bottomLayer = [CAShapeLayer layer];
    bottomLayer.bounds = self.bounds;
    bottomLayer.position = self.center;
    bottomLayer.fillColor = [UIColor clearColor].CGColor;//填充颜色
    bottomLayer.strokeColor = [[UIColor blackColor]colorWithAlphaComponent:0.3].CGColor;//线段颜色
    bottomLayer.lineWidth = 1;
    bottomLayer.lineJoin = kCALineJoinRound;
    bottomLayer.lineDashPattern = @[@6,@2];
    UIBezierPath *bottomPath = [UIBezierPath bezierPathWithArcCenter:self.center radius:KOutterRadio startAngle:0 endAngle:2*M_PI clockwise:YES];
    bottomLayer.path = bottomPath.CGPath;
    [self.layer addSublayer:bottomLayer];
    
    CAShapeLayer *topLayer = [CAShapeLayer layer];
    topLayer.bounds = self.bounds;
    topLayer.position = self.center;
    topLayer.fillColor = [UIColor clearColor].CGColor;//填充颜色
    topLayer.strokeColor = [UIColor yellowColor].CGColor;//线段颜色
    topLayer.lineWidth = 2;
    topLayer.strokeStart = 0;
    topLayer.strokeEnd = 0.2;
    topLayer.lineJoin = kCALineCapRound;
    UIBezierPath *topPath = [UIBezierPath bezierPathWithArcCenter:self.center radius:KOutterRadio startAngle:M_PI_2 endAngle:1.5*M_PI clockwise:YES];
    topLayer.path = topPath.CGPath;
    self.topLayer = topLayer;
    [self.layer addSublayer:self.topLayer];
    
    //添加文字显示
    NSArray *tempArr = @[@"0",@"60",@"120",@"180",@"240",@"300",@"360"];
    CGFloat singleAngle = (180.0)/(tempArr.count - 1);
    CGFloat startDegree = 0;
    for (int i = 0; i < 7; i++) {
        CGFloat degree = startDegree + i * singleAngle;
        UILabel *label = [UILabel new];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:10];
        label.bounds = CGRectMake(0, 0, 20, 20);

        //对应的center
        CGFloat cons = cosf(i*92/180.0+M_PI_2);
        CGFloat sins = sinf(i*92/180.0+M_PI_2);
        CGPoint majorCenter = CGPointMake(self.center.x+KTextRadio*cons, self.center.y+KTextRadio*sins);
        //减去label高度值得一半
        label.center = CGPointMake(majorCenter.x - 10*cons, majorCenter.y - 10*sins);
        //变换文字的方向
        label.transform = CGAffineTransformRotate(label.transform, (180+degree)/180*M_PI);
        label.text = tempArr[i];
        [self addSubview:label];
    }

}

#pragma mark -设置显示的内圈渐变视图
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.topLayer == nil) {
        [self addOutCircle];
        [self customMyPath];
    }
}

- (void)customMyPath{
    
    const CGFloat *startColorComponents = CGColorGetComponents(KStartColor.CGColor); //RGB components
    const CGFloat *endColorComponents = CGColorGetComponents(KEndColor.CGColor); //RGB components
    
    CGFloat R, G, B, A;
    //多个小扇形构造渐变的大扇形
    for (int i = 0; i<= self.battery; i++) {
        CGFloat ratio = i/self.battery;
        R = startColorComponents[0] - (startColorComponents[0] - endColorComponents[0])*ratio;
        G = startColorComponents[1] - (startColorComponents[1] - endColorComponents[1])*ratio;
        B = startColorComponents[2] - (startColorComponents[2] - endColorComponents[2])*ratio;
        A = startColorComponents[3] - (startColorComponents[3] - endColorComponents[3])*ratio;
        UIColor *aColor = [UIColor colorWithRed:R green:G blue:B alpha:A];

        CAShapeLayer *layer1 = [CAShapeLayer layer];
        layer1.fillColor = aColor.CGColor;
        layer1.strokeColor = [UIColor clearColor].CGColor;
        layer1.lineWidth = 0;
        layer1.strokeStart = 0;
        layer1.strokeEnd = 0;
        layer1.bounds = self.bounds;
        layer1.position = self.center;
        layer1.lineJoin = @"bevel";
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:self.center radius:KInnerRadio startAngle:i*M_PI/180.0-M_PI_2 endAngle: (i+1)*M_PI/180.0-M_PI_2 clockwise:YES];
        [path addLineToPoint:self.center];
        
        layer1.path = [path CGPath];
        [self.layer addSublayer:layer1];
    }
    
    //构造一个大的扇形覆盖创建的扇形
    _maskLayer = [CAShapeLayer layer];
    _maskLayer.fillColor = [UIColor clearColor].CGColor;
    _maskLayer.strokeColor = [UIColor whiteColor].CGColor;
    _maskLayer.lineWidth = 100;
    _maskLayer.strokeStart = 0;
    _maskLayer.strokeEnd = 1.0;
    _maskLayer.bounds = self.bounds;
    _maskLayer.position = self.center;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    [maskPath addArcWithCenter:self.center radius:50 startAngle:-M_PI_2 endAngle: (self.battery+1)*M_PI/180.0-M_PI_2 clockwise:YES];
//    [maskPath addLineToPoint:self.center];
    _maskLayer.path = [maskPath CGPath];
    [self.layer addSublayer:_maskLayer];

}

-(void)setCircleShowPresent:(CGFloat)end layer:(CAShapeLayer*)layer path:(NSString*)keyPath duration:(CGFloat)duration{
    CABasicAnimation *pathAnima = [CABasicAnimation animationWithKeyPath:keyPath];
    pathAnima.duration = duration;
    pathAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnima.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnima.toValue = [NSNumber numberWithFloat:end];
    pathAnima.fillMode = kCAFillModeForwards;
    pathAnima.removedOnCompletion = NO;
    [layer addAnimation:pathAnima forKey:[NSString stringWithFormat:@"%@Annomation",keyPath]];
}
@end
