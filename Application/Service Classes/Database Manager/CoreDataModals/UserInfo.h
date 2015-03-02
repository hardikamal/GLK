//
//  UserInfo.h
//  Application
//
//  Created by Alok Singh on 26/02/15.
//  Copyright (c) 2015 Mobulous. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserInfo : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * email_id;
@property (nonatomic, retain) NSNumber * hide_status;
@property (nonatomic, retain) NSNumber * location;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSNumber * server_updation_date;
@property (nonatomic, retain) NSString * token_id;
@property (nonatomic, retain) NSNumber * updation_date;
@property (nonatomic, retain) NSString * user_dob;
@property (nonatomic, retain) NSData * user_img;
@property (nonatomic, retain) NSString * user_name;
@property (nonatomic, retain) NSString * user_token_id;

@end
