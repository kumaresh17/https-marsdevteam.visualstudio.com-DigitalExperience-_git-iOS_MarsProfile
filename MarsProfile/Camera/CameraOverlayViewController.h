//
//  CameraOverlayViewController.h
//  SampleImageEditor
//
//  Created by preeti on 19/05/17.
//  Copyright © 2017 preeti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MISVerticalColorPickerView.h"
@protocol MISCaptureProtocol
- (void)sendImageToView:(UIImage*)image;
@end
@interface CameraOverlayViewController : UIViewController<AVCapturePhotoCaptureDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, MISVerticalColorPickerDelegate>
@property (assign, nonatomic) BOOL isCameraToUse;
@property (weak, nonatomic) IBOutlet UIImageView *capturedImageView;
@property (weak, nonatomic) IBOutlet MISVerticalColorPickerView *verticalColorPickerView;
@property(nonatomic, weak)id<MISCaptureProtocol> captureDelegate;
-(void) sharePhotoFromGallery;
-(void) sharePhotoFromCamera;
@end
