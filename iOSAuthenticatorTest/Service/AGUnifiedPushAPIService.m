#import "AGUnifiedPushAPIService.h"
#import "AGAuthenticator.h"
#import "AGPipeline.h"
#import "AGPushApplication.h"

static AGUnifiedPushAPIService* __sharedInstance;

@implementation AGUnifiedPushAPIService {

    id <AGPipe> _applicationsPipe;

    id <AGAuthenticationModule> _restAuthModule;


}

@synthesize applications;

+ (void)initSharedInstanceWithBaseURL:(NSString*)baseURL
                              success:(void (^)())success
                              failure:(void (^)(NSError* error))failure {

    __sharedInstance = [[AGUnifiedPushAPIService alloc] initWithBaseURL:[NSURL URLWithString:baseURL]
                                                                success:success
                                                                failure:failure];

}

+ (void)initSharedInstanceWithBaseURL:(NSString*)baseURL
                             username:(NSString*)username
                             password:(NSString*)password
                              success:(void (^)())success
                              failure:(void (^)(NSError* error))failure {

    __sharedInstance = [[AGUnifiedPushAPIService alloc] initWithBaseURL:[NSURL URLWithString:baseURL]
                                                               username:username
                                                               password:password
                                                                success:success
                                                                failure:failure];

}

- (id)initWithBaseURL:(NSURL*)serverUrl
              success:(void (^)())success
              failure:(void (^)(NSError* error))failure {
    if(self = [super init]) {
        AGPipeline*  pipeline = [AGPipeline pipelineWithBaseURL:serverUrl];

        _applicationsPipe = [pipeline pipe:^(id <AGPipeConfig> config) {
            [config setName:@"applications"];
            [config setType:@"REST"];
            [config setRecordId:@"pushApplicationID"];
        }];

        success();
    }

    return self;
}

- (id)initWithBaseURL:(NSURL*)serverUrl
             username:(NSString*)username
             password:(NSString*)password
              success:(void (^)())success
              failure:(void (^)(NSError* error))failure {
    if (self = [super init]) {
        AGAuthenticator* authenticator = [AGAuthenticator authenticator];

        _restAuthModule = [authenticator auth:^(id <AGAuthConfig> config) {
            [config setName:@"restAuthMod"];
            [config setBaseURL:serverUrl];
        }];

        [_restAuthModule login:@{@"loginName": username, @"password": password} success:^(id object) {
            AGPipeline* pipeline = [AGPipeline pipelineWithBaseURL:serverUrl];

            _applicationsPipe = [pipeline pipe:^(id <AGPipeConfig> config) {
                [config setName:@"applications"];
                [config setAuthModule:_restAuthModule];
                [config setType:@"REST"];
                [config setRecordId:@"pushApplicationID"];
            }];

            success();
        } failure:^(NSError* error) {
            failure(error);
        }];
    }

    return self;
}

+ (AGUnifiedPushAPIService*)sharedInstance {
    return __sharedInstance;
}

- (void) logout:(void (^)())success
        failure:(void (^)(NSError* error))failure {
    if(_restAuthModule == nil) {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"restAuthModule is nil!!" forKey:NSLocalizedDescriptionKey];
        failure([NSError errorWithDomain:@"apiService" code:444 userInfo:details]);
        return;
    }
    [_restAuthModule logout:^{
                        success();
                    }
                    failure:^(NSError* error) {
                        failure(error);
                    }];
}

- (void) fetchApplications:(void (^)(NSMutableArray* applications))success
                   failure:(void (^)(NSError* error))failure {
    [_applicationsPipe read:^(id responseObject) {
        NSMutableArray* applications = [NSMutableArray array];

        for(id applicationDictionary in responseObject) {
            AGPushApplication* application = [[AGPushApplication alloc] initWithDictionary:applicationDictionary];

            [applications addObject:application];
        }

        success(applications);
    } failure:^(NSError* error) {
        failure(error);
    }];
}

- (void)postApplication:(AGPushApplication*)application
                success:(void (^)())success
                failure:(void (^)(NSError* error))failure {

    [_applicationsPipe save:[application dictionary]
                    success:^(id responseObject) {
                        if(responseObject != nil) {
                            [application initWithDictionary:responseObject];
                        }
                        success();
                    } failure:^(NSError* error) {
                        failure(error);
                    }];
}

- (void)removeApplication:(AGPushApplication*)application
                  success:(void (^)())success
                  failure:(void (^)(NSError* error))failure {

    [_applicationsPipe remove:[application dictionary]
                      success:^(id responseObject) {
                          success();
                      } failure:^(NSError* error) {
                          failure(error);
                      }];

}

@end