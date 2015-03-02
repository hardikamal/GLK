//
//  ReminderManger.m
//  Daily Expense Manager
//
//  Created by Appbulous on 18/09/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import "ReminderManger.h"
#import "ReminderHandler.h"
#import "TransactionHandler.h"
#import "ReminderHandler.h"
#import "Reminder.h"
#import "TransactionDetailsViewController.h"
@implementation ReminderManger


-(id) init
{
    self = [super init];
    if(self)
    {
     
    }
    return self;
}



+(ReminderManger *) sharedMager
{
    static ReminderManger *singletone=nil;
    if(!singletone)
    {
        singletone=[[ReminderManger alloc] init];
    }
    return singletone;
}


-(void)setReminde:(NSString*)uuid :(NSDate*)date :(NSString  *)subHeading :(NSString*)trasactionId :(NSString*)subAlarm
{
    NSDate *correctDate ;
    if([[NSDate date] compare:date] == NSOrderedAscending)
    {
             correctDate=date;
    }  else
    {
             correctDate = [[NSDate date] dateByAddingTimeInterval:1];
    }
    NSMutableDictionary *theInfo =[[NSMutableDictionary alloc] init];
    [theInfo setValue:trasactionId forKey:@"reminder"];
    [theInfo setValue:uuid forKey:@"transactionId"];
    [theInfo setValue:subAlarm forKey:@"reminder_sub_alarm"];
    UILocalNotification *notification = [[UILocalNotification alloc]  init] ;
    notification.fireDate = correctDate ;
    notification.userInfo= theInfo;
    
    if ([subHeading length]==0)
    {
            notification.alertBody = nil;
    }else
          notification.alertBody = subHeading;
    
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.applicationIconBadgeNumber = 1;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification] ;
}


-(void)cancelAlarm:(NSString*)uuid
{
    for (UILocalNotification *notification in [[[UIApplication sharedApplication] scheduledLocalNotifications] copy])
    {
        NSDictionary *userInfo = notification.userInfo;
        if ([uuid isEqualToString:[userInfo objectForKey:@"reminder"]])
        {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
}


-(void)initReminder:(NSString*)uuid :(NSString*)trnsactionId
{
    NSArray* reminderItems =[[ReminderHandler sharedCoreDataController] getAllReminder:trnsactionId];
    NSDictionary *dictionary=[reminderItems objectAtIndex:0];
    NSString *nDate=[[dictionary objectForKey:@"date"] stringValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:([nDate doubleValue] / 1000)];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *newDate ;
    NSString *heading =[[NSString alloc] init];
    NSString *subalarm =@"false";
    if ([[dictionary objectForKey:@"reminder_sub_alarm"] isEqualToString:@"true"])
    {
        subalarm=[dictionary objectForKey:@"reminder_sub_alarm"];
        if ([[dictionary objectForKey:@"reminder_when_to_alert"] intValue]==1)
        {
            [dateComponents setDay:-[[dictionary objectForKey:@"reminder_time_period"] intValue]];
            newDate = [calendar dateByAddingComponents:dateComponents toDate:date options:0];
            
        }else if ([[dictionary objectForKey:@"reminder_when_to_alert"] intValue]==2)
        {
            [dateComponents setHour:-[[dictionary objectForKey:@"reminder_time_period"]intValue]];
            newDate = [calendar dateByAddingComponents:dateComponents toDate:date options:0];
        }
        NSString *currency= [Utility  userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",CURRENT_CURRENCY,[Utility userDefaultsForKey:MAIN_TOKEN_ID]]];
        NSString * amount=[NSString stringWithFormat:@"%@ %.02f",[[currency componentsSeparatedByString:@"-"] objectAtIndex:1],[[dictionary objectForKey:@"amount"] doubleValue]];
        NSString *nDate=[[dictionary objectForKey:@"date"] stringValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:([nDate doubleValue] / 1000)];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd/MM/yyyy hh:mm:ss a"];
        NSString *transactionType=NSLocalizedString(@"a",nil);
        if (![[dictionary objectForKey:@"reminder_recurring_type"]isEqualToString:NSLocalizedString(@"none", nil)])
        {
            transactionType =[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"an",nil),[dictionary objectForKey:@"transaction_type"]];
        }
        NSString *subHeading=[NSString stringWithFormat:@"%@ %@ %@ %@ %@,%@",NSLocalizedString(@"youHave",nil),transactionType,NSLocalizedString(@"reminderOf",nil),amount,NSLocalizedString(@"forf",nil),[dictionary objectForKey:@"reminder_heading"]];;
        if (![[dictionary objectForKey:@"reminder_recurring_type"]isEqualToString:NSLocalizedString(@"none", nil)])
        {
            NSString *str =  NSLocalizedString(@"addedTo", nil);
            if ([[dictionary objectForKey:@"transaction_type"]isEqualToString:NSLocalizedString(@"expense", nil)])
            {
                str =NSLocalizedString(@"deductedFrom", nil);
            }
            heading=[NSString stringWithFormat:@"%@ %@ %@ %@  %@",subHeading,NSLocalizedString(@"Thiswouldbe", nil),str,amount,[dateFormat  stringFromDate:date]];
        }else
            heading=subHeading;
        if ([[dictionary objectForKey:@"reminder_alert"] isEqualToString:@"false"])
        {
            heading = nil;
        }
    }else
        {
            NSString *currency= [Utility  userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",CURRENT_CURRENCY,[Utility userDefaultsForKey:MAIN_TOKEN_ID]]];
            NSString * amount=[NSString stringWithFormat:@"%@ %.02f",[[currency componentsSeparatedByString:@"-"] objectAtIndex:1],[[dictionary objectForKey:@"amount"] doubleValue]];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"dd/MM/yyyy hh:mm:ss a"];
            NSString *reminderType=NSLocalizedString(@"income",nil);
            newDate=date;
            NSString *discription=[dictionary objectForKey:@"description"];
            if ([discription length]==0)
            {
                discription=@"";
            }
            if ([[dictionary objectForKey:@"transaction_type"] isEqualToString:NSLocalizedString(@"none", nil)])
            {
                reminderType = NSLocalizedString(@"none", nil);
                heading=[NSString stringWithFormat:@"%@ :- %@ %@ %@",reminderType,heading,amount,NSLocalizedString(@"viaDEM",nil)];
            }else
            {
                NSString *str =  NSLocalizedString(@"addedTo", nil);
                if ([[dictionary objectForKey:@"transaction_type"] isEqualToString:NSLocalizedString(@"expense", nil)])
                {
                    str = NSLocalizedString(@"deductedFrom", nil);
                    reminderType = NSLocalizedString(@"expense", nil);
                }
                NSLog(@"%@",NSLocalizedString(@"yourBal", nil) );
                heading=[NSString stringWithFormat:@"%@ :- %@ %@ %@ %@",reminderType,amount,str, NSLocalizedString(@"yourBal", nil),discription];
            }
            if ([[dictionary objectForKey:@"reminder_alert"] isEqualToString:@"false"])
            {
                heading = nil;
            }
        }
    [self setReminde:uuid  :newDate :heading :[dictionary objectForKey:@"transaction_id"] :subalarm];
}


-(void) manageSubAlarmNotification:(NSDictionary*)dictionary
{
      NSError*error;
      NSArray* reminderItems =[[ReminderHandler sharedCoreDataController] getAllReminderWithReminderId:[dictionary objectForKey:@"transaction_id"]];
      Reminder   *info =(Reminder*)[reminderItems objectAtIndex:0];
      [info setReminder_sub_alarm:[NSString stringWithFormat:@"%@", @"false"]];
      [[APP_DELEGATE managedObjectContext] save:&error];
     [self initReminder:[dictionary objectForKey:@"transaction_id"] :[dictionary objectForKey:@"transaction_id"]];
}




-(void)handleTransaction:(NSDictionary*)dic
{
    NSString* transactionType = [dic objectForKey:@"transaction_type"];
   if ([transactionType isEqualToString:NSLocalizedString(@"none", nil)])
    {
        [[ReminderHandler sharedCoreDataController] checkForAlarmReschedule:[dic objectForKey:@"transaction_id"] :[dic objectForKey:@"transaction_id"]];
    }else
    {
     NSString *string= [[TransactionHandler sharedCoreDataController] insertDataIntoTransactionTableFromNotification:(NSMutableDictionary*)dic];
     [[ReminderHandler sharedCoreDataController] checkForAlarmReschedule:string :[dic objectForKey:@"transaction_id"]];
    }
    
}



@end
