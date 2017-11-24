//
//  MISStickerViewController.h
//  MPulse
//
//  Created by preeti on 26/05/17.
//  Copyright © 2017 Mars IS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MISStickerImageChoice
-(void)setStickerImageToView :(UIImage*)image;
@end
@interface MISStickerViewController : UIViewController
@property(nonatomic, weak) id<MISStickerImageChoice> stickerImageDelegate;
@end
