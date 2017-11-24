//
//  MISRestClient.m
//  MPulse
//
//  Created by François Grémont on 05/02/16.
//  Copyright © 2016 Mars IS. All rights reserved.
//

#import "MISRestClient.h"
#import "XMLDictionary.h"
#import <UIKit/UIKit.h>

@implementation NSURLRequest (NSURLRequestWithIgnoreSSL)


//Bypass all HTTPS certificates validation
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host
{
    return YES;
}

@end



@interface MISRestClient () <NSURLSessionDelegate>

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation MISRestClient

+ (instancetype)sharedClient {
    static MISRestClient *service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[MISRestClient alloc] init];
    });
    return service;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _session = [NSURLSession sessionWithConfiguration:NSURLSessionConfiguration.defaultSessionConfiguration delegate:self delegateQueue:nil];
    }
    return self;
}

#pragma mark - GET

- (void)getJsonWithURL:(NSURL *)URL withOdata:(BOOL)isOdataService completionHandler:(void (^)(id results, NSError *error))completionHandler {
    
    [self getJsonWithURL:URL JsonObjectClass:nil  withOdata:isOdataService completionHandler:completionHandler];
}

- (void)getJsonWithURL:(NSURL *)URL JsonObjectClass:(Class)JsonObjectClass withOdata:(BOOL)isOdataService completionHandler:(void (^)(id results, NSError *error))completionHandler {
    
    [self getJsonWithRequest:[NSURLRequest requestWithURL:URL] JsonObjectClass:JsonObjectClass withOdata:isOdataService completionHandler:completionHandler];
    
}


/*
 This is the to get Image from dotmars // Kumaresh
 */
- (void)getImageWithRequest:(NSURLRequest *)request
          completionHandler:(void (^)(id results, NSError *error))completionHandler {
    
    NSMutableURLRequest *mutableRequest = request.mutableCopy;
    
    //string url = "data:image/jpeg;base64," + Convert.ToBase64String(response2)
    
    [mutableRequest setValue:@"image/jpg" forHTTPHeaderField:@"Content-Type"];
   
    [[self.session dataTaskWithRequest:mutableRequest completionHandler:^(NSData * data, NSURLResponse *response, NSError *error) {
        
        UIImage *image = [UIImage imageWithData:data];
         if (completionHandler)
            completionHandler(image, error);
        
    }] resume];
}


/*
 This is the main call for dotmars and sharepoint backend // Kumaresh
 */
- (void)getJsonWithRequest:(NSURLRequest *)request JsonObjectClass:(Class)JsonObjectClass withOdata:(BOOL)isOdataService completionHandler:(void (^)(id results, NSError *error))completionHandler {
    
    NSMutableURLRequest *mutableRequest = request.mutableCopy;
    if(isOdataService){
        mutableRequest = [self setJsonHeadersOdata:mutableRequest];
    }else{
        mutableRequest = [self setJsonHeaders:mutableRequest];
    }
    
    [[self.session dataTaskWithRequest:mutableRequest completionHandler:^(NSData * data, NSURLResponse *response, NSError *error) {
        
        NSError *globalError = nil;
#if DEBUG
        //Commented logging of whole response data to optimize performance.
        //        NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //        NSLog(@"response Data = %@",newStr);
#endif
        id results = [self JSONObjectFromResponse:response data:data dataTaskError:error class:JsonObjectClass error:&globalError];
        
        if (completionHandler)
            completionHandler(results, globalError);
        
    }] resume];
}


- (void)getXMLWithURL:(NSURL *)URL completionHandler:(void (^)(id results, NSError *error))completionHandler {
    
    NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:URL];
    
    mutableRequest = [self setXMLHeaders:mutableRequest];
    
    [[self.session dataTaskWithRequest:mutableRequest completionHandler:^(NSData * data, NSURLResponse *response, NSError *error) {
        
        NSError *globalError = nil;
#if DEBUG
        // Commented logging of whole response data to optimize performance.
        NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //NSLog(@"response Data = %@",newStr);
#endif
        id results;
        if(data != nil){
            results = [NSDictionary dictionaryWithXMLData:data];
        }
        if (completionHandler)
            completionHandler(results, globalError);
        
    }] resume];
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
    
    [self postData:data withRequest:[NSURLRequest requestWithURL:URL] customHeaders:customHeaders deserializeJSONResponse:deserializeJSONResponse completionHandler:completionHandler];
}

- (void)       postData:(NSData *)data
            withRequest:(NSURLRequest *)request
          customHeaders:(NSDictionary *)customHeaders
deserializeJSONResponse:(BOOL)deserializeJSONResponse
      completionHandler:(void (^)(id results, NSError *error))completionHandler {
    
    NSMutableURLRequest *mutableRequest = request.mutableCopy;
    
    mutableRequest.HTTPMethod = @"POST";
    mutableRequest.HTTPBody = data;
    
    for (NSString *headerField in customHeaders.allKeys) {
        [mutableRequest addValue:customHeaders[headerField] forHTTPHeaderField:headerField];
    }
    //ffff
    //[[BusyHudIndicator sharedInstance] startIndicator];
    //
    [[self.session uploadTaskWithRequest:mutableRequest fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSError *globalError = nil;
        id results = nil;
        
        if (deserializeJSONResponse)
            results = [self JSONObjectFromResponse:response data:data dataTaskError:error class:nil error:&globalError];
        else
            [self isSuccessfulCallWith:response data:data error:error outError:&globalError];
        
        //[[BusyHudIndicator sharedInstance] stopIndicator];
        
        if (completionHandler)
            completionHandler(results, globalError);
        
    }] resume];
}

#pragma mark - PUT

- (void)putJSONObject:(id)JSONObject
              withURL:(NSURL *)URL
    completionHandler:(void (^)(NSError *error))completionHandler {
    
    [self putJSONObject:JSONObject withRequest:[NSURLRequest requestWithURL:URL] completionHandler:completionHandler];
    
}

- (void)putJSONObject:(id)JSONObject
          withRequest:(NSURLRequest *)request
    completionHandler:(void (^)(NSError *error))completionHandler {
    
    // **************************************************
    // BODY SERIALIZATION
    NSError *error = nil;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:JSONObject options:kNilOptions error:&error];
    if (error) {
#       if DEBUG
        NSLog(@"JSON serialization error: %@", error.localizedDescription);
#       endif
        if (completionHandler)
            completionHandler(error);
        return;
    }

    NSMutableURLRequest *mutableRequest = request.mutableCopy;
        
    // **************************************************
    // URL REQUEST
    mutableRequest.HTTPMethod = @"PUT";
    mutableRequest = [self setJsonHeadersForImage:mutableRequest];
    mutableRequest.HTTPBody = bodyData;
    
    // **************************************************
    // SENDS REQUEST
  //  [[BusyHudIndicator sharedInstance] startIndicator];
    [[self.session dataTaskWithRequest:mutableRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *globalError = nil;
        [self isSuccessfulCallWith:response data:data error:error outError:&globalError];
        //[[BusyHudIndicator sharedInstance] stopIndicator];
        if (completionHandler)
            completionHandler(globalError);
    }] resume];
}
- (void)putDataObject:(NSData*)dataObject
               withRequest:(NSURLRequest *)request
     completionHandler:(void (^)(NSError *error))completionHandler{
    
    // **************************************************
    // BODY SERIALIZATION
    NSError *error = nil;
    NSData *bodyData = dataObject;
    if (error) {
#       if DEBUG
        NSLog(@"JSON serialization error: %@", error.localizedDescription);
#       endif
        if (completionHandler)
            completionHandler(error);
        return;
    }
    
    NSMutableURLRequest *mutableRequest = request.mutableCopy;
    
    // **************************************************
    // URL REQUEST
    mutableRequest.HTTPMethod = @"PUT";
    mutableRequest = [self setJsonHeadersForImage:mutableRequest];
    [mutableRequest setValue:[NSString stringWithFormat:@"%lu",(unsigned long)dataObject.length] forHTTPHeaderField:@"Content-Length"];
    // **************************************************
    // SENDS REQUEST
    //  [[BusyHudIndicator sharedInstance] startIndicator];
    [[self.session uploadTaskWithRequest:mutableRequest fromData:dataObject completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *globalError = nil;
        [self isSuccessfulCallWith:response data:data error:error outError:&globalError];
        //[[BusyHudIndicator sharedInstance] stopIndicator];
        if (completionHandler)
            completionHandler(globalError);
    }] resume];
}
#pragma mark - HTTP Upload

- (void)uploadTaskWithURL:(NSURL *)URL
                 fromData:(NSData *)data
        completionHandler:(void (^)(id results, NSError *error))completionHandler {
    
    [self uploadTaskWithRequest:[NSURLRequest requestWithURL:URL] fromData:data completionHandler:completionHandler];
}

- (void)uploadTaskWithRequest:(NSURLRequest *)request
                 fromData:(NSData *)data
        completionHandler:(void (^)(id results, NSError *error))completionHandler {
    
    NSMutableURLRequest *mutableRequest = request.mutableCopy;
    
    mutableRequest.HTTPMethod = @"POST";
    [mutableRequest setValue:@"application/json;odata=verbose" forHTTPHeaderField:@"Accept"];
    
    [[self.session uploadTaskWithRequest:mutableRequest fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *globalError;
        NSDictionary *results = [self JSONObjectFromResponse:response data:data dataTaskError:error class:NSDictionary.class error:&globalError];
        if (globalError) {
            if (completionHandler)
                completionHandler(nil, globalError);
            return;
        }
        
        if (completionHandler)
            completionHandler(results, nil);
        
    }] resume];
}

#pragma mark - HTTP Download

- (void)downloadTaskWithURL:(NSURL *)URL
          completionHandler:(void (^)(NSURL *location, NSError *error))completionHandler {

    [self downloadTaskWithRequest:[NSURLRequest requestWithURL:URL] completionHandler:completionHandler];
}

- (void)downloadTaskWithRequest:(NSURLRequest *)request
          completionHandler:(void (^)(NSURL *location, NSError *error))completionHandler {

    
   // [[BusyHudIndicator sharedInstance] startIndicator];
    
    [[self.session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        NSError *globalError = nil;
        [self isSuccessfulCallWith:response data:nil error:error outError:&globalError];
        //[[BusyHudIndicator sharedInstance] stopIndicator];
        if (completionHandler)
            completionHandler(location, globalError);
    }] resume];
}

#pragma mark - DELETE HTTP Requests

- (void)deleteWithURL:(NSURL *)URL
    completionHandler:(void (^)(NSError *error))completionHandler {
    [self deleteWithRequest:[NSURLRequest requestWithURL:URL] completionHandler:completionHandler];
}

- (void)deleteWithRequest:(NSURLRequest *)request
    completionHandler:(void (^)(NSError *error))completionHandler {
    
    NSMutableURLRequest *mutableRequest = request.mutableCopy;
    
    mutableRequest.HTTPMethod = @"DELETE";
    [mutableRequest setValue:@"DELETE" forHTTPHeaderField:@"X-HTTP-Method"];
    [mutableRequest setValue:@"*" forHTTPHeaderField:@"IF-MATCH"];
    [mutableRequest setValue:@"application/json;odata=verbose" forHTTPHeaderField:@"Accept"];
    //[[BusyHudIndicator sharedInstance] startIndicator];
    [[self.session dataTaskWithRequest:mutableRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *globalError = nil;
        [self isSuccessfulCallWith:response data:data error:error outError:&globalError];
        //[[BusyHudIndicator sharedInstance] stopIndicator];
        if (completionHandler)
            completionHandler(globalError);
    }] resume];
}

#pragma mark - JSON Headers

- (NSMutableURLRequest *)setJsonHeaders:(NSMutableURLRequest *)request {
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    return request;
}
- (NSMutableURLRequest *)setJsonHeadersOdata:(NSMutableURLRequest *)request {
    
    [request setValue:@"application/json;odata=verbose" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json;odata=verbose" forHTTPHeaderField:@"Content-Type"];
    
    return request;
}
- (NSMutableURLRequest *)setJsonHeadersForImage:(NSMutableURLRequest *)request {
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
    
    return request;
}
#pragma mark - XML Headers

- (NSMutableURLRequest *)setXMLHeaders:(NSMutableURLRequest *)request {
    
    [request setValue:@"application/xml;odata=verbose" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/xml;odata=verbose" forHTTPHeaderField:@"Content-Type"];
    
    return request;
}

#pragma mark - Helpers

- (id)JSONObjectFromResponse:(NSURLResponse *)response
                        data:(NSData *)data
               dataTaskError:(NSError *)dataTaskError
                       class:(Class)class
                       error:(NSError * __autoreleasing *)error {
    
    if (![self isSuccessfulCallWith:response data:data error:dataTaskError outError:error]) {
        return nil;
    }
    
    id results = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:error];
    if (*error) {
#       if DEBUG
        NSLog(@"HTTP response error: JSON deserialization error: %@", (*error).localizedDescription);
#       endif
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey: NSLocalizedString(@"JSON deserialization error.", nil),
                                   NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"Response is not valid JSON.", nil)
                                   };
        NSError *customError = [NSError errorWithDomain:@"MISRestClient"
                                                   code:-101
                                               userInfo:userInfo];
        *error = customError;
        return nil;
    }
    
    if (class) {
        if (![results isKindOfClass:class]) {
#if DEBUG
            NSLog(@"HTTP response error: JSON response is not as expected: Expected JSON class: %@. Actual response: %@", class, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
#endif
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(@"JSON Error.", nil),
                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"Response is not valid JSON.", nil)
                                       };
            NSError *customError = [NSError errorWithDomain:@"MISRestClient"
                                                       code:-101
                                                   userInfo:userInfo];
            *error = customError;
            return nil;
        }
    }
    return results;
}

- (BOOL)isSuccessfulCallWith:(NSURLResponse *)response
                        data:(NSData *)data error:(NSError *)inError
                    outError:(NSError * __autoreleasing *)error {
    
    // **************************************************
    // LOCAL ERROR HANDLING
    if (inError) {
#       if DEBUG
        NSLog(@"error: %@", inError.localizedDescription);
#       endif
        if (error != NULL)
            *error = inError;
        return NO;
    }
    
    // **************************************************
    // CLIENT/SERVER ERROR HANDLING
    
    if ([response isKindOfClass:NSHTTPURLResponse.class]) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode >= 400) {
#           if DEBUG
            NSLog(@"HTTP error: %ld - %@\n%@", (long)httpResponse.statusCode, httpResponse.description, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
#           endif
            NSDictionary *userInfo = nil;
            NSError *customError = nil;
            userInfo = @{
                         NSLocalizedDescriptionKey: NSLocalizedString(@"HTTP Error.", nil),
                         NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The operation failed.", nil)
                         };
            
            customError = [NSError errorWithDomain:@"MISRestClient"
                                              code:-httpResponse.statusCode
                                          userInfo:userInfo];
            if (error != NULL)
                *error = customError;
            return NO;
        }
    }
    return YES;
}

#pragma mark - URL session delegate

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust] ) {
        
        //-----------------------------------------------------------------------------------------------------
        // Certificate validation is disable for dotMars web services (because they are self-sign certificates)
        completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
        
    } else {
        
        //-------------------------------------------
        // Perform default handling for the challenge
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
        
    }
}
@end
