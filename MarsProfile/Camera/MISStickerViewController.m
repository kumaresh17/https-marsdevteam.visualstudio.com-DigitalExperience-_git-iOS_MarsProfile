//
//  MISStickerViewController.m
//  MPulse
//
//  Created by preeti on 26/05/17.
//  Copyright © 2017 Mars IS. All rights reserved.
//
#import "CLStickerTool.h"
#import "MISStickerViewController.h"
#import "MISStickerCollectionViewCell.h"
#import "MISADALRestClient.h"
#import "UIImageView+Webcache.h"
#import "BusyHudIndicator.h"

static NSString *const kMISDocumentAccessURLTemplate = @"/_api/web/GetFileByServerRelativeUrl('%@')/$value";
// CMS backend server (Sharepoint) constants
static NSString *const kMISProtocol = @"https";                                                                 // Protocol of the Sharepoint server
static NSString *const kMISHost = @"team.effem.com";
static NSString *const kMISSiteName = @"MPulseIS";

static NSString* const kCLStickerToolStickerPathKey = @"stickerPath";
static NSString* const kCLStickerToolDeleteIconName = @"deleteIconAssetsName";
static NSString* StickerCellIdentifier = @"StickerCellIdentifier";

NSString *const kGetStickerApi = @"https://team.effem.com/sites/MPulseIS/_api/Web/Lists/GetByTitle('Stickers')/Items?$select=ID,Title,StickerImage,DisplayOrder&$top=2000";

@interface MISStickerViewController ()
{    NSArray *listOfStickers;
}
@property (weak, nonatomic) IBOutlet UICollectionView *stcikerCollectionView;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray* stickersImageuUrlArray;
@end

@implementation MISStickerViewController
- (IBAction)tappedBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *docsurl = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                            inDomain:NSUserDomainMask
                                                   appropriateForURL:nil
                                                              create:YES
                                                               error:nil];
    NSURL *stickersPath = [docsurl URLByAppendingPathComponent:@"StickerPath"];
    [[NSFileManager defaultManager] createDirectoryAtPath:stickersPath.absoluteString withIntermediateDirectories:NO attributes:nil error:nil];
    [[BusyHudIndicator sharedInstance] startIndicator];
    [self.navigationController setTitle:@"Stickers"];
    // Do any additional setup after loading the view from its nib.
    [self setStickerMenu];
    [self.view setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8]];
    [self.stcikerCollectionView registerClass:[MISStickerCollectionViewCell class] forCellWithReuseIdentifier:StickerCellIdentifier];
    /** We will hit the sharepoint service to fetch the stickers */
    [self getStickersFromSharepoint];
    
}

- (void) getStickersFromSharepoint{
    
    NSURL* urlMix = [NSURL URLWithString:kGetStickerApi];
    
    
    [MISADALRestClient.restClientForSharePoint getJsonWithURL:urlMix withOdata:YES completionHandler:^(id results, NSError *error) {
        if (error) {
#if DEBUG
            NSLog(@"Error when fetching Group Settings: %@", error);
#endif
            [self dismissViewControllerAnimated:NO completion:nil];
            return;
        }
        
        NSArray *stickerResponse= (NSArray *)[results valueForKeyPath:@"d.results"];
        
        self.stickersImageuUrlArray = [[NSMutableArray alloc] initWithCapacity:0];
        for(id stickerImageUrl in stickerResponse){
            NSString* stickerUrl = [stickerImageUrl valueForKeyPath:@"StickerImage.Url"];
            [self.stickersImageuUrlArray addObject:stickerUrl];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.stcikerCollectionView reloadData];
        });
    }];
    
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.view setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8]];
}

- (void) viewWillDisappear:(BOOL)animated{
    [[BusyHudIndicator sharedInstance] stopIndicator];
    [super viewWillDisappear:animated];
}
- (void)setStickerMenu
{
    NSString *stickerPath = [CLStickerTool defaultStickerPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    listOfStickers = [NSArray arrayWithArray:[fileManager contentsOfDirectoryAtPath:stickerPath error:&error]];
    
    //[self.stickersImageuUrlArray count];
}
#pragma mark <UICollectionViewDataSource>
#pragma mark- implementation
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //  return [listOfStickers count];
    if(self.stickersImageuUrlArray == nil){
        return 0;
    }
    return [self.stickersImageuUrlArray count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MISStickerCollectionViewCell *cell=(MISStickerCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:StickerCellIdentifier forIndexPath:indexPath];
    for (id subview in cell.contentView.subviews) {
        if ([subview isKindOfClass:[UIImageView class]]) {
            [subview removeFromSuperview];
        }
    }
    NSURL* imageurl = [self imageURL:[NSURL URLWithString:[self.stickersImageuUrlArray objectAtIndex:indexPath.row]]];
    UIImageView *imageView = [[UIImageView alloc] init];
    cell.imageName = [NSString stringWithFormat:@"Image%ld.png",(long)indexPath.row];
    NSString *imagePath = [self imagePathFromName:cell.imageName];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:imagePath]){
        [imageView sd_setImageWithURL:imageurl placeholderImage:nil completed:^(UIImage *imageDownloaded, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            CGFloat width = 130.0;
            if(imageDownloaded != nil){
                CGFloat scalingOfImageForHeight = 50/imageDownloaded.size.height;
                width = imageDownloaded.size.width*scalingOfImageForHeight;
                if(imageDownloaded.size.width*scalingOfImageForHeight > 100.0){
                    width = 130.0;
                }
                CGFloat imageHeight = imageDownloaded.size.height*scalingOfImageForHeight;
                [imageView setFrame:CGRectMake((cell.frame.size.width - width)/2, (cell.frame.size.height - imageHeight)/2, width, imageHeight - 10)];
            }
            [[BusyHudIndicator sharedInstance] stopIndicator];
            // download and clear and save it in folder; and also show
            if(imageDownloaded)
                [self saveImagesToPath:imageDownloaded byName:[NSString stringWithFormat:@"Image%ld.png",(long)indexPath.row]];
        }];
    }else{
        CGFloat width = 130.0;
        [[BusyHudIndicator sharedInstance] stopIndicator];
        UIImage *imageDownloaded = [UIImage imageWithContentsOfFile:imagePath];
        if(imageDownloaded != nil){
            CGFloat scalingOfImageForHeight = 50/imageDownloaded.size.height;
            width = imageDownloaded.size.width*scalingOfImageForHeight;
            if(imageDownloaded.size.width*scalingOfImageForHeight > 100.0){
                width = 130.0;
            }
            CGFloat imageHeight = imageDownloaded.size.height*scalingOfImageForHeight;
            [imageView setFrame:CGRectMake((cell.frame.size.width - width)/2, (cell.frame.size.height - imageHeight)/2, width, imageHeight - 10)];
        }
        imageView.image = [imageDownloaded copy];
    }
    //[imageView setFrame:CGRectMake(20, 20, 130.0, 100.0)];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    [cell.contentView addSubview:imageView];
    [cell.contentView setNeedsDisplay];
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = 130.0;
    UIImage *image = [(MISStickerCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath] stickerImage].image;
    if(image != nil){
        CGFloat scalingOfImageForHeight = 50/image.size.height;
        width = image.size.width*scalingOfImageForHeight;
        if(image.size.width*scalingOfImageForHeight > 100.0){
            width = 130.0;
        }
    }
    return CGSizeMake(width, 50);
}


#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MISStickerCollectionViewCell *cell = (MISStickerCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    NSString *imagePath = [self imagePathFromName:cell.imageName];
    NSData *imgData = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:imagePath]];
    [self.stickerImageDelegate setStickerImageToView:[UIImage imageWithData:imgData]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Utility methods
- (void) saveImagesToPath :(UIImage*)image byName:(NSString*)name{
    NSString *imagePath = [self imagePathFromName:name];
    NSData *imageData = UIImagePNGRepresentation(image);
    //    if([[NSFileManager defaultManager] fileExistsAtPath:imagePath]){
    //        [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
    //    }
    [imageData writeToFile:imagePath atomically:NO];
}

- (NSString *)imagePathFromName:(NSString*)name
{
    NSError *error = nil;
    NSArray *docpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [docpaths objectAtIndex:0];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:name];
    return imagePath;
}
- (NSURL *)imageURL:(NSURL*)forImageURL {
    return [MISStickerViewController URLForRESTAPIAccessToDocument:forImageURL.path];
}

+ (NSURL *)URLForRESTAPIAccessToDocument:(NSString *)documentRelativePath {
    NSURLComponents *baseURL = [[NSURLComponents alloc] init];
    baseURL.scheme = kMISProtocol;
    baseURL.host = kMISHost;
    baseURL.port = @(443);
    baseURL.path = [@"/sites/" stringByAppendingString:kMISSiteName];
    NSString *encodedDocumentRelativePath = [documentRelativePath stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    NSString *path = [NSString stringWithFormat:kMISDocumentAccessURLTemplate, encodedDocumentRelativePath];
    baseURL.path = [baseURL.path stringByAppendingString:path];
    return baseURL.URL;
}

@end
