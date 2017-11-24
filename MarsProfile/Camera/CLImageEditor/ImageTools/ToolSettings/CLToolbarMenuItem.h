//
//  CLToolbarMenuItem.h
//
//  Created by TechM on 2017/5/11.
//  Copyright (c) Mars Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIView+CLImageToolInfo.h"

@interface CLToolbarMenuItem : UIView
{
    UIImageView *_iconView;
    UILabel *_titleLabel;
}

@property (nonatomic, assign) NSString *title;
@property (nonatomic, assign) UIImage *iconImage;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, readonly) UIImageView *iconView;

 - (id)initWithFrame:(CGRect)frame target:(id)target action:(SEL)action toolInfo:(CLImageToolInfo*)toolInfo;

@end
