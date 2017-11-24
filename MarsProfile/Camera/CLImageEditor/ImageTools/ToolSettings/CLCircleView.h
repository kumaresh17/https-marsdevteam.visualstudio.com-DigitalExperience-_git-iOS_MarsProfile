//
//  CLCircleView.h
//
//  Created by TechM on 2017/5/11.
//  Copyright (c) Mars Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLCircleView : UIView

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGFloat radius;

@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;

@end
