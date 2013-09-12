#import "AGPushApplication.h"


@implementation AGPushApplication {

}

@synthesize recordId;
@synthesize pushApplicationID;
@synthesize name;
@synthesize description;
@synthesize developer;
@synthesize androidVariantsCount;
@synthesize iosVariantsCount;
@synthesize simplePushVariantsCount;

- (id)initWithDictionary:(NSDictionary*)dictionary {
    if(self = [super init]) {
        self.recordId = [dictionary objectForKey:@"id"];
        self.pushApplicationID = [dictionary objectForKey:@"pushApplicationID"];
        self.masterSecret = [dictionary objectForKey:@"masterSecret"];
        self.name = [dictionary objectForKey:@"name"];
        self.description = [dictionary objectForKey:@"description"];
        self.developer = [dictionary objectForKey:@"developer"];
        self.androidVariantsCount = [[NSNumber alloc] initWithInteger:[[dictionary objectForKey:@"androidVariants"] count]];
        self.iosVariantsCount = [[NSNumber alloc] initWithInteger:[[dictionary objectForKey:@"iosvariants"] count]];
        self.simplePushVariantsCount = [[NSNumber alloc] initWithInteger:[[dictionary objectForKey:@"simplePushVariants"] count]];
    }

    return self;
}

- (NSDictionary*)dictionary {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];

    [dictionary setValue:self.pushApplicationID forKey:@"pushApplicationID"];
    [dictionary setValue:self.name forKey:@"name"];
    [dictionary setValue:self.description forKey:@"description"];

    return dictionary;
}

- (void)copyFrom:(AGPushApplication*)application {
    self.recordId = application.recordId;
    self.pushApplicationID = application.pushApplicationID;
    self.masterSecret = application.masterSecret;
    self.name = application.name;
    self.description = application.description;
    self.developer = application.developer;
    self.androidVariantsCount = application.androidVariantsCount;
    self.iosVariantsCount = application.iosVariantsCount;
    self.simplePushVariantsCount = application.simplePushVariantsCount;
}

- (BOOL)isEqual:(id)other {
    if(![other isKindOfClass:[AGPushApplication class]]) {
        return NO;
    }

    AGPushApplication* otherApplication = (AGPushApplication*) other;

    return ([self.recordId isEqualToString:otherApplication.recordId]);
}

@end