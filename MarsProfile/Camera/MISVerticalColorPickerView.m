//
//  MISVerticalColorPickerView.m
//  MPulse
//
//  Created by preeti on 31/05/17.
//  Copyright © 2017 Mars IS. All rights reserved.
//

#import "MISVerticalColorPickerView.h"
@interface MISVerticalColorPickerView ()

@property (nonatomic) CGFloat currentSelectionY;

@end
@implementation MISVerticalColorPickerView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.currentSelectionY = 0.0;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// for when coming out of a nib
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.currentSelectionY = 0.0;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    
    //draw wings
    [[UIColor whiteColor] set];
    CGFloat tempYPlace = self.currentSelectionY;
    if (tempYPlace < 0.0) {
        tempYPlace = 0.0;
    } else if (tempYPlace >= self.frame.size.height) {
        tempYPlace = self.frame.size.height - 1.0;
    }
    CGRect temp = CGRectMake(0.0, tempYPlace, self.frame.size.width, 10.0);
    UIRectFill(temp);
    
    //draw central bar over it
    CGFloat cbxbegin = self.frame.size.width * 0.2;
    CGFloat cbwidth = self.frame.size.width * 0.6;
    for (int y = 0; y < self.frame.size.height; y++) {
        [[UIColor colorWithHue:(y/self.frame.size.height) saturation:1.0 brightness:1.0 alpha:1.0] set];
        CGRect temp = CGRectMake(cbxbegin, y, cbwidth, 1.0);
        UIRectFill(temp);
    }
}

/*!
 Changes the selected color, updates the UI, and notifies the delegate.
 */
- (void)setSelectedColor:(UIColor *)selectedColor
{
    if (selectedColor != _selectedColor)
    {
        CGFloat hue = 0.0, temp = 0.0;
        if ([selectedColor getHue:&hue saturation:&temp brightness:&temp alpha:&temp])
        {
            self.currentSelectionY = floorf(hue * self.frame.size.height);
            [self setNeedsDisplay];
        }
        _selectedColor = selectedColor;
        if([self.delegate respondsToSelector:@selector(colorPicked:)])
        {
            [self.delegate colorPicked:_selectedColor];
        }
    }
}

#pragma mark - Touch Events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //update color
    self.currentSelectionY = [((UITouch *)[touches anyObject]) locationInView:self].y;
    _selectedColor = [UIColor colorWithHue:(self.currentSelectionY / self.frame.size.height) saturation:1.0 brightness:1.0 alpha:1.0];
    //notify delegate
    if([self.delegate respondsToSelector:@selector(colorPicked:)])
    {
        [self.delegate colorPicked:self.selectedColor];
    }
    [self setNeedsDisplay];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //update color
    self.currentSelectionY = [((UITouch *)[touches anyObject]) locationInView:self].y;
    _selectedColor = [UIColor colorWithHue:(self.currentSelectionY / self.frame.size.height) saturation:1.0 brightness:1.0 alpha:1.0];
    //notify delegate
    if([self.delegate respondsToSelector:@selector(colorPicked:)])
    {
        [self.delegate colorPicked:self.selectedColor];
    }
    [self setNeedsDisplay];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //update color
    self.currentSelectionY = [((UITouch *)[touches anyObject]) locationInView:self].y;
    _selectedColor = [UIColor colorWithHue:(self.currentSelectionY / self.frame.size.height) saturation:1.0 brightness:1.0 alpha:1.0];
    //notify delegate
    if([self.delegate respondsToSelector:@selector(colorPicked:)])
    {
        [self.delegate colorPicked:self.selectedColor];
    }
    [self setNeedsDisplay];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
@end
