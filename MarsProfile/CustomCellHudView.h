//
//  CustomCellHudView.h
//  MTD2016
//
//  Created by Kumaresh Shrivastava on 23/02/16.
//  Copyright © 2016 TechM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCellHudView : UIView
{
    UIColor *fillColor;
    UIColor *borderColor;
}

@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIColor *borderColor;

- (id)initWithFrame:(CGRect)frame backgroundColor:(UIColor *)theBackColor borderColor:(UIColor *)theBorderColor;


@end
