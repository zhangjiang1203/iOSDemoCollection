//
//  ZJCarInfoView.m
//  YUDOApp
//
//  Created by zitang on 2018/5/7.
//

#import "ZJCarInfoView.h"
#import <math.h>

@interface ZJCarInfoView()
{
    CGFloat viewWidth;
    CGFloat viewHeight;
    CGFloat innerRadio; //内圆半径
    CGFloat outterRadio;//外圆半径
    CGFloat textRadio;  //文字半径
    CGPoint viewCenter; //视图中心
}

/**
 显示的底部的路径
 */
@property (nonatomic, strong) CAShapeLayer *bottomLayer;

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
        viewWidth = self.bounds.size.width;
        viewHeight = self.bounds.size.height;
        CGFloat maxRadio = MIN(viewWidth, viewHeight)/2.0;
        textRadio = maxRadio - 20;
        outterRadio = maxRadio - 40;
        innerRadio = maxRadio - 60;
        viewCenter = CGPointMake(viewWidth/2.0, viewHeight/2.0);
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    if (self.topLayer == nil) {
        [self addOutCircle];
        [self customMyPath];
    }
}

#pragma mark -设置颜色的懒加载
-(UIColor *)startColor{
    if (_startColor == nil) {
        _startColor = [UIColor colorWithRed:255/255.0 green:214/255.0 blue:159/255.0 alpha:0.1];
    }
    return _startColor;
}

-(UIColor *)endColor{
    if (_endColor == nil) {
        _endColor = [UIColor colorWithRed:224/255.0 green:197/255.0 blue:159/255.0 alpha:0.8];
    }
    return _endColor;
}

-(UIColor *)dottedColor{
    if (_dottedColor == nil) {
        _dottedColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
    }
    return _dottedColor;
}

-(UIColor *)fullColor{
    if (_fullColor == nil) {
        _fullColor = [UIColor yellowColor];
    }
    return _fullColor;
}

-(UIColor *)textColor{
    if (_textColor == nil) {
        _textColor = [UIColor blackColor];
    }
    return _textColor;
}

#pragma mark -设置里程数和电量的显示
-(void)setBattery:(CGFloat)battery{
    _battery = battery;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setCircleShowPresent:battery/360.0 layer:self.maskLayer path:@"strokeStart" duration:2.5];
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
    self.bottomLayer = [CAShapeLayer layer];
    self.bottomLayer.frame = CGRectMake(0, 0, viewWidth, viewHeight);
    self.bottomLayer.fillColor = [UIColor clearColor].CGColor;//填充颜色
    self.bottomLayer.strokeColor = self.dottedColor.CGColor;//线段颜色
    self.bottomLayer.lineWidth = 1;
    self.bottomLayer.lineJoin = kCALineJoinRound;
    self.bottomLayer.lineDashPattern = @[@6,@2];
    UIBezierPath *bottomPath = [UIBezierPath bezierPathWithArcCenter:viewCenter radius:outterRadio startAngle:0 endAngle:2*M_PI clockwise:YES];
    self.bottomLayer.path = bottomPath.CGPath;
    [self.layer addSublayer:self.bottomLayer];
    
    CAShapeLayer *topLayer = [CAShapeLayer layer];
    topLayer.frame = CGRectMake(0, 0, viewWidth, viewHeight);
    topLayer.fillColor = [UIColor clearColor].CGColor;//填充颜色
    topLayer.strokeColor = self.fullColor.CGColor;//线段颜色
    topLayer.lineWidth = 2;
    topLayer.strokeStart = 0;
    topLayer.strokeEnd = 0.2;
    topLayer.lineJoin = kCALineCapRound;
    UIBezierPath *topPath = [UIBezierPath bezierPathWithArcCenter:viewCenter radius:outterRadio startAngle:M_PI_2 endAngle:1.5*M_PI clockwise:YES];
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
        label.textColor = self.textColor;
        label.font = [UIFont systemFontOfSize:10];
        label.bounds = CGRectMake(0, 0, 20, 20);

        //对应的center
        CGFloat cons = cosf(i*92/180.0+M_PI_2);
        CGFloat sins = sinf(i*92/180.0+M_PI_2);
        CGPoint majorCenter = CGPointMake(viewWidth/2.0+textRadio*cons, viewHeight/2.0+textRadio*sins);
        //减去label高度值得一半
        label.center = CGPointMake(majorCenter.x - 10*cons, majorCenter.y - 10*sins);
        //变换文字的方向
        label.transform = CGAffineTransformRotate(label.transform, (180+degree)/180*M_PI);
        label.text = tempArr[i];
        [self addSubview:label];
    }
}

- (void)customMyPath{
    
    const CGFloat *startColorComponents = CGColorGetComponents(self.startColor.CGColor); //RGB components
    const CGFloat *endColorComponents = CGColorGetComponents(self.endColor.CGColor); //RGB components
    
    CGFloat R, G, B, A;
    //多个小扇形构造渐变的大扇形
    for (int i = 0; i<= 360; i++) {
        CGFloat ratio = i/360.0;
        R = startColorComponents[0] - (startColorComponents[0] - endColorComponents[0])*ratio;
        G = startColorComponents[1] - (startColorComponents[1] - endColorComponents[1])*ratio;
        B = startColorComponents[2] - (startColorComponents[2] - endColorComponents[2])*ratio;
        A = startColorComponents[3] - (startColorComponents[3] - endColorComponents[3])*ratio;
        UIColor *aColor = [UIColor colorWithRed:R green:G blue:B alpha:A];

        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(0, 0, viewWidth, viewHeight);
        layer.fillColor = aColor.CGColor;
        layer.strokeColor = [UIColor clearColor].CGColor;
        layer.lineWidth = 0;
        layer.frame = CGRectMake(0, 0, viewWidth, viewHeight);
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:viewCenter radius:innerRadio startAngle:i*M_PI/180.0-M_PI_2 endAngle: (i+1)*M_PI/180.0-M_PI_2 clockwise:YES];
        [path addLineToPoint:viewCenter];
        
        layer.path = [path CGPath];
        [self.layer addSublayer:layer];
    }
    
    //构造一个大的扇形覆盖创建的扇形
    _maskLayer = [CAShapeLayer layer];
    _maskLayer.frame = CGRectMake(0, 0, viewWidth, viewHeight);
    _maskLayer.fillColor = [UIColor clearColor].CGColor;
    _maskLayer.strokeColor = [UIColor whiteColor].CGColor;
    _maskLayer.lineWidth = innerRadio;
    _maskLayer.strokeStart = 0;
    _maskLayer.strokeEnd = 1.0;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    [maskPath addArcWithCenter:viewCenter radius:innerRadio/2.0 startAngle:-M_PI_2 endAngle: (360+1)*M_PI/180.0-M_PI_2 clockwise:YES];
//    [maskPath addLineToPoint:self.center];
    _maskLayer.path = [maskPath CGPath];
    [self.layer addSublayer:_maskLayer];

}

/**
 设置动画

 @param end 结束值
 @param layer 动画图层
 @param keyPath 动画路径
 @param duration 动画时间
 */
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
