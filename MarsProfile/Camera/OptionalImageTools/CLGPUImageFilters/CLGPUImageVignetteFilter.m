//
//  CLGPUImageVignetteFilter.m
//
//  Created by TechM on 2017/05/18.
//  Copyright (c) 2017 Mars Inc All rights reserved.
//

#if __has_include("GPUImage.h")

#import "CLGPUImageVignetteFilter.h"

#import "GPUImage.h"

@implementation CLGPUImageVignetteFilter

+ (CGFloat)defaultDockedNumber
{
    return 2.5;
}

+ (NSString*)defaultTitle
{
    return [CLImageEditorTheme localizedString:@"CLGPUImageVignetteFilter_DefaultTitle" withDefault:@"Vignette2"];
}

+ (BOOL)isAvailable
{
    return ([UIDevice iosVersion] >= 5);
}

#pragma mark-

+ (UIImage*)applyFilter:(UIImage*)image
{
    GPUImagePicture *imageSource = [[GPUImagePicture alloc] initWithImage:image];
    GPUImageVignetteFilter *filter = [[GPUImageVignetteFilter alloc] init];
    
    [imageSource addTarget:filter];
    [imageSource processImage];
    
    return [filter imageFromCurrentlyProcessedOutput];
}

@end

#endif
