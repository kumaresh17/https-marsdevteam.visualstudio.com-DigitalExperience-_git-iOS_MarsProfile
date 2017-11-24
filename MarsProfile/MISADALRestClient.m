//
//  MISADALURLSession.m
//  MPulse
//
//  Created by François Grémont on 03/02/16.
//  Copyright © 2016 Mars IS. All rights reserved.
//

#import "MISADALRestClient.h"
#import <ADALiOS/ADAL.h>
#import "SDWebImageManager.h"
@import CoreData;
@interface MISADALRestClient()

@property (nonatomic, copy) NSString *resource;
@property (nonatomic, strong) NSURL *redirectURI;
@property (nonatomic, strong) ADAuthenticationContext *authenticationContext;
//Yammer Constants

@end

@implementation MISADALRestClient

+ (instancetype)restClientForSharePoint {
    return [[self alloc] initWithResource:kAuthEffemResourceUri redirectURI:[NSURL URLWithString:kAuthRedirectUri]];
}

+ (instancetype)restClientForYammer {
    return [[self alloc] initWithResource:kAuthYammerResourceUri redirectURI:[NSURL URLWithString:kAuthRedirectUri]];
}

+ (instancetype)restClientForOutlook {
    return [[self alloc] initWithResource:kAuthO365ResourceUri redirectURI:[NSURL URLWithString:kAuthRedirectUri]];
}

+ (void)removeAllTokens {
    
    NSError *error;
    ADAuthenticationContext *context = [ADAuthenticationContext authenticationContextWithAuthority:kLoginAuthority error:&error];
    
    // Clear token cache
    [context.tokenCacheStore removeAllWithError:&error];
    
    // Clear HTTP cookies
    NSHTTPCookieStorage *storage = NSHTTPCookieStorage.sharedHTTPCookieStorage;
    for (NSHTTPCookie *cookie in storage.cookies) {
        [storage deleteCookie:cookie];
    }
    
    // Remove Bearer token to the image manager
    [SDWebImageManager.sharedManager.imageDownloader setValue:nil forHTTPHeaderField:@"Authorization"];
}

- (instancetype)init {
    return [self initWithResource:nil redirectURI:nil];
}

- (instancetype)initWithResource:(NSString *)resource redirectURI:(NSURL *)redirectURI {
    self = [super init];
    if (self) {
        _resource = resource;
        _redirectURI = redirectURI;
    }
    return self;
}

- (ADAuthenticationContext *)authenticationContext {
    if (!_authenticationContext) {
        NSError *error;
        _authenticationContext = [ADAuthenticationContext authenticationContextWithAuthority:kLoginAuthority error:&error];
    }
    return _authenticationContext;
}

#pragma mark - GET

- (void)getJsonWithURL:(NSURL *)URL withOdata:(BOOL)isOdataService completionHandler:(void (^)(id results, NSError *error))completionHandler {
    
    [self getJsonWithURL:URL JsonObjectClass:nil withOdata:isOdataService completionHandler:completionHandler];
}


- (void)getImageWithURL:(NSURL *)URL completionHandler:(void (^)(id results, NSError *error))completionHandler {
    
    [self craftRequest:URL completionHandler:^(NSMutableURLRequest *request, NSError *error) {
        
        if (error) {
            if (completionHandler)
                completionHandler(nil, error);
            return;
        }
        
        [super getImageWithRequest:request completionHandler:completionHandler];
    }];

}


- (void)getJsonWithURL:(NSURL *)URL JsonObjectClass:(Class)JsonObjectClass withOdata:(BOOL)isOdataService completionHandler:(void (^)(id results, NSError *error))completionHandler {
    NSLog(@"getJsonWithURL out");
    [self craftRequest:URL completionHandler:^(NSMutableURLRequest *request, NSError *error) {
        NSLog(@"getJsonWithURL in");
        if (error) {
            if (completionHandler)
                completionHandler(nil, error);
            return;
        }
        
        [super getJsonWithRequest:request JsonObjectClass:JsonObjectClass withOdata:isOdataService completionHandler:completionHandler];
    }];
}

#pragma mark - POST

- (void) postJSONObject:(id)JSONObject
                withURL:(NSURL *)URL
          customHeaders:(NSDictionary *)customHeaders
deserializeJSONResponse:(BOOL)deserializeJSONResponse
      completionHandler:(void (^)(id results, NSError *error))completionHandler {
    
    //-------------------
    // Body Serialization
    //-------------------
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:JSONObject options:kNilOptions error:&error];
    if (error) {
#if DEBUG
        NSLog(@"JSON serialization error: %@", error.localizedDescription);
#endif
        if (completionHandler)
            completionHandler(nil, error);
        return;
    }
    
    [self postData:data withURL:URL customHeaders:customHeaders deserializeJSONResponse:deserializeJSONResponse completionHandler:completionHandler];
}

- (void)       postData:(NSData *)data
                withURL:(NSURL *)URL
          customHeaders:(NSDictionary *)customHeaders
deserializeJSONResponse:(BOOL)deserializeJSONResponse
      completionHandler:(void (^)(id results, NSError *error))completionHandler {
    
    [self craftRequest:URL completionHandler:^(NSMutableURLRequest *request, NSError *error) {
        if (error) {
            if (completionHandler)
                completionHandler(nil, error);
            return;
        }
        
        [super postData:data withRequest:request customHeaders:customHeaders deserializeJSONResponse:deserializeJSONResponse completionHandler:completionHandler];
    }];
}

#pragma mark - PUT

- (void)putJSONObject:(id)JSONObject
              withURL:(NSURL *)URL
    completionHandler:(void (^)(NSError *error))completionHandler {
    
    [self craftRequest:URL completionHandler:^(NSMutableURLRequest *request, NSError *error) {
        
        if (error) {
            if (completionHandler)
                completionHandler(error);
            return;
        }
        
        [super putJSONObject:JSONObject withRequest:request completionHandler:completionHandler];
    }];
}

- (void)putDataObject:(UIImage*)imageObject
              withURL:(NSURL *)URL
    completionHandler:(void (^)(NSError *error))completionHandler {
    
    [self craftRequest:URL completionHandler:^(NSMutableURLRequest *request, NSError *error) {
        
        if (error) {
            if (completionHandler)
                completionHandler(error);
            return;
        }
        
        [super putDataObject:imageObject withRequest:request completionHandler:completionHandler];
    }];
}


#pragma mark - HTTP Upload

- (void)uploadTaskWithURL:(NSURL *)URL
                 fromData:(NSData *)data
        completionHandler:(void (^)(id results, NSError *error))completionHandler {
    
    [self craftRequest:URL completionHandler:^(NSMutableURLRequest *request, NSError *error) {
        
        if (error) {
            if (completionHandler)
                completionHandler(nil, error);
            return;
        }
        
        [super uploadTaskWithRequest:request fromData:data completionHandler:completionHandler];
    }];
}

#pragma mark - HTTP Download

- (void)downloadTaskWithURL:(NSURL *)URL
          completionHandler:(void (^)(NSURL *location, NSError *error))completionHandler {

    [self craftRequest:URL completionHandler:^(NSMutableURLRequest *request, NSError *error) {
        
        if (error) {
            if (completionHandler)
                completionHandler(nil, error);
            return;
        }
        
        [super downloadTaskWithRequest:request completionHandler:completionHandler];
    }];
}

#pragma mark - DELETE HTTP Requests

- (void)deleteWithURL:(NSURL *)URL
    completionHandler:(void (^)(NSError *error))completionHandler {
    
    [self craftRequest:URL completionHandler:^(NSMutableURLRequest *request, NSError *error) {
        
        if (error) {
            if (completionHandler)
                completionHandler(error);
            return;
        }
        
        [super deleteWithRequest:request completionHandler:completionHandler];
    }];
}

#pragma mark - ADAL specifics

- (void)craftRequest:(NSURL *)URL
   completionHandler:(void (^)(NSMutableURLRequest *request, NSError *error))completionBlock {
    NSLog(@"craftRequest out");
    [self getAccessToken:^(NSString *accessToken, NSError *error) {
        NSLog(@"craftRequest inside");
        if (accessToken == nil) {
            completionBlock(nil, error);
        } else {
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
            NSString *authHeader = [NSString stringWithFormat:@"Bearer %@", accessToken];
            [[NSUserDefaults standardUserDefaults] setObject:authHeader forKey:@"access_token_app"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [request addValue:authHeader forHTTPHeaderField:@"Authorization"];
            completionBlock(request, nil);
        }
        
    }];
}

- (void)getAccessToken:(void (^)(NSString *accessToken, NSError *error))completionBlock {
    NSLog(@"getAccessToken out");
    ADAuthenticationError *error;
    self.authenticationContext = [ADAuthenticationContext authenticationContextWithAuthority:kLoginAuthority error:&error];
    
    [self.authenticationContext acquireTokenWithResource:self.resource
                                                clientId:kAuthClientId
                                             redirectUri:self.redirectURI
                                                  userId:nil
                                    extraQueryParameters:kMISOAuthExtraQueryParameters
                                         completionBlock:^(ADAuthenticationResult *result) {
                                             NSLog(@"getAccessToken in");
                                             if (result.status != AD_SUCCEEDED) {
                                                 completionBlock(nil, result.error);
                                             } else {
                                                 completionBlock(result.accessToken, nil);
                                             }
                                             
                                         }];
}

+ (NSString *)getAccessTokenForURL:(NSURL *)URL andResource:(NSString*)resource {
    
    ADAuthenticationError *error;
    ADAuthenticationContext *authenticationContext = [ADAuthenticationContext authenticationContextWithAuthority:kLoginAuthority error:&error];
    __block NSString *accessToken = nil;
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [authenticationContext acquireTokenSilentWithResource:resource
                                                     clientId:kAuthClientId
                                                  redirectUri:[NSURL URLWithString:kAuthRedirectUri]
                                              completionBlock:^(ADAuthenticationResult *result) {
                                                  if (result.status == AD_SUCCEEDED) {
                                                      accessToken = result.tokenCacheStoreItem.accessToken;
                                            
                                                     }
                                                  dispatch_group_leave(group);
                                              }];
    });
    
    long res = dispatch_group_wait(group, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(50 * NSEC_PER_MSEC)));
#if DEBUG
    if (res != 0) {
        NSLog(@"acquireTokenSilentWithResource for image download timed out. Thanks MISandbox!");
    }
#endif
    return accessToken;
}


+ (void)getAccessTokenForO365URL {
    
    ADAuthenticationError *error;
    ADAuthenticationContext *authenticationContext = [ADAuthenticationContext authenticationContextWithAuthority:kLoginAuthority error:&error];
    
    NSString *resource = nil;
    __block NSString *accessToken = nil;
    
    
    resource = kAuthO365ResourceUri;
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [authenticationContext acquireTokenSilentWithResource:resource
                                                     clientId:kAuthClientId
                                                  redirectUri:[NSURL URLWithString:kAuthRedirectUri]
                                              completionBlock:^(ADAuthenticationResult *result) {
                                                  if (result.status == AD_SUCCEEDED) {
                                                      accessToken = result.tokenCacheStoreItem.accessToken;
                                                      NSLog(@"access token for Outlook") ;                        }
                                                  dispatch_group_leave(group);
                                              }];
    });
    
    long res = dispatch_group_wait(group, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(50 * NSEC_PER_MSEC)));
#if DEBUG
    if (res != 0) {
    }
#endif
 
}

+ (void)getAccessTokenForYammerURL {
    
    ADAuthenticationError *error;
    ADAuthenticationContext *authenticationContext = [ADAuthenticationContext authenticationContextWithAuthority:kLoginAuthority error:&error];
    
    NSString *resource = kAuthYammerResourceUri;
    __block NSString *accessToken = nil;
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [authenticationContext acquireTokenSilentWithResource:resource
                                                     clientId:kAuthClientId
                                                  redirectUri:[NSURL URLWithString:kAuthRedirectUri]
                                              completionBlock:^(ADAuthenticationResult *result) {
                                                  if (result.status == AD_SUCCEEDED) {
                                                      accessToken = result.tokenCacheStoreItem.accessToken;
                                                      NSLog(@" kAuthYammerResourceUri accessToken");
                                                  }
                                                  dispatch_group_leave(group);
                                              }];
    });
    
    long res = dispatch_group_wait(group, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(50 * NSEC_PER_MSEC)));
#if DEBUG
    if (res != 0) {
       
    }
#endif

}

+ (NSURL *)URLForUserProfilePictureWithURL:(NSURL *)profilePictureURL {
    
    NSURLComponents *baseURL = [[NSURLComponents alloc] init];
    baseURL.scheme = @"https";
    baseURL.host = @"team.effem.com";
    baseURL.port = @(443);
    baseURL.path = @"/_layouts/15/userphoto.aspx";
    baseURL.queryItems = @[ [NSURLQueryItem queryItemWithName:@"URL" value:profilePictureURL.absoluteString] ];
    return baseURL.URL;
}
@end
