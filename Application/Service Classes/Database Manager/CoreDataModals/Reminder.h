//
//  Reminder.h
//  Application
//
//  Created by Alok Singh on 26/02/15.
//  Copyright (c) 2015 Mobulous. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Reminder : NSManagedObject

@property (nonatomic, retain) NSString * amount;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSNumber * date;
@property (nonatomic, retain) NSString * discription;
@property (nonatomic, retain) NSString * paymentMode;
@property (nonatomic, retain) NSData * pic;
@property (nonatomic, retain) NSString * reminder_alarm;
@property (nonatomic, retain) NSString * reminder_alert;
@property (nonatomic, retain) NSString * reminder_heading;
@property (nonatomic, retain) NSString * reminder_recurring_type;
@property (nonatomic, retain) NSString * reminder_sub_alarm;
@property (nonatomic, retain) NSString * reminder_time_period;
@property (nonatomic, retain) NSString * reminder_when_to_alert;
@property (nonatomic, retain) NSNumber * server_updation_date;
@property (nonatomic, retain) NSString * sub_category;
@property (nonatomic, retain) NSString * token_id;
@property (nonatomic, retain) NSString * transaction_id;
@property (nonatomic, retain) NSString * transaction_type;
@property (nonatomic, retain) NSNumber * updation_date;
@property (nonatomic, retain) NSString * user_token_id;

@end
