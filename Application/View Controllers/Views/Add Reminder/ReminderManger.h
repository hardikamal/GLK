//
//  ReminderManger.h
//  Daily Expense Manager
//
//  Created by Appbulous on 18/09/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReminderManger : NSObject
+(ReminderManger *) sharedMager;
-(void)setReminde:(NSString*)uuid :(NSDate*)date;
-(void)manageSubAlarmNotification:(NSDictionary*)dictionary;
-(void)handleTransaction:(NSDictionary*)dic;
-(void)initReminder:(NSString*)uuid :(NSString*)trnsactionId;
-(void)cancelAlarm:(NSString*)uuid;
@end
