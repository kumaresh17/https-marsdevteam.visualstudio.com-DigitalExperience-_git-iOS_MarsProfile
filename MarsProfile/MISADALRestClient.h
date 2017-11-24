//
//  MISADALURLSession.h
//  MPulse
//
//  Created by François Grémont on 03/02/16.
//  Copyright © 2016 Mars IS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MISRestClient.h"
static NSString* kAuthYammerResourceUri = @"https://www.yammer.com";
//Outlook Constants
static NSString* kAuthO365ResourceUri = @"https://graph.microsoft.com";
// Share point
static NSString* kAuthEffemResourceUri = @"https://team.effem.com";
//App/Client Id
//static NSString* kAuthClientId = @"JIY2VDvafPkQJK2CfD2Q";
static NSString* kAuthClientId = @"c768d832-83bf-4d17-ad4e-1d53a5af728a";
//Common params
static NSString* kAuthRedirectUri = @"https://profile.mars.com";
static NSString* kLoginAuthority = @"https://login.microsoftonline.com/common/oauth2/authorize/";
//static NSString* kLoginAuthority = @"https://www.yammer.com/oauth2/authorize/";

static NSString* kMISOAuthExtraQueryParameters    = @"domain_hint=effem.com";

/*!
 HTTP REST client using Azure AD library for authentication
 */
@interface MISADALRestClient : MISRestClient

#pragma mark - Convenient static initializers

/// @abstract Initialize a REST client for SharePoint
+ (instancetype)restClientForSharePoint;

/// @abstract Initialize a REST client for Yammer
+ (instancetype)restClientForYammer;

/// @abstract Initialize a REST client for Outlook web services
+ (instancetype)restClientForOutlook ;

#pragma mark - Resetting the session / context

/// @abstract Delete all access tokens and session cookies
+ (void)removeAllTokens;

#pragma mark - Initializers

/*!
 @abstract Designated initializer using a resource and a redirect URI
 @param resource The authenticated resource ID associated to the endpoints
 @param redirectURI Redirect URI for the OAuth 2.0 authorization code flow
 @return A REST client initialized for the Azure AD authenticated resource
 */
- (instancetype)initWithResource:(NSString *)resource redirectURI:(NSURL *)redirectURI;

#pragma mark - GET HTTP Requests

/*!
 @abstract GET request (Accept: application/json)
 @param URL URL to get
 @param completionHandler Handler to call when a response is received or if an error occurs
 */
- (void)getJsonWithURL:(NSURL *)URL withOdata:(BOOL)isOdataService completionHandler:(void (^)(id results, NSError *error))completionHandler;


/*!
 @abstract GET Image from Dot Mars Savvie
 @param URL URL to get
 @param completionHandler Handler to call when a response is received or if an error occurs
 */

- (void)getImageWithURL:(NSURL *)URL completionHandler:(void (^)(id results, NSError *error))completionHandler;


/*!
 @abstract GET request (Accept: application/json)
 @param URL URL to get
 @param JsonObjectClass Class for storing the JSON response (predictive)
 @param completionHandler Handler to call when a response is received or if an error occurs
 */
- (void)getJsonWithURL:(NSURL *)URL JsonObjectClass:(Class)JsonObjectClass withOdata:(BOOL)isOdataService completionHandler:(void (^)(id results, NSError *error))completionHandler;

#pragma mark - POST HTTP Requests

/*!
 @abstract POST request (Content-Type: application/json)
 @param JSONObject JSON object for the body of the POST request
 @param URL URL where data must be posted
 @param customHeaders Dictionary containing optional HTTP headers
 @param deserializeJSONResponse Flag specifying that the response must be deserialized
 @param completionHandler Handler called when a response is received or if an error occurs
 */
- (void) postJSONObject:(id)JSONObject
                withURL:(NSURL *)URL
          customHeaders:(NSDictionary *)customHeaders
deserializeJSONResponse:(BOOL)deserializeJSONResponse
      completionHandler:(void (^)(id results, NSError *error))completionHandler;

/*!
 @abstract POST request
 @param data Data for the body of the POST request
 @param URL URL where data must be posted
 @param customHeaders Dictionary containing optional HTTP headers
 @param deserializeJSONResponse Flag specifying that the response must be deserialized
 @param completionHandler Handler called when a response is received or if an error occurs
 */
- (void)       postData:(NSData *)data
                withURL:(NSURL *)URL
          customHeaders:(NSDictionary *)customHeaders
deserializeJSONResponse:(BOOL)deserializeJSONResponse
      completionHandler:(void (^)(id results, NSError *error))completionHandler;
- (void)postDataObject:(NSData*)imageObject
              withURL:(NSURL *)URL
    completionHandler:(void (^)(NSError *error))completionHandler;
#pragma mark - PUT HTTP Requests

/*!
 @abstract POST (MERGE) request
 @param JSONObject JSON object for the body of the POST request
 @param URL URL to get
 @param completionHandler Handler called when a response is received or if an error occurs
 */
- (void)putJSONObject:(id)JSONObject
              withURL:(NSURL *)URL
    completionHandler:(void (^)(NSError *error))completionHandler;
- (void)putDataObject:(NSData*)imageObject
               withURL:(NSURL *)URL
     completionHandler:(void (^)(NSError *error))completionHandler;
#pragma mark - Upload (POST) HTTP Requests

/*!
 @abstract Upload task (POST)
 @param URL URL where data must be uploaded
 @param data Data to upload
 @param completionHandler Handler called when a response is received or if an error occurs
 */
- (void)uploadTaskWithURL:(NSURL *)URL
                 fromData:(NSData *)data
        completionHandler:(void (^)(id results, NSError *error))completionHandler;

#pragma mark - Download (GET) HTTP Requests

/*!
 @abstract Download task (GET)
 @param URL URL for the download task
 @param completionHandler Handler called when a response is received or if an error occurs
 */
- (void)downloadTaskWithURL:(NSURL *)URL
          completionHandler:(void (^)(NSURL *location, NSError *error))completionHandler;

#pragma mark - DELETE HTTP Requests

/*!
 @abstract DELETE request
 @param URL URL for the delete request
 @param completionHandler Handler called when a response is received or if an error occurs
 */
- (void)deleteWithURL:(NSURL *)URL
    completionHandler:(void (^)(NSError *error))completionHandler;
+ (NSString *)getAccessTokenForURL:(NSURL *)URL andResource:(NSString*)resource;
- (void)getAccessToken:(void (^)(NSString *accessToken, NSError *error))completionBlock;
+ (NSURL *)URLForUserProfilePictureWithURL:(NSURL *)profilePictureURL;
@end
