//
//  CLStickerTool.h
//
//  Created by TechM on 2017/5/11.
//  Copyright (c) Mars Inc. All rights reserved.
//

#import "MISImageToolbase.h"

@interface CLStickerTool : MISImageToolbase<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
+ (NSString*)defaultStickerPath;
@end
@interface _CLStickerView : UIView
+ (void)setActiveStickerView:(_CLStickerView*)view;
- (UIImageView*)imageView;
- (id)initWithImage:(UIImage *)image tool:(CLStickerTool*)tool;
- (void)setScale:(CGFloat)scale;
+ (NSString*)defaultDeletePath;
@end
