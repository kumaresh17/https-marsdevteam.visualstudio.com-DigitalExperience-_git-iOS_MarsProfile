//
//  BusyHudIndicator.m
//  MTD2016
//
//  Created by Kumaresh Shrivastava on 23/02/16.
//  Copyright © 2016 TechM. All rights reserved.
//

#import "BusyHudIndicator.h"
#import "MarsProfile-Swift.h"

static BusyHudIndicator *sharedObject;

@implementation BusyHudIndicator

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) init
{
    self = [super init];
    if (self != nil) {
        
       /* [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter]
         addObserver:self selector:@selector(orientationChangedForBusyIndicator:)
         name:UIDeviceOrientationDidChangeNotification
         object:[UIDevice currentDevice]];
        */
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChangedForBusyIndicator:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
        
        [self initIndicator];
        
       
       
    }
    return self;
}


+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (sharedObject == nil)
        {
            sharedObject = [super allocWithZone:zone];
            return sharedObject;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

+ (BusyHudIndicator *)sharedInstance
{
    @synchronized(self)
    {
        if (sharedObject == nil)
        {
            sharedObject =	[[self alloc] init];
        }
    }
    return sharedObject;
}


- (void)initIndicator
{
    
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        if (IS_IPHONE_5)
        {
            mainBounds = CGRectMake(0, 0, 320, 568);
            
        }
        else if(IS_IPHONE_6)
        {
            mainBounds = CGRectMake(0, 0, 375, 667);
        }
        else if(IS_IPHONE_6P)
        {
            mainBounds = CGRectMake(0, 0, 414, 736);
            
        }
        else if(IS_IPHONE_5_Landscape)
        {
            mainBounds = CGRectMake(0, 0, 568, 320);
            
        }
        else if(IS_IPHONE_6_Landscape)
        {
            mainBounds = CGRectMake(0, 0, 667, 375);
            
        }
        else if(IS_IPHONE_6P_Landscape)
        {
            mainBounds = CGRectMake(0, 0, 736, 414);
            
        }
        
    }
    
    else
    {
        mainBounds = CGRectMake(0, 0, 768, 1024);
    }

    [self setFrame:mainBounds];
    
    roundedRectView = [[CustomCellHudView alloc] initWithFrame:mainBounds backgroundColor:[UIColor blackColor] borderColor:[UIColor blackColor]];
    [roundedRectView setAlpha:0.5];
    [self addSubview:roundedRectView];
    
    
    CGRect indicatorBounds = CGRectMake(mainBounds.size.width / 2 - 15, mainBounds.size.height / 2 - 15, 30, 30);
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:indicatorBounds];
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    [roundedRectView addSubview:activityIndicator];

    
    activityIndicator.center = roundedRectView.center;
    roundedRectView.center =self.center;
   
    
    activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    
    [roundedRectView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
}

- (void)startIndicator
{
    AppDelegate *appDelegate	=	(AppDelegate* )[[UIApplication sharedApplication] delegate];
 
    //ISSUE FIX FOR BUSY INDICATOR
    
    self.center = appDelegate.window.center;
    [self setFrame:mainBounds];
    
    //
    [appDelegate.window addSubview:self];
    
    [appDelegate.window bringSubviewToFront:self];
    

    [activityIndicator startAnimating];
    
}


- (void)stopIndicator
{
    [activityIndicator stopAnimating];
    [self removeFromSuperview];
}

- (void) orientationChangedForBusyIndicator:(NSNotification *)note
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    switch(orientation)
    {
        case UIInterfaceOrientationUnknown:
        case UIInterfaceOrientationPortrait:
        {
            if (IS_IPHONE_5)
            {
                mainBounds = CGRectMake(0, 0, 320, 568);
                
            }
            else if(IS_IPHONE_6)
            {
                mainBounds = CGRectMake(0, 0, 375, 667);
            }
            else if(IS_IPHONE_6P)
            {
                mainBounds = CGRectMake(0, 0, 414, 736);
                
            }
        }
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            
            if (IS_IPHONE_5)
            {
                mainBounds = CGRectMake(0, 0, 320, 568);
                
            }
            else if(IS_IPHONE_6)
            {
                mainBounds = CGRectMake(0, 0, 375, 667);
            }
            else if(IS_IPHONE_6P)
            {
                mainBounds = CGRectMake(0, 0, 414, 736);
                
            }
        }
            break;
            
        case UIInterfaceOrientationLandscapeLeft:
        {
            
            if(IS_IPHONE_5_Landscape)
            {
                mainBounds = CGRectMake(0, 0, 568, 320);
                
            }
            else if(IS_IPHONE_6_Landscape)
            {
                mainBounds = CGRectMake(0, 0, 667, 375);
                
                
            }
            else if(IS_IPHONE_6P_Landscape)
            {

                mainBounds = CGRectMake(0, 0, 736, 414);

            }
            
            
        }
            break;
            
        case UIInterfaceOrientationLandscapeRight:
        {
            if(IS_IPHONE_5_Landscape)
            {
                mainBounds = CGRectMake(0, 0, 568, 320);
                
            }
            else if(IS_IPHONE_6_Landscape)
            {
                mainBounds = CGRectMake(0, 0, 667, 375);
               
                
            }
            else if(IS_IPHONE_6P_Landscape)
            {
                mainBounds = CGRectMake(0, 0, 736, 414);
                
            }
            
            
        }
            break;
            
        default:
            break;
    }
    
    
    
    
}

@end

