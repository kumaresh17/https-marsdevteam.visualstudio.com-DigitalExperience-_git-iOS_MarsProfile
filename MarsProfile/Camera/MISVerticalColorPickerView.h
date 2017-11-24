//
//  MISVerticalColorPickerView.h
//  MPulse
//
//  Created by preeti on 31/05/17.
//  Copyright © 2017 Mars IS. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 A delegate that gets notifications when the color picked changes.
 */
@protocol MISVerticalColorPickerDelegate <NSObject>
@optional
-(void)colorPicked:(UIColor *)color;
@end
IB_DESIGNABLE
@interface MISVerticalColorPickerView : UIView
@property (nonatomic, weak) IBOutlet id<MISVerticalColorPickerDelegate> delegate;  //set after inited
@property (nonatomic) IBInspectable UIColor *selectedColor;  //setting this will update the UI & notify the delegate

@end
