//
//  TransactionHandler.m
//  Daily Expense Manager
//
//  Created by Appbulous on 12/09/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import "TransactionHandler.h"
#import "Transactions.h"
#import "CategoryListHandler.h"
#import "PaymentmodeHandler.h"
#import "UpdateOnServerTransactionsTable.h"
#include "UserInfoHandler.h"
#import "Utility.h"
@implementation TransactionHandler

-(id) init
{
    self = [super init];
    if(self)
    {
        _managedObjectContext = [APP_DELEGATE managedObjectContext];
    }
    return self;
}

+(TransactionHandler *) sharedCoreDataController
{
    static TransactionHandler *singletone=nil;
    if(!singletone)
    {
        singletone=[[TransactionHandler alloc] init];
    }
    return singletone;
}


-(BOOL)insertDataIntoTransactionTable:(NSMutableDictionary*)dictionary
{
    NSError *error;
    Transactions   *info = [NSEntityDescription insertNewObjectForEntityForName:@"Transactions" inManagedObjectContext:_managedObjectContext];
    [info setDate:[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date:[dictionary objectForKey:@"date"]]];
    [info setWith_person:[dictionary objectForKey:@"with_person"]];
    if (![[dictionary objectForKey:@"Waranty"] isEqual:@""])
    {
         [info setWarranty:[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date:[dictionary objectForKey:@"Waranty"]]];
    }
    [info setAmount:[NSNumber numberWithDouble:[[dictionary objectForKey:@"amount"] doubleValue]]];
    
    [info setCategory:[dictionary objectForKey:@"category"]];
    [info setSub_category:[dictionary objectForKey:@"sub_category"]];
    [info setDiscription:[dictionary objectForKey:@"discription"]];
    [info setTransaction_type:[dictionary objectForKey:@"transaction_type"]];
    [info setWith_person:[dictionary objectForKey:@"with_person"]];
    [info setShow_on_homescreen:[dictionary objectForKey:@"shown_on_homescreen"]];
    [info setLocation:[dictionary objectForKey:@"location"]];
    
    if([dictionary valueForKey:@"pic"] != nil)
    {
         UIImage *image=[dictionary objectForKey:@"pic"];
        [info setPic:UIImageJPEGRepresentation(image, 1.0)];
    }
    [info setTransaction_inserted_from:[dictionary objectForKey:@"transaction_inserted_from"]];
    [info setTransaction_reference_id:[dictionary objectForKey:@"transaction_reference_id"]];
    [info setPaymentMode:[dictionary objectForKey:@"paymentMode"]];
    [info setToken_id:[Utility userDefaultsForKey:MAIN_TOKEN_ID] ];
    [info setTransaction_id:[[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date] stringValue]];
    [info setUpdation_date:[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date]];
    [info setServer_updation_date:[NSNumber numberWithInt:0]];
    [info setCurrency:[dictionary objectForKey:@"currency"]];
    [info setUser_token_id:[dictionary objectForKey:@"user_token_id"]];
    [[APP_DELEGATE managedObjectContext] save:&error];
    return YES;
}


-(BOOL)insertDataIntoTransactionTableFromEmport:(NSMutableDictionary*)dictionary
{
    NSError *error;
    
    Transactions   *info = [NSEntityDescription insertNewObjectForEntityForName:@"Transactions" inManagedObjectContext:_managedObjectContext];
    
    [info setDate:[dictionary objectForKey:@"date"]];
    [info setWith_person:[dictionary objectForKey:@"with_person"]];
    [info setWarranty:[dictionary objectForKey:@"warranty"]];
    [info setAmount:[dictionary objectForKey:@"amount"]];
    [info setCategory:[dictionary objectForKey:@"category"]];
    
    if ([[dictionary objectForKey:@"sub_category"] isEqualToString:@"null"])
    {
        [info setSub_category:@""];
    }else
         [info setSub_category:[dictionary objectForKey:@"sub_category"]];
    
    if ([[dictionary objectForKey:@"with_person"] isEqualToString:@"null"])
    {
        [info setWith_person:@""];
    }else
        [info setWith_person:[dictionary objectForKey:@"with_person"]];
    
    if ([[dictionary objectForKey:@"location"] isEqualToString:@"null"])
    {
        [info setLocation:@""];
    }else
        [info setLocation:[dictionary objectForKey:@"location"]];
    
    if([[dictionary valueForKey:@"pic"] length]!=0 && [Utility isInternetAvailable])
    {
        NSURL *url = [NSURL URLWithString:[[dictionary valueForKey:@"pic"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSData* data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
        if (error)
        {
        } else
        {
           [info setPic:data];
        }
    }
    
    [info setDiscription:[dictionary objectForKey:@"discription"]];
    [info setTransaction_type:[dictionary objectForKey:@"transaction_type"]];
    [info setShow_on_homescreen:[dictionary objectForKey:@"show_on_homescreen"]];
    [info setTransaction_inserted_from:[dictionary objectForKey:@"transaction_inserted_from"]];
    [info setTransaction_reference_id:[dictionary objectForKey:@"transaction_reference_id"]];
    [info setPaymentMode:[dictionary objectForKey:@"paymentMode"]];
    [info setToken_id:[dictionary objectForKey:@"token_id"]];
    
    [info setUpdation_date:[dictionary objectForKey:@"updation_date"]];
    [info setTransaction_id:[dictionary objectForKey:@"transaction_id"]];
    [info setServer_updation_date:[dictionary objectForKey:@"server_updation_date"]];
    
    [info setCurrency:@""];
    [info setUser_token_id:[dictionary objectForKey:@"user_token_id"]];
    [[APP_DELEGATE managedObjectContext] save:&error];
    
    NSLog(@"%@",info);
    return YES;
}

-(void)insertDataIntoTransactionTableFromServer:(NSDictionary*)responseObject
{
    NSArray *array=[responseObject objectForKey:@"data"];
    for (NSDictionary *dictionary in array)
    {
        NSError *error;
        Transactions   *info = [NSEntityDescription insertNewObjectForEntityForName:@"Transactions" inManagedObjectContext:_managedObjectContext];
        [info setDate:[dictionary objectForKey:@"transaction_date"]];
        
        if ([dictionary objectForKey:@"person"] == (id)[NSNull null])
        {
            [info setWith_person:@""];
        }else
            [info setWith_person:[dictionary objectForKey:@"person"]];
        
        if ([dictionary objectForKey:@"location"] == (id)[NSNull null])
        {
            [info setLocation:@""];
        }else
            [info setLocation:[dictionary objectForKey:@"location"]];
        
        if ([dictionary objectForKey:@"sub_category"] == (id)[NSNull null])
        {
            [info setSub_category:@""];
        }else
            [info setSub_category:[dictionary objectForKey:@"sub_category"]];
        
        if([[dictionary valueForKey:@"attachments"] length]!=0)
        {
            NSURL *url = [NSURL URLWithString:[dictionary objectForKey:@"attachments"]];
            NSData *data = [NSData dataWithContentsOfURL:url];
            [info setPic:data];
        }
        
        [info setWarranty:[dictionary objectForKey:@"warranty"]];
        [info setAmount:[NSNumber numberWithInt:[[dictionary objectForKey:@"price"] doubleValue]]];
        [info setCategory:[dictionary objectForKey:@"category"]];
       
        [info setDiscription:[dictionary objectForKey:@"description"]];
        [info setTransaction_type:[NSNumber numberWithInt:[[dictionary objectForKey:@"transaction_type"] intValue]]];
        [info setShow_on_homescreen:[NSNumber numberWithInt:[[dictionary objectForKey:@"isRead"] intValue]]];
       
        [info setTransaction_inserted_from:[NSNumber numberWithInt:[[dictionary objectForKey:@"transaction_insert_from"] intValue]]];
        [info setTransaction_reference_id:[dictionary objectForKey:@"transaction_reference_id"]];
        [info setPaymentMode:[dictionary objectForKey:@"payment_mode"]];
        
        [info setTransaction_id:[[[dictionary objectForKey:@"transaction_id"] componentsSeparatedByString:@"_"] objectAtIndex:0]];
         NSNumber *number= [Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date];
        
        [info setServer_updation_date:number];
        [info setUpdation_date:[NSNumber numberWithLongLong:[number longLongValue]-10]];
        [info setCurrency:@""];
        [info setToken_id:[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
        [info setUser_token_id:[dictionary objectForKey:@"account_id"]];
        
        [[APP_DELEGATE managedObjectContext] save:&error];
    }
}



-(void)insertDataIntoTransactionTableFromAddedTransactionToServer:(NSDictionary*)dictionary
{
    NSError *error;
    Transactions   *info = [NSEntityDescription insertNewObjectForEntityForName:@"Transactions" inManagedObjectContext:_managedObjectContext];
    
    [info setDate:[dictionary objectForKey:@"transaction_date"]];
    [info setWarranty:[dictionary objectForKey:@"warranty"]];
    
    if ([dictionary objectForKey:@"person"] == (id)[NSNull null])
    {
        [info setWith_person:@""];
    }else
        [info setWith_person:[dictionary objectForKey:@"person"]];
    
  
    if ([dictionary objectForKey:@"sub_category"] == (id)[NSNull null])
    {
        [info setSub_category:@""];
    }else
        [info setSub_category:[dictionary objectForKey:@"sub_category"]];

    if ([dictionary objectForKey:@"location"] == (id)[NSNull null])
    {
        [info setLocation:@""];
        
    }else
        [info setLocation:[dictionary objectForKey:@"location"]];

    [info setAmount:[NSNumber numberWithInt:[[dictionary objectForKey:@"price"] doubleValue]]];
    [info setCategory:[dictionary objectForKey:@"category"]];
    
    if([[dictionary valueForKey:@"attachments"] length]!=0)
    {
        NSURL *url = [NSURL URLWithString:[dictionary objectForKey:@"attachments"]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        [info setPic:data];
    }
    
    [info setDiscription:[dictionary objectForKey:@"description"]];
    [info setTransaction_type:[NSNumber numberWithInt:[[dictionary objectForKey:@"transaction_type"] intValue]]];
    [info setShow_on_homescreen:[NSNumber numberWithInt:[[dictionary objectForKey:@"isRead"] intValue]]];
    [info setTransaction_inserted_from:[NSNumber numberWithInt:[[dictionary objectForKey:@"transaction_insert_from"] intValue]]];
    [info setTransaction_reference_id:[dictionary objectForKey:@"transaction_reference_id"]];
    [info setPaymentMode:[dictionary objectForKey:@"payment_mode"]];
    [info setTransaction_id:[[[dictionary objectForKey:@"transaction_id"] componentsSeparatedByString:@"_"] objectAtIndex:0]];
    
    NSNumber *number= [Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date];
    [info setServer_updation_date:number];
    
    [info setUpdation_date:[NSNumber numberWithLongLong:[number longLongValue]-10]];
    [info setCurrency:@""];
    [info setToken_id:[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    [info setUser_token_id:[dictionary objectForKey:@"account_id"]];
    [[APP_DELEGATE managedObjectContext] save:&error];
}


-(void)deleteDataIntoTransactionTableFromAddedTransactionToServer:(NSDictionary*)dictionary
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transactions" inManagedObjectContext:_managedObjectContext];
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
    for (Transactions *info in fetchedRecords)
    {
        [[APP_DELEGATE managedObjectContext] deleteObject:info];
        [[APP_DELEGATE managedObjectContext] save:&error];
    }
    
}

-(void)editDataIntoTransactionTableFromAddedTransactionToServer:(NSDictionary*)dictionary
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transactions"  inManagedObjectContext:_managedObjectContext];
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
        for (Transactions *info in fetchedRecords)
        {
            NSError *error;
            [info setDate:[dictionary objectForKey:@"transaction_date"]];
            [info setWarranty:[dictionary objectForKey:@"warranty"]];
            [info setAmount:[NSNumber numberWithInt:[[dictionary objectForKey:@"price"] doubleValue]]];
            [info setCategory:[dictionary objectForKey:@"category"]];
            if ([dictionary objectForKey:@"person"] == (id)[NSNull null])
            {
                [info setWith_person:@""];
                
            }else
                [info setWith_person:[dictionary objectForKey:@"person"]];
            
            
            if ([dictionary objectForKey:@"sub_category"] == (id)[NSNull null])
            {
                [info setSub_category:@""];
                
            }else
                [info setSub_category:[dictionary objectForKey:@"sub_category"]];
            
            
            
            if ([dictionary objectForKey:@"location"] == (id)[NSNull null])
            {
                [info setLocation:@""];
                
            }else
                [info setLocation:[dictionary objectForKey:@"location"]];
            
            if([[dictionary valueForKey:@"attachments"] length]!=0)
            {
                NSURL *url = [NSURL URLWithString:[dictionary objectForKey:@"attachments"]];
                NSData *data = [NSData dataWithContentsOfURL:url];
                [info setPic:data];
            }
            [info setDiscription:[dictionary objectForKey:@"description"]];
            [info setTransaction_type:[NSNumber numberWithInt:[[dictionary objectForKey:@"transaction_type"] intValue]]];
            [info setShow_on_homescreen:[NSNumber numberWithInt:[[dictionary objectForKey:@"isRead"] intValue]]];
            [info setTransaction_inserted_from:[NSNumber numberWithInt:[[dictionary objectForKey:@"transaction_insert_from"] intValue]]];
            [info setTransaction_reference_id:[dictionary objectForKey:@"transaction_reference_id"]];
            [info setPaymentMode:[dictionary objectForKey:@"payment_mode"]];
            [info setTransaction_id:[[[dictionary objectForKey:@"transaction_id"] componentsSeparatedByString:@"_"] objectAtIndex:0]];
            NSNumber *number= [Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date];
            [info setServer_updation_date:number];
            [info setUpdation_date:[NSNumber numberWithLongLong:[number longLongValue]-10]];
            [info setCurrency:@""];
            [info setToken_id:[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
            [info setUser_token_id:[dictionary objectForKey:@"account_id"]];
            [[APP_DELEGATE managedObjectContext] save:&error];
        }
    }else
    {
        [self insertDataIntoTransactionTableFromAddedTransactionToServer:dictionary];
    }
}


-(NSNumber*)insertDataIntoTransactionTableFromTransferTable:(NSMutableDictionary*)dictionary
{
    NSError *error;
    Transactions   *info = [NSEntityDescription insertNewObjectForEntityForName:@"Transactions" inManagedObjectContext:_managedObjectContext];
    [info setDate:[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date:[dictionary objectForKey:@"date"]]];
    [info setAmount:[NSNumber numberWithDouble:[[dictionary objectForKey:@"amount"] doubleValue]]];
    [info setCategory:[dictionary objectForKey:@"category"]];
    [info setSub_category:[dictionary objectForKey:@"sub_category"]];
    [info setDiscription:[dictionary objectForKey:@"description"]];
    [info setTransaction_type:[dictionary objectForKey:@"transaction_type"]];
    if([dictionary valueForKey:@"pic"] != nil)
    {
        UIImage *image=[dictionary objectForKey:@"pic"];
        [info setPic:UIImageJPEGRepresentation(image, 1.0)];
    }
    [info setTransaction_inserted_from:[NSNumber numberWithInt:TYPE_TRANSFER]];
    [info setPaymentMode:[dictionary objectForKey:@"paymentMode"]];
    [info setToken_id:[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    
     [info setUpdation_date:[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date]];
    
    [info setServer_updation_date:[NSNumber numberWithInt:0]];
    [info setCurrency:[dictionary objectForKey:@"currency"]];
    [info setLocation:@""];
    [info setCurrency:@""];
    [info setWith_person:@""];
    [info setUser_token_id:[dictionary objectForKey:@"user_token_id"]];
    
     NSNumber *number = [Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date];
    if ([[dictionary objectForKey:@"transaction_type"] isEqualToNumber:[NSNumber numberWithInt:TYPE_EXPENSE]])
    {
        number = [NSNumber numberWithLongLong:[number longLongValue] + 5];
        [info setTransaction_id:[number stringValue]];
    }else
    {
        [info setTransaction_id:[number stringValue]];
    }
    [[APP_DELEGATE managedObjectContext] save:&error];
     NSLog(@"%@",info);
    return number;
}


-(void)updateServerUpdationDate:(NSString*)data
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transactions"  inManagedObjectContext:_managedObjectContext];
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
    for (Transactions *info in fetchedRecords)
    {
        NSNumber *number= [Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date];
        [info setServer_updation_date:number];
        [info setUpdation_date:[NSNumber numberWithLongLong:[number longLongValue]-10]];
        [[APP_DELEGATE managedObjectContext] save:&error];
    }
}




-(void)updateDataIntoTransactionTableFromTransferTable:(NSMutableDictionary*)dictionary :(Transactions*)info
{
    NSError *error;
    [info setDate:[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date:[dictionary objectForKey:@"date"]]];
    [info setAmount:[NSNumber numberWithDouble:[[dictionary objectForKey:@"amount"] doubleValue]]];
    [info setCategory:[dictionary objectForKey:@"category"]];
    [info setSub_category:[dictionary objectForKey:@"sub_category"]];
    [info setDiscription:[dictionary objectForKey:@"description"]];
    [info setTransaction_type:[dictionary objectForKey:@"transaction_type"]];
    if([dictionary valueForKey:@"pic"] != nil)
    {
        UIImage *image=[dictionary objectForKey:@"pic"];
        [info setPic:UIImageJPEGRepresentation(image, 1.0)];
    }
    [info setTransaction_inserted_from:[NSNumber numberWithInt:TYPE_TRANSFER]];
    [info setPaymentMode:[dictionary objectForKey:@"paymentMode"]];
    [info setToken_id:[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    [info setCurrency:[dictionary objectForKey:@"currency"]];
     [info setUpdation_date:[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date]];
    [info setUser_token_id:[dictionary objectForKey:@"user_token_id"]];
      NSLog(@"%@",info);
    [[APP_DELEGATE managedObjectContext] save:&error];
}


-(BOOL)updateRefrence_idIntoTransactionTableFromTransferTable:(NSString*)string :(Transactions*)info
{
     NSError *error;
    [info setTransaction_reference_id:string];
    [info setUpdation_date:[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date]];
    [[APP_DELEGATE managedObjectContext] save:&error];
    return YES;
}


-(NSString*)insertDataIntoTransactionTableFromNotification:(NSMutableDictionary*)dictionary
{
     NSError *error;
     Transactions   *info = [NSEntityDescription insertNewObjectForEntityForName:@"Transactions" inManagedObjectContext:_managedObjectContext];
     [info setDate:[dictionary objectForKey:@"date"]];
     [info setAmount:[NSNumber numberWithInt:[[dictionary objectForKey:@"amount"] intValue]]];
     [info setCategory:[dictionary objectForKey:@"category"]];
     [info setSub_category:[dictionary objectForKey:@"sub_category"]];
     [info setDiscription:[dictionary objectForKey:@"discription"]];
     [info setPaymentMode:[dictionary objectForKey:@"paymentMode"]];
    if ([[dictionary objectForKey:@"transaction_type"] isEqualToString:NSLocalizedString(@"income", nil)])
    {
         [info setTransaction_type:[NSNumber numberWithInt:1]];
        
    }else if ([[dictionary objectForKey:@"transaction_type"] isEqualToString:NSLocalizedString(@"expense", nil)])
    {
        [dictionary setObject:[NSNumber numberWithInt:0] forKey:@"transaction_type"];
        
    }else if ([[dictionary objectForKey:@"transaction_type"] isEqualToString:NSLocalizedString(@"none", nil)])
    {
        [dictionary setObject:[NSNumber numberWithInt:2] forKey:@"transaction_type"];
    }
     [info setTransaction_inserted_from:[NSNumber numberWithInt:TYPE_REMINDER]];
     [info setUser_token_id:[dictionary objectForKey:@"user_token_id"]];
     if([dictionary objectForKey:@"pic"]!= nil)
     {
        [info setPic:[dictionary objectForKey:@"pic"]];
     }
    NSString *mainToken=[Utility userDefaultsForKey:MAIN_TOKEN_ID];
    NSString *currency= [Utility  userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",CURRENT_CURRENCY,mainToken]];
    [info setCurrency:currency];
    [info setLocation:@""];
    [info setWith_person:@""];
    [info setToken_id:[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    NSNumber *number=[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date];
    [info setUpdation_date:number];
    [info setTransaction_id:[number stringValue]];
    [info setTransaction_reference_id:[dictionary objectForKey:@"transaction_id"]];
    [info setServer_updation_date:[NSNumber numberWithInt:0]];
     NSLog(@"%@",info);
    [[APP_DELEGATE managedObjectContext] save:&error];
    return [number stringValue];
}


-(NSArray *)getTransactionWithTransactionRefrenceId:(NSString*)searchText
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transactions"
                                              inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"transaction_id = %@  AND token_id = %@",searchText,[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    // Returning Fetched Records
    return fetchedRecords;
}

-(NSArray *)getTransactionWithRemiderId:(NSString*)searchText
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transactions"
                                              inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"transaction_reference_id = %@  AND token_id = %@",searchText,[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    // Returning Fetched Records
    return fetchedRecords;
}


-(NSArray *)getTransactionWithTransactionRefrenceId:(NSString*)searchText :(NSString*)userTokenId
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transactions"
                                              inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"transaction_id = %@ AND user_token_id = %@ AND token_id = %@",searchText,userTokenId,[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    // Returning Fetched Records
    return fetchedRecords;
}

-(BOOL)updateDataIntoTransactionTable:(NSMutableDictionary*)dictionary :(Transactions*)info
{
    NSError *error;
    [info setDate:[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date:[dictionary objectForKey:@"date"]]];
    [info setWith_person:[dictionary objectForKey:@"with_person"]];
    if (![[dictionary objectForKey:@"Waranty"] isEqual:@""])
    {
        [info setWarranty:[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date:[dictionary objectForKey:@"Waranty"]]];
    }
    [info setAmount:[NSNumber numberWithDouble:[[dictionary objectForKey:@"amount"] doubleValue]]];
    [info setCategory:[dictionary objectForKey:@"category"]];
    [info setSub_category:[dictionary objectForKey:@"sub_category"]];
    [info setDiscription:[dictionary objectForKey:@"discription"]];
    [info setTransaction_type:[dictionary objectForKey:@"transaction_type"]];
    [info setWith_person:[dictionary objectForKey:@"with_person"]];
    [info setShow_on_homescreen:[dictionary objectForKey:@"shown_on_homescreen"]];
    [info setLocation:[dictionary objectForKey:@"location"]];
    [info setUser_token_id:[dictionary objectForKey:@"user_token_id"]];
    if([dictionary valueForKey:@"pic"] != nil)
    {
        UIImage *image=[dictionary objectForKey:@"pic"];
        [info setPic:UIImageJPEGRepresentation(image, 1.0)];
    }else
         [info setPic:nil];
    
    [info setDate:[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date:[dictionary objectForKey:@"date"]]];
    [info setPaymentMode:[dictionary objectForKey:@"paymentMode"]];
    NSString *currency= [Utility  userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",CURRENT_CURRENCY,[Utility userDefaultsForKey:MAIN_TOKEN_ID]]];
    [info setCurrency:currency];
    [info setUpdation_date:[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date]];
    [[APP_DELEGATE managedObjectContext] save:&error];
    NSLog(@"%@",info);
    return YES;
}


-(NSArray*)getAllTransactionsForID:(NSString*)userTokenid;
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transactions" inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate ;
    
    if ([userTokenid length]!=0)
    {
         predicate =[NSPredicate predicateWithFormat:@"user_token_id = %@ AND token_id = %@",userTokenid,[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    }else
    {
         predicate =[NSPredicate predicateWithFormat:@"token_id = %@",[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    }
    
    NSArray *categery=[[CategoryListHandler sharedCoreDataController] getAllCategoryList];
    NSArray *paymetnMode=[[PaymentmodeHandler sharedCoreDataController] getAllPaymetModeListUnhide];
    NSPredicate *p1 =  [NSPredicate predicateWithFormat:@"category IN %@", categery];
    NSPredicate *p2 =  [NSPredicate predicateWithFormat:@"paymentMode IN %@", paymetnMode];
    
    NSArray *usetTokeArray=[[UserInfoHandler sharedCoreDataController] getUserNameListFromUserRegisterTable];
    NSPredicate *p3 =  [NSPredicate predicateWithFormat:@"user_token_id IN %@", usetTokeArray];
    NSPredicate *newPredicate = [NSCompoundPredicate andPredicateWithSubpredicates: @[predicate,p1, p2,p3]];
    
   // [fetchRequest setPredicate:newPredicate];
   // fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchLimit:10];
    [fetchRequest setReturnsDistinctResults:YES];
     NSError* error;
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return fetchedRecords;
}


-(NSArray*)getAllTransactionsForID:(NSString *)userTokenId :(NSDate*)startDate :(NSDate*)endDate :(NSString*)transaction_type :(NSString*)oderBy :(NSMutableArray*)categery :(NSMutableArray*)paymetnMode
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSString *transactiontype;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transactions" inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate;
    
    if ([oderBy isEqualToString:NSLocalizedString(@"Recent Transactions", nil)])
    {
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
        
    }else if ([oderBy isEqualToString:  NSLocalizedString(@"Old Transactions", nil)])
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
                 predicate = [NSPredicate predicateWithFormat:@"token_id = %@ AND user_token_id = %@ AND  ((date >= %@) AND (date < %@))",[Utility userDefaultsForKey:MAIN_TOKEN_ID ],userTokenId,[self getDate:startDate], [self getDate:endDate]];
            }else
                 predicate = [NSPredicate predicateWithFormat:@"token_id = %@ AND ((date >= %@) AND (date < %@))",[Utility userDefaultsForKey:MAIN_TOKEN_ID],[self getDate:startDate], [self getDate:endDate]];
        }else
        {
            if ([ transaction_type isEqualToString:  NSLocalizedString(@"income", nil)])
            {
                transactiontype=[NSString stringWithFormat:@"%i",TYPE_INCOME];
                
            }else if ([transaction_type isEqualToString:NSLocalizedString(@"expense", nil)])
            {
                transactiontype=[NSString stringWithFormat:@"%i",TYPE_EXPENSE];
            }
            if ([userTokenId length]!=0)
            {
            predicate = [NSPredicate predicateWithFormat:@"token_id = %@ AND transaction_type = %@ AND user_token_id = %@ AND ((date >= %@) AND (date < %@))",[Utility userDefaultsForKey:MAIN_TOKEN_ID],transactiontype,userTokenId,[self getDate:startDate], [self getDate:endDate]];
            }else
            predicate = [NSPredicate predicateWithFormat:@"token_id = %@ AND transaction_type =%@ AND ((date >= %@) AND (date < %@))",[Utility userDefaultsForKey:MAIN_TOKEN_ID],transactiontype,[self getDate:startDate], [self getDate:endDate]];
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


-(NSArray *)getAllWarranrtyList
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transactions" inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate;
     predicate =[NSPredicate predicateWithFormat:@"transaction_inserted_from = %@ AND token_id = %@",[NSString stringWithFormat:@"%i",TYPE_WARRANTY],[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    // Returning Fetched Records
    return fetchedRecords;
    
}


-(NSArray *)getAllWarranrty:(NSString*)searchText :(NSString*)userTokenid
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transactions" inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate;
    if ([userTokenid length]!=0)
    {
    predicate =[NSPredicate predicateWithFormat:@"transaction_inserted_from = %@ AND user_token_id = %@  AND token_id = %@",searchText,userTokenid,[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    }else
    predicate =[NSPredicate predicateWithFormat:@"transaction_inserted_from = %@ AND token_id = %@",searchText,[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    
    NSArray *categery=[[CategoryListHandler sharedCoreDataController] getAllCategoryList];
    NSArray *paymetnMode=[[PaymentmodeHandler sharedCoreDataController] getAllPaymetModeListUnhide];
    NSPredicate *p1 =  [NSPredicate predicateWithFormat:@"category IN %@", categery];
    NSPredicate *p2 =  [NSPredicate predicateWithFormat:@"paymentMode IN %@", paymetnMode];
    NSArray *usetTokeArray=[[UserInfoHandler sharedCoreDataController] getUserNameListFromUserRegisterTable];
    NSPredicate *p3 =  [NSPredicate predicateWithFormat:@"user_token_id IN %@", usetTokeArray];
    NSPredicate *newPredicate = [NSCompoundPredicate andPredicateWithSubpredicates: @[predicate,p1, p2,p3]];   
    [fetchRequest setPredicate:newPredicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    // Returning Fetched Records
    return fetchedRecords;
}


-(NSArray *)getAllWarranrtyOnHomeScreen:(NSString*)searchText :(NSString*)userTokenid
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transactions" inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate;
    if ([userTokenid length]!=0)
    {
        predicate =[NSPredicate predicateWithFormat:@"transaction_inserted_from = %@ AND user_token_id = %@ AND show_on_homescreen = %@ AND token_id = %@",searchText,userTokenid,@"0",[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    }else
        predicate =[NSPredicate predicateWithFormat:@"transaction_inserted_from = %@ AND show_on_homescreen = %@ AND token_id = %@",searchText,@"0",[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    
    NSArray *categery=[[CategoryListHandler sharedCoreDataController] getAllCategoryList];
    NSArray *paymetnMode=[[PaymentmodeHandler sharedCoreDataController] getAllPaymetModeListUnhide];
    
    NSArray *usetTokeArray=[[UserInfoHandler sharedCoreDataController] getUserNameListFromUserRegisterTable];
    NSPredicate *p3 =  [NSPredicate predicateWithFormat:@"user_token_id IN %@", usetTokeArray];
    
    NSPredicate *p1 =  [NSPredicate predicateWithFormat:@"category IN %@", categery];
    NSPredicate *p2 =  [NSPredicate predicateWithFormat:@"paymentMode IN %@", paymetnMode];
   

    NSPredicate *newPredicate = [NSCompoundPredicate andPredicateWithSubpredicates: @[predicate,p1, p2,p3]];
    [fetchRequest setPredicate:newPredicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
       [fetchRequest setFetchLimit:5];
    NSMutableArray *array=[[NSMutableArray alloc] init];
    for ( Transactions *transaction in fetchedRecords)
    {
        NSString *nDate=[transaction.warranty stringValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:([nDate doubleValue] / 1000)];
        NSTimeInterval interval = [date timeIntervalSinceDate:[NSDate date]];
        int numberOfDays = interval / 86400;
        if (numberOfDays<=10 && numberOfDays>=0)
        {
            [array addObject:transaction];
        }
    }
    // Returning Fetched Records
    return array;
}


-(NSArray *)getTransactionWithCategeryAndPaymenMode:(NSString*)categary :(NSString*)paymentMode :(NSString*)subCategery :(NSString*)userToke :(NSNumber*)startDate :(NSNumber*)endDate;
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transactions" inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate ;
  
    if([categary isEqualToString:@"All"] && [paymentMode isEqualToString:@"All"])
    {
        predicate = [NSPredicate predicateWithFormat:@"user_token_id = %@",userToke];
        
    }else if(![categary isEqualToString:@"All"] && [paymentMode isEqualToString:@"All"])
    {
        if ([subCategery length]==0)
        {
            predicate = [NSPredicate predicateWithFormat:@"category = %@ AND user_token_id = %@",categary,userToke];
        }else
        {
            predicate = [NSPredicate predicateWithFormat:@"category = %@ AND sub_category =%@ AND user_token_id = %@",categary,subCategery,userToke];
        }
        
    }else if(![categary isEqualToString:@"All"] && ![paymentMode isEqualToString:@"All"])
    {
        if ([subCategery length]==0)
        {
            predicate = [NSPredicate predicateWithFormat:@"category = %@ AND paymentMode =%@ AND user_token_id = %@",categary,paymentMode,userToke];
        }else
        {
            predicate = [NSPredicate predicateWithFormat:@"category = %@ AND sub_category =%@ AND paymentMode =%@  AND user_token_id = %@",categary,subCategery,paymentMode,userToke];
        }
    }
    
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchLimit:10];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    // Returning Fetched Records
    return fetchedRecords;
}

-(NSArray *)getTransactionWithTransactionId:(NSString*)searchText :(NSString*)userTokenId
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transactions"
                                              inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"transaction_id = %@ AND user_token_id = %@ AND token_id = %@ ",searchText,userTokenId,[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    // Returning Fetched Records
    return fetchedRecords;
}

-(NSNumber*)getDate:(NSDate*)date
{
    long long milliseconds = (long long)([date timeIntervalSince1970] * 1000.0);
    return [NSNumber numberWithUnsignedLongLong:milliseconds];
    
}

-(NSArray *)getMaxDateFromTransactionTable:(NSString*)string
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transactions"
                                              inManagedObjectContext:_managedObjectContext];
    if ([string length]!=0)
    {
         fetchRequest.predicate = [NSPredicate predicateWithFormat:@"user_token_id = %@ AND token_id = %@",string,[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    }else
         fetchRequest.predicate = [NSPredicate predicateWithFormat:@"token_id = %@",[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
   
    [fetchRequest setEntity:entity];
    fetchRequest.fetchLimit = 1;
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];

    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    // Returning Fetched Records
    return fetchedRecords;
}


-(NSArray *)getMinDateFromTransactionTable:(NSString*)string
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transactions"  inManagedObjectContext:_managedObjectContext];
    if ([string length]!=0)
    {
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"user_token_id = %@ AND token_id = %@",string,[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    }else
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"token_id = %@",[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    fetchRequest.fetchLimit = 1;
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    // Returning Fetched Records
    return fetchedRecords;
}



-(NSArray*)getAllUserTransaction
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transactions"  inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"token_id = %@",[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
     NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return fetchedRecords;
}

-(NSArray*)getAllUserTransactionWithType:(NSString *)type
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transactions"  inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"transaction_type = %@ AND token_id = %@",type,[Utility userDefaultsForKey:MAIN_TOKEN_ID]];;
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return fetchedRecords;
}


-(NSArray*)getAllTransactionToUpdateOnServer
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transactions"  inManagedObjectContext:_managedObjectContext];
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


-(NSArray*)getAllTransactionToEditOnServer
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transactions"  inManagedObjectContext:_managedObjectContext];
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


-(NSArray *)getAllUser:(NSString*)searchText :(NSString*)userTokenId
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transactions" inManagedObjectContext:_managedObjectContext];
    //Setting Entity to be Queried
    NSPredicate *predicate;
    
    if ([userTokenId length]!=0)
    {
         predicate =[NSPredicate predicateWithFormat:@"transaction_type = %@ AND user_token_id = %@  AND token_id = %@",searchText,userTokenId,[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
        NSArray *categery=[[CategoryListHandler sharedCoreDataController] getAllCategoryList];
        NSArray *paymetnMode=[[PaymentmodeHandler sharedCoreDataController] getAllPaymetModeListUnhide];
        NSPredicate *p1 =  [NSPredicate predicateWithFormat:@"category IN %@", categery];
        NSPredicate *p2 =  [NSPredicate predicateWithFormat:@"paymentMode IN %@", paymetnMode];
        NSPredicate *newPredicate = [NSCompoundPredicate andPredicateWithSubpredicates: @[predicate,p1, p2]];
       [fetchRequest setPredicate:newPredicate];
    }else
    {
        predicate =[NSPredicate predicateWithFormat:@"transaction_type = %@ AND token_id = %@",searchText,[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
        NSArray *categery=[[CategoryListHandler sharedCoreDataController] getAllCategoryList];
        NSArray *paymetnMode=[[PaymentmodeHandler sharedCoreDataController] getAllPaymetModeListUnhide];
        NSPredicate *p1 =  [NSPredicate predicateWithFormat:@"category IN %@", categery];
        NSPredicate *p2 =  [NSPredicate predicateWithFormat:@"paymentMode IN %@", paymetnMode];
        NSArray *usetTokeArray=[[UserInfoHandler sharedCoreDataController] getUserNameListFromUserRegisterTable];
        NSPredicate *p3 =  [NSPredicate predicateWithFormat:@"user_token_id IN %@", usetTokeArray];
        NSPredicate *newPredicate = [NSCompoundPredicate andPredicateWithSubpredicates: @[predicate,p1, p2,p3]];
        [fetchRequest setPredicate:newPredicate];
    }
    //Setting Entity to be Queried
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    // Returning Fetched Records
    return fetchedRecords;
}


-(double)getTotalIncomeForAllAccounts:(NSString*)tokenId
{
     double totalamountIncome = 0.0;
    NSArray *array=[self getAllUser:[NSString stringWithFormat:@"%i",TYPE_INCOME] :tokenId];
    if ([array count]!=0)
    {
        for (Transactions *transaction in array)
        {
            totalamountIncome=totalamountIncome+[transaction.amount doubleValue];
        }
    }
    return totalamountIncome;
}


-(double)getTotalExpenseForAllAccounts:(NSString*)tokenId
{
   double totalamountExpense = 0.0;
    NSArray *array=[self getAllUser:[NSString stringWithFormat:@"%i",TYPE_EXPENSE] :tokenId];
    if ([array count]!=0)
    {
        for (Transactions *transaction in array)
        {
            totalamountExpense=totalamountExpense+[transaction.amount doubleValue];
        }
    }
    return totalamountExpense;
}


-(NSArray *)getAllUserwithCategaryandPaymentMode:(NSString *)categary andSearchText:(NSString*)paymentMode :(NSString*)typeExpense :(NSString*)userToke :(NSString*)subCategery :(NSNumber*)startDate :(NSNumber*)endDate
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transactions"   inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate;
    
    if([categary isEqualToString:@"All"] && [paymentMode isEqualToString:@"All"])
    {
        predicate = [NSPredicate predicateWithFormat:@"transaction_type =%@ AND user_token_id = %@ AND ((date >= %@) AND (date < %@))",typeExpense,userToke,startDate,endDate];
        
    }else if([categary isEqualToString:@"All"] && ![paymentMode isEqualToString:@"All"])
    {
        predicate = [NSPredicate predicateWithFormat:@"transaction_type =%@ AND user_token_id = %@ AND paymentMode =%@ AND ((date >= %@) AND (date < %@))",typeExpense,userToke,paymentMode,startDate,endDate];
        
    }else if(![categary isEqualToString:@"All"] && [paymentMode isEqualToString:@"All"])
    {
        if ([subCategery length]==0)
        {
             predicate = [NSPredicate predicateWithFormat:@"category = %@ AND transaction_type =%@ AND user_token_id = %@ AND ((date >= %@) AND (date < %@))",categary,typeExpense,userToke,startDate,endDate];
        }else
        {
              predicate = [NSPredicate predicateWithFormat:@"category = %@ AND sub_category =%@  AND transaction_type =%@ AND user_token_id = %@ AND ((date >= %@) AND (date < %@))",categary,subCategery,typeExpense,userToke,startDate,endDate];
        }
       
    }else if(![categary isEqualToString:@"All"] && ![paymentMode isEqualToString:@"All"])
    {
        if ([subCategery length]==0)
        {
             predicate = [NSPredicate predicateWithFormat:@"category = %@ AND paymentMode =%@ AND transaction_type =%@ AND user_token_id = %@ AND ((date >= %@) AND (date < %@))",categary,paymentMode,typeExpense,userToke,startDate,endDate];
        }else
        {
              predicate = [NSPredicate predicateWithFormat:@"category = %@ AND sub_category =%@ AND paymentMode =%@ AND transaction_type =%@ AND user_token_id = %@ AND ((date >= %@) AND (date < %@))",categary,subCategery,paymentMode,typeExpense,userToke,startDate,endDate];
        }
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

-(double)getTotalExpenseForAllAccountswithCategryAndPaymentMode:(NSString*)categary :(NSString *)paymentMode :(NSString*)userToke :(NSString*)subCategery :(NSNumber*)startDate :(NSNumber*)endeDate
{
    double totalamountExpense = 0.0;
    NSArray *array=[self getAllUserwithCategaryandPaymentMode:categary andSearchText:paymentMode :[NSString stringWithFormat:@"%i",TYPE_EXPENSE] :userToke :subCategery :startDate :endeDate];
    if ([array count]!=0)
    {
        for (Transactions *transaction in array)
        {
            totalamountExpense=totalamountExpense+[transaction.amount doubleValue];
        }
    }
    return totalamountExpense;
}


-(void)deleteCategeroyList:(NSString *)categery chekServerUpdation:(BOOL)chek
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transactions"
                                              inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"category = %@ AND token_id = %@",categery,[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    // Returning Fetched Records
    for (Transactions *info in fetchedRecords)
    {
        if (![info.token_id isEqualToString:@"0"] && !chek)
        {
            [self insertDataIntoUpdateOnServerTransactionsTable:info];
        }
        [[APP_DELEGATE managedObjectContext] deleteObject:info];
        [[APP_DELEGATE managedObjectContext] save:&error];
    }
}


-(void)updateCategeroyToCategery:(NSString*)fromCategery :(NSString*)toCategery
{

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transactions"
                                              inManagedObjectContext:_managedObjectContext];
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
    for (Transactions *info in fetchedRecords)
    {
        [info setCategory:toCategery];
        [info setUpdation_date:[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date]];
        [[APP_DELEGATE managedObjectContext] save:&error];
    }
}

-(void)updateTokenId:(NSDictionary*)dictionary  :(Transactions*)info
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




-(void)updateCategeroySubCategryToCategery:(NSString*)fromCategery :(NSString*)toCategery
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transactions" inManagedObjectContext:_managedObjectContext];
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
    for (Transactions *info in fetchedRecords)
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transactions"  inManagedObjectContext:_managedObjectContext];
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
    for (Transactions *info in fetchedRecords)
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transactions"  inManagedObjectContext:_managedObjectContext];
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

-(void)updateUserToken:(NSString*)fromAccount :(NSString*)ToAccount
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transactions"  inManagedObjectContext:_managedObjectContext];
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




-(void)updatePaymentMode:(NSString*)paymetMode :(NSString*)toPaymetMode
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transactions" inManagedObjectContext:_managedObjectContext];
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transactions"
                                              inManagedObjectContext:_managedObjectContext];
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
        if (![info.token_id isEqualToString:@"0"] && !chek)
        {
            [self insertDataIntoUpdateOnServerTransactionsTable:info];
        }
        [[APP_DELEGATE managedObjectContext] deleteObject:info];
        [[APP_DELEGATE managedObjectContext] save:&error];
    }
}




-(void)updateTransaction:(Transactions*)info
{
    NSError *error;
    [info setShow_on_homescreen:[NSNumber numberWithInt:1]];
    NSNumber *number= [Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date];
    [info setServer_updation_date:number];
    [info setUpdation_date:[NSNumber numberWithLongLong:[number longLongValue]-10]];
    [[APP_DELEGATE managedObjectContext] save:&error];
}

-(void)insertDataIntoUpdateOnServerTransactionsTable:(Transactions*)newInfo
{
    NSError *error;
    UpdateOnServerTransactionsTable   *info = [NSEntityDescription insertNewObjectForEntityForName:@"UpdateOnServerTransactionsTable" inManagedObjectContext:_managedObjectContext];
    [info setTransaction_id:newInfo.transaction_id];
    [info setUser_token_id:newInfo.user_token_id];
    [info setTransaction_type:newInfo.transaction_type];
    [[APP_DELEGATE managedObjectContext] save:&error];
}

-(BOOL)deleteTransaction:(Transactions*)info
{
    if (![info.token_id isEqualToString:@"0"])
    {
        [self insertDataIntoUpdateOnServerTransactionsTable:info];
    }
     NSError *error;
    [[APP_DELEGATE managedObjectContext] deleteObject:info];
    [[APP_DELEGATE managedObjectContext] save:&error];
    return YES;
}

-(NSArray*)getAllTransferToDeleteOnServer
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UpdateOnServerTransactionsTable" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setFetchLimit:50];
    // [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return fetchedRecords;
}


-(void)deleteAccountToDeleteOnServer:(NSDictionary *)responseObject
{
    NSArray *array=[responseObject objectForKey:@"data"];
    for (NSDictionary *dic in array)
    {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        //Setting Entity to be Queried
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"UpdateOnServerTransactionsTable"
                                                  inManagedObjectContext:_managedObjectContext];
        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"user_token_id = %@ AND transaction_id = %@ ",[dic objectForKey:@"usertoken_id"],[dic objectForKey:@"transaction_id"]];
        [fetchRequest setPredicate:predicate];
        [fetchRequest setEntity:entity];
        [fetchRequest setReturnsDistinctResults:YES];
        NSError* error;
        // Query on managedObjectContext With Generated fetchRequest
        NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
        // Returning Fetched Records
        for (UpdateOnServerTransactionsTable *info in fetchedRecords)
        {
            [[APP_DELEGATE managedObjectContext] deleteObject:info];
            [[APP_DELEGATE managedObjectContext] save:&error];
        }
        
    }
   
}


@end
