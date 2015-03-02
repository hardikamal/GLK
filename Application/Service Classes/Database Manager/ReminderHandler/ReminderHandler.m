
//
//  ReminderHandler.m
//  Daily Expense Manager
//
//  Created by Appbulous on 17/09/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import "ReminderHandler.h"
#import "Reminder.h"
//#import "ReminderManger.h"
#import "TransactionHandler.h"
#import "PaymentmodeHandler.h"
#import "UpdateOnServerTransactionsTable.h"
#import "UserInfoHandler.h"
#import "Utility.h"
@implementation ReminderHandler
{
    NSManagedObjectContext *_managedObjectContext;
    NSString  *heello;
}

-(id) init
{
    self = [super init];
    if(self)
    {
        _managedObjectContext = [APP_DELEGATE managedObjectContext];
    }
    return self;
}

+(ReminderHandler *) sharedCoreDataController
{
    static ReminderHandler *singletone=nil;
    if(!singletone)
    {
        singletone=[[ReminderHandler alloc] init];
    }
    return singletone;
}

-(void)insertDataIntoReminderTablefromServer:(NSDictionary*)responseObject
{
    NSArray *array=[responseObject objectForKey:@"data"];
    for (NSDictionary *dictionary in array)
    {
        NSError *error;
        Reminder   *info = [NSEntityDescription insertNewObjectForEntityForName:@"Reminder" inManagedObjectContext:_managedObjectContext];
        [info setDate:[dictionary objectForKey:@"transaction_date"]];
        [info setAmount:[dictionary objectForKey:@"price"]];
        [info setCategory:[dictionary objectForKey:@"category"]];
    
        if ([dictionary objectForKey:@"sub_category"] == (id)[NSNull null])
        {
            [info setSub_category:@""];
        }else
            [info setSub_category:[dictionary objectForKey:@"sub_category"]];
        
        [info setDiscription:[dictionary objectForKey:@"description"]];
        [info setReminder_heading:[dictionary objectForKey:@"reminder_heading"]];
        [info setUser_token_id:[dictionary objectForKey:@"account_id"]];
        [info setTransaction_type:[dictionary objectForKey:@"transaction_type"]];
        [info setPaymentMode:[dictionary objectForKey:@"payment_mode"]];
        [info setReminder_recurring_type:[dictionary objectForKey:@"reminder_recurring_type"]];
        [info setReminder_time_period:[dictionary objectForKey:@"reminder_time_period"]];
        [info setReminder_when_to_alert:[dictionary objectForKey:@"reminder_when_to_alert"]];
        
        if([[dictionary valueForKey:@"attachments"] length]!=0)
        {
            NSURL *url = [NSURL URLWithString:[dictionary objectForKey:@"attachments"]];
            NSData *data = [NSData dataWithContentsOfURL:url];
            [info setPic:data];
        }
        
        if ([[dictionary objectForKey:@"reminder_alarm"] isEqualToString:@"1"])
        {
            [info setReminder_alarm:@"true"];
        }else
            [info setReminder_alarm:@"false"];
        
        if ([[dictionary objectForKey:@"reminder_alert"] isEqualToString:@"1"])
        {
            [info setReminder_alert:@"true"];
        }else
            [info setReminder_alert:@"false"];
        
        if ([[dictionary objectForKey:@"reminder_sub_alarm"] isEqualToString:@"1"])
        {
            [info setReminder_alert:@"true"];
        }else
            [info setReminder_alert:@"false"];
        
        [info setToken_id:[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
        [info setTransaction_id:[[[dictionary objectForKey:@"transaction_id"] componentsSeparatedByString:@"_"] objectAtIndex:0]];
        NSNumber *number= [Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date];
        [info setServer_updation_date:number];
        [info setUpdation_date:[NSNumber numberWithLongLong:[number longLongValue]-10]];
        [[APP_DELEGATE managedObjectContext] save:&error];
    }
}

-(void)insertDataIntoReminderTablefromAddedTranasactionToServer:(NSDictionary*)dictionary
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Reminder"  inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"transaction_id = %@",[[[dictionary objectForKey:@"transaction_id"] componentsSeparatedByString:@"_"] objectAtIndex:0]];
    NSPredicate *p1 =  [NSPredicate predicateWithFormat:@"token_id = %@",[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    NSPredicate *newPredicate = [NSCompoundPredicate andPredicateWithSubpredicates: @[predicate,p1]];
    //Setting Entity to be Queried
    [fetchRequest setPredicate:newPredicate];
    
    
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if ([fetchedRecords count]==0)
    {
        NSError *error;
        Reminder   *info = [NSEntityDescription insertNewObjectForEntityForName:@"Reminder" inManagedObjectContext:_managedObjectContext];
        [info setDate:[dictionary objectForKey:@"transaction_date"]];
        [info setAmount:[dictionary objectForKey:@"price"]];
        [info setCategory:[dictionary objectForKey:@"category"]];
        
        
        if ([dictionary objectForKey:@"sub_category"] == (id)[NSNull null])
        {
            [info setSub_category:@""];
        }else
            [info setSub_category:[dictionary objectForKey:@"sub_category"]];
        
        [info setDiscription:[dictionary objectForKey:@"description"]];
        [info setReminder_heading:[dictionary objectForKey:@"reminder_heading"]];
        [info setUser_token_id:[dictionary objectForKey:@"account_id"]];
        [info setTransaction_type:[dictionary objectForKey:@"transaction_type"]];
        [info setPaymentMode:[dictionary objectForKey:@"payment_mode"]];
        [info setReminder_recurring_type:[dictionary objectForKey:@"reminder_recurring_type"]];
        [info setReminder_alarm:[dictionary objectForKey:@"reminder_alarm"]];
        [info setReminder_alert:[dictionary objectForKey:@"reminder_alert"]];
        [info setReminder_sub_alarm:[dictionary objectForKey:@"reminder_sub_alarm"]];
        [info setReminder_time_period:[dictionary objectForKey:@"reminder_time_period"]];
        [info setReminder_when_to_alert:[dictionary objectForKey:@"reminder_when_to_alert"]];
        if([[dictionary valueForKey:@"attachments"] length]!=0)
        {
            NSURL *url = [NSURL URLWithString:[dictionary objectForKey:@"attachments"]];
            NSData *data = [NSData dataWithContentsOfURL:url];
            [info setPic:data];
        }
        [info setToken_id:[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
        [info setTransaction_id:[[[dictionary objectForKey:@"transaction_id"] componentsSeparatedByString:@"_"] objectAtIndex:0]];
        NSNumber *number= [Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date];
        [info setServer_updation_date:number];
        [info setUpdation_date:[NSNumber numberWithLongLong:[number longLongValue]-10]];
        [[APP_DELEGATE managedObjectContext] save:&error];
    }
}

-(void)deleteDataIntoReminderTablefromAddedTranasactionToServer:(NSDictionary*)dictionary
{
 
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Reminder" inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"transaction_id = %@",[[[dictionary objectForKey:@"transaction_id"] componentsSeparatedByString:@"_"] objectAtIndex:0]];
    NSPredicate *p1 =  [NSPredicate predicateWithFormat:@"token_id = %@",[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    NSPredicate *newPredicate = [NSCompoundPredicate andPredicateWithSubpredicates: @[predicate,p1]];
    //Setting Entity to be Queried
    [fetchRequest setPredicate:newPredicate];
    
    
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    // Returning Fetched Records
    for (Reminder *info in fetchedRecords)
    {
        [[APP_DELEGATE managedObjectContext] deleteObject:info];
        [[APP_DELEGATE managedObjectContext] save:&error];
    }
}

-(void)editDataIntoReminderTablefromAddedTranasactionToServer:(NSDictionary*)dictionary
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Reminder"  inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"transaction_id = %@",[[[dictionary objectForKey:@"transaction_id"] componentsSeparatedByString:@"_"] objectAtIndex:0]];
    NSPredicate *p1 =  [NSPredicate predicateWithFormat:@"token_id = %@",[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    NSPredicate *newPredicate = [NSCompoundPredicate andPredicateWithSubpredicates: @[predicate,p1]];
    //Setting Entity to be Queried
    [fetchRequest setPredicate:newPredicate];
    
    
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if ([fetchedRecords count]!=0)
    {
        // Returning Fetched Records
        for (Reminder *info in fetchedRecords)
        {
            NSError *error;
            [info setDate:[dictionary objectForKey:@"transaction_date"]];
            [info setAmount:[dictionary objectForKey:@"price"]];
            [info setCategory:[dictionary objectForKey:@"category"]];
            
            
            if ([dictionary objectForKey:@"sub_category"] == (id)[NSNull null])
            {
                [info setSub_category:@""];
            }else
                [info setSub_category:[dictionary objectForKey:@"sub_category"]];
            
            [info setDiscription:[dictionary objectForKey:@"description"]];
            [info setReminder_heading:[dictionary objectForKey:@"reminder_heading"]];
            [info setUser_token_id:[dictionary objectForKey:@"account_id"]];
            [info setTransaction_type:[dictionary objectForKey:@"transaction_type"]];
            [info setPaymentMode:[dictionary objectForKey:@"payment_mode"]];
            [info setReminder_recurring_type:[dictionary objectForKey:@"reminder_recurring_type"]];
            [info setReminder_alarm:[dictionary objectForKey:@"reminder_alarm"]];
            [info setReminder_alert:[dictionary objectForKey:@"reminder_alert"]];
            [info setReminder_sub_alarm:[dictionary objectForKey:@"reminder_sub_alarm"]];
            [info setReminder_time_period:[dictionary objectForKey:@"reminder_time_period"]];
            [info setReminder_when_to_alert:[dictionary objectForKey:@"reminder_when_to_alert"]];
            if([[dictionary valueForKey:@"attachments"] length]!=0)
            {
                NSURL *url = [NSURL URLWithString:[dictionary objectForKey:@"attachments"]];
                NSData *data = [NSData dataWithContentsOfURL:url];
                [info setPic:data];
            }
            [info setToken_id:[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
            
            [info setTransaction_id:[[[dictionary objectForKey:@"transaction_id"] componentsSeparatedByString:@"_"] objectAtIndex:0]];
            NSNumber *number= [Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date];
            [info setServer_updation_date:number];
            [info setUpdation_date:[NSNumber numberWithLongLong:[number longLongValue]-10]];
            [[APP_DELEGATE managedObjectContext] save:&error];
        }
    }else
    {
        [self insertDataIntoReminderTablefromAddedTranasactionToServer:dictionary];
    }
}



-(NSString*)insertDataIntoReminderTable:(NSMutableDictionary*)dictionary
{
    NSError *error;
    Reminder   *info = [NSEntityDescription insertNewObjectForEntityForName:@"Reminder" inManagedObjectContext:_managedObjectContext];
    [info setDate:[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date:[dictionary objectForKey:@"date"]]];
    [info setAmount:[dictionary objectForKey:@"amount"]];
    [info setCategory:[dictionary objectForKey:@"category"]];
    [info setSub_category:[dictionary objectForKey:@"sub_category"]];
    [info setDiscription:[dictionary objectForKey:@"description"]];
    [info setReminder_heading:[dictionary objectForKey:@"reminder_heading"]];
    [info setUser_token_id:[dictionary objectForKey:@"user_token_id"]];
    [info setTransaction_type:[dictionary objectForKey:@"transaction_type"]];
    [info setPaymentMode:[dictionary objectForKey:@"paymentMode"]];
    [info setReminder_recurring_type:[dictionary objectForKey:@"reminder_recurring_type"]];
    [info setReminder_alarm:[dictionary objectForKey:@"reminder_alarm"]];
    [info setReminder_alert:[dictionary objectForKey:@"reminder_alert"]];
    [info setReminder_sub_alarm:[dictionary objectForKey:@"reminder_sub_alarm"]];
    [info setReminder_time_period:[dictionary objectForKey:@"reminder_time_period"]];
    [info setReminder_when_to_alert:[dictionary objectForKey:@"reminder_when_to_alert"]];
    if([dictionary valueForKey:@"pic"] != nil)
    {
        UIImage *image=[dictionary objectForKey:@"pic"];
        [info setPic:UIImageJPEGRepresentation(image, 1.0)];
    }else
        [info setPic:nil];
    
    [info setToken_id:[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
     NSNumber *number=[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date];
    [info setUpdation_date:number];
    [info setTransaction_id:[number stringValue]];
    [info setServer_updation_date:[NSNumber numberWithInt:0]];
    [[APP_DELEGATE managedObjectContext] save:&error];
      NSLog(@"%@",info);
    return [number stringValue];
}

-(void)insertDataIntoReminderTableFromImport:(NSMutableDictionary*)dictionary
{
    
    NSError *error;
    Reminder   *info = [NSEntityDescription insertNewObjectForEntityForName:@"Reminder" inManagedObjectContext:_managedObjectContext];
    [info setDate:[dictionary objectForKey:@"date"]];
    [info setAmount:[dictionary objectForKey:@"amount"]];
    [info setCategory:TRIM([dictionary objectForKey:@"category"])];
    if ([[dictionary objectForKey:@"sub_category"] isEqualToString:@"null"])
    {
        [info setSub_category:@""];
    }else
    [info setSub_category:TRIM([dictionary objectForKey:@"sub_category"])];
    
    [info setDiscription:[dictionary objectForKey:@"discription"]];
    [info setReminder_heading:[dictionary objectForKey:@"reminder_heading"]];
    [info setUser_token_id:[dictionary objectForKey:@"user_token_id"]];
    [info setTransaction_type:[dictionary objectForKey:@"transaction_type"]];
  
    if([[dictionary valueForKey:@"pic"] length]!=0 && [Utility isInternetAvailable])
    {
        NSURL *url = [NSURL URLWithString:[[dictionary valueForKey:@"pic"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        if ([data length]!=0)
        {
            [info setPic:data];
        }
    }
    [info setTransaction_id:[dictionary objectForKey:@"transaction_id"]];
    [info setPaymentMode:[dictionary objectForKey:@"paymentMode"]];
    [info setReminder_recurring_type:[dictionary objectForKey:@"reminder_recurring_type"]];
    
    [info setReminder_alarm:[dictionary objectForKey:@"reminder_alarm"]];
    
    [info setReminder_alert:[dictionary objectForKey:@"reminder_alert"]];
    [info setReminder_sub_alarm:[dictionary objectForKey:@"reminder_sub_alarm"]];
   
    [info setReminder_time_period:[dictionary objectForKey:@"reminder_time_period"]];
    [info setReminder_when_to_alert:[dictionary objectForKey:@"reminder_when_to_alert"]];
    
    [info setToken_id:[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    [info setUpdation_date:[dictionary objectForKey:@"updation_date"]];
    [info setServer_updation_date:[dictionary objectForKey:@"server_updation_date"]];
    [[APP_DELEGATE managedObjectContext] save:&error];
    if ([[dictionary objectForKey:@"reminder_alarm"] isEqualToString:@"true"] && [info.reminder_recurring_type isEqualToString:NSLocalizedString(@"none", nil)] )
    {
        
    }else
    {
//         [[ReminderManger sharedMager] initReminder:[dictionary objectForKey:@"transaction_id"] :[dictionary objectForKey:@"transaction_id"]];
    }
}


-(void)updateUserToken:(NSString*)fromAccount :(NSString*)ToAccount
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Budget"  inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"user_token_id =%@ ",fromAccount];
    NSPredicate *p1 =  [NSPredicate predicateWithFormat:@"token_id = %@",[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    NSPredicate *newPredicate = [NSCompoundPredicate andPredicateWithSubpredicates: @[predicate,p1]];
    //Setting Entity to be Queried
    [fetchRequest setPredicate:newPredicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    // Returning Fetched Records
    for (Transactions *info in fetchedRecords)
    {
        [info setUser_token_id:ToAccount];
        [info setUpdation_date:[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date]];
        [[APP_DELEGATE managedObjectContext] save:&error];
    }
}


-(BOOL)updateDataIntoReminderTable:(NSMutableDictionary*)dictionary :(Reminder*)info
{
    NSError *error;
    [info setDate:[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date:[dictionary objectForKey:@"date"]]];
    [info setAmount:[dictionary objectForKey:@"amount"]];
    [info setCategory:[dictionary objectForKey:@"category"]];
    [info setSub_category:[dictionary objectForKey:@"sub_category"]];
    [info setDiscription:[dictionary objectForKey:@"description"]];
    [info setReminder_heading:[dictionary objectForKey:@"reminder_heading"]];
    [info setUser_token_id:[dictionary objectForKey:@"user_token_id"]];
    [info setTransaction_type:[dictionary objectForKey:@"transaction_type"]];
    [info setPaymentMode:[dictionary objectForKey:@"paymentMode"]];
    [info setReminder_recurring_type:[dictionary objectForKey:@"reminder_recurring_type"]];
    [info setReminder_alarm:[dictionary objectForKey:@"reminder_alarm"]];
    [info setReminder_alert:[dictionary objectForKey:@"reminder_alert"]];
    [info setReminder_sub_alarm:[dictionary objectForKey:@"reminder_sub_alarm"]];
    [info setReminder_time_period:[dictionary objectForKey:@"reminder_time_period"]];
    [info setReminder_when_to_alert:[dictionary objectForKey:@"reminder_when_to_alert"]];
    if([dictionary valueForKey:@"pic"] != nil)
    {
        UIImage *image=[dictionary objectForKey:@"pic"];
        [info setPic:UIImageJPEGRepresentation(image, 1.0)];
    }else
        [info setPic:nil];
    
    [info setToken_id:[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    [info setUpdation_date:[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date]];
    [[APP_DELEGATE managedObjectContext] save:&error];
      NSLog(@"%@",info);
    return YES;
}

-(NSArray*)getAllReminderForID:(NSString *)userTokenId :(NSDate*)startDate :(NSDate*)endDate :(NSString*)transaction_type :(NSString*)oderBy :(NSMutableArray*)categery :(NSMutableArray*)paymetnMode
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSString *transactiontype;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transactions" inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate;
    
    if ([oderBy isEqualToString:NSLocalizedString(@"Recent Transactions", nil)])
    {
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
        
    }else if ([oderBy isEqualToString:  NSLocalizedString(@"Old Transactionspense", nil)])
    {
        fetchRequest.sortDescriptors =@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
        
    }else if ([oderBy isEqualToString:  NSLocalizedString(@"Highest Amount", nil)])
    {
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"amount" ascending:NO]];
        
    }else if ([oderBy isEqualToString:  NSLocalizedString(@"Lowest Amount", nil)])
    {
        fetchRequest.sortDescriptors =@[[NSSortDescriptor sortDescriptorWithKey:@"amount" ascending:YES]];
    }
    
    if ([transaction_type isEqualToString:  NSLocalizedString(@"both", nil)])
    {
        if ([userTokenId length]!=0)
        {
            predicate = [NSPredicate predicateWithFormat:@"user_token_id = %@ AND ((date >= %@) AND (date < %@))",userTokenId,[self getDate:startDate], [self getDate:endDate]];
        }else
            predicate = [NSPredicate predicateWithFormat:@"((date >= %@) AND (date < %@))",[self getDate:startDate], [self getDate:endDate]];
    }else
    {
        if ([ transaction_type isEqualToString:  NSLocalizedString(@"income", nil)])
        {
            transactiontype=[NSString stringWithFormat:@"%i",TYPE_INCOME];
            
        }else if ([transaction_type isEqualToString:  NSLocalizedString(@"expen", nil)])
        {
            transactiontype=[NSString stringWithFormat:@"%i",TYPE_EXPENSE];
        }
        if ([userTokenId length]!=0)
        {
            predicate = [NSPredicate predicateWithFormat:@"transaction_type = %@ AND user_token_id = %@ AND ((date >= %@) AND (date < %@))",transactiontype,userTokenId,[self getDate:startDate], [self getDate:endDate]];
        }else
            predicate = [NSPredicate predicateWithFormat:@"transaction_type =%@ AND ((date >= %@) AND (date < %@))",transactiontype,[self getDate:startDate], [self getDate:endDate]];
    }
    
    NSPredicate *p1 =  [NSPredicate predicateWithFormat:@"category IN %@", categery];
    NSPredicate *p2 =  [NSPredicate predicateWithFormat:@"paymentMode IN %@", paymetnMode];
    NSArray *usetTokeArray=[[UserInfoHandler sharedCoreDataController] getUserNameListFromUserRegisterTable];
    NSPredicate *p3 =  [NSPredicate predicateWithFormat:@"user_token_id IN %@", usetTokeArray];
    NSPredicate *p4 =  [NSPredicate predicateWithFormat:@"token_id = %@",[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    NSPredicate *newPredicate = [NSCompoundPredicate andPredicateWithSubpredicates: @[predicate,p1, p2,p3,p4]];
    
    //Setting Entity to be Queried
    [fetchRequest setPredicate:newPredicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return fetchedRecords;
}


-(NSNumber*)getDate:(NSDate*)date
{
    long long milliseconds = (long long)([date timeIntervalSince1970] * 1000.0);
    return [NSNumber numberWithUnsignedLongLong:milliseconds];
    
}


-(NSArray *)getAllReminder:(NSString*)searchText
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Reminder" inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate;
    if ([searchText length]!=0)
    {
        predicate =[NSPredicate predicateWithFormat:@"token_id = %@ AND transaction_id = %@",[Utility userDefaultsForKey:MAIN_TOKEN_ID],searchText];
    }else
    {
        predicate =[NSPredicate predicateWithFormat:@"token_id = %@",[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    }
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    [fetchRequest setResultType:NSDictionaryResultType];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    // Returning Fetched Records
    return fetchedRecords;
}




-(NSArray *)getAllReminder
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Reminder" inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"token_id = %@",[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    // Returning Fetched Records
    return fetchedRecords;
    
}


-(void)updateServerUpdationDate:(NSString*)data
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Reminder"  inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"transaction_id = %@",data];
    NSPredicate *p1 =  [NSPredicate predicateWithFormat:@"token_id = %@",[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    NSPredicate *newPredicate = [NSCompoundPredicate andPredicateWithSubpredicates: @[predicate,p1]];
    //Setting Entity to be Queried
    [fetchRequest setPredicate:newPredicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    // Returning Fetched Records
    for (Reminder *info in fetchedRecords)
    {
        NSNumber *number= [Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date];
        [info setServer_updation_date:number];
        [info setUpdation_date:[NSNumber numberWithLongLong:[number longLongValue]-10]];
        [[APP_DELEGATE managedObjectContext] save:&error];
    }
}



-(NSArray*)getAllReminderToUpdateOnServer
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Reminder" inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"(server_updation_date <= %@) AND token_id = %@ ",@"0",[Utility userDefaultsForKey:MAIN_TOKEN_ID]];;
    [fetchRequest setFetchLimit:50];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return fetchedRecords;
}

-(NSArray*)getAllReminderToEditOnServer
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Reminder" inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"updation_date > server_updation_date AND token_id = %@ ",[Utility userDefaultsForKey:MAIN_TOKEN_ID]];;
    [fetchRequest setFetchLimit:50];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return fetchedRecords;
}


-(NSArray *)getAllReminderWithUserToken:(NSString*)searchText
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Reminder" inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate;
    
    if ([searchText length]!=0)
    {
        predicate =[NSPredicate predicateWithFormat:@"token_id = %@ AND user_token_id = %@",[Utility userDefaultsForKey:MAIN_TOKEN_ID],searchText];
    }else
    {
        predicate =[NSPredicate predicateWithFormat:@"token_id = %@",[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    }
    
    
    NSArray *categery=[[CategoryListHandler sharedCoreDataController] getAllCategoryList];
    
    NSArray *paymetnMode=[[PaymentmodeHandler sharedCoreDataController] getAllPaymetModeListUnhide];
    NSArray *usetTokeArray=[[UserInfoHandler sharedCoreDataController] getUserNameListFromUserRegisterTable];

    NSPredicate *p1 =  [NSPredicate predicateWithFormat:@"category IN %@", categery];
    NSPredicate *p2 =  [NSPredicate predicateWithFormat:@"paymentMode IN %@", paymetnMode];
    NSPredicate *p3 =  [NSPredicate predicateWithFormat:@"user_token_id IN %@", usetTokeArray];
    NSPredicate *newPredicate = [NSCompoundPredicate andPredicateWithSubpredicates: @[predicate,p1, p2,p3]];
    [fetchRequest setPredicate:newPredicate];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return fetchedRecords;

}

-(NSArray *)getAllReminderWithReminderId:(NSString*)searchText
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Reminder" inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate;
    
    if ([searchText length]!=0)
    {
        predicate =[NSPredicate predicateWithFormat:@"token_id = %@ AND transaction_id = %@",[Utility userDefaultsForKey:MAIN_TOKEN_ID],searchText];
    }else
    {
        predicate =[NSPredicate predicateWithFormat:@"token_id = %@",[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    }
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    // Returning Fetched Records
    return fetchedRecords;
}


-(void)checkForAlarmReschedule:(NSString*)uuid :(NSString*)transactionId
{
    NSError *error;
    NSArray* reminderItems =[[ReminderHandler sharedCoreDataController] getAllReminderWithReminderId:transactionId];
    Reminder   *info =(Reminder*)[reminderItems objectAtIndex:0];
    NSString *nDate=[info.date stringValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:([nDate doubleValue] / 1000)];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    if ([info.reminder_recurring_type isEqualToString:NSLocalizedString(@"yearly", nil)])
    {
        [dateComponents setYear:1];
        
    }else if ([info.reminder_recurring_type isEqualToString:NSLocalizedString(@"monthly", nil)])
    {
        [dateComponents setMonth:1];
        
    }else if ([info.reminder_recurring_type isEqualToString:NSLocalizedString(@"weekly", nil)])
    {
        [dateComponents setWeekOfMonth:1];
    }
    else if ([info.reminder_recurring_type isEqualToString:NSLocalizedString(@"daily", nil)])
    {
        [dateComponents setDay:1];
        
    }
    
   if ([info.reminder_recurring_type isEqualToString:NSLocalizedString(@"none", nil)])
     {
         [info setReminder_alarm:@"true"];
         [_managedObjectContext save:&error];
     }else
     {
         int val=[info.reminder_when_to_alert intValue];
         NSDate *newDate ;
         if (val==0)
         {
             newDate = [calendar dateByAddingComponents:dateComponents toDate:date options:0];
             [info setReminder_sub_alarm:[NSString stringWithFormat:@"%@", @"false"]];
             long long milliseconds = (long long)([newDate timeIntervalSince1970] * 1000);
             [info setDate:[NSNumber numberWithUnsignedLongLong:milliseconds]];
             
         }else if (val==1)
         {
             newDate = [calendar dateByAddingComponents:dateComponents toDate:date options:0];
             [dateComponents setDay:[info.reminder_time_period intValue]];
             [info setReminder_sub_alarm:[NSString stringWithFormat:@"%@", @"true"]];
             long long milliseconds = (long long)([newDate timeIntervalSince1970] * 1000);
             [info setDate:[NSNumber numberWithUnsignedLongLong:milliseconds]];
             
         }else if (val==2)
         {
             newDate = [calendar dateByAddingComponents:dateComponents toDate:date options:0];
             [dateComponents setHour:[info.reminder_time_period intValue]];
             [info setReminder_sub_alarm:[NSString stringWithFormat:@"%@", @"true"]];
             long long milliseconds = (long long)([newDate timeIntervalSince1970] * 1000);
             [info setDate:[NSNumber numberWithUnsignedLongLong:milliseconds]];
         }
         NSNumber *number=[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date];
         [info setUpdation_date:number];
         [_managedObjectContext save:&error];
        // [[ReminderManger sharedMager] initReminder:uuid :info.transaction_id];
    }
}



-(void)deleteCategeroyList:(NSString *)categery chekServerUpdation:(BOOL)chek
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Reminder" inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"category = %@",categery];
    NSPredicate *p1 =  [NSPredicate predicateWithFormat:@"token_id = %@",[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    NSPredicate *newPredicate = [NSCompoundPredicate andPredicateWithSubpredicates: @[predicate,p1]];
    //Setting Entity to be Queried
    [fetchRequest setPredicate:newPredicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    // Returning Fetched Records
    for (Reminder *info in fetchedRecords)
    {
        if (![info.token_id isEqualToString:@"0"] && !chek)
        {
            [self insertDataIntoUpdateOnServerTransactionsTable:info];
        }
        [[APP_DELEGATE managedObjectContext] deleteObject:info];
        [[APP_DELEGATE managedObjectContext] save:&error];
    }
}


-(void)updatePaymentMode:(NSString*)paymetMode :(NSString*)toPaymetMode
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Reminder" inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"paymentMode = %@",paymetMode];
    NSPredicate *p1 =  [NSPredicate predicateWithFormat:@"token_id = %@",[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    NSPredicate *newPredicate = [NSCompoundPredicate andPredicateWithSubpredicates: @[predicate,p1]];
    //Setting Entity to be Queried
    [fetchRequest setPredicate:newPredicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    // Returning Fetched Records
    for (Transactions *info in fetchedRecords)
    {
        [info setPaymentMode:toPaymetMode];
        [info setUpdation_date:[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date]];
        [[APP_DELEGATE managedObjectContext] save:&error];
    }
}



-(void)deletePaymentMode:(NSString *)paymetMode chekServerUpdation:(BOOL)chek

{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Reminder" inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"paymentMode = %@",paymetMode];
    NSPredicate *p1 =  [NSPredicate predicateWithFormat:@"token_id = %@",[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    NSPredicate *newPredicate = [NSCompoundPredicate andPredicateWithSubpredicates: @[predicate,p1]];
    //Setting Entity to be Queried
    [fetchRequest setPredicate:newPredicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    // Returning Fetched Records
    for (Reminder *info in fetchedRecords)
    {
        if (![info.token_id isEqualToString:@"0"] && !chek)
        {
            [self insertDataIntoUpdateOnServerTransactionsTable:info];
        }
        [[APP_DELEGATE managedObjectContext] deleteObject:info];
        [[APP_DELEGATE managedObjectContext] save:&error];
    }
}


-(BOOL)deleteReminder:(Reminder*)info
{
    NSError *error;
    NSArray *array=[[TransactionHandler sharedCoreDataController] getTransactionWithTransactionRefrenceId:info.transaction_id :info.user_token_id];
    for (int i=0; i<[array count]; i++)
    {
           [[TransactionHandler sharedCoreDataController] deleteTransaction:[array objectAtIndex:0]];
    }
    
    if (![info.token_id isEqualToString:@"0"])
    {
        [self insertDataIntoUpdateOnServerTransactionsTable:info];
    }
    [[APP_DELEGATE managedObjectContext] deleteObject:info];
    [[APP_DELEGATE managedObjectContext] save:&error];
    return YES;
}


-(void)updateTokenId:(NSDictionary*)dictionary  :(Reminder*)info
{
    NSError* error;
    // [[ objectAtIndex:107]
    
    [info setToken_id:[dictionary objectForKey:@"TokenId"]];
    
    if ([info.user_token_id isEqualToString:[Utility userDefaultsForKey:CURRENT_TOKEN_ID]])
    {
        [info setUser_token_id:[dictionary objectForKey:@"AccountId"]];
        
    }else
    {
        NSString *string=[[info.user_token_id  componentsSeparatedByString:@"_"] objectAtIndex:1];
        [info setUser_token_id:[NSString stringWithFormat:@"%@_%@",[dictionary objectForKey:@"TokenId"],string]];
    }
    [[APP_DELEGATE managedObjectContext] save:&error];
}




-(void)updateCategeroyToCategery:(NSString*)fromCategery :(NSString*)toCategery
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Reminder" inManagedObjectContext:_managedObjectContext];
     NSPredicate *predicate =[NSPredicate predicateWithFormat:@"category = %@",fromCategery];
    NSPredicate *p1 =  [NSPredicate predicateWithFormat:@"token_id = %@",[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    NSPredicate *newPredicate = [NSCompoundPredicate andPredicateWithSubpredicates: @[predicate,p1]];
    //Setting Entity to be Queried
    [fetchRequest setPredicate:newPredicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
     NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    // Returning Fetched Records
    for (Reminder *info in fetchedRecords)
    {
        [info setCategory:toCategery];
        [info setUpdation_date:[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date]];
        [[APP_DELEGATE managedObjectContext] save:&error];
    }
}


-(void)updateCategeroySubCategryToCategery:(NSString*)fromCategery :(NSString*)toCategery
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Reminder" inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"sub_category = %@",fromCategery];
    NSPredicate *p1 =  [NSPredicate predicateWithFormat:@"token_id = %@",[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    NSPredicate *newPredicate = [NSCompoundPredicate andPredicateWithSubpredicates: @[predicate,p1]];
    //Setting Entity to be Queried
    [fetchRequest setPredicate:newPredicate];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    // Returning Fetched Records
    for (Reminder *info in fetchedRecords)
    {
        [info setCategory:toCategery];
        [info setUpdation_date:[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date]];
        [[APP_DELEGATE managedObjectContext] save:&error];
    }
}



-(void)updateCategeroySubCategryToCategerysubcategery:(NSString*)fromCategery :(CategoryList*)toCategery
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Reminder"  inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"sub_category =%@ ",fromCategery];
    NSPredicate *p1 =  [NSPredicate predicateWithFormat:@"token_id = %@",[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    NSPredicate *newPredicate = [NSCompoundPredicate andPredicateWithSubpredicates: @[predicate,p1]];
    //Setting Entity to be Queried
    [fetchRequest setPredicate:newPredicate];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    // Returning Fetched Records
    for (Reminder *info in fetchedRecords)
    {
        [info setCategory:toCategery.category];
        [info setSub_category:toCategery.sub_category];
           [info setUpdation_date:[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date]];
        [[APP_DELEGATE managedObjectContext] save:&error];
    }
    
}



-(void)updateSubCategry:(NSString*)fromSubCategery :(NSString*)toSubCategery
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Reminder"  inManagedObjectContext:_managedObjectContext];

    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"sub_category =%@ ",fromSubCategery];
    NSPredicate *p1 =  [NSPredicate predicateWithFormat:@"token_id = %@",[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    NSPredicate *newPredicate = [NSCompoundPredicate andPredicateWithSubpredicates: @[predicate,p1]];
    //Setting Entity to be Queried
    [fetchRequest setPredicate:newPredicate];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    // Returning Fetched Records
    for (Transactions *info in fetchedRecords)
    {
        [info setSub_category:toSubCategery];
        [info setUpdation_date:[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date]];
        [[APP_DELEGATE managedObjectContext] save:&error];
    }
}



-(void)insertDataIntoUpdateOnServerTransactionsTable:(Reminder*)newInfo
{
    NSError *error;
    UpdateOnServerTransactionsTable   *info = [NSEntityDescription insertNewObjectForEntityForName:@"UpdateOnServerTransactionsTable" inManagedObjectContext:_managedObjectContext];
    [info setTransaction_id:newInfo.transaction_id];
    [info setUser_token_id:newInfo.user_token_id];
    [info setTransaction_type:[NSNumber numberWithInt:TYPE_REMINDER]];
    [[APP_DELEGATE managedObjectContext] save:&error];
}



@end
