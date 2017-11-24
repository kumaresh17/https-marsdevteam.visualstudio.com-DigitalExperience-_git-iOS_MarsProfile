//
//  CameraOverlayViewController.m
//  SampleImageEditor
//
//  Created by preeti on 19/05/17.
//  Copyright © 2017 preeti. All rights reserved.
//
#import "MarsProfile-Swift.h"
#import <TOCropViewController/TOCropViewController.h>
#import "CameraOverlayViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "CLImageEditor.h"
#import "MISStickerViewController.h"
#import "CLStickerTool.h"
#import "CLTextTool.h"
#import <SDWebImage/SDWebImageManager.h>
#import "MISADALRestClient.h"
static NSString* const CLTextViewActiveViewDidChangeNotification = @"CLTextViewActiveViewDidChangeNotificationString";

@interface CameraOverlayViewController ()<CLImageEditorDelegate, MISStickerImageChoice,TOCropViewControllerDelegate>{
    CGRect rectForLayer;
    BOOL isLoadedFirst;
    UIFont *marsTextFont;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalColorPlateY;
@property (strong, nonatomic) MISStickerViewController *stickerCollectionViewController;
@property (strong, nonatomic) AVCaptureSession *avSession;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@property (strong, nonatomic) AVCaptureDeviceInput *captureInputDevice;
@property (strong, nonatomic) AVCapturePhotoOutput *captureOutput;
@property (strong, nonatomic) AVCapturePhotoSettings *photoSettings;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) CLImageEditor *editor;
@property (weak, nonatomic) IBOutlet UIButton *stickerMenu;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *textToolButton;
@property (weak, nonatomic) IBOutlet UIButton *cropToolButton;
@property (weak, nonatomic) _CLTextView *selectedTextView;
@property(strong, nonatomic)MPShareSourceViewController *shareSourceViewController;
@end

@implementation CameraOverlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //To set the header authentication
    SDWebImageManager.sharedManager.imageDownloader.headersFilter  = ^NSDictionary *(NSURL *URL, NSDictionary *headers) {
        NSMutableDictionary *mutableHeaders = [headers mutableCopy];
        [mutableHeaders removeObjectForKey:@"Authorization"];
        NSString *accessToken = [MISADALRestClient getAccessTokenForURL:URL andResource:@"https://team.effem.com"];
        
        if (accessToken)
            [mutableHeaders setValue:[NSString stringWithFormat:@"Bearer %@", accessToken] forKey:@"Authorization"];
        return mutableHeaders;
    };
    isLoadedFirst = YES;
    //
    marsTextFont = [self getMarsFont];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activeTextViewDidChange:) name:CLTextViewActiveViewDidChangeNotification object:nil];
    [self setButtonsToTopOfLayer:_capturedImageView.layer];
    rectForLayer = [[UIScreen mainScreen] bounds];
    [self.verticalColorPickerView setHidden:YES];
    //Notification for closing the camera when app goes background
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(closeCameraIfAppBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(doneButtonPressed) name:@"DoneButtonPressed" object:nil];
    [notificationCenter addObserver:self selector:@selector(startEditingPressed) name:@"StartTextEditingPressed" object:nil];
    self.navigationController.navigationBarHidden = YES;
    #if (TARGET_OS_SIMULATOR)
        self.isCameraToUse = NO;
    #endif
}

-(void)viewWillAppear:(BOOL)animated{
#if (TARGET_OS_SIMULATOR)
    self.isCameraToUse = NO;
#endif
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    if(isLoadedFirst){
        isLoadedFirst = NO;
        if(self.isCameraToUse)
            [self sharePhotoFromCamera];
        else{
            [self sharePhotoFromGallery];
        }
    }else{
        [self changeVisibleButtonsOnCameraView:NO];
    }
}
# pragma mark -- Public method
-(void) sharePhotoFromGallery{
    [self checkPhotoActionsWithAuthorizationStatus];
}
-(void) sharePhotoFromCamera{
    [self checkCameraActionsWithAuthorizationStatus];
}
# pragma mark -- Private method
- (void) showCameraPicker{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    #if !(TARGET_OS_SIMULATOR)
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.showsCameraControls = YES;
    picker.allowsEditing = NO;
    #else
     picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    #endif
    
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:NULL];
}
- (UIFont*)getMarsFont{
    UIFont *marsFont=nil;
    for(NSString *familyName in [UIFont familyNames]){
        for(NSString *fontName in [UIFont fontNamesForFamilyName:familyName]){
            if([fontName rangeOfString:@"Dosis"].location != NSNotFound){
                marsFont=[UIFont fontWithName:fontName size:50];
                break;
            }
        }
        if(marsFont != nil){
            break;
        }
    }
    if(marsFont == nil){
        marsFont = [UIFont systemFontOfSize:14.0];
    }
    return marsFont;
}
- (IBAction)tappedTextTool:(id)sender {
    [_textToolButton setHidden:YES];
    [_stickerMenu setHidden:YES];
    [_cropToolButton setHidden:YES];
    [self.verticalColorPickerView setFrame:CGRectMake(self.verticalColorPickerView.frame.origin.x, 50.0, self.verticalColorPickerView.frame.size.width, self.verticalColorPickerView.frame.size.height)];
    [self.verticalColorPickerView setHidden:NO];
    _CLTextView *view = [[_CLTextView alloc] initWithTool:nil withFrame:CGRectMake((self.view.frame.origin.x+self.view.frame.size.width/2-150), (self.view.frame.origin.y+self.view.frame.size.height/2-40), 300, 40)];
    view.fillColor = [UIColor blackColor];
    view.borderColor =  [UIColor whiteColor];
    view.borderWidth = 5.0;
    
    view.font = marsTextFont;
    
    CGFloat ratio = MIN( (0.8 * self.view.width) / view.width, (0.2 * self.view.height) / view.height);
    [view setScale:ratio];
    view.center = CGPointMake(self.view.width/2, self.view.frame.size.height/2 - 40);
    
    [self.view addSubview:view];
    [view.label becomeFirstResponder];
    [_CLTextView setActiveTextView:view];
}

- (IBAction)tappedStickerMenu:(id)sender {
    [self.verticalColorPickerView setHidden:YES];
    if(self.selectedTextView){
        [self.selectedTextView resignResponderFromCurrentContext];;
    }
    _stickerCollectionViewController = [[MISStickerViewController alloc] initWithNibName:@"MISStickerViewController" bundle:[NSBundle mainBundle]];
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    [_stickerCollectionViewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    _stickerCollectionViewController.stickerImageDelegate = self;
    [self presentViewController:_stickerCollectionViewController animated:YES completion:nil];
}

- (IBAction)tappedClose:(id)sender {
    [_CLStickerView setActiveStickerView:nil];
    [_CLTextView setActiveTextView:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)tappedDoneButton:(id)sender {
    [_CLStickerView setActiveStickerView:nil];
    [_CLTextView setActiveTextView:nil];
    UIImage *withoutButtonsImage = [self buildImage:_capturedImageView.image];
    _shareSourceViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MPShareSourceViewController"];
    _shareSourceViewController.updatedProfileImage = withoutButtonsImage;
    [self.navigationController pushViewController:_shareSourceViewController animated:YES];
}

- (IBAction)tappedOnbackground:(id)sender {
    if(self.selectedTextView){
        [self.selectedTextView resignResponderFromCurrentContext];
    }
}
- (IBAction)cropBarButtonClick:(id)sender {
    if(_capturedImageView.image != nil){
        [_CLStickerView setActiveStickerView:nil];
        [_CLTextView setActiveTextView:nil];
        UIImage *withoutButtonsImage = [self buildImage:_capturedImageView.image];
        TOCropViewController *cropViewController = [[TOCropViewController alloc]initWithImage:withoutButtonsImage];
        cropViewController.delegate = self;
        [self presentViewController:cropViewController animated:YES completion:nil];
    }
}

-(CGSize)CGSizeAspectFitRatio:(CGSize) aspectRatio andBound:(CGSize) boundingSize
{
    float mW = boundingSize.width / aspectRatio.width;
    float mH = boundingSize.height / aspectRatio.height;
    if( mH < mW )
        boundingSize.width = boundingSize.height / aspectRatio.height * aspectRatio.width;
    else if( mW < mH )
        boundingSize.height = boundingSize.width / aspectRatio.width * aspectRatio.height;
    if(boundingSize.height>boundingSize.width){
        boundingSize.height = boundingSize.width;
    }
    return boundingSize;
}
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)croppedImage withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    for (UIView *view in self.view.subviews) {
        if([view isKindOfClass:[_CLTextView class]] || [view isKindOfClass:[_CLStickerView class]]){
            [view removeFromSuperview];
        }
    }
    [self dismissViewControllerAnimated:YES completion:^{
        _capturedImageView.image = croppedImage;
    }];
}
#pragma mark - Private methods
-(void)setStickerImageToView :(UIImage*)image{
    [self dismissViewControllerAnimated:YES completion:nil];
    _CLStickerView *view = [[_CLStickerView alloc] initWithImage:image tool:nil];
    CGFloat ratio = MIN( (0.5 * self.view.frame.size.width) / view.width, (0.5 * self.view.frame.size.height) / view.height);
    [view setScale:ratio];
    view.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    
    [self.view addSubview:view];
    [_CLStickerView setActiveStickerView:view];
}
#pragma mark - Button visiblity changes
-(void) setButtonsToTopOfLayer: (CALayer*)layer{
    [self.view.layer addSublayer:layer];
    [self.closeButton setEnabled:YES];
    [self.view.layer insertSublayer:self.textToolButton.layer above:layer];
    [self.view.layer insertSublayer:self.verticalColorPickerView.layer above:layer];
    [self.view.layer insertSublayer:self.closeButton.layer above:layer];
    [self.view.layer insertSublayer:self.doneButton.layer above:layer];
    [self.view.layer insertSublayer:self.stickerMenu.layer above:layer];
    [self.view.layer insertSublayer:self.cropToolButton.layer above:layer];
}

-(void)changeVisibleButtonsOnCameraView :(BOOL) isVisible{
    [self.doneButton setHidden:isVisible];
    [self.textToolButton setHidden:isVisible];
    [self.closeButton setHidden:NO];
    [self.stickerMenu setHidden:isVisible];
    [self.cropToolButton setHidden:isVisible];
}

#pragma mark -- Image Picker methods

-(void) openGallery {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:picker animated:YES completion:^{
        picker.navigationBar.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        picker.navigationController.navigationItem.rightBarButtonItem.tintColor = [UIColor redColor];
        picker.navigationController.navigationBar.backgroundColor = [UIColor grayColor];
        picker.navigationItem.rightBarButtonItem.tintColor = [UIColor greenColor];
        picker.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    }];
}
- (void)checkCameraActionsWithAuthorizationStatus{
    __weak CameraOverlayViewController *weakSelf = self;
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        [self showCameraPicker];
    } else if(authStatus == AVAuthorizationStatusDenied){
        dispatch_async(dispatch_get_main_queue(), ^{
            if(weakSelf != nil){
                [weakSelf showAlertForError:NSLocalizedString(@"You didn't authorize the application to access your camera.\nYou must allow it by going in the Mars Profile settings inside your device settings in order to use them in the application", nil) handlerForOKAction:nil];
            }
        });
    } else if(authStatus == AVAuthorizationStatusRestricted){
        dispatch_async(dispatch_get_main_queue(), ^{
            if(weakSelf != nil){
                [weakSelf showAlertForError:NSLocalizedString(@"You didn't authorize the application to access your camera.\nYou must allow it by going in the Mars Profile settings inside your device settings in order to use them in the application", nil) handlerForOKAction:nil];
            }
        });
    } else if(authStatus == AVAuthorizationStatusNotDetermined){
        // not determined?!
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            if(granted){
                [weakSelf showCameraPicker];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(weakSelf != nil){
                        [weakSelf showAlertForError:NSLocalizedString(@"You didn't authorize the application to access your camera.\nYou must allow it by going in the Mars Profile settings inside your device settings in order to use them in the application", nil) handlerForOKAction:nil];
                    }
                });
            }
        }];
    }
}
- (void)checkPhotoActionsWithAuthorizationStatus{
    __weak CameraOverlayViewController *weakSelf = self;
    switch (PHPhotoLibrary.authorizationStatus) {
        case PHAuthorizationStatusAuthorized: {
            [self openGallery];
            break;
        }
            
        case PHAuthorizationStatusDenied: {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(weakSelf != nil){
                    [weakSelf showAlertForError:NSLocalizedString(@"You didn't authorize the application to access your photos.\nYou must allow it by going in the MPulse settings inside your device settings in order to use them in the application", nil) handlerForOKAction:nil];
                }
            });
            break;
        }
            
        case PHAuthorizationStatusRestricted: {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(weakSelf != nil){
                    [weakSelf showAlertForError:NSLocalizedString(@"Access to your photos is restricted by the device.\nSorry for the inconvenience.", nil) handlerForOKAction:nil];
                }
            });
            break;
        }
            
        case PHAuthorizationStatusNotDetermined: {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if(status == PHAuthorizationStatusAuthorized)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(weakSelf != nil){
                            [weakSelf openGallery];
                        }
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(weakSelf != nil){
                            [weakSelf showAlertForError:NSLocalizedString(@"You didn't authorize the application to access your photos.\nYou must allow it by going in the MPulse settings inside your device settings in order to use them in the application", nil) handlerForOKAction:nil];
                        }
                    });
                }
            }];
            break;
        }
            
        default: {
            break;
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    __weak CameraOverlayViewController *camSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        if(camSelf != nil){
            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
            camSelf.capturedImageView.image  = image;
            [camSelf changeVisibleButtonsOnCameraView:NO];
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        [self tappedClose:nil];
    }];
}


#pragma mark -- Utility methods
- (UIImage*) getFinalImage:(UIImage*)image{
    UIImage *imageBanner = [UIImage imageNamed:@"standard-sticker.png"];
    CGSize size = CGSizeMake([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [image drawInRect:CGRectMake(0,0,size.width, [[UIScreen mainScreen] bounds].size.height - imageBanner.size.height)];
    [imageBanner drawInRect:CGRectMake(size.width - imageBanner.size.width,size.height-imageBanner.size.height,imageBanner.size.width,imageBanner.size.height)];
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return finalImage;
}

- (void) showAlertForError:(NSString *)error handlerForOKAction:(void (^)(UIAlertController *alertController, UIAlertAction *action))handlerForOKAction {
    UIAlertController *alertController =
    [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", nil)
                                        message:error
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    void (^actionHandler)(UIAlertAction *action) = nil;
    if (handlerForOKAction) {
        actionHandler = ^(UIAlertAction *action) {
            handlerForOKAction(alertController, action);
        };
    } else {
        actionHandler = ^(UIAlertAction *action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        };
    }
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil)
                                                     style:UIAlertActionStyleDefault
                                                   handler:actionHandler];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void) closeCameraIfAppBackground{
    if([self isKindOfClass:[CameraOverlayViewController class]]){
        NSLog(@"CameraOverlayViewController");
        [self dismissViewControllerAnimated:NO completion:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }else{
        NSLog(@"CameraOverlayViewController else");
        [self dismissViewControllerAnimated:NO completion:^{
            NSLog(@"CameraOverlayViewController else com[");
             [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

- (UIImage*)buildImage:(UIImage*)image
{
    //Remove button adn other views from Image from current view
    for (UIView *view in self.view.subviews) {
        if([view isKindOfClass:[UIButton class]])
        {
            [view setHidden:YES];
        }else if([view isKindOfClass:[MISVerticalColorPickerView class]]){
            [view setHidden:YES];
        }
    }
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, self.view.opaque, [[UIScreen mainScreen] scale]);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return img;
}

- (BOOL)shouldAutorotate{
    return NO;
}

-(UIInterfaceOrientationMask) supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
// Change color picker for text view from VerticalColor Palate
-(void)colorPicked:(UIColor *)color
{
    self.selectedTextView.fillColor = color;
}
// Change active text view notification from Text editor
- (void)activeTextViewDidChange:(NSNotification*)notification
{
    self.selectedTextView = notification.object;
}
// Done button press notification from Text view
-(void) doneButtonPressed{
    //if(self.view.frame.origin.y<0){}
    _verticalColorPlateY.constant = 10.0;
    [self.view layoutIfNeeded];
    [_stickerMenu setHidden:NO];
    [_textToolButton setHidden:NO];
    [_verticalColorPickerView setHidden:YES];
    [_cropToolButton setHidden:NO];
}
// Start editing button press notification from Text view
-(void) startEditingPressed{
    
    if(self.view.frame.origin.y<0){
        _verticalColorPlateY.constant = 200.0;
    }else{
        _verticalColorPlateY.constant = 10.0;
    }
    //[self.view updateConstraints];
    [self.view layoutIfNeeded];
    //}
    [_stickerMenu setHidden:YES];
    [_textToolButton setHidden:YES];
    [_verticalColorPickerView setHidden:NO];
    [_cropToolButton setHidden:YES];
}
+ (UIImage *)imageWithRoundedCornersSize:(float)cornerRadius usingImage:(UIImage *)original
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:original];
    
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 0.0);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:imageView.bounds
                                cornerRadius:0.0] addClip];
    // Draw your image
    [original drawInRect:imageView.bounds];
    
    // Get the image, here setting the UIImageView image
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    
    return imageView.image;
}

- (void)dealloc{
    _captureDelegate = nil;
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
