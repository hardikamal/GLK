#import "SAAPIClient.h"
#import "AFURLResponseSerialization.h"
#import "AFHTTPRequestOperationManager.h"

//static NSString * const kSAAPIBaseURLString =@"http://68.169.58.198/DemMobile/DemService/ServiceData/";
//static NSString * const kSAAPIBaseURLString =@"http://68.169.60.185/DemMobile/";


@implementation SAAPIClient

+ (instancetype)sharedClient
{
    static SAAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kSAAPIBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (!self) {
        return nil;
    }
    [self setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey]];
    [[self responseSerializer] setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    NSOperationQueue *operationQueue=[self operationQueue];
    
    [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
    {
        switch (status)
        {
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [operationQueue setSuspended:NO];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                [[[UIAlertView alloc] initWithTitle:@"No Internet" message:@"Check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            }
            default:
                [operationQueue setSuspended:YES];
                break;
        }
    }];
    
    return self;
}


@end
