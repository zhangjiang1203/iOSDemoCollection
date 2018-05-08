//
//  EnergyPieView.m
//  YUDOApp
//
//  Created by 高宇飞 on 2017/11/21.
//

#import "EnergyPieView.h"

@implementation EnergyPieView

- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    // Drawing code
    //一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextRef image = (__bridge CGContextRef)(UIGraphicsGetImageFromCurrentImageContext());
    
    
    
    const CGFloat *startColorComponents = CGColorGetComponents(self.startColor.CGColor); //RGB components
    const CGFloat *endColorComponents = CGColorGetComponents(self.endColor.CGColor); //RGB components
    
    CGFloat R, G, B, A;
    //多个小扇形构造渐变的大扇形
    for (int i = 0; i<= self.angle; i++) {
        CGFloat ratio = i/self.angle;
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
        CGContextAddArc(context, self.center.x, self.center.y, self.radius,  i * M_PI / 180-M_PI_2, (i + (self.clockwise?-1:1)) * M_PI / 180+M_PI*2-M_PI_2, self.clockwise);
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFillStroke); //绘制路径
    }
}
@end
