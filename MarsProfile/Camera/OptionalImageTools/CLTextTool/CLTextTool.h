//
//  CLTextTool.h
//
//  Created by TechM on 2017/5/15.
//  Copyright (c) Mars Inc. All rights reserved.
//

#import "CLImageToolBase.h"
#import "MISImageToolbase.h"

@interface CLTextTool : MISImageToolbase

@end
@interface _CLTextView : UIView<UITextViewDelegate>

@property (nonatomic, strong) UITextView *label;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) NSTextAlignment textAlignment;

+ (void)setActiveTextView:(_CLTextView*)view;
- (id)initWithTool:(CLTextTool*)tool withFrame:(CGRect)frame;
- (void)setScale:(CGFloat)scale;
- (void)sizeToFitWithMaxWidth:(CGFloat)width lineHeight:(CGFloat)lineHeight;
- (void) resignResponderFromCurrentContext;
@end
