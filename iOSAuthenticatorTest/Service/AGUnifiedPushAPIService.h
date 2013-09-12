#import <Foundation/Foundation.h>

@class AGPushApplication;


@interface AGUnifiedPushAPIService : NSObject

@property (strong, nonatomic) NSMutableDictionary* applications;

+(void)initSharedInstanceWithBaseURL:(NSString*)baseURL
                             success:(void (^)())success
                             failure:(void (^)(NSError* error))failure;

+ (void)initSharedInstanceWithBaseURL:(NSString*)baseURL
                             username:(NSString*)username
                             password:(NSString*)password
                              success:(void (^)())success
                              failure:(void (^)(NSError* error))failure;

+ (AGUnifiedPushAPIService*)sharedInstance;

- (void) logout:(void (^)())success
        failure:(void (^)(NSError* error))failure;

- (void)fetchApplications:(void (^)(NSMutableArray* applications))success
                  failure:(void (^)(NSError* error))failure;

- (void)postApplication:(AGPushApplication*)application
                success:(void (^)())success
                failure:(void (^)(NSError* error))failure;

- (void)removeApplication:(AGPushApplication*)application
                  success:(void (^)())success
                  failure:(void (^)(NSError* error))failure;

@end