//
//  ReminderHandler.h
//  Daily Expense Manager
//
//  Created by Appbulous on 17/09/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reminder.h"
#import "CategoryListHandler.h"
@interface ReminderHandler : NSObject
+(ReminderHandler *) sharedCoreDataController;
-(NSString*)insertDataIntoReminderTable:(NSMutableDictionary*)dictionary;
-(NSArray *)getAllReminder:(NSString*)searchText;
-(void)checkForAlarmReschedule:(NSString*)uuid :(NSString*)transactionId;
-(NSArray *)getAllReminderWithUserToken:(NSString*)searchText;
-(BOOL)updateDataIntoReminderTable:(NSMutableDictionary*)dictionary :(Reminder*)info;
-(BOOL)deleteReminder:(Reminder*)info;
-(NSArray *)getAllReminder;
-(NSArray *)getAllReminderWithReminderId:(NSString*)searchText;
-(void)insertDataIntoReminderTableFromImport:(NSMutableDictionary*)dictionary;
-(void)updateCategeroySubCategryToCategery:(NSString*)fromCategery :(NSString*)toCategery;
-(void)updateCategeroyToCategery:(NSString*)fromCategery :(NSString*)toCategery;
-(void)updateCategeroySubCategryToCategerysubcategery:(NSString*)fromCategery :(CategoryList*)toCategery;
-(NSArray*)getAllReminderForID:(NSString *)userTokenId :(NSDate*)startDate :(NSDate*)endDate :(NSString*)transaction_type :(NSString*)oderBy :(NSMutableArray*)categery :(NSMutableArray*)paymetnMode;
-(void)updateTokenId:(NSDictionary*)dictionary  :(Reminder*)info;
-(void)insertDataIntoReminderTablefromServer:(NSDictionary*)dictionary;
-(NSArray*)getAllReminderToUpdateOnServer;
-(void)updateServerUpdationDate:(NSString*)data;
-(NSArray*)getAllReminderToEditOnServer;
-(void)insertDataIntoReminderTablefromAddedTranasactionToServer:(NSDictionary*)dictionary;
-(void)editDataIntoReminderTablefromAddedTranasactionToServer:(NSDictionary*)dictionary;
-(void)deleteDataIntoReminderTablefromAddedTranasactionToServer:(NSDictionary*)dictionary;
-(void)deleteCategeroyList:(NSString *)categery chekServerUpdation:(BOOL)chek;
-(void)deletePaymentMode:(NSString *)paymetMode chekServerUpdation:(BOOL)chek;
-(void)updatePaymentMode:(NSString*)paymetMode :(NSString*)toPaymetMode;
-(void)updateSubCategry:(NSString*)fromSubCategery :(NSString*)toSubCategery;
-(void)updateUserToken:(NSString*)fromAccount :(NSString*)ToAccount;
@end

