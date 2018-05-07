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
@property (nonatomic, strong) CAShapeLayer *topLayer;

@end

@implementation ZJCarInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.battery = 0;
        self.radius = 100;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)setBattery:(CGFloat)battery{
    _battery = battery;
    [self setNeedsDisplay];
}

-(void)setMileage:(CGFloat)mileage{
    _mileage = mileage;
//    self.topLayer.strokeEnd = _mileage;
     [self setCircleShowPresent];
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
    // Drawing code
    //一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
    CGContextRef context = UIGraphicsGetCurrentContext();
    
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
        //画扇形，也就画圆，只不过是设置角度的大小，形成一个扇形
        UIColor *aColor = [UIColor colorWithRed:R green:G blue:B alpha:A];
        
        CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
        CGContextSetLineWidth(context, 0);//线的宽度
        //以self.radius为半径围绕圆心画指定角度扇形
        CGContextMoveToPoint(context, self.center.x, self.center.y);
        CGContextAddArc(context, self.center.x, self.center.y, KInnerRadio,  i * M_PI / 180-M_PI_2, (i-1) * M_PI / 180+M_PI*2-M_PI_2, YES);
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFillStroke); //绘制路径
    }
    [self addOutCircle];
}

-(void) setCircleShowPresent{
    CABasicAnimation *pathAnima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnima.duration = 3.0f;
    pathAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnima.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnima.toValue = [NSNumber numberWithFloat:self.mileage];
    pathAnima.fillMode = kCAFillModeForwards;
    pathAnima.removedOnCompletion = NO;
    [self.topLayer addAnimation:pathAnima forKey:@"strokeEndAnimation"];
}
@end
