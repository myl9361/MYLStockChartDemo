//
//  TipBoardView.m
//  ChartDemo
//
//  Created by xdliu on 16/8/16.
//  Copyright © 2016年 taiya. All rights reserved.
//

#import "TipBoardView.h"

#define kPopupTriangleHeigh 8
#define kPopupTriangleWidth 5
#define kBorderOffset       0.5f

@interface TipBoardView ()

@property (nonatomic) BOOL arrowInLeft;

@property (nonatomic) CGPoint tipPoint;

@end

@implementation TipBoardView

#pragma mark - public methods

- (void)drawInContext {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect rrect = CGRectMake(0.5, 0.5, self.bounds.size.width-1, self.bounds.size.height-1);
    
    CGFloat minx = CGRectGetMinX(rrect), maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
    
    CGFloat startMoveX = !self.arrowInLeft ? self.triangleWidth : maxx - self.triangleWidth;
    CGMutablePathRef path = CGPathCreateMutable();;
    CGPathMoveToPoint(path, NULL, startMoveX, midy - self.triangleWidth);
    CGPathAddLineToPoint(path, NULL, (!self.arrowInLeft ? minx : maxx), midy);
    CGPathAddLineToPoint(path, NULL, startMoveX, midy + self.triangleWidth);
    
    CGPoint p1 = !self.arrowInLeft ? CGPointMake(self.triangleWidth, midy + self.triangleWidth) : CGPointMake(maxx - self.triangleWidth, midy + self.triangleWidth);
    CGPoint p2 = !self.arrowInLeft ? CGPointMake(self.triangleWidth, maxy) : CGPointMake(maxx - self.triangleWidth, maxy);
    CGPoint p3 = !self.arrowInLeft ? CGPointMake(maxx, maxy) : CGPointMake(minx, maxy);
    CGPoint p4 = !self.arrowInLeft ? CGPointMake(maxx, miny) : CGPointMake(minx, miny);
    CGPoint p5 = !self.arrowInLeft ? CGPointMake(self.triangleWidth, miny) : CGPointMake(maxx - self.triangleWidth, miny);
    CGPoint p6 = !self.arrowInLeft ? CGPointMake(self.triangleWidth, midy - self.triangleWidth) : CGPointMake(maxx - self.triangleWidth, midy - self.triangleWidth);
    NSArray *points = @[NSStringFromCGPoint(p1), NSStringFromCGPoint(p2),NSStringFromCGPoint(p3),NSStringFromCGPoint(p4),NSStringFromCGPoint(p5), NSStringFromCGPoint(p6)];
    
    for (int i = 0; i < points.count - 1; i ++) {
        p1 = CGPointFromString(points[i]);
        p2 = CGPointFromString(points[i + 1]);
        CGPathAddArcToPoint(path, NULL, p1.x, p1.y, p2.x, p2.y, self.radius);
    }
    CGPathCloseSubpath(path);
    CGContextAddPath(context, path);
    
    CGContextSetLineWidth(context, 1.0);
    CGContextSetFillColorWithColor(context, self.fillColor.CGColor);
    CGContextSetStrokeColorWithColor(context, self.strockColor.CGColor);
    
    CGContextDrawPath(context, kCGPathFillStroke);
    CGPathRelease(path);
}

- (void)showWithTipPoint:(CGPoint)point {
    self.hidden = NO;
    [self.layer removeAllAnimations];
    
    CGRect rect = self.superview.frame;
    if ((CGPointEqualToPoint(self.tipPoint, point))) {
        return;
    }
    self.arrowInLeft = NO;
    CGRect frame = self.frame;
    
    if (point.x > rect.origin.x && point.x < rect.origin.x + frame.size.width + 20.0f + 2) {
        frame.origin.x = point.x + 2;
    } else if (point.x > rect.origin.x + rect.size.width - frame.size.width - 20.0f - 2) {
        frame.origin.x = point.x - frame.size.width - 2;
        self.arrowInLeft = YES;
    }else if (point.x < (rect.origin.x + rect.size.width - frame.size.width - 20 - 2) && point.x > (rect.origin.x + frame.size.width + 20 + 2)) {
        if (CGPointEqualToPoint(self.tipPoint, CGPointZero)) {
            if (point.x - rect.origin.x > rect.size.width/2.0) {
                frame.origin.x = point.x - frame.size.width - 2;
                self.arrowInLeft = YES;
            } else {
                frame.origin.x = point.x + 2;
            }
        } else {
            if (self.tipPoint.x < point.x) {
                frame.origin.x = point.x - frame.size.width - 2;
                self.arrowInLeft = YES;
            } else {
                frame.origin.x = point.x + 2;
            }
        }
        
    }
    
    frame.origin.y = point.y;    
    self.tipPoint = point;
    self.frame = frame;
    [self setNeedsDisplay];
}

- (void)hide {
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = self.hideDuration;
    animation.startProgress = 0.0;
    animation.endProgress = 0.35;
    [self.layer addAnimation:animation forKey:nil];
    self.hidden = YES;
}

#pragma mark - getters 

- (UIColor *)fillColor {
    return !_fillColor ? [UIColor colorWithWhite:1.0 alpha:0.65] : _fillColor;
}

- (UIColor *)strockColor {
    return _strockColor ? _strockColor : [UIColor clearColor];
}

@end
