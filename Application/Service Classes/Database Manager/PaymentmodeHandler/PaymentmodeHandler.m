//
//  PaymentmodeHandler.m
//  Daily Expense Manager
//
//  Created by Appbulous on 03/09/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import "PaymentmodeHandler.h"
#import "Paymentmode.h"
#import "UpdateOnServerTransactionsTable.h"
#import "TransactionHandler.h"
#import "ReminderHandler.h"
#import "TransferHandler.h"
#import "BudgetHandler.h"
#import "Utility.h"
@implementation PaymentmodeHandler

-(id) init
{
    self = [super init];
    if(self)
    {
        _managedObjectContext = [APP_DELEGATE managedObjectContext];
    }
    return self;
}

+(PaymentmodeHandler *) sharedCoreDataController
{
    static PaymentmodeHandler *singletone=nil;
    if(!singletone)
    {
        singletone=[[PaymentmodeHandler alloc] init];
    }
    return singletone;
}


-(void)addDefaultPaymentMode:(NSString *)paymentMedium
{
    NSArray  *paymentMediumArray=[paymentMedium componentsSeparatedByString:@","];
    for (NSString *string in paymentMediumArray)
    {
        Paymentmode   *info = [NSEntityDescription insertNewObjectForEntityForName:@"Paymentmode" inManagedObjectContext:_managedObjectContext];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_icon.png",string]];
        NSData *data=UIImageJPEGRepresentation(image, 1.0);
        if ([data length]==0)
        {
            data=UIImageJPEGRepresentation([UIImage imageNamed:@"paymentmode_icon.png"], 1.0);
        }
        [info setPaymentmode_icon:data];
        [info setPaymentMode:TRIM(string)];
        [info setHide_status:[NSNumber numberWithInt:0]];
        [info setToken_id:[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
        [info setUpdation_date:[self getGMT_MillisFromYYYY_MM_DD_HH_SS_Date]];
        [info setTransaction_id:[[self getGMT_MillisFromYYYY_MM_DD_HH_SS_Date] stringValue]];
        [info setServer_updation_date:[NSNumber numberWithInt:0]];
         NSError *error;
        [[APP_DELEGATE managedObjectContext] save:&error];
    }
}


-(NSArray*)getDefaultPaymentModeBeanList
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Paymentmode" inManagedObjectContext:_managedObjectContext];
     NSPredicate *predicate=[NSPredicate predicateWithFormat:@"token_id = %@",[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"paymentMode" ascending:YES]];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return fetchedRecords;
}


-(NSArray *)getsearchPaymentMode:(NSString *)searchText
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Paymentmode" inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"paymentMode = %@ AND hide_status = %@ ",searchText,@"0"];
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
    return fetchedRecords;
}

-(void)updateCategoryListWithHideStatus:(NSString *)paymentMode :(int)hidestatus
{
    NSError *error;
    NSArray *array=[self getsearchPaymentMode:paymentMode];
    for (Paymentmode *list in array)
    {
        if ([list.hide_status intValue] != hidestatus)
        {
            [list setHide_status:[NSNumber numberWithInt:hidestatus]];
            [[APP_DELEGATE managedObjectContext] save:&error];
        }
       
    }
}



-(NSArray*)getPaymentModeBeanList
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Paymentmode" inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"token_id = %@",[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    [fetchRequest setResultType:NSDictionaryResultType];
    NSError* error;
    NSMutableArray *array=[[NSMutableArray alloc] init];
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (int i=0; i<[fetchedRecords count]; i++)
    {
        NSString *string=[[fetchedRecords objectAtIndex:i] objectForKey:@"paymentMode"];
        [array addObject:string];
    }
    return array;
    // Query on managedObjectContext With Generated fetchRequest
}


-(NSArray*)getPaymentModeBeanListToUpdateOnServer
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Paymentmode" inManagedObjectContext:_managedObjectContext];
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

-(NSArray*)getPaymentModeBeanListToEditOnServer
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Paymentmode" inManagedObjectContext:_managedObjectContext];
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

-(void)insertDataIntoUpdateOnServerTransactionsTable:(Paymentmode*)newInfo
{
    NSError *error;
    UpdateOnServerTransactionsTable   *info = [NSEntityDescription insertNewObjectForEntityForName:@"UpdateOnServerTransactionsTable" inManagedObjectContext:_managedObjectContext];
    [info setTransaction_id:newInfo.transaction_id];
    [info setUser_token_id:@""];
    [info setTransaction_type:[NSNumber numberWithInt:TYPE_PAYMENT]];
    [[APP_DELEGATE managedObjectContext] save:&error];
}

-(void)updateServerUpdationDate:(NSString*)data
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Paymentmode"  inManagedObjectContext:_managedObjectContext];
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
    for (Paymentmode *info in fetchedRecords)
    {
        NSNumber *number= [Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date];
        [info setServer_updation_date:number];
        [info setUpdation_date:[NSNumber numberWithLongLong:[number longLongValue]-10]];
        [[APP_DELEGATE managedObjectContext] save:&error];
    }
}

-(NSArray*)getPaymentModeList
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Paymentmode" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"token_id = %@ AND hide_status = %@",[Utility userDefaultsForKey:MAIN_TOKEN_ID],@"0"];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setReturnsDistinctResults:YES];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"paymentMode" ascending:YES]];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return fetchedRecords;
}


-(NSMutableArray*)getAllPaymetModeListUnhide
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Paymentmode" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"token_id = %@ AND hide_status = %@",[Utility userDefaultsForKey:MAIN_TOKEN_ID],@"0"];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSMutableArray *array=[[NSMutableArray alloc] init];
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (Paymentmode *info in fetchedRecords)
    {
        NSString *string=info.paymentMode;
        [array addObject:TRIM(string)];
    }
    return array;
}


-(NSMutableArray*)getAllPaymetModeListWithHideStatus
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Paymentmode" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"token_id = %@",[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSMutableArray *array=[[NSMutableArray alloc] init];
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (Paymentmode *info in fetchedRecords)
    {
        NSString *string=info.paymentMode;
        [array addObject:TRIM(string)];
    }
    return array;
}





-(NSArray *)getsearchPaymentWithAttributeName:(NSString *)searchText
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Paymentmode" inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"paymentMode = %@ AND token_id = %@",searchText,[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setResultType:NSDictionaryResultType];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    // Returning Fetched Records
    return fetchedRecords;
}

-(NSNumber*)getGMT_MillisFromYYYY_MM_DD_HH_SS_Date
{
    long long milliseconds = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
    return [NSNumber numberWithUnsignedLongLong:milliseconds];
}



-(BOOL)insetItemPayemtMode:(NSDictionary *)dictionary
{
    Paymentmode   *info = [NSEntityDescription insertNewObjectForEntityForName:@"Paymentmode" inManagedObjectContext:_managedObjectContext];
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@ icon.png",[dictionary objectForKey:@"paymentMode"]]];
    
    if (image==nil)
    {
        UIImage *image = [dictionary objectForKey:@"paymentmode_icon"];
        [info setPaymentmode_icon:UIImageJPEGRepresentation(image, 1.0)];
    }else
    {
        [info setPaymentmode_icon:UIImageJPEGRepresentation(image, 1.0)];
    }
    
    [info setPaymentMode:[dictionary objectForKey:@"paymentMode"]];
    [info setHide_status:[dictionary objectForKey:@"hide_status"]];
    [info setToken_id:[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    [info setUpdation_date:[self getGMT_MillisFromYYYY_MM_DD_HH_SS_Date]];
    [info setTransaction_id:[[self getGMT_MillisFromYYYY_MM_DD_HH_SS_Date] stringValue]];
    [info setServer_updation_date:[NSNumber numberWithInt:0]];
    
    NSError *error;
    [[APP_DELEGATE managedObjectContext] save:&error];
    
    NSLog(@"%@",info);
    return true;
}

-(BOOL)insetItemPayemtModeFromExport:(NSDictionary *)dictionary
{
    Paymentmode   *info = [NSEntityDescription insertNewObjectForEntityForName:@"Paymentmode" inManagedObjectContext:_managedObjectContext];
    [info setPaymentMode:TRIM([dictionary objectForKey:@"paymentMode"])];
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@ icon.png",[dictionary objectForKey:@"paymentMode"]]];
    if (image==nil)
    {
        UIImage *image = [UIImage imageNamed:@"paymentmode.png"];
        [info setPaymentmode_icon:UIImageJPEGRepresentation(image, 1.0)];
    }else
         [info setPaymentmode_icon:UIImageJPEGRepresentation(image, 1.0)];
    
    [info setHide_status:[dictionary objectForKey:@"hide_status"]];
    [info setToken_id:[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    [info setTransaction_id:[dictionary objectForKey:@"transaction_id"]];
    [info setServer_updation_date:[dictionary objectForKey:@"server_updation_date"]];
    [info setUpdation_date:[dictionary objectForKey:@"updation_date"]];
    NSError *error;
    [[APP_DELEGATE managedObjectContext] save:&error];
    return YES;
}


-(void)insetItemPayemtModeFromServer:(NSDictionary*)responseObject
{
    NSArray *array=[responseObject objectForKey:@"data"];
    for (NSDictionary *dic in array)
    {
        NSError  *error;
       Paymentmode   *info = [NSEntityDescription insertNewObjectForEntityForName:@"Paymentmode" inManagedObjectContext:_managedObjectContext];

        [info setPaymentMode:[dic objectForKey:@"payment_mode"]];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@ icon.png",[dic objectForKey:@"payment_mode"]]];
        if (image==nil)
        {
              image= [UIImage imageNamed:@"paymentmode_icon.png"];
             [info setPaymentmode_icon:UIImageJPEGRepresentation(image, 1.0)];
        }else
        {
            [info setPaymentmode_icon:UIImageJPEGRepresentation(image, 1.0)];
        }
        
        [info setHide_status:[NSNumber numberWithInt:[[dic objectForKey:@"hide_status"] intValue]]];
        [info setToken_id:[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
        [info setTransaction_id:[[[dic objectForKey:@"transaction_id"] componentsSeparatedByString:@"_"] objectAtIndex:0]];
        NSNumber *number= [Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date];
        [info setServer_updation_date:number];
        [info setUpdation_date:[NSNumber numberWithLongLong:[number longLongValue]-10]];
        [[APP_DELEGATE managedObjectContext] save:&error];
    }
    
}

-(void)insetItemPayemtModeFromAllTransactionToServer:(NSDictionary*)dic
{
    NSError  *error;
    Paymentmode   *info = [NSEntityDescription insertNewObjectForEntityForName:@"Paymentmode" inManagedObjectContext:_managedObjectContext];
    
    [info setPaymentMode:[dic objectForKey:@"payment_mode"]];
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@ icon.png",[dic objectForKey:@"payment_mode"]]];
    if (image==nil)
    {
        image= [UIImage imageNamed:@"paymentmode_icon.png"];
        [info setPaymentmode_icon:UIImageJPEGRepresentation(image, 1.0)];
    }else
    {
        [info setPaymentmode_icon:UIImageJPEGRepresentation(image, 1.0)];
    }
    
    [info setHide_status:[NSNumber numberWithInt:[[dic objectForKey:@"hide_status"] intValue]]];
    [info setToken_id:[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    [info setTransaction_id:[[[dic objectForKey:@"transaction_id"] componentsSeparatedByString:@"_"] objectAtIndex:0]];
    NSNumber *number= [Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date];
    [info setServer_updation_date:number];
    [info setUpdation_date:[NSNumber numberWithLongLong:[number longLongValue]-10]];
    [[APP_DELEGATE managedObjectContext] save:&error];
    
}

-(void)editItemPayemtModeFromAllTransactionToServer:(NSDictionary*)dic
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Paymentmode"  inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"transaction_id = %@",[dic objectForKey:@"transaction_id"]];
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
        for (Paymentmode *info in fetchedRecords)
        {
            NSError  *error;
            [info setPaymentMode:[dic objectForKey:@"payment_mode"]];
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@ icon.png",[dic objectForKey:@"payment_mode"]]];
            if (image==nil)
            {
                image= [UIImage imageNamed:@"paymentmode_icon.png"];
                [info setPaymentmode_icon:UIImageJPEGRepresentation(image, 1.0)];
            }else
            {
                [info setPaymentmode_icon:UIImageJPEGRepresentation(image, 1.0)];
            }
            
            [info setHide_status:[NSNumber numberWithInt:[[dic objectForKey:@"hide_status"] intValue]]];
            [info setToken_id:[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
            [info setTransaction_id:[[[dic objectForKey:@"transaction_id"] componentsSeparatedByString:@"_"] objectAtIndex:0]];
            NSNumber *number= [Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date];
            [info setServer_updation_date:number];
            [info setUpdation_date:[NSNumber numberWithLongLong:[number longLongValue]-10]];
            [[APP_DELEGATE managedObjectContext] save:&error];
        }
    }else
    {
        [self insetItemPayemtModeFromAllTransactionToServer:dic];
    }
}

-(void)deleteItemPayemtModeFromAllTransactionToServer:(NSDictionary*)dic
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Paymentmode"  inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"transaction_id = %@",[dic objectForKey:@"transaction_id"]];
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
        for (Paymentmode *info in fetchedRecords)
        {
            [[TransactionHandler sharedCoreDataController] deletePaymentMode:info.paymentMode chekServerUpdation:YES];
            [[ReminderHandler sharedCoreDataController]  deletePaymentMode:info.paymentMode chekServerUpdation:YES];
            [[BudgetHandler sharedCoreDataController]  deletePaymentMode:info.paymentMode chekServerUpdation:YES];
            [[TransferHandler sharedCoreDataController] deletePaymentMode:info.paymentMode chekServerUpdation:YES];
            [[APP_DELEGATE managedObjectContext] deleteObject:info];
            [[APP_DELEGATE managedObjectContext] save:&error];
        }
    }
}


-(void)updateTokenId:(NSDictionary *)dictionary :(Paymentmode*)info
{
    NSError* error;
    [info setToken_id:[dictionary objectForKey:@"TokenId"]];
    [[APP_DELEGATE managedObjectContext] save:&error];
}



-(BOOL)updateItemPayemtMode:(NSDictionary *)dictionary :(Paymentmode*)info
{
    
    [[TransactionHandler sharedCoreDataController] updatePaymentMode:info.paymentMode :[dictionary objectForKey:@"paymentMode"]];
    [[ReminderHandler sharedCoreDataController] updatePaymentMode:info.paymentMode :[dictionary objectForKey:@"paymentMode"]];
    [[BudgetHandler sharedCoreDataController] updatePaymentMode:info.paymentMode :[dictionary objectForKey:@"paymentMode"]];
    [[TransferHandler sharedCoreDataController] updatePaymentMode:info.paymentMode :[dictionary objectForKey:@"paymentMode"]];
    
    [info setPaymentMode:[dictionary objectForKey:@"paymentMode"]];
    [info setHide_status:[dictionary objectForKey:@"hide_status"]];
    [info setUpdation_date:[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date]];
    NSError *error;
    [[APP_DELEGATE managedObjectContext] save:&error];
    return true;
}

-(BOOL)deletePaymentModeInfo:(Paymentmode*)info
{
    NSError *error;
    if (![info.token_id isEqualToString:@"0"])
    {
        [self insertDataIntoUpdateOnServerTransactionsTable:info];
    }
    [[APP_DELEGATE managedObjectContext] deleteObject:info];
    [[APP_DELEGATE managedObjectContext] save:&error];
    return YES;
}

@end
