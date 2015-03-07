

#import "KDGoalBarPercentLayer.h"

#define toRadians(x) ((x)*M_PI / 180.0)
#define toDegrees(x) ((x)*180.0 / M_PI)
#define innerRadius    45.5
#define outerRadius    70.5

@implementation KDGoalBarPercentLayer
@synthesize percent;

-(void)drawInContext:(CGContextRef)ctx {
    [self DrawRight:ctx];
    [self DrawLeft:ctx];
    
}
-(void)DrawRight:(CGContextRef)ctx {
    CGPoint center = CGPointMake(self.frame.size.width / (2), self.frame.size.height / (2));
    
    CGFloat delta = -toRadians(360 * percent);

    
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:232/255.0f green:76/255.0f blue:61/255.0f alpha:100.0f].CGColor);
    
    CGContextSetLineWidth(ctx, 1);
    
    CGContextSetLineCap(ctx, kCGLineCapRound);
    
    CGContextSetAllowsAntialiasing(ctx, YES);
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathAddRelativeArc(path, NULL, center.x, center.y, innerRadius, -(M_PI / 2), delta);
    CGPathAddRelativeArc(path, NULL, center.x, center.y, outerRadius, delta - (M_PI / 2), -delta);
    CGPathAddLineToPoint(path, NULL, center.x, center.y-innerRadius);
    
    CGContextAddPath(ctx, path);
    CGContextFillPath(ctx);
    
    CFRelease(path);
}

-(void)DrawLeft:(CGContextRef)ctx
{

    CGPoint center = CGPointMake(self.frame.size.width / (2), self.frame.size.height / (2));
    
    CGFloat delta = toRadians(360 * (1-percent));
    if (self.chekforNoTransaction)
    {
         CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:100.0].CGColor);
    }
    else
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:53/255.0 green:152/255.0 blue:219/255.0 alpha:100.0].CGColor);

    
    CGContextSetLineWidth(ctx, 1);
    
    CGContextSetLineCap(ctx, kCGLineCapRound);
    
    CGContextSetAllowsAntialiasing(ctx, YES);
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathAddRelativeArc(path, NULL, center.x, center.y, innerRadius, -(M_PI / 2), delta);
    CGPathAddRelativeArc(path, NULL, center.x, center.y, outerRadius, delta - (M_PI / 2), -delta);
    CGPathAddLineToPoint(path, NULL, center.x, center.y-innerRadius);
    
    CGContextAddPath(ctx, path);
    CGContextFillPath(ctx);
    
    CFRelease(path);
}

@end
