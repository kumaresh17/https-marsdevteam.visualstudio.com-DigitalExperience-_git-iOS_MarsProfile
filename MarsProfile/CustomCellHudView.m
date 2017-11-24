//
//  CustomCellHudView.m
//  MTD2016
//
//  Created by Kumaresh Shrivastava on 23/02/16.
//  Copyright © 2016 TechM. All rights reserved.
//

#import "CustomCellHudView.h"

static void addRoundedRectToPath(CGContextRef context, CGRect rect,
                                 float ovalWidth,float ovalHeight);

@implementation CustomCellHudView

@synthesize fillColor, borderColor;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL) isOpaque
{
    return NO;
}

- (id)initWithFrame:(CGRect)frame backgroundColor:(UIColor *)theBackColor borderColor:(UIColor *)theBorderColor
{
    if (self = [super initWithFrame:frame])
    {
        self.fillColor = theBackColor;
        self.borderColor = theBorderColor;
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(c, fillColor.CGColor);
    CGContextSetStrokeColorWithColor(c, borderColor.CGColor);
    
    CGContextBeginPath(c);
    addRoundedRectToPath(c, rect, 0.0f, 0.0f);
    CGContextFillPath(c);
    
    CGContextSetLineWidth(c, 1);
    CGContextBeginPath(c);
    addRoundedRectToPath(c, rect, 0.0f, 0.0f);
    CGContextStrokePath(c);
}



@end

static void addRoundedRectToPath(CGContextRef context, CGRect rect,float ovalWidth,float ovalHeight)
{
    float fw, fh;
    
    if (ovalWidth == 0 || ovalHeight == 0) // 1
    {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);// 2
    
    CGContextTranslateCTM (context, CGRectGetMinX(rect),// 3
                           CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);// 4
    fw = CGRectGetWidth (rect) / ovalWidth;// 5
    fh = CGRectGetHeight (rect) / ovalHeight;// 6
    
    CGContextMoveToPoint(context, fw, fh/2); // 7
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);// 8
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);// 9
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);// 10
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // 11
    CGContextClosePath(context);// 12
    
    CGContextRestoreGState(context);// 13
}

