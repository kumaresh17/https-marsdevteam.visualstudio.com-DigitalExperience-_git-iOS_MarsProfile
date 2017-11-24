//
//  CLImageToolBase.h
//
//  Created by TechM on 2017/5/17.
//  Copyright (c) Mars Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "../ViewController/_CLImageEditorViewController.h"
#import "ToolSettings/CLImageToolSettings.h"


static const CGFloat kCLImageToolAnimationDuration = 0.3;
static const CGFloat kCLImageToolFadeoutDuration   = 0.2;



@interface CLImageToolBase : NSObject<CLImageToolProtocol>
{
    
}
@property (nonatomic, weak) _CLImageEditorViewController *editor;
@property (nonatomic, weak) CLImageToolInfo *toolInfo;

- (id)initWithImageEditor:(_CLImageEditorViewController*)editor withToolInfo:(CLImageToolInfo*)info;

- (void)setup;
- (void)cleanup;
- (void)executeWithCompletionBlock:(void(^)(UIImage *image, NSError *error, NSDictionary *userInfo))completionBlock;

- (UIImage*)imageForKey:(NSString*)key defaultImageName:(NSString*)defaultImageName;

@end
