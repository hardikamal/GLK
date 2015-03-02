//
//  BudgetHandler.m
//  Daily Expense Manager
//
//  Created by Appbulous on 29/09/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import "BudgetHandler.h"
#import "Budget.h"
#import "TransactionHandler.h"
#import "CategoryListHandler.h"
#import "PaymentmodeHandler.h"
#import "UpdateOnServerTransactionsTable.h"
#import "UserInfoHandler.h"
#import "AppDelegate.h"
#import "Utility.h"
@implementation BudgetHandler
{
    NSManagedObjectContext *_managedObjectContext;
    NSString  *heello;
}

-(id) init
{
    self = [super init];
    if(self)
    {
        
        _managedObjectContext = [[AppDelegate getAppDelegate] managedObjectContext];
    }
    return self;
}

+(BudgetHandler *) sharedCoreDataController
{
    static BudgetHandler *singletone=nil;
    if(!singletone)
    {
        singletone=[[BudgetHandler alloc] init];
    }
    return singletone;
}


-(NSArray*)getAllBudgetForID:(NSString *)userTokenId :(NSDate*)startDate :(NSDate*)endDate :(NSString*)transaction_type :(NSString*)oderBy :(NSMutableArray*)categery :(NSMutableArray*)paymetnMode
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


-(BOOL)insertDataIntoBudgetTable:(NSMutableDictionary*)dictionary
{
    NSError *error;
    Budget   *info = [NSEntityDescription insertNewObjectForEntityForName:@"Budget" inManagedObjectContext:_managedObjectContext];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSDate *date = [formatter dateFromString:[dictionary objectForKey:@"fromDate"]];
    long long milliseconds = (long long)([date timeIntervalSince1970] * 1000.0);
    [info  setFromdate:[NSNumber numberWithUnsignedLongLong:milliseconds]];
    date = [formatter dateFromString:[dictionary objectForKey:@"toDate"]];
    milliseconds = (long long)([date timeIntervalSince1970] * 1000.0);
    [info  setTodate:[NSNumber numberWithUnsignedLongLong:milliseconds]];
    
    [info setAmount:[NSNumber numberWithDouble:[[dictionary objectForKey:@"amount"] doubleValue]]];
    [info setCategory:[dictionary objectForKey:@"category"]];
    [info setSub_category:[dictionary objectForKey:@"sub_category"]];
    [info setPaymentMode:[dictionary objectForKey:@"paymentMode"]];
    [info setDiscription:[dictionary objectForKey:@"description"]];
    [info setShow_on_homescreen:[dictionary objectForKey:@"Shown_on_homescreen"]];
    [info setToken_id:[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    [info setUser_token_id:[dictionary objectForKey:@"user_token_id"]];
    [info setUpdation_date:[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date]];
    [info setTransaction_id:[[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date] stringValue]];
    [info setServer_updation_date:[NSNumber numberWithInt:0]];
    [[[AppDelegate getAppDelegate] managedObjectContext] save:&error];
    return YES;
}


-(void)insertDataIntoBudgetFromServer:(NSDictionary*)responseObject
{
    NSArray *array=[responseObject objectForKey:@"data"];
    for (NSDictionary *dictionary in array)
    {
        NSError *error;
        Budget   *info = [NSEntityDescription insertNewObjectForEntityForName:@"Budget" inManagedObjectContext:_managedObjectContext];
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        
        [info  setFromdate:[dictionary objectForKey:@"budget_date_from"]];
        [info  setTodate:[dictionary objectForKey:@"budget_date_to"]];
        [info setAmount:[NSNumber numberWithInt:[[dictionary objectForKey:@"price"] doubleValue]]];
        [info setCategory:[dictionary objectForKey:@"category"]];
        
        if ([dictionary objectForKey:@"sub_category"] == (id)[NSNull null])
        {
            [info setSub_category:@""];
        }else
            [info setSub_category:[dictionary objectForKey:@"sub_category"]];
        
        [info setPaymentMode:[dictionary objectForKey:@"payment_mode"]];
        [info setDiscription:[dictionary objectForKey:@"description"]];
        [info setShow_on_homescreen:[NSNumber numberWithInt:[[dictionary objectForKey:@"isRead"] intValue]]];
        [info setToken_id:[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
        [info setUser_token_id:[dictionary objectForKey:@"account_id"]];
        [info setUpdation_date:[dictionary objectForKey:@"updation_date"]];
        [info setTransaction_id:[[[dictionary objectForKey:@"transaction_id"] componentsSeparatedByString:@"_"] objectAtIndex:0]];
         NSNumber *number= [Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date];
        [info setServer_updation_date:number];
        [info setUpdation_date:[NSNumber numberWithLongLong:[number longLongValue]-10]];
        [[[AppDelegate getAppDelegate] managedObjectContext] save:&error];
    }
}


-(void)insertDataIntoBudgetFromAddedTransactionToServer:(NSDictionary*)dictionary
{
    NSError *error;
    Budget   *info = [NSEntityDescription insertNewObjectForEntityForName:@"Budget" inManagedObjectContext:_managedObjectContext];
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    
    [info  setFromdate:[dictionary objectForKey:@"budget_date_from"]];
    [info  setTodate:[dictionary objectForKey:@"budget_date_to"]];
    [info setAmount:[NSNumber numberWithInt:[[dictionary objectForKey:@"price"] doubleValue]]];
    [info setCategory:[dictionary objectForKey:@"category"]];
    
    if ([dictionary objectForKey:@"sub_category"] == (id)[NSNull null])
    {
        [info setSub_category:@""];
    }else
        [info setSub_category:[dictionary objectForKey:@"sub_category"]];
    
    [info setPaymentMode:[dictionary objectForKey:@"payment_mode"]];
    [info setDiscription:[dictionary objectForKey:@"description"]];
    [info setShow_on_homescreen:[NSNumber numberWithInt:[[dictionary objectForKey:@"isRead"] intValue]]];
    [info setToken_id:[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    [info setUser_token_id:[dictionary objectForKey:@"account_id"]];
    [info setUpdation_date:[dictionary objectForKey:@"updation_date"]];
    [info setTransaction_id:[[[dictionary objectForKey:@"transaction_id"] componentsSeparatedByString:@"_"] objectAtIndex:0]];
    NSNumber *number= [Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date];
    [info setServer_updation_date:number];
    [info setUpdation_date:[NSNumber numberWithLongLong:[number longLongValue]-10]];
    NSLog(@"%@",info);
    [[[AppDelegate getAppDelegate] managedObjectContext] save:&error];
}



-(void)deleteDataIntoBudgetFromAddedTransactionToServer:(NSDictionary*)dictionary
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Budget" inManagedObjectContext:_managedObjectContext];
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
    for (Budget *info in fetchedRecords)
    {
        [[[AppDelegate getAppDelegate] managedObjectContext] deleteObject:info];
        [[[AppDelegate getAppDelegate] managedObjectContext] save:&error];
    }
}


-(void)editDataIntoBudgetFromAddedTransactionToServer:(NSDictionary*)dictionary
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Budget"  inManagedObjectContext:_managedObjectContext];
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
        for (Budget *info in fetchedRecords)
        {
            NSError *error;
            NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
            [f setNumberStyle:NSNumberFormatterDecimalStyle];
            
            [info  setFromdate:[dictionary objectForKey:@"budget_date_from"]];
            [info  setTodate:[dictionary objectForKey:@"budget_date_to"]];
            [info setAmount:[NSNumber numberWithInt:[[dictionary objectForKey:@"price"] doubleValue]]];
            [info setCategory:[dictionary objectForKey:@"category"]];
            
            if ([dictionary objectForKey:@"sub_category"] == (id)[NSNull null])
            {
                [info setSub_category:@""];
            }else
                [info setSub_category:[dictionary objectForKey:@"sub_category"]];
            
            [info setPaymentMode:[dictionary objectForKey:@"paymentMode"]];
            [info setDiscription:[dictionary objectForKey:@"description"]];
            [info setShow_on_homescreen:[NSNumber numberWithInt:[[dictionary objectForKey:@"isRead"] intValue]]];
            [info setToken_id:[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
            [info setUser_token_id:[dictionary objectForKey:@"account_id"]];
            [info setUpdation_date:[dictionary objectForKey:@"updation_date"]];
            [info setTransaction_id:[[[dictionary objectForKey:@"transaction_id"] componentsSeparatedByString:@"_"] objectAtIndex:0]];
            NSNumber *number= [Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date];
            [info setServer_updation_date:number];
            [info setUpdation_date:[NSNumber numberWithLongLong:[number longLongValue]-10]];
            [[[AppDelegate getAppDelegate] managedObjectContext] save:&error];
        }
    }else
    {
        [self insertDataIntoBudgetFromAddedTransactionToServer:dictionary];
    }
  
}



-(BOOL)insertDataIntoBudgetFromImport:(NSMutableDictionary*)dictionary
{
    NSError *error;
    Budget   *info = [NSEntityDescription insertNewObjectForEntityForName:@"Budget" inManagedObjectContext:_managedObjectContext];
    [info  setFromdate:[dictionary objectForKey:@"fromdate"]];
    [info  setTodate:[dictionary objectForKey:@"todate"]];
    [info setAmount:[dictionary objectForKey:@"amount"]];
    [info setCategory:[dictionary objectForKey:@"category"]];
    if ([[dictionary objectForKey:@"sub_category"] isEqualToString:@"null"])
    {
        [info setSub_category:@""];
    }else
        [info setSub_category:[dictionary objectForKey:@"sub_category"]];
    [info setSub_category:[dictionary objectForKey:@"sub_category"]];
    [info setPaymentMode:[dictionary objectForKey:@"paymentMode"]];
    [info setDiscription:[dictionary objectForKey:@"discription"]];
    [info setShow_on_homescreen:[dictionary objectForKey:@"show_on_homescreen"]];
    [info setToken_id:[dictionary objectForKey:@"token_id"]];
    [info setUser_token_id:[dictionary objectForKey:@"user_token_id"]];
    [info setUpdation_date:[dictionary objectForKey:@"updation_date"]];
    [info setTransaction_id:[dictionary objectForKey:@"transaction_id"]];
    [info setServer_updation_date:[dictionary objectForKey:@"server_updation_date"]];
    
    NSLog(@"%@",info);
    
    [[[AppDelegate getAppDelegate] managedObjectContext] save:&error];
    return YES;
}

-(NSArray *)getAllBudget
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Budget" inManagedObjectContext:_managedObjectContext];
    NSPredicate * predicate =[NSPredicate predicateWithFormat:@"token_id = %@",[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Budget"  inManagedObjectContext:_managedObjectContext];
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
    for (Budget *info in fetchedRecords)
    {
        NSNumber *number= [Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date];
        [info setServer_updation_date:number];
        [info setUpdation_date:[NSNumber numberWithLongLong:[number longLongValue]-10]];
        [[[AppDelegate getAppDelegate] managedObjectContext] save:&error];
    }
}


-(NSArray*)getAllBudgetToUpdateOnServer
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
     //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Budget" inManagedObjectContext:_managedObjectContext];
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



-(NSArray*)getAllBudgetToEditOnServer
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Budget" inManagedObjectContext:_managedObjectContext];
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
-(NSArray *)getAllBudget:(NSString*)searchText
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Budget" inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate ;
      if ([searchText length]!=0)
    {
        predicate =[NSPredicate predicateWithFormat:@"user_token_id = %@ AND token_id = %@",searchText,[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    }else
    {
        predicate =[NSPredicate predicateWithFormat:@"token_id = %@",[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    }
    
    NSMutableArray *categery=[[CategoryListHandler sharedCoreDataController] getAllCategoryList];
      [categery addObject:NSLocalizedString(@"all", nil)];
    NSMutableArray *paymetnMode=[[PaymentmodeHandler sharedCoreDataController] getAllPaymetModeListUnhide];
      [paymetnMode addObject:NSLocalizedString(@"all", nil)];
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

-(NSArray *)getAllBudgetOnHomeScereeen:(NSString*)searchText
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Budget" inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate ;
    if ([searchText length]!=0)
    {
        predicate =[NSPredicate predicateWithFormat:@"user_token_id = %@ AND token_id = %@ AND show_on_homescreen = %@",searchText,[Utility userDefaultsForKey:MAIN_TOKEN_ID],@"0"];
    }else
    {
        predicate =[NSPredicate predicateWithFormat:@"token_id = %@ AND show_on_homescreen = %@",[Utility userDefaultsForKey:MAIN_TOKEN_ID],@"0"];
    }
    
    NSMutableArray *categery=[[CategoryListHandler sharedCoreDataController] getAllCategoryList];
    [categery addObject:NSLocalizedString(@"all", nil)];
    NSMutableArray *paymetnMode=[[PaymentmodeHandler sharedCoreDataController] getAllPaymetModeListUnhide];
    [paymetnMode addObject:NSLocalizedString(@"all", nil)];
    
    NSPredicate *p1 =  [NSPredicate predicateWithFormat:@"category IN %@", categery];
    NSPredicate *p2 =  [NSPredicate predicateWithFormat:@"paymentMode IN %@", paymetnMode];
    
    NSArray *usetTokeArray=[[UserInfoHandler sharedCoreDataController] getUserNameListFromUserRegisterTable];
    NSPredicate *p3 =  [NSPredicate predicateWithFormat:@"user_token_id IN %@", usetTokeArray];
    NSPredicate *newPredicate = [NSCompoundPredicate andPredicateWithSubpredicates: @[predicate,p1, p2,p3]];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"todate" ascending:NO]];
    [fetchRequest setFetchLimit:5];
    [fetchRequest setPredicate:newPredicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *array=[[NSMutableArray alloc] init];
    double value=0.0;
    for ( Budget *transaction in fetchedRecords)
    {
       value=[[TransactionHandler sharedCoreDataController] getTotalExpenseForAllAccountswithCategryAndPaymentMode:transaction.category :transaction.paymentMode :transaction.user_token_id :transaction.sub_category :transaction.fromdate :transaction.todate];
        if ( [transaction.amount doubleValue] < value)
        {
            [array addObject:transaction];
        }
    }
    // Returning Fetched Records
    return array;
}

-(BOOL)updateDataIntoTransactionTable:(NSMutableDictionary*)dictionary :(Budget*)info;
{
    NSError *error;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSDate *date = [formatter dateFromString:[dictionary objectForKey:@"fromDate"]];
    long long milliseconds = (long long)([date timeIntervalSince1970] * 1000.0);
    [info  setFromdate:[NSNumber numberWithUnsignedLongLong:milliseconds]];
    date = [formatter dateFromString:[dictionary objectForKey:@"toDate"]];
    milliseconds = (long long)([date timeIntervalSince1970] * 1000.0);
    [info  setTodate:[NSNumber numberWithUnsignedLongLong:milliseconds]];
    [info setUser_token_id:[dictionary objectForKey:@"user_token_id"]];
    [info setAmount:[NSNumber numberWithDouble:[[dictionary objectForKey:@"amount"] doubleValue]]];
    [info setCategory:[dictionary objectForKey:@"category"]];
    [info setSub_category:[dictionary objectForKey:@"sub_category"]];
    [info setPaymentMode:[dictionary objectForKey:@"paymentMode"]];
    [info setDiscription:[dictionary objectForKey:@"description"]];
    [info setUpdation_date:[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date]];
    [[[AppDelegate getAppDelegate] managedObjectContext] save:&error];
      NSLog(@"%@",info);
    return YES;
}

-(void)deleteCategeroyList:(NSString *)categery chekServerUpdation:(BOOL)chek
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Budget" inManagedObjectContext:_managedObjectContext];
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
    for (Budget *info in fetchedRecords)
    {
        if (![info.token_id isEqualToString:@"0"] && !chek)
        {
            [self insertDataIntoUpdateOnServerTransactionsTable:info];
        }
        [[[AppDelegate getAppDelegate] managedObjectContext] deleteObject:info];
        [[[AppDelegate getAppDelegate] managedObjectContext] save:&error];
    }
}
-(void)insertDataIntoUpdateOnServerTransactionsTable:(Budget*)newInfo
{
    NSError *error;
    UpdateOnServerTransactionsTable   *info = [NSEntityDescription insertNewObjectForEntityForName:@"UpdateOnServerTransactionsTable" inManagedObjectContext:_managedObjectContext];
    [info setTransaction_id:newInfo.transaction_id];
    [info setUser_token_id:newInfo.user_token_id];
    [info setTransaction_type:[NSNumber numberWithInt:TYPE_BUDGET]];
    [[[AppDelegate getAppDelegate] managedObjectContext] save:&error];
}



-(void)updatePaymentMode:(NSString*)paymetMode :(NSString*)toPaymetMode
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Budget" inManagedObjectContext:_managedObjectContext];

    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"paymentMode = %@",paymetMode];
    NSPredicate *p1 =  [NSPredicate predicateWithFormat:@"token_id = %@",[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    NSPredicate *newPredicate = [NSCompoundPredicate andPredicateWithSubpredicates: @[predicate,p1]];
    //Setting Entity to be Queried
    [fetchRequest setPredicate:newPredicate];
    
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
        [[[AppDelegate getAppDelegate] managedObjectContext] save:&error];
    }
}

-(void)deletePaymentMode:(NSString *)paymetMode chekServerUpdation:(BOOL)chek
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Budget" inManagedObjectContext:_managedObjectContext];
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
    for (Budget *info in fetchedRecords)
    {
        if (![info.token_id isEqualToString:@"0"] && !chek)
        {
            [self insertDataIntoUpdateOnServerTransactionsTable:info];
        }
        [[[AppDelegate getAppDelegate] managedObjectContext] deleteObject:info];
        [[[AppDelegate getAppDelegate] managedObjectContext] save:&error];
    }
}


-(double )getBudget:(NSString *)categary andSearchText:(NSString*)paymentMode;
{
   
    return 0;
}

-(BOOL)deleteBudget:(Budget*)info
{
      NSError *error;
    if (![info.token_id isEqualToString:@"0"])
    {
        [self insertDataIntoUpdateOnServerTransactionsTable:info];
    }
     [[[AppDelegate getAppDelegate] managedObjectContext] deleteObject:info];
     [[[AppDelegate getAppDelegate] managedObjectContext] save:&error];
     return YES;
}

-(void)updateBudget:(Budget*)info
{
    NSError *error;
    [info setShow_on_homescreen:[NSNumber numberWithInt:1]];
    NSNumber *number= [Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date];
    [info setServer_updation_date:number];
    [info setUpdation_date:[NSNumber numberWithLongLong:[number longLongValue]-10]];
    [[[AppDelegate getAppDelegate] managedObjectContext] save:&error];
}

-(void)updateTokenId:(NSDictionary*)dictionary :(Budget*)info
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
    
    [[[AppDelegate getAppDelegate] managedObjectContext] save:&error];
    
}



-(void)updateCategeroyToCategery:(NSString*)fromCategery :(NSString*)toCategery
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Budget"
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
    for (Budget *info in fetchedRecords)
    {
        [info setCategory:toCategery];
        [info setUpdation_date:[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date]];
        [[[AppDelegate getAppDelegate] managedObjectContext] save:&error];
    }
}


-(void)updateCategeroySubCategryToCategery:(NSString*)fromCategery :(NSString*)toCategery
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Budget" inManagedObjectContext:_managedObjectContext];
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
    for (Budget *info in fetchedRecords)
    {
        [info setCategory:toCategery];
        [info setUpdation_date:[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date]];
        [[[AppDelegate getAppDelegate] managedObjectContext] save:&error];
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
        [[[AppDelegate getAppDelegate] managedObjectContext] save:&error];
    }
}


-(void)updateSubCategry:(NSString*)fromSubCategery :(NSString*)toSubCategery
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Budget"  inManagedObjectContext:_managedObjectContext];
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
        [[[AppDelegate getAppDelegate] managedObjectContext] save:&error];
    }
}



-(void)updateCategeroySubCategryToCategerysubcategery:(NSString*)fromCategery :(CategoryList*)toCategery
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Budget"  inManagedObjectContext:_managedObjectContext];
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
    for (Budget *info in fetchedRecords)
    {
        [info setCategory:toCategery.category];
        [info setSub_category:toCategery.sub_category];
         [info setUpdation_date:[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date]];
        [[[AppDelegate getAppDelegate] managedObjectContext] save:&error];
    }
    
}

@end
