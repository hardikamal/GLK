//
//  Last Updated by Alok on 26/02/15.
//  Copyright (c) 2015 Aryansbtloe. All rights reserved.
//

#import "FeedItemServices.h"
#import "AFNetworking.h"
#import "Reachability.h"


@implementation FeedItemServices

@synthesize responseErrorOption;
@synthesize progresssIndicatorText;

/**
 METHODS TO DIRECTLY GET UPDATED DATA FROM THE SERVER
 */

#define RESPONSE_STATUS_KEY  @"CODE"
#define RESPONSE_MESSAGE_KEY @"MESSAGE"

- (id)init {
    self = [super init];
    if (self) {
        [self setResponseErrorOption:ShowErrorResponseWithUsingNotification];
    }
    return self;
}

#define CONTINUE_IF_CONNECTION_AVAILABLE_SHOW_ERROR_MSG if (![self getStatusForNetworkConnectionAndShowUnavailabilityMessage:YES]) { operationFinishedBlock(nil); return; }
#define CONTINUE_IF_CONNECTION_AVAILABLE                if (![self getStatusForNetworkConnectionAndShowUnavailabilityMessage:NO]) { operationFinishedBlock(nil); return; }
#define CONTINUE_IF_CONNECTION_AVAILABLE_1              if (![self getStatusForNetworkConnectionAndShowUnavailabilityMessage:NO]) { operationFinishedBlock(); return; }

- (void)addCommonInformationInto:(NSMutableDictionary *)bodyData {
}

- (void)registerUser:(NSMutableDictionary *)info didFinished:(operationFinishedBlock)operationFinishedBlock {
    /**
     PARAMETERS TO SEND
     1)email(string)
     2)password(stinrg)
     3)name(string)
     4)device_token(string) :
     5)device_type(string)
     6)address(string)
     7)city(string)
     8)country( string)
     9)latitude(double)
     10) longitude(double)
     11)device_key
     12)purse_key="8ba470d10"
     13)profile_image
     */
    NSMutableDictionary *bodyData = [[NSMutableDictionary alloc]init];
    [AKSMethods From:info WithKey:@"firstName"              To:bodyData U:@"first_name"        OnM:M_N];
    [AKSMethods From:info WithKey:@"lastName"               To:bodyData U:@"last_name"         OnM:M_N];
    [AKSMethods From:info WithKey:@"email"                  To:bodyData U:@"email"            OnM:M_N];
    [AKSMethods From:info WithKey:@"password"               To:bodyData U:@"password"         OnM:M_N];
    [AKSMethods From:info WithKey:@"age"                    To:bodyData U:@"age"              OnM:M_N];
    [AKSMethods From:info WithKey:@"gender"                 To:bodyData U:@"sex"              OnM:M_N];
    [AKSMethods From:info WithKey:@"address"                To:bodyData U:@"address"          OnM:M_N];
    [AKSMethods From:info WithKey:@"city"                   To:bodyData U:@"city"             OnM:M_N];
    [AKSMethods From:info WithKey:@"country"                To:bodyData U:@"country"          OnM:M_N];
    [AKSMethods From:info WithKey:@"latitude"               To:bodyData U:@"latitude"         OnM:M_N];
    [AKSMethods From:info WithKey:@"longitude"              To:bodyData U:@"longitude"        OnM:M_N];
    [AKSMethods From:info WithKey:@"facebook_uid"           To:bodyData U:@"facebook_uid"     OnM:M_N];
    [AKSMethods From:info WithKey:@"twitter_uid"            To:bodyData U:@"twitter_uid"      OnM:M_N];
    [self addCommonInformationInto:bodyData];
    [self performPostRequestWithBody:bodyData toUrl:[NSString stringWithFormat:@"%@/%@", BASE_URL, REGISTER_USER] constructingBodyWithBlock: ^(id <AFMultipartFormData> formData) {
        if ([self isNotNull:[info objectForKey:@"profilePicture"]]) {
            [formData appendPartWithFileData:[info objectForKey:@"profilePicture"]
                                        name:@"profile_image"
                                    fileName:[NSString stringWithFormat:@"%f.png", (double)([[NSDate date]timeIntervalSince1970])]
                                    mimeType:@"image/png"];
        }
    } withFinishedBlock:operationFinishedBlock];
}

- (void)loginUser:(NSMutableDictionary *)info didFinished:(operationFinishedBlock)operationFinishedBlock {
    /**
     PARAMETERS TO SEND
     1)email(string)
     2)password(string)
     3)device_token(string)
     4)device_type(string)
     5)device_key(string)
     6)purse_key="37ab70e1b"
     */
    NSMutableDictionary *bodyData = [[NSMutableDictionary alloc]init];
    [AKSMethods From:info WithKey:@"email"                  To:bodyData U:@"email"            OnM:M_N];
    [AKSMethods From:info WithKey:@"password"               To:bodyData U:@"password"         OnM:M_N];
    [self addCommonInformationInto:bodyData];
    [self performPostRequestWithJsonBody:bodyData toUrl:[NSString stringWithFormat:@"%@/%@", BASE_URL, LOGIN] withFinishedBlock:operationFinishedBlock];
}

- (void)performPostRequestWithJsonBody:(NSMutableDictionary *)bodyData toUrl:(NSString *)url withFinishedBlock:(operationFinishedBlock)operationFinishedBlock {
    CONTINUE_IF_CONNECTION_AVAILABLE_SHOW_ERROR_MSG
    NSString *urlToHit = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSLog(@"\n\n\n                  HITTING URL\n\n %@\n\n\n                  WITH POST JSON BODY\n\n%@\n\n", urlToHit, bodyData);
    if (progresssIndicatorText != nil)
        [CommonFunctions showActivityIndicatorWithText:progresssIndicatorText];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager POST:urlToHit parameters:bodyData success: ^(AFHTTPRequestOperation *operation, id responseObject) {
        [self verifyServerResponseAndPerformAction:operationFinishedBlock WithResponseData:responseObject IfError:nil];
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        [self verifyServerResponseAndPerformAction:operationFinishedBlock WithResponseData:nil IfError:error];
    }];
}

- (void)performPutRequestWithJsonBody:(NSMutableDictionary *)bodyData toUrl:(NSString *)url withFinishedBlock:(operationFinishedBlock)operationFinishedBlock {
    CONTINUE_IF_CONNECTION_AVAILABLE_SHOW_ERROR_MSG
    NSString *urlToHit = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSLog(@"\n\n\n                  HITTING URL\n\n %@\n\n\n                  WITH POST JSON BODY\n\n%@\n\n", urlToHit, bodyData);
    if (progresssIndicatorText != nil)
        [CommonFunctions showActivityIndicatorWithText:progresssIndicatorText];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager PUT:urlToHit parameters:bodyData success: ^(AFHTTPRequestOperation *operation, id responseObject) {
        [self verifyServerResponseAndPerformAction:operationFinishedBlock WithResponseData:responseObject IfError:nil];
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        [self verifyServerResponseAndPerformAction:operationFinishedBlock WithResponseData:nil IfError:error];
    }];
}

- (void)performPostRequestWithBody:(NSMutableDictionary *)bodyData toUrl:(NSString *)url withFinishedBlock:(operationFinishedBlock)operationFinishedBlock {
    CONTINUE_IF_CONNECTION_AVAILABLE_SHOW_ERROR_MSG
    NSString *urlToHit = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSLog(@"\n\n\n                  HITTING URL\n\n %@\n\n\n                  WITH POST BODY\n\n%@\n\n", urlToHit, bodyData);
    if (progresssIndicatorText != nil)
        [CommonFunctions showActivityIndicatorWithText:progresssIndicatorText];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager POST:urlToHit parameters:bodyData success: ^(AFHTTPRequestOperation *operation, id responseObject) {
        [self verifyServerResponseAndPerformAction:operationFinishedBlock WithResponseData:responseObject IfError:nil];
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        [self verifyServerResponseAndPerformAction:operationFinishedBlock WithResponseData:nil IfError:error];
    }];
}

- (void)performPostRequestWithBody:(NSMutableDictionary *)bodyData toUrl:(NSString *)url constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block withFinishedBlock:(operationFinishedBlock)operationFinishedBlock {
    CONTINUE_IF_CONNECTION_AVAILABLE_SHOW_ERROR_MSG
    NSString *urlToHit = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSLog(@"\n\n\n                  HITTING URL\n\n %@\n\n\n                  WITH POST BODY\n\n%@\n\n", urlToHit, bodyData);
    if (progresssIndicatorText != nil)
        [CommonFunctions showActivityIndicatorWithText:progresssIndicatorText];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager POST:urlToHit parameters:bodyData constructingBodyWithBlock: ^(id < AFMultipartFormData > formData) {
        block(formData);
    } success: ^(AFHTTPRequestOperation *operation, id responseObject) {
        [self verifyServerResponseAndPerformAction:operationFinishedBlock WithResponseData:responseObject IfError:nil];
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        [self verifyServerResponseAndPerformAction:operationFinishedBlock WithResponseData:nil IfError:error];
    }];
}

- (void)performGetRequestWithParameters:(NSMutableDictionary *)parameters toUrl:(NSString *)url withFinishedBlock:(operationFinishedBlock)operationFinishedBlock {
    CONTINUE_IF_CONNECTION_AVAILABLE_SHOW_ERROR_MSG
    NSString *urlToHit = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSLog(@"\n\n\n                  HITTING URL\n\n %@\n\n\n                  WITH GET PARAMETERS\n\n%@\n\n", urlToHit, parameters);
    if (progresssIndicatorText != nil)
        [CommonFunctions showActivityIndicatorWithText:progresssIndicatorText];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:urlToHit parameters:parameters success: ^(AFHTTPRequestOperation *operation, id responseObject) {
        [self verifyServerResponseAndPerformAction:operationFinishedBlock WithResponseData:responseObject IfError:nil];
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        [self verifyServerResponseAndPerformAction:operationFinishedBlock WithResponseData:nil IfError:error];
    }];
}

- (void)performDeleteRequestWithParameters:(NSMutableDictionary *)parameters toUrl:(NSString *)url withFinishedBlock:(operationFinishedBlock)operationFinishedBlock {
    CONTINUE_IF_CONNECTION_AVAILABLE_SHOW_ERROR_MSG
    NSString *urlToHit = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSLog(@"\n\n\n                  HITTING URL\n\n %@\n\n\n                  WITH DELETE PARAMETERS\n\n%@\n\n", urlToHit, parameters);
    if (progresssIndicatorText != nil)
        [CommonFunctions showActivityIndicatorWithText:progresssIndicatorText];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager DELETE:urlToHit parameters:parameters success: ^(AFHTTPRequestOperation *operation, id responseObject) {
        [self verifyServerResponseAndPerformAction:operationFinishedBlock WithResponseData:responseObject IfError:nil];
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        [self verifyServerResponseAndPerformAction:operationFinishedBlock WithResponseData:nil IfError:error];
    }];
}

- (void)verifyServerResponseAndPerformAction:(operationFinishedBlock)block WithResponseData:(id)responseData IfError:(NSError *)error {
    BOOL removeActivityIndicator = (progresssIndicatorText != nil);
    if (removeActivityIndicator)
        [CommonFunctions removeActivityIndicator];
    
    if ([self isNotNull:error]) {
        if (responseErrorOption != DontShowErrorResponseMessage) {
            [self showServerNotRespondingMessage];
        }
        [FeedItemServices printErrorMessage:error];
        block(nil);
    }
    else if ([self isNotNull:responseData]) {
        id responseDictionary = [self getParsedDataFrom:responseData];
        if ([responseDictionary isKindOfClass:[NSDictionary class]]) {
            if ([self isSuccess:responseDictionary]) {
                block(responseDictionary);
            }
            else if ([self isFailure:responseDictionary]) {
                NSString *errorMessage = nil;
                if ([self isNotNull:[responseDictionary objectForKey:RESPONSE_MESSAGE_KEY]]) {
                    if ([[responseDictionary objectForKey:RESPONSE_MESSAGE_KEY]isKindOfClass:[NSString class]]) {
                        errorMessage = [responseDictionary objectForKey:RESPONSE_MESSAGE_KEY];
                    }
                    else {
                        NSMutableDictionary *dictionaryObject = [responseDictionary objectForKey:RESPONSE_MESSAGE_KEY];
                        while (([dictionaryObject isKindOfClass:[NSDictionary class]]) && ([[dictionaryObject allKeys]count] > 0)) {
                            errorMessage = [dictionaryObject objectForKey:[[dictionaryObject allKeys]objectAtIndex:0]];
                            dictionaryObject = (NSMutableDictionary *)errorMessage;
                        }
                        if ([self isNull:errorMessage] || (![errorMessage isKindOfClass:[NSString class]])) {
                            errorMessage = MESSAGE_TEXT___FOR_SERVER_NOT_REACHABILITY;
                        }
                    }
                }
                else {
                    errorMessage = MESSAGE_TEXT___FOR_SERVER_NOT_REACHABILITY;
                }
                
                if (responseErrorOption == ShowErrorResponseWithUsingNotification) {
                    [CommonFunctions showNotificationInViewController:APPDELEGATE.window.rootViewController withTitle:nil withMessage:errorMessage withType:TSMessageNotificationTypeError withDuration:MIN_DUR];
                }
                else if (responseErrorOption == ShowErrorResponseWithUsingPopUp) {
                    [CommonFunctions showMessageWithTitle:@"Error" withMessage:errorMessage];
                }
                block(nil);
            }
            else {
                if (responseErrorOption == ShowErrorResponseWithUsingNotification) {
                    [self showServerNotRespondingMessage];
                }
                block(nil);
            }
        }
        else {
            if (responseErrorOption == ShowErrorResponseWithUsingNotification) {
                [self showServerNotRespondingMessage];
            }
            block(nil);
        }
    }
    else {
        block(nil);
    }
}

#pragma mark - common method for Internet reachability checking

- (BOOL)getStatusForNetworkConnectionAndShowUnavailabilityMessage:(BOOL)showMessage {
    if (([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)) {
        if (showMessage == NO) return NO;
        [JDStatusBarNotification setDefaultStyle: ^JDStatusBarStyle *(JDStatusBarStyle *style) {
            style.barColor = [UIColor colorWithRed:0.797 green:0.148 blue:0.227 alpha:1.000];
            style.textColor = [UIColor whiteColor];
            style.animationType = JDStatusBarAnimationTypeMove;
            return style;
        }];
        [JDStatusBarNotification showWithStatus:MESSAGE_TEXT___FOR_NETWORK_NOT_REACHABILITY dismissAfter:MIN_DUR];
        return NO;
    }
    return YES;
}

- (void)showServerNotRespondingMessage {
    [CommonFunctions showNotificationInViewController:APPDELEGATE.window.rootViewController withTitle:MESSAGE_TITLE___FOR_SERVER_NOT_REACHABILITY withMessage:MESSAGE_TEXT___FOR_SERVER_NOT_REACHABILITY withType:TSMessageNotificationTypeError withDuration:MIN_DUR];
}

#pragma mark - common method parse and return the data

- (id)getParsedDataFrom:(NSData *)dataReceived {
    NSString *dataAsString = [[NSString alloc] initWithData:dataReceived encoding:NSUTF8StringEncoding];
    id parsedData   = [NSJSONSerialization JSONObjectWithData:dataReceived options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"\n\nRECEIVED DATA BEFORE PARSING IS \n\n%@\n\n\n", dataAsString);
    NSLog(@"\n\nRECEIVED DATA AFTER PARSING IS \n\n%@\n\n\n", parsedData);
    return parsedData;
}

- (void)prepareRequestForGetMethod:(NSMutableURLRequest *)request {
    [self addCredentialsToRequest:request];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
}

- (void)reportMissingParameterWithName:(NSString *)missingParameter WhileRequestingWithMethodName:(NSString *)method {
    NSString *report = [NSString stringWithFormat:@"\nMISSING PARAMETER :--- %@ ---IN METHOD : %@\n", missingParameter, method];
    NSLog(@"%@", report);
}

- (BOOL)isSuccess:(NSMutableDictionary *)response {
    if ([response isKindOfClass:[NSDictionary class]]) {
        NSString *requestStatus = [NSString stringWithFormat:@"%@", [response objectForKey:RESPONSE_STATUS_KEY]];
        if ([requestStatus isEqualToString:@"200"]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isFailure:(NSMutableDictionary *)response {
    if ([response isKindOfClass:[NSDictionary class]]) {
        NSString *requestStatus = [NSString stringWithFormat:@"%@", [response objectForKey:RESPONSE_STATUS_KEY]];
        if ([self isNotNull:requestStatus] && (![requestStatus isEqualToString:@"200"])) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - common method to add credentials to request

- (void)addCredentialsToRequest:(NSMutableURLRequest *)request {
#define NEED_TO_ADD_CREDENTIALS FALSE
    if (NEED_TO_ADD_CREDENTIALS) {
        NSString *userName = @"";
        NSString *password = @"";
        if ([self isNotNull:userName] && [self isNotNull:password]) {
            [request addValue:[@"Basic "stringByAppendingFormat : @"%@", [self encode:[[NSString stringWithFormat:@"%@:%@", userName, password] dataUsingEncoding:NSUTF8StringEncoding]]] forHTTPHeaderField:@"Authorization"];
        }
    }
}

#pragma mark - common method to do some encoding

static char *alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
- (NSString *)encode:(NSData *)plainText {
    int encodedLength = (4 * (([plainText length] / 3) + (1 - (3 - ([plainText length] % 3)) / 3))) + 1;
    unsigned char *outputBuffer = malloc(encodedLength);
    unsigned char *inputBuffer = (unsigned char *)[plainText bytes];
    NSInteger i;
    NSInteger j = 0;
    int remain;
    for (i = 0; i < [plainText length]; i += 3) {
        remain = [plainText length] - i;
        outputBuffer[j++] = alphabet[(inputBuffer[i] & 0xFC) >> 2];
        outputBuffer[j++] = alphabet[((inputBuffer[i] & 0x03) << 4) |
                                     ((remain > 1) ? ((inputBuffer[i + 1] & 0xF0) >> 4) : 0)];
        
        if (remain > 1)
            outputBuffer[j++] = alphabet[((inputBuffer[i + 1] & 0x0F) << 2)
                                         | ((remain > 2) ? ((inputBuffer[i + 2] & 0xC0) >> 6) : 0)];
        else outputBuffer[j++] = '=';
        
        if (remain > 2) outputBuffer[j++] = alphabet[inputBuffer[i + 2] & 0x3F];
        else outputBuffer[j++] = '=';
    }
    outputBuffer[j] = 0;
    NSString *result = [NSString stringWithCString:outputBuffer length:strlen(outputBuffer)];
    free(outputBuffer);
    return result;
}

+ (void)printErrorMessage:(NSError *)error {
    if (error) {
        NSLog(@"[error localizedDescription]        : %@", [error localizedDescription]);
        NSLog(@"[error localizedFailureReason]      : %@", [error localizedFailureReason]);
        NSLog(@"[error localizedRecoverySuggestion] : %@", [error localizedRecoverySuggestion]);
    }
}

@end
