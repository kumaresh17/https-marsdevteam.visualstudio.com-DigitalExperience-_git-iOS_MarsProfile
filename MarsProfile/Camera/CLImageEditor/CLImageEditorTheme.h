//
//  CLImageEditorTheme.h
//
//  Created by TechM on 2017/5/05.
//  Copyright (c) Mars Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol CLImageEditorThemeDelegate;

@interface CLImageEditorTheme : NSObject

@property (nonatomic, weak) id<CLImageEditorThemeDelegate> delegate;
@property (nonatomic, strong) NSString *bundleName;
@property (nonatomic, strong) UIColor  *backgroundColor;
@property (nonatomic, strong) UIColor  *toolbarColor;
@property (nonatomic, strong) NSString *toolIconColor;
@property (nonatomic, strong) UIColor  *toolbarTextColor;
@property (nonatomic, strong) UIColor  *toolbarSelectedButtonColor;
@property (nonatomic, strong) UIFont   *toolbarTextFont;
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;

+ (CLImageEditorTheme*)theme;

@end


@protocol CLImageEditorThemeDelegate <NSObject>
@optional
- (UIActivityIndicatorView*)imageEditorThemeActivityIndicatorView;

@end
