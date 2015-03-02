//
//  VSGGoogleServiceDrive.m
//  Daily Expense Manager
//
//  Created by Appbulous on 03/01/15.
//  Copyright (c) 2015 Chandan Kumar. All rights reserved.
//


#import "VSGGoogleServiceDrive.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "GTMOAuth2ViewControllerTouch.h"
#import "GTLDrive.h"

static NSString *const kKeychainItemName = @"PdfReaderRes";//@"PdfReaderRes";
static NSString *const kClientId =@"1009544359695-vfq6m7hltvudgj5ek5l5grcvt62hatoo.apps.googleusercontent.com";//@"102673127935-4c68qg4u5vbldb9vjs46ongsgkslcmk2.apps.googleusercontent.com";*/
static NSString *const kClientSecret =@"UTj3KeexhlkJD58AwwdLX0kQ";//@"CAOBkGq9lFmFKxT_tvDCj4sg";

@implementation VSGGoogleServiceDrive

+ (VSGGoogleServiceDrive *)sharedService {
    
    static VSGGoogleServiceDrive *sharedServiceDrive = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedServiceDrive = [[VSGGoogleServiceDrive alloc] init];
    });
    return sharedServiceDrive;
}


- (id)init
{
    self = [super init];
    if (!self)
    {
        return nil;
    }
    GTMOAuth2Authentication *auth = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName   clientID:kClientId    clientSecret:kClientSecret];
    self.authorizer = auth;
    return self;
}

@end