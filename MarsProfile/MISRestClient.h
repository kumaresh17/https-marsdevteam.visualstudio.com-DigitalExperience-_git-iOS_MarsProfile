//
//  MISRestClient.h
//  MPulse
//
//  Created by François Grémont on 05/02/16.
//  Copyright © 2016 Mars IS. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSURLRequest (NSURLRequestWithIgnoreSSL)


//Bypass all HTTPS certificates validation
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
@end

/*!
 Basic HTTP REST client
 */
@interface MISRestClient : NSObject

/// @abstract Shared HTTP REST client
+ (instancetype)sharedClient;

#pragma mark - GET HTTP Requests

/*!
 @abstract GET request (Accept: application/json)
 @param URL URL to get
 @param completionHandler Handler to call when a response is received or if an error occurs
 */
- (void)getJsonWithURL:(NSURL *)URL withOdata:(BOOL)isOdataService completionHandler:(void (^)(id results, NSError *error))completionHandler;


/*!
 @abstract Get Image
 @param URL URL to get
 @param completionHandler Handler to call when a response is received or if an error occurs
 */
- (void)getImageWithRequest:(NSURLRequest *)request completionHandler:(void (^)(id results, NSError *error))completionHandler;


/*!
 @abstract GET request (Accept: application/json)
 @param URL URL to get
 @param JsonObjectClass Class for storing the JSON response (predictive)
 @param completionHandler Handler to call when a response is received or if an error occurs
 */
- (void)getJsonWithURL:(NSURL *)URL JsonObjectClass:(Class)JsonObjectClass withOdata:(BOOL)isOdataService completionHandler:(void (^)(id results, NSError *error))completionHandler;

/*!
 @abstract GET request (Accept: application/json)
 @param request GET Request
 @param JsonObjectClass Class for storing the JSON response (predictive)
 @param completionHandler Handler called when a response is received or if an error occurs
 */
- (void)getJsonWithRequest:(NSURLRequest *)request JsonObjectClass:(Class)JsonObjectClass withOdata:(BOOL)isOdataService completionHandler:(void (^)(id results, NSError *error))completionHandler;

/*!
 @abstract GET request (Accept: application/xml)
 @param URL URL to get
 @param completionHandler Handler to call when a response is received or if an error occurs
 */
- (void)getXMLWithURL:(NSURL *)URL completionHandler:(void (^)(id results, NSError *error))completionHandler;
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

/*!
 @abstract POST request
 @param data Data for the body of the POST request
 @param request POST request
 @param customHeaders Dictionary containing optional HTTP headers
 @param deserializeJSONResponse Flag specifying that the response must be deserialized
 @param completionHandler Handler called when a response is received or if an error occurs
 */
- (void)       postData:(NSData *)data
            withRequest:(NSURLRequest *)request
          customHeaders:(NSDictionary *)customHeaders
deserializeJSONResponse:(BOOL)deserializeJSONResponse
      completionHandler:(void (^)(id results, NSError *error))completionHandler;

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

/*!
 @abstract POST (MERGE) request
 @param JSONObject JSON object for the body of the POST request
 @param request POST (MERGE) request
 @param completionHandler Handler called when a response is received or if an error occurs
 */
- (void)putJSONObject:(id)JSONObject
          withRequest:(NSURLRequest *)request
    completionHandler:(void (^)(NSError *error))completionHandler;
- (void)putDataObject:(NSData*)dataObject
              withRequest:(NSURLRequest *)request
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

/*!
 @abstract Upload task (POST)
 @param request POST request
 @param data Data to upload
 @param completionHandler Handler called when a response is received or if an error occurs
 */
- (void)uploadTaskWithRequest:(NSURLRequest *)request
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

/*!
 @abstract Download task (GET)
 @param request GET request
 @param completionHandler Handler called when a response is received or if an error occurs
 */
- (void)downloadTaskWithRequest:(NSURLRequest *)request
          completionHandler:(void (^)(NSURL *location, NSError *error))completionHandler;

#pragma mark - DELETE HTTP Requests

/*!
 @abstract DELETE request
 @param URL URL for the delete request
 @param completionHandler Handler called when a response is received or if an error occurs
 */
- (void)deleteWithURL:(NSURL *)URL
    completionHandler:(void (^)(NSError *error))completionHandler;

/*!
 @abstract DELETE request
 @param request DELETE request
 @param completionHandler Handler called when a response is received or if an error occurs
 */
- (void)deleteWithRequest:(NSURLRequest *)request
    completionHandler:(void (^)(NSError *error))completionHandler;

@end
