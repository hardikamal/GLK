//
//  VSGGoogleServiceDrive.h
//  Daily Expense Manager
//
//  Created by Appbulous on 03/01/15.
//  Copyright (c) 2015 Chandan Kumar. All rights reserved.
//


#import <Foundation/Foundation.h>

#import "GTLDrive.h"
#import "GTMOAuth2Authentication.h"


@interface VSGGoogleServiceDrive : GTLServiceDrive

/**
 Static method for having a shared Google service across the app
 */
+ (VSGGoogleServiceDrive *)sharedService;

@end