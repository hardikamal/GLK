//
//  Last Updated by Alok on 26/02/15.
//  Copyright (c) 2015 Aryansbtloe. All rights reserved.
//

#ifndef ApplicationSpecificConstants_h
#define ApplicationSpecificConstants_h

/**
 Constants:-
 
 This header file holds all configurable constants specific  to this application.
 
 */

////////////////////////////////////////SOME MACROS TO MAKE YOUR PROGRAMING LIFE EASIER/////////////////////////////////////////

/**
 return if no internet connection is available with and without error message
 */
#define RETURN_IF_NO_INTERNET_AVAILABLE_WITH_USER_WARNING if (![CommonFunctions getStatusForNetworkConnectionAndShowUnavailabilityMessage:YES]) return;
#define RETURN_IF_NO_INTERNET_AVAILABLE                   if (![CommonFunctions getStatusForNetworkConnectionAndShowUnavailabilityMessage:NO]) return;

/**
 get status of internet connection
 */
#define IS_INTERNET_AVAILABLE_WITH_USER_WARNING           [CommonFunctions getStatusForNetworkConnectionAndShowUnavailabilityMessage:YES]
#define IS_INTERNET_AVAILABLE                             [CommonFunctions getStatusForNetworkConnectionAndShowUnavailabilityMessage:NO]

#define SHOW_SERVER_NOT_RESPONDING_MESSAGE                [CommonFunctions showNotificationInViewController:self withTitle:nil withMessage:@"Server not responding .Please try again after some time." withType:TSMessageNotificationTypeError withDuration:MIN_DUR];
#define CONTINUE_IF_MAIN_THREAD if ([NSThread isMainThread] == NO) { NSAssert(FALSE, @"Not called from main thread"); }

#define FUNCTIONALLITY_PENDING_MESSAGE  [CommonFunctions showNotificationInViewController:APPDELEGATE.window.rootViewController withTitle:nil withMessage:@"We are still developing this functionallity ,please ignore it." withType:TSMessageNotificationTypeMessage withDuration:MIN_DUR];

#define MIN_DUR 3

#define IMG(x) [CommonFunctions getDeviceSpecificImageNameForName : x]

#define PUSH_NOTIFICATION_DEVICE_TOKEN                    @"deviceToken"
#define DEVICE_KEY                                        @"deviceKey"

#define TIME_DELAY_IN_FREQUENTLY_SAVING_CHANGES 1

#define WINDOW_OBJECT ((UIWindow *)[[[UIApplication sharedApplication].windows sortedArrayUsingComparator: ^NSComparisonResult (UIWindow *win1, UIWindow *win2) { return win1.windowLevel - win2.windowLevel; }]lastObject])

#define COMMON_VIEW_CONTROLLER_METHODS \
- (id)initWithNibName : (NSString *)nibNameOrNil bundle : (NSBundle *)nibBundleOrNil { \
self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];            \
if (self) {                                                                       \
}                                                                             \
return self;                                                                  \
}                                                                                 \
- (id)init {                                                                      \
self = [super init];                                                          \
if (self) {                                                                   \
}                                                                             \
return self;                                                                  \
}                                                                                 \
- (void)dealloc { \
[[NSNotificationCenter defaultCenter]removeObserver:self]; \
NSLog(@"%@ deallocated", [[self class]description]); \
[[NSUserDefaults standardUserDefaults]removeObjectForKey:[[self class]description]]; \
} \
- (void)didReceiveMemoryWarning {                                                 \
[super didReceiveMemoryWarning];                                              \
} \
- (void)viewDidDisappear:(BOOL)animated { \
CHECK_IF_VIEW_CONTROLLER_DEALLOCATED_WHEN_POPPED \
[super viewDidDisappear : animated]; \
}

#define LOG_VIEW_CONTROLLER_LOADING NSLog(@"%@ loaded", [[self class]description]);
#define LOG_VIEW_CONTROLLER_APPEARING NSLog(@"%@ appears", [[self class]description]);

#define APPLICATION_WEB_LINK @"http://www.getbetify.com/"
#define APPLICATION_APP_STORE_LINK @"https://itunes.apple.com/us/app/betify/id657775633?ls=1&mt=8"

#define USE_EXTERNAL_API_FOR_FACEBOOK_SHARING 0

#define VIEW_DECK_LEFT_SIZE 44

/*
 Message titles AND texts for all alerts in the application
 */

#define MINIMUM_LENGTH_LIMIT_USERNAME 1
#define MAXIMUM_LENGTH_LIMIT_USERNAME 20

#define MINIMUM_LENGTH_LIMIT_FIRST_NAME 0
#define MAXIMUM_LENGTH_LIMIT_FIRST_NAME 24

#define MINIMUM_LENGTH_LIMIT_LAST_NAME 0
#define MAXIMUM_LENGTH_LIMIT_LAST_NAME 24

#define MINIMUM_LENGTH_LIMIT_PASSWORD 6
#define MAXIMUM_LENGTH_LIMIT_PASSWORD 20

#define MINIMUM_LENGTH_LIMIT_MOBILE_NUMBER 7
#define MAXIMUM_LENGTH_LIMIT_MOBILE_NUMBER 14

#define MAXIMUM_LENGTH_LIMIT_EMAIL 64

#define MESSAGE_TITLE___TWITTER_SHARING_SUCCESSFULL @"Application"
#define MESSAGE_TEXT____TWITTER_SHARING_SUCCESSFULL @"Shared on twitter."

#define MESSAGE_TITLE___TWITTER_SHARING_FAILED @"Application"
#define MESSAGE_TEXT____TWITTER_SHARING_FAILED @"Failed to share on twitter."

#define MESSAGE_TITLE___FACEBOOK_SHARING_FAILED @"Application"
#define MESSAGE_TEXT____FACEBOOK_SHARING_FAILED @"Failed to share on facebook."

#define MESSAGE_TITLE___FACEBOOK_SHARING_SUCCESSFULL @"Application"
#define MESSAGE_TEXT____FACEBOOK_SHARING_SUCCESSFULL @"Shared on facebook."

#define MESSAGE_TITLE___NO_TWITTER_ACCOUNT_FOUND @"Application"
#define MESSAGE_TEXT____NO_TWITTER_ACCOUNT_FOUND @"No twitter account found.\nPlease go to settings to add twitter account."

#define MESSAGE_TITLE___NO_FACEBOOK_ACCOUNT_FOUND @"Application"
#define MESSAGE_TEXT____NO_FACEBOOK_ACCOUNT_FOUND @"No facebook account found.\nPlease go to settings to add facebook account."

#define WAIT_FOR_RESPONSE_TIME 30

#define SHOW_EXCEPTION_MESSAGE(x) \
[CommonFunctions showNotificationInViewController : APPDELEGATE.window.rootViewController withTitle : nil withMessage : x withType : TSMessageNotificationTypeError withDuration : MIN_DUR];

#define NOTIFY_TO_UPDATE_LAYOUT_CUSTOM [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NEED_LAYOUT_UPDATE_CUSTOM object:nil];

#define NOTIFICATION_NEED_LAYOUT_UPDATE_CUSTOM @"NOTIFICATION_NEED_LAYOUT_UPDATE_CUSTOM"

#define SPLASH_DURATION 3

#define DELAY_IN_ACTUAL_UPDATE 6

#define PUSH_NOTIFICATION_TOKEN [[NSUserDefaults standardUserDefaults]objectForKey:PUSH_NOTIFICATION_DEVICE_TOKEN]

#define S_NB_N_S_VALUE -12

#define PAGINATION_SIZE 20
#define PAGINATION_SIZE_INFINITE 102400

#define GREEN_COLOR  [UIColor colorWithRed:0/255.0f green:150/255.0f blue:136/255.0f alpha:1.0f]

#endif
