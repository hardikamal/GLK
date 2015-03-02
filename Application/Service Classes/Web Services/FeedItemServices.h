//
//  Last Updated by Alok on 26/02/15.
//  Copyright (c) 2015 Aryansbtloe. All rights reserved.
//

/**
 FeedItemServices:-
 This service class initiates and handles all server interaction related network connection.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JDStatusBarNotification.h"

typedef NS_ENUM (NSInteger, ResponseErrorOption) {
	DontShowErrorResponseMessage = 0,
	ShowErrorResponseWithUsingNotification, //Default value is set to this option
	ShowErrorResponseWithUsingPopUp
};

@class AppDelegate;

typedef void (^operationFinishedBlock)(id responseData);

@interface FeedItemServices : NSObject

@property (nonatomic, readwrite) ResponseErrorOption responseErrorOption;
@property (nonatomic, strong) NSString *progresssIndicatorText;

- (void)registerUser:(NSMutableDictionary *)info didFinished:(operationFinishedBlock)operationFinishedBlock;
- (void)loginUser:(NSMutableDictionary *)info didFinished:(operationFinishedBlock)operationFinishedBlock;

@end

#define  BASE_URL                         @"http://purse.appxcel.com"
#define  REGISTER_USER                    @"signup"
#define  LOGIN                            @"login"