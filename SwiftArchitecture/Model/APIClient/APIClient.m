//
//  APIClient.m
//  NewWindBase
//
//  Created by newwindsoft  on 8/6/13.
//  Copyright (c) 2013 newwindsoft . All rights reserved.
//

#import "APIClient.h"

@implementation APIClient

+ (APIClient *)sharedClient {
    static APIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[APIClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseServer]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self)
    {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    
    return self;
}

/*
 * Handle Success Operation
 */
- (void)handleSuccess:(id)responseData success:(void (^)(ResponseObject *responseObject))blockSuccess
{
    if (blockSuccess) {
		NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
		
        NSError *error = nil;
        NSDictionary *responseDict;
		if (responseData) {
			responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
		} else {
			responseDict = nil;
		}
		ResponseObject *responseObject = [[ResponseObject alloc] init];
		
		if (error) {
			responseObject.data = nil;
			responseObject.message = responseString;
		} else {
			responseObject.data = responseDict;
			responseObject.message = @"Success!";
		}
		
        blockSuccess(responseObject);
    }
}

/*
 * Handle Failed Operation
 */
- (void)handleFailed:(NSError *)error failure:(void (^)(ResponseObject *failureObject))blockFail
{
    if (blockFail) {
        ResponseObject *responseObject = [[ResponseObject alloc] init];
		responseObject.errorCode = (NSInteger)error.code;
		responseObject.data = nil;
		responseObject.message = [error.userInfo objectForKey:@"message"];
		//TrungDQ - Add general info to responseObject
        responseObject.info = error.userInfo;
        blockFail(responseObject);
    }
}


//Process response
- (void)processOperation:(AFHTTPRequestOperation *)operation withData:(id)responseObject success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure
{
	
	if ([operation.response statusCode] != kJSONSuccess && [operation.response statusCode] != kJSONCreatedSuccess && [operation.response statusCode] != kJSONDeletedSuccess) {
		NSError *errorParser = nil;
        NSDictionary *responseDict;
		if (operation.responseData) {
			responseDict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:&errorParser];
		} else {
			responseDict = nil;
		}
		
		NSString *message = @"";
		if (responseDict && !errorParser) {
			message = [responseDict objectForKey:@"error"];
		} else {
			message = operation.responseString;
		}
		
		NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:message, @"message", nil];
		if ((message == nil) && ([operation.response statusCode] == kJSONForbiddenError)) {
            userInfo = responseDict;
        }
		NSError *error = [[NSError alloc] initWithDomain:operation.request.URL.absoluteString code:operation.response.statusCode userInfo:userInfo];
		[self handleFailed:error failure:blockFailure];
		return;
	}
	[self handleSuccess:responseObject success:blockSuccess];
}

/*

- (void)addDrugWithName:(NSString *)name forNric:(NSString *)nric success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure{

    NSString *path = kAddDrug_Service;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    _setObjectToDictionary(params, @"name", name);
    _setObjectToDictionary(params, @"token", [Session sharedInstance].accessToken);
    _setObjectToDictionary(params, @"nric",nric);
    
    NSString *json = [params JSONString];
    NSMutableDictionary *sendParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:json, @"drug_allergies_add", nil];
    
    [self postPath:path parameters:sendParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];

}

- (void)editDrug:(NSString *)ids name:(NSString *)name forNric:(NSString *)nric success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure{

    NSString *path = kEditDrug_Service;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    _setObjectToDictionary(params, @"id",ids);
    _setObjectToDictionary(params, @"nric",nric);
    _setObjectToDictionary(params, @"name", name);
    _setObjectToDictionary(params, @"token", [Session sharedInstance].accessToken);
    
    NSString *json = [params JSONString];
    NSMutableDictionary *sendParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:json, @"drug_allergies_edit", nil];
    
    [self postPath:path parameters:sendParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];

}

- (void)deleteDrug:(NSString *)ids forNric:(NSString *)nric success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure{

    NSString *path = kDeleteDrug_Service;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    _setObjectToDictionary(params, @"id",ids);
    _setObjectToDictionary(params, @"nric",nric);
    _setObjectToDictionary(params, @"token", [Session sharedInstance].accessToken);
    
    NSString *json = [params JSONString];
    NSMutableDictionary *sendParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:json, @"drug_allergies_delete", nil];
    
    [self postPath:path parameters:sendParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
}
*/
@end
