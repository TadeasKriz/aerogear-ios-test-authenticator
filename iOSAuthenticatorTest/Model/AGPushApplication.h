#import <Foundation/Foundation.h>


@interface AGPushApplication : NSObject

@property (strong, nonatomic) NSString* recordId;
@property (copy, nonatomic) NSString* pushApplicationID;
@property (copy, nonatomic) NSString* masterSecret;
@property (copy, nonatomic) NSString* name;
@property (copy, nonatomic) NSString* description;
@property (copy, nonatomic) NSString* developer;
@property (copy, nonatomic) NSNumber* androidVariantsCount;
@property (copy, nonatomic) NSNumber* iosVariantsCount;
@property (copy, nonatomic) NSNumber* simplePushVariantsCount;

- (id)initWithDictionary:(NSDictionary*)dictionary;

- (NSDictionary*)dictionary;

- (void)copyFrom:(AGPushApplication*)application;

@end