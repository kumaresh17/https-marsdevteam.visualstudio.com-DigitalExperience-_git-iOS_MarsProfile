//
//  MISStickerCollectionViewCell.h
//  MPulse
//
//  Created by preeti on 26/05/17.
//  Copyright © 2017 Mars IS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MISStickerCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *stickerImage;
@property (strong, nonatomic) NSString *imageName;
@end
