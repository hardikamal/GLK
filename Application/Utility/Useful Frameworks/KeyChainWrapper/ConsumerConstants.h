//
//  ConsumerConstants.h
//  ConsumerApp
//
//  Created by Jyoti Kumar on 06/05/14.
//  Copyright (c) 2014 AppStudioz. All rights reserved.
//

#ifndef ConsumerApp_ConsumerConstants_h
#define ConsumerApp_ConsumerConstants_h


typedef enum {
    kResponseTypeFail = 0,
    kresponseTypeSuccess
} ResponseType;

#pragma mark * Block Definitions

typedef void (^CompletionBlock) ();
typedef void (^CompletionWithIndexBlock) (NSUInteger index);
typedef void (^CompletionWithMessagesBlock) (id messages);
typedef void (^CompletionWithStringBlock) (NSString *string);
typedef void (^CompletionWithBoolBlock) (BOOL successful);
typedef void (^CompletionWithBoolAndStringBlock) (BOOL successful, NSString *info);
typedef void (^CompletionWithResponseTypeAndResponse) (ResponseType type, id response);
typedef void (^BusyUpdateBlock) (BOOL busy);

// Used to specify the application used in accessing the Keychain.
#define APP_NAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]

// Used for saving to NSUserDefaults that a PIN has been set, and is the unique identifier for the Keychain.
#define PIN_SAVED @"hasSavedPIN"

// Used for saving the user's name to NSUserDefaults.
#define USERNAME @"username"

// Used to help secure the PIN.
// Ideally, this is randomly generated, but to avoid the unnecessary complexity and overhead of storing the Salt separately, we will standardize on this key.
// !!KEEP IT A SECRET!!
#define SALT_HASH @"YOURMADEUPSALTHASHB8TQRygHaS2B1pgfy02wqGndj7PLHD2G3fxaZz4oGA3RsKdN2pxdAopXYgzzzz"

#define NOTIFICATION_HUB_NAME @"YOUR_NOTIFICATION_HUB_NAME"
#define NOTIFICATION_HUB_CONNECTION_STRING @"YOUR_LISTEN_CONNECTION_STRING"
#define MOBILE_SERVICE_URL @"https://offermill-js.azure-mobile.net/"
#define MOBILE_SERVICE_APPLICATION_KEY @"kIPHTTMaQGsqegomRFIpvFykhMwPQx12"

//Set urls to your terms and privacy pages
//#define TERMS_AND_CONDITIONS_URL @"http://lensrocket.azurewebsites.net/terms.html"
//#define PRIVACY_POLICY_URL @"http://lensrocket.azurewebsites.net/privacy.html"





#endif
