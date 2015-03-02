//
//  TransferHandler.m
//  Daily Expense Manager
//
//  Created by Appbulous on 16/10/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import "TransferHandler.h"
#import "Transfer.h"
#import "TransactionHandler.h"
#import "UpdateOnServerTransactionsTable.h"
#import "PaymentmodeHandler.h"
#import "UserInfoHandler.h"
#import "Utility.h"
@implementation TransferHandler
{
    NSManagedObjectContext *_managedObjectContext;
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

+(TransferHandler *) sharedCoreDataController
{
    static TransferHandler *singletone=nil;
    if(!singletone)
    {
        singletone=[[TransferHandler alloc] init];
    }
    return singletone;
}


-(NSString*)insertDataIntorTransaferTable:(NSMutableDictionary*)dictionary
{
    NSError *error;
    Transfer   *info = [NSEntityDescription insertNewObjectForEntityForName:@"Transfer" inManagedObjectContext:_managedObjectContext];
    [info  setFromaccount:[dictionary objectForKey:@"fromaccount"]];
    [info  setToaccount:[dictionary objectForKey:@"toaccount"]];
    [info setAmount:[NSNumber numberWithDouble:[[dictionary objectForKey:@"amount"] doubleValue]]];
    [info setCategory:[dictionary objectForKey:@"category"]];
    [info setDate:[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date:[dictionary objectForKey:@"date"]]];
    [info setSub_category:[dictionary objectForKey:@"sub_category"]];
    [info setPaymentMode:[dictionary objectForKey:@"paymentMode"]];
    [info setDiscription:[dictionary objectForKey:@"description"]];
    [info setToken_id:[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
     NSNumber *numar= [Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date];
    [info setUpdation_date:numar];
    [info setIncome_transaction_id:[dictionary objectForKey:@"income_transaction_id"]];
    [info setExpense_transaction_id:[dictionary objectForKey:@"expense_transaction_id"]];
    [info setServer_updation_date:[NSNumber numberWithInt:0]];
    [info setTransaction_id:[numar stringValue]];
    [[APP_DELEGATE managedObjectContext] save:&error];
      NSLog(@"%@",info);
    return [numar stringValue];
}


-(void)insertDataToTransferTableFromServer:(NSDictionary*)responseObject
{
    NSArray *array=[responseObject objectForKey:@"data"];
    for (NSDictionary *dictionary in array)
    {
        NSError *error;
        
        Transfer   *info = [NSEntityDescription insertNewObjectForEntityForName:@"Transfer" inManagedObjectContext:_managedObjectContext];
        
        [info  setFromaccount:[dictionary objectForKey:@"usertoken_id_from"]];
        [info  setToaccount:[dictionary objectForKey:@"usertoken_id_to"]];
        [info setAmount:[NSNumber numberWithInt:[[dictionary objectForKey:@"price"] doubleValue]]];
        [info setCategory:[dictionary objectForKey:@"category"]];
        
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        
        [info setDate:[dictionary objectForKey:@"transaction_date"]];
        
        if ([dictionary objectForKey:@"sub_category"] == (id)[NSNull null])
        {
            [info setSub_category:@""];
            
        }else
            [info setSub_category:[dictionary objectForKey:@"sub_category"]];
        
        [info setPaymentMode:[dictionary objectForKey:@"payment_mode"]];
        [info setDiscription:[dictionary objectForKey:@"description"]];
        
        [info setToken_id:[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
        
        NSNumber *number= [Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date];
        
        [info setServer_updation_date:number];
        [info setUpdation_date:[NSNumber numberWithLongLong:[number longLongValue]-10]];
        [info setIncome_transaction_id:[f numberFromString:[[[dictionary objectForKey:@"income_id"] componentsSeparatedByString:@"_"] objectAtIndex:0]]];
        [info setExpense_transaction_id:[f numberFromString:[[[dictionary objectForKey:@"expense_id"] componentsSeparatedByString:@"_"] objectAtIndex:0]]];
        [info setTransaction_id:[[[dictionary objectForKey:@"transaction_id"] componentsSeparatedByString:@"_"] objectAtIndex:0]];
        
        [[APP_DELEGATE managedObjectContext] save:&error];
    }
}


-(void)insertDataToTransferTableFromAddedTransactionToServer:(NSDictionary*)dictionary
{
    NSError *error;
    
    Transfer   *info = [NSEntityDescription insertNewObjectForEntityForName:@"Transfer" inManagedObjectContext:_managedObjectContext];
    
    [info  setFromaccount:[dictionary objectForKey:@"usertoken_id_from"]];
    [info  setToaccount:[dictionary objectForKey:@"usertoken_id_to"]];
    [info setAmount:[NSNumber numberWithInt:[[dictionary objectForKey:@"price"] doubleValue]]];
    [info setCategory:[dictionary objectForKey:@"category"]];
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    
    [info setDate:[dictionary objectForKey:@"transaction_date"]];
    
    if ([dictionary objectForKey:@"sub_category"] == (id)[NSNull null])
    {
        [info setSub_category:@""];
        
    }else
        [info setSub_category:[dictionary objectForKey:@"sub_category"]];
    
    [info setPaymentMode:[dictionary objectForKey:@"payment_mode"]];
    [info setDiscription:[dictionary objectForKey:@"description"]];
    
    [info setToken_id:[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    
    NSNumber *number= [Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date];
    
    [info setServer_updation_date:number];
    [info setUpdation_date:[NSNumber numberWithLongLong:[number longLongValue]-10]];
    [info setIncome_transaction_id:[f numberFromString:[[[dictionary objectForKey:@"income_id"] componentsSeparatedByString:@"_"] objectAtIndex:0]]];
    [info setExpense_transaction_id:[f numberFromString:[[[dictionary objectForKey:@"expense_id"] componentsSeparatedByString:@"_"] objectAtIndex:0]]];
    [info setTransaction_id:[[[dictionary objectForKey:@"transaction_id"] componentsSeparatedByString:@"_"] objectAtIndex:0]];
    
    [[APP_DELEGATE managedObjectContext] save:&error];
}

-(void)deleteDataToTransferTableFromAddedTransactionToServer:(NSDictionary*)dictionary
{
   
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transfer" inManagedObjectContext:_managedObjectContext];
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
    for (Transfer *info in fetchedRecords)
    {
        [[APP_DELEGATE managedObjectContext] deleteObject:info];
        [[APP_DELEGATE managedObjectContext] save:&error];
    }
}


-(void)editDataToTransferTableFromAddedTransactionToServer:(NSDictionary*)dictionary
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transfer"  inManagedObjectContext:_managedObjectContext];
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
        for (Transfer *info in fetchedRecords)
        {
            NSError *error;
            [info  setFromaccount:[dictionary objectForKey:@"usertoken_id_from"]];
            [info  setToaccount:[dictionary objectForKey:@"usertoken_id_to"]];
            [info setAmount:[NSNumber numberWithInt:[[dictionary objectForKey:@"price"] doubleValue]]];
            [info setCategory:[dictionary objectForKey:@"category"]];
            
            NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
            [f setNumberStyle:NSNumberFormatterDecimalStyle];
            
            [info setDate:[dictionary objectForKey:@"transaction_date"]];
            
            if ([dictionary objectForKey:@"sub_category"] == (id)[NSNull null])
            {
                [info setSub_category:@""];
                
            }else
                [info setSub_category:[dictionary objectForKey:@"sub_category"]];
            
            [info setPaymentMode:[dictionary objectForKey:@"payment_mode"]];
            [info setDiscription:[dictionary objectForKey:@"description"]];
            
            [info setToken_id:[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
            
            NSNumber *number= [Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date];
            
            [info setServer_updation_date:number];
            [info setUpdation_date:[NSNumber numberWithLongLong:[number longLongValue]-10]];
            [info setIncome_transaction_id:[f numberFromString:[[[dictionary objectForKey:@"income_id"] componentsSeparatedByString:@"_"] objectAtIndex:0]]];
            [info setExpense_transaction_id:[f numberFromString:[[[dictionary objectForKey:@"expense_id"] componentsSeparatedByString:@"_"] objectAtIndex:0]]];
            [info setTransaction_id:[[[dictionary objectForKey:@"transaction_id"] componentsSeparatedByString:@"_"] objectAtIndex:0]];
            
            [[APP_DELEGATE managedObjectContext] save:&error];
        }
    }else
    {
        [self insertDataToTransferTableFromAddedTransactionToServer:dictionary];
    }
}


-(void)insertDataIntoTransaferTablefromEmport:(NSMutableDictionary*)dictionary
{
    NSError *error;
    Transfer   *info = [NSEntityDescription insertNewObjectForEntityForName:@"Transfer" inManagedObjectContext:_managedObjectContext];
    [info  setFromaccount:[dictionary objectForKey:@"fromaccount"]];
    [info  setToaccount:[dictionary objectForKey:@"toaccount"]];
    [info setAmount:[dictionary objectForKey:@"amount"]];
    [info setCategory:[dictionary objectForKey:@"category"]];
    [info setDate:[dictionary objectForKey:@"date"]];
    if ([[dictionary objectForKey:@"sub_category"] isEqualToString:@"null"])
    {
        [info setSub_category:@""];
    }else
    [info setSub_category:[dictionary objectForKey:@"sub_category"]];
    [info setPaymentMode:[dictionary objectForKey:@"paymentMode"]];
    [info setDiscription:[dictionary objectForKey:@"discription"]];
    [info setToken_id:[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    [info setUpdation_date:[dictionary objectForKey:@"updation_date"]];
    [info setIncome_transaction_id:[dictionary objectForKey:@"income_transaction_id"]];
    [info setExpense_transaction_id:[dictionary objectForKey:@"expense_transaction_id"]];
    [info setServer_updation_date:[dictionary objectForKey:@"server_updation_date"]];
    [info setTransaction_id:[dictionary objectForKey:@"transaction_id"]];
    [info setToaccount:[dictionary objectForKey:@"toaccount"]];
    [info setFromaccount:[dictionary objectForKey:@"fromaccount"]];
    [[APP_DELEGATE managedObjectContext] save:&error];
  }


-(NSString*)updateDataIntorTransferTable:(NSMutableDictionary*)dictionary :(Transfer*)info;
{
     NSError *error;
    [info  setFromaccount:[dictionary objectForKey:@"fromaccount"]];
    [info  setToaccount:[dictionary objectForKey:@"toaccount"]];
    [info setAmount:[NSNumber numberWithDouble:[[dictionary objectForKey:@"amount"] doubleValue]]];
    [info setCategory:[dictionary objectForKey:@"category"]];
    [info setDate:[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date:[dictionary objectForKey:@"date"]]];
    [info setSub_category:[dictionary objectForKey:@"sub_category"]];
    [info setPaymentMode:[dictionary objectForKey:@"paymentMode"]];
    [info setDiscription:[dictionary objectForKey:@"description"]];
    NSNumber *number= [Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date];
    [info setUpdation_date:number];
    [[APP_DELEGATE managedObjectContext] save:&error];
      NSLog(@"%@",info);
    return [number stringValue];
}

-(NSArray*)getTranferWithTransactionId:(NSString*)searchText
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transfer" inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate=   predicate =[NSPredicate predicateWithFormat:@"token_id = %@ AND transaction_id = %@",[Utility userDefaultsForKey:MAIN_TOKEN_ID],searchText];
    [fetchRequest setPredicate:predicate];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    // Returning Fetched Records
    return fetchedRecords;
}

-(NSArray*)getAllTransferForID:(NSString *)userTokenId :(NSDate*)startDate :(NSDate*)endDate :(NSString*)transaction_type :(NSString*)oderBy :(NSMutableArray*)categery :(NSMutableArray*)paymetnMode
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

-(NSArray*)getUserDetailsfromTransfer:(NSString*)searchText
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transfer" inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate;
    if ([searchText length]!=0)
    {
        predicate =[NSPredicate predicateWithFormat:@"token_id = %@ AND fromaccount = %@",[Utility userDefaultsForKey:MAIN_TOKEN_ID],searchText];
    }else
    {
        predicate =[NSPredicate predicateWithFormat:@"token_id = %@",[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    }
    NSArray *categery=[[CategoryListHandler sharedCoreDataController] getAllCategoryList];
    NSArray *paymetnMode=[[PaymentmodeHandler sharedCoreDataController] getAllPaymetModeListUnhide];
    NSPredicate *p1 =  [NSPredicate predicateWithFormat:@"category IN %@", categery];
    NSPredicate *p2 =  [NSPredicate predicateWithFormat:@"paymentMode IN %@", paymetnMode];
    NSArray *usetTokeArray=[[UserInfoHandler sharedCoreDataController] getUserNameListFromUserRegisterTable];
    NSPredicate *p3 =  [NSPredicate predicateWithFormat:@"fromaccount IN %@", usetTokeArray];
    NSPredicate *p4 =  [NSPredicate predicateWithFormat:@"toaccount IN %@", usetTokeArray];
    
    NSPredicate *newPredicate = [NSCompoundPredicate andPredicateWithSubpredicates: @[predicate,p1, p2,p3,p4]];
    [fetchRequest setPredicate:newPredicate];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    // Returning Fetched Records
    return fetchedRecords;
}


-(NSArray*)getUserDetailsfromTransferToTable:(NSString*)searchText
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transfer" inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate;
    if ([searchText length]!=0)
    {
        predicate =[NSPredicate predicateWithFormat:@"token_id = %@ AND toaccount = %@",[Utility userDefaultsForKey:MAIN_TOKEN_ID],searchText];
    }else
    {
        predicate =[NSPredicate predicateWithFormat:@"token_id = %@",[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    }
    NSArray *categery=[[CategoryListHandler sharedCoreDataController] getAllCategoryList];
    NSArray *paymetnMode=[[PaymentmodeHandler sharedCoreDataController] getAllPaymetModeListUnhide];
    NSPredicate *p1 =  [NSPredicate predicateWithFormat:@"category IN %@", categery];
    NSPredicate *p2 =  [NSPredicate predicateWithFormat:@"paymentMode IN %@", paymetnMode];
    NSArray *usetTokeArray=[[UserInfoHandler sharedCoreDataController] getUserNameListFromUserRegisterTable];
    NSPredicate *p3 =  [NSPredicate predicateWithFormat:@"fromaccount IN %@", usetTokeArray];
    NSPredicate *p4 =  [NSPredicate predicateWithFormat:@"toaccount IN %@", usetTokeArray];
    
    NSPredicate *newPredicate = [NSCompoundPredicate andPredicateWithSubpredicates: @[predicate,p1, p2,p3,p4]];
    [fetchRequest setPredicate:newPredicate];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    // Returning Fetched Records
    return fetchedRecords;
}




-(NSArray*)getAllTransfer
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transfer" inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"token_id = %@",[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    // Returning Fetched Records
    return fetchedRecords;
    
}

-(NSArray*)getAllTransferToUpdateOnServer
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transfer" inManagedObjectContext:_managedObjectContext];
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


-(NSArray*)getAllTransferToEditOnServer
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transfer" inManagedObjectContext:_managedObjectContext];
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


-(NSArray*)getcabName
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Dem_cab" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    [fetchRequest setResultType:NSDictionaryResultType];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    // Returning Fetched Records
    return fetchedRecords;
}



-(void)deleteCategeroyList:(NSString *)categery chekServerUpdation:(BOOL)chek
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transfer" inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"category = %@ AND token_id = %@ ",categery,[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    // Returning Fetched Records
    for (Transfer *info in fetchedRecords)
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transfer" inManagedObjectContext:_managedObjectContext];
     NSPredicate *predicate =[NSPredicate predicateWithFormat:@"paymentMode = %@ AND token_id = %@ ",paymetMode,[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    [fetchRequest setPredicate:predicate];
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transfer" inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"paymentMode = %@ AND token_id = %@ ",paymetMode,[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    // Returning Fetched Records
    for (Transfer *info in fetchedRecords)
    {
        if (![info.token_id isEqualToString:@"0"] && !chek)
        {
           [self insertDataIntoUpdateOnServerTransactionsTable:info];
        }
        [[APP_DELEGATE managedObjectContext] deleteObject:info];
        [[APP_DELEGATE managedObjectContext] save:&error];
    }
}


-(void)insertDataIntoUpdateOnServerTransactionsTable:(Transfer*)newInfo
{
    NSError *error;
    UpdateOnServerTransactionsTable   *info = [NSEntityDescription insertNewObjectForEntityForName:@"UpdateOnServerTransactionsTable" inManagedObjectContext:_managedObjectContext];
    [info setTransaction_id:newInfo.transaction_id];
    [info setUser_token_id:newInfo.fromaccount];
    [info setTransaction_type:[NSNumber numberWithInt:TYPE_TRANSFER]];
    [[APP_DELEGATE managedObjectContext] save:&error];
}


-(BOOL)deleteTransefer:(Transfer*)info
{
    NSError *error;
    NSArray *expensearray =[[TransactionHandler sharedCoreDataController] getTransactionWithTransactionId:[info.expense_transaction_id stringValue] :info.fromaccount];
    NSArray *incomarray =[[TransactionHandler sharedCoreDataController] getTransactionWithTransactionId:[info.income_transaction_id stringValue] :info.toaccount];
    if ([expensearray count]!=0)
    {
         [[TransactionHandler sharedCoreDataController] deleteTransaction:[expensearray objectAtIndex:0]];
    }
    if ([incomarray count]!=0)
    {
         [[TransactionHandler sharedCoreDataController] deleteTransaction:[incomarray objectAtIndex:0]];
    }
    
    if (![info.token_id isEqualToString:@"0"])
    {
        [self insertDataIntoUpdateOnServerTransactionsTable:info];
    }
    
    [[APP_DELEGATE managedObjectContext] deleteObject:info];
    [[APP_DELEGATE managedObjectContext] save:&error];
    return YES;
}

-(void)updateTokenId:(NSDictionary*)dictionary :(Transfer*)info
{
    NSError* error;
    [info setToken_id:[dictionary objectForKey:@"TokenId"]];
    if ([info.fromaccount isEqualToString:[dictionary objectForKey:[Utility userDefaultsForKey:CURRENT_TOKEN_ID]]])
    {
        [info setToken_id:[dictionary objectForKey:@"TokenId"]];
        [info setFromaccount:[dictionary objectForKey:@"AccountId"]];
    }else
    {
        [info setToken_id:[dictionary objectForKey:@"TokenId"]];
         NSString *string=[[info.fromaccount  componentsSeparatedByString:@"_"] objectAtIndex:1];
        [info setFromaccount:[NSString stringWithFormat:@"%@_%@",[dictionary objectForKey:@"TokenId"],string]];
        
    }
    if ([info.toaccount isEqualToString:[dictionary objectForKey:[Utility userDefaultsForKey:CURRENT_TOKEN_ID]]])
    {
        [info setToken_id:[dictionary objectForKey:@"TokenId"]];
        [info setToaccount:[dictionary objectForKey:@"AccountId"]];
    }else
    {
        [info setToken_id:[dictionary objectForKey:@"TokenId"]];
        NSString *string=[[info.fromaccount  componentsSeparatedByString:@"_"] objectAtIndex:1];
        [info setToaccount:[NSString stringWithFormat:@"%@_%@",[dictionary objectForKey:@"TokenId"],string]];
    }
    //[info set:[dictionary objectForKey:@"AccountId"]];
    [[APP_DELEGATE managedObjectContext] save:&error];
    
    
    
}

-(void)updateCategeroyToCategery:(NSString*)fromCategery :(NSString*)toCategery
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transfer"
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
    for (Transfer *info in fetchedRecords)
    {
        [info setCategory:toCategery];
        [info setUpdation_date:[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date]];
        [[APP_DELEGATE managedObjectContext] save:&error];
    }
}


-(void)updateServerUpdationDate:(NSString*)data
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transfer"  inManagedObjectContext:_managedObjectContext];
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
    for (Transfer *info in fetchedRecords)
    {
        NSNumber *number= [Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date];
        [info setServer_updation_date:number];
        [info setUpdation_date:[NSNumber numberWithLongLong:[number longLongValue]-10]];
        [[APP_DELEGATE managedObjectContext] save:&error];
    }
}


-(void)updateCategeroySubCategryToCategery:(NSString*)fromCategery :(NSString*)toCategery
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transfer" inManagedObjectContext:_managedObjectContext];
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
    for (Transfer *info in fetchedRecords)
    {
        [info setCategory:toCategery];
        [info setUpdation_date:[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date]];
        [[APP_DELEGATE managedObjectContext] save:&error];
    }
}


-(void)updateUserToken:(NSString*)fromAccount :(NSString*)ToAccount
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transfer"  inManagedObjectContext:_managedObjectContext];
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


-(void)updateSubCategry:(NSString*)fromSubCategery :(NSString*)toSubCategery
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
     NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transfer"  inManagedObjectContext:_managedObjectContext];
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


-(void)updateCategeroySubCategryToCategerysubcategery:(NSString*)fromCategery :(CategoryList*)toCategery
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transfer"  inManagedObjectContext:_managedObjectContext];
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
    for (Transfer *info in fetchedRecords)
    {
        [info setCategory:toCategery.category];
        [info setSub_category:toCategery.sub_category];
          [info setUpdation_date:[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date]];
        [[APP_DELEGATE managedObjectContext] save:&error];
    }
    
}

@end
