//
//  CategoryListHandler.m
//  Daily Expense Manager
//
//  Created by Appbulous on 02/09/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import "CategoryListHandler.h"
#import "CategoryList.h"
#import "UpdateOnServerTransactionsTable.h"
#import "TransactionHandler.h"
#import "ReminderHandler.h"
#import "TransferHandler.h"
#import "BudgetHandler.h"
#import "Utility.h"

@implementation CategoryListHandler
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


+(CategoryListHandler *) sharedCoreDataController
{
    static CategoryListHandler *singletone=nil;
    if(!singletone)
    {
        singletone=[[CategoryListHandler alloc] init];
    }
    return singletone;
}


-(void)addDefaultCategoryList:(NSString *)expenses :(NSString *)income
{
    NSArray *expensesArrray=[expenses componentsSeparatedByString:@"."];
    for (NSString *fitststring in expensesArrray)
    {
        NSArray *newArray=[fitststring componentsSeparatedByString:@" -"];
        [self saveDefaultDataInCateGoryList:[[newArray objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] :@"" :[NSNumber numberWithInt:0]];
        if ([newArray count]==2)
        {
            NSString *subCategery=[newArray objectAtIndex:1];
            NSArray *subCategeryArray=[subCategery componentsSeparatedByString:@","];
            for (NSString *string in subCategeryArray)
            {
                [self saveDefaultDataInCateGoryList:[[newArray objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]  :string :[NSNumber numberWithInt:0]];
            }
        }
    }
    NSArray *incomeArrray=[income componentsSeparatedByString:@"."];
    for (NSString *fitststring in incomeArrray)
    {
        NSArray *newArray=[fitststring componentsSeparatedByString:@" -"];
         [self saveDefaultDataInCateGoryList:[[newArray objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] :@"" :[NSNumber numberWithInt:1]];
        if ([newArray count]==2)
        {
            NSString *subCategery=[newArray objectAtIndex:1];
            NSArray *subCategeryArray=[subCategery componentsSeparatedByString:@","];
            for (NSString *string in subCategeryArray)
            {
                [self saveDefaultDataInCateGoryList:[[newArray objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]  :string :[NSNumber numberWithInt:1]];
            }
        }
    }
}



-(void)updateServerUpdationDate:(NSString*)data
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CategoryList"  inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"transaction_id = %@",data];
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
    for (CategoryList *info in fetchedRecords)
    {
        NSNumber *number= [Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date];
        [info setServer_updation_date:number];
        [info setUpdation_date:[NSNumber numberWithLongLong:[number longLongValue]-10]];
        [[APP_DELEGATE managedObjectContext] save:&error];
    }
}


-(void)saveDefaultDataInCateGoryList:(NSString*)categery :(NSString*)subCatgery :(NSNumber*)number
{
    NSError  *error;
    CategoryList   *info = [NSEntityDescription insertNewObjectForEntityForName:@"CategoryList" inManagedObjectContext:_managedObjectContext];
    [info setSub_category:TRIM(subCatgery)];
    NSString *trimmed=TRIM(categery);
    [info setCategory:trimmed];
    UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:@"%@_icon.png",trimmed]];
                    //[ stringByReplacingOccurrencesOfString:@"/" withString:@" "]];
    NSData *data=UIImageJPEGRepresentation(image, 1.0);
    if ([data length]==0)
    {
        if ([categery isEqualToString:NSLocalizedString(@"BooksStationary", nil)])
        {
         data=UIImageJPEGRepresentation([UIImage imageNamed:@"Books Stationary_icon.png"], 1.0);
        }else
           data=UIImageJPEGRepresentation([UIImage imageNamed:@"Miscellaneous_icon.png"], 1.0);
    }
    [info setCategory_icon:data];
    [info setClass_type:number];
    [info setHide_status:[NSNumber numberWithInt:0]];
    [info setToken_id:[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    [info setUpdation_date:[self getGMT_MillisFromYYYY_MM_DD_HH_SS_Date]];
    [info setTransaction_id:[[self getGMT_MillisFromYYYY_MM_DD_HH_SS_Date] stringValue]];
    [info setServer_updation_date:[NSNumber numberWithInt:0]];
     NSLog(@"%@",info);
    [[APP_DELEGATE managedObjectContext] save:&error];
}

-(void)insertCateGoryListFromAddedTransactionToServer:(NSDictionary*)dic
{
    NSError  *error;
    CategoryList   *info = [NSEntityDescription insertNewObjectForEntityForName:@"CategoryList" inManagedObjectContext:_managedObjectContext];
    if (![[dic objectForKey:@"sub_category"] isEqualToString:@"null"])
    {
        [info setSub_category:[dic objectForKey:@"sub_category"]];
    }else
        [info setSub_category:@""];
    
    [info setCategory:[dic objectForKey:@"category"]];
    if([[dic objectForKey:@"attachments"] length]!=0)
    {
        NSURL *url = [NSURL URLWithString:[dic objectForKey:@"attachments"]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        [info setCategory_icon:data];
    }
    [info setClass_type:[NSNumber numberWithInt:[[dic objectForKey:@"transaction_type"] intValue]]];
    [info setHide_status:[NSNumber numberWithInt:[[dic objectForKey:@"hide_status"] intValue]]];
    [info setToken_id:[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    [info setTransaction_id:[[[dic objectForKey:@"transaction_id"] componentsSeparatedByString:@"_"] objectAtIndex:0]];
    NSNumber *number= [Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date];
    [info setServer_updation_date:number];
    [info setUpdation_date:[NSNumber numberWithLongLong:[number longLongValue]-10]];
    [[APP_DELEGATE managedObjectContext] save:&error];

}

-(void)deleteCateGoryListFromAddedTransactionToServer:(NSDictionary*)dic
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CategoryList"  inManagedObjectContext:_managedObjectContext];
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
        if (![[dic objectForKey:@"boolean"] boolValue])
        {
           CategoryList *info =[fetchedRecords objectAtIndex:0];
           NSArray *categeryLists=[[CategoryListHandler sharedCoreDataController]getCategeryAttributeName: @"category = %@" andSearchText:info.category];
            for (CategoryList *list in categeryLists)
            {
                [[TransactionHandler sharedCoreDataController] deleteCategeroyList:list.category chekServerUpdation:YES];
                [[ReminderHandler sharedCoreDataController] deleteCategeroyList:list.category chekServerUpdation:YES];
                [[BudgetHandler sharedCoreDataController]  deleteCategeroyList:list.category chekServerUpdation:YES];
                [[TransferHandler sharedCoreDataController] deleteCategeroyList:list.category chekServerUpdation:YES];
                [[APP_DELEGATE managedObjectContext] deleteObject:list];
                [[APP_DELEGATE managedObjectContext] save:&error];
            }
        }else
        {
            for (CategoryList *list in fetchedRecords)
            {
                [[TransactionHandler sharedCoreDataController] deleteCategeroyList:list.category chekServerUpdation:YES];
                [[ReminderHandler sharedCoreDataController] deleteCategeroyList:list.category chekServerUpdation:YES];
                [[BudgetHandler sharedCoreDataController]  deleteCategeroyList:list.category chekServerUpdation:YES];
                [[TransferHandler sharedCoreDataController] deleteCategeroyList:list.category chekServerUpdation:YES];
                [[APP_DELEGATE managedObjectContext] deleteObject:list];
                [[APP_DELEGATE managedObjectContext] save:&error];
            }
        }
    }
}

-(void)editCateGoryListFromAddedTransactionToServer:(NSDictionary*)dic
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CategoryList"  inManagedObjectContext:_managedObjectContext];
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
    // Returning Fetched Records
    if ([fetchedRecords count]!=0)
    {
        for (CategoryList *info in fetchedRecords)
        {
            NSError  *error;
            if (![[dic objectForKey:@"sub_category"] isEqualToString:@"null"])
            {
                [info setSub_category:[dic objectForKey:@"sub_category"]];
            }else
                [info setSub_category:@""];
            
            [info setCategory:[dic objectForKey:@"category"]];
            if([[dic objectForKey:@"attachments"] length]!=0)
            {
                NSURL *url = [NSURL URLWithString:[dic objectForKey:@"attachments"]];
                NSData *data = [NSData dataWithContentsOfURL:url];
                [info setCategory_icon:data];
            }
            [info setClass_type:[NSNumber numberWithInt:[[dic objectForKey:@"transaction_type"] intValue]]];
            [info setHide_status:[NSNumber numberWithInt:[[dic objectForKey:@"hide_status"] intValue]]];
            [info setToken_id:[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
            [info setTransaction_id:[[[dic objectForKey:@"transaction_id"] componentsSeparatedByString:@"_"] objectAtIndex:0]];
            NSNumber *number= [Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date];
            [info setServer_updation_date:number];
            [info setUpdation_date:[NSNumber numberWithLongLong:[number longLongValue]-10]];
            [[APP_DELEGATE managedObjectContext] save:&error];
        }
    }else
        [self insertCateGoryListFromAddedTransactionToServer:dic];
}


-(void)insertCateGoryListFromServer:(NSDictionary*)responseObject
{
    NSArray *array=[responseObject objectForKey:@"data"];
    for (NSDictionary *dic in array)
    {
        NSError  *error;
       CategoryList   *info = [NSEntityDescription insertNewObjectForEntityForName:@"CategoryList" inManagedObjectContext:_managedObjectContext];
        if ([dic objectForKey:@"sub_category"] == (id)[NSNull null])
        {
            [info setSub_category:@""];
            
        }else
            [info setSub_category:[dic objectForKey:@"sub_category"]];
        
        [info setCategory:[dic objectForKey:@"category"]];
        if([[dic objectForKey:@"attachments"] length]!=0)
        {
            NSURL *url = [NSURL URLWithString:[dic objectForKey:@"attachments"]];
            NSData *data = [NSData dataWithContentsOfURL:url];
            [info setCategory_icon:data];
        }
        [info setClass_type:[NSNumber numberWithInt:[[dic objectForKey:@"transaction_type"] intValue]]];
        [info setHide_status:[NSNumber numberWithInt:[[dic objectForKey:@"hide_status"] intValue]]];
        [info setToken_id:[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
        [info setTransaction_id:[[[dic objectForKey:@"transaction_id"] componentsSeparatedByString:@"_"] objectAtIndex:0]];
         NSNumber *number= [Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date];
        [info setServer_updation_date:number];
        [info setUpdation_date:[NSNumber numberWithLongLong:[number longLongValue]-10]];
        NSLog(@"%@",info);
        [[APP_DELEGATE managedObjectContext] save:&error];
    }
}



-(NSNumber*)getGMT_MillisFromYYYY_MM_DD_HH_SS_Date
{
    long long milliseconds = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
    return [NSNumber numberWithUnsignedLongLong:milliseconds];
    
}


-(NSMutableArray*)getDefaultList
{
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [self getAllCategoryList];
    NSMutableArray *incomeList=[[NSMutableArray alloc] init];
    
    for (int i=0; i<[fetchedRecords count]; i++)
    {
        NSString *string=[fetchedRecords objectAtIndex:i];
        NSArray *classType=[self getsearchCategeryWithAttributeName:@"class_type" andSearchText:string];
        if ([[[classType objectAtIndex:0] objectForKey:@"class_type"] intValue])
        {
            NSArray *categeryIcon=[self getsearchCategeryWithAttributeName:@"category_icon" andSearchText:string];
            if (![categeryIcon count]==0)
            {
                NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
                [dic setObject:string forKey:@"name"];
                [dic setObject:@"0" forKey:@"tag"];
                [incomeList addObject:dic];
            }
            NSArray *relatedSubCategeryLists=[self getsearchCategeryWithAttributeName:@"sub_category" andSearchText:string];
           for (int j=0; j<[relatedSubCategeryLists count]; j++)
            {
                NSString *substring=[[relatedSubCategeryLists objectAtIndex:j] objectForKey:@"sub_category"];
                if ([substring length]!=0)
                {
                    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
                    [dic setObject:[NSString stringWithFormat:@"      %@",substring] forKey:@"name"];
                    [dic setObject:@"1" forKey:@"tag"];
                    [incomeList addObject:dic];
                }
            }
        }else
        {
            NSArray *categeryIcon=[self getsearchCategeryWithAttributeName:@"category_icon" andSearchText:string];
            if (![categeryIcon count]==0)
            {
                NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
                [dic setObject:string forKey:@"name"];
                [dic setObject:@"0" forKey:@"tag"];
                [incomeList addObject:dic];
            }
            NSArray *relatedSubCategeryLists=[self getsearchCategeryWithAttributeName:@"sub_category" andSearchText:string];;
            NSLog(@"%@",relatedSubCategeryLists);
            for (int j=0; j<[relatedSubCategeryLists count]; j++)
            {
               
                NSString *substring=[[relatedSubCategeryLists objectAtIndex:j] objectForKey:@"sub_category"];
                if ([substring length]!=0)
                {
                    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
                    [dic setObject:[NSString stringWithFormat:@"      %@",substring] forKey:@"name"];
                    [dic setObject:@"1" forKey:@"tag"];
                    [incomeList addObject:dic];
                }
            }
        }
    }
    return incomeList;
}


-(NSArray*)getAllCategory
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CategoryList" inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"token_id = %@",[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
      fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"category" ascending:YES]];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    // Returning Fetched Records
    return fetchedRecords;
}



-(NSArray*)getAllUnHideCategery
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CategoryList" inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"hide_status = %@ AND token_id = %@",@"0",[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
      fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"category" ascending:YES]];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    // Returning Fetched Records
    return fetchedRecords;
}


-(NSArray *)getsearchCategeryWithAttributeName:(NSString *)attributeName andSearchText:(NSString *)searchText
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CategoryList" inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"category = %@ AND token_id = %@",searchText,[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
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


-(NSArray *)getsearchSubCategery:(NSString *)searchText
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CategoryList"
                                              inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"sub_category = %@ AND token_id = %@",searchText,[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    // Returning Fetched Records
    return fetchedRecords;
}


-(BOOL)getCategoryKeyByValue:(NSString*)subCategery :(NSString*)csvMainCategery
{
    NSArray *categeryIcon=[[CategoryListHandler sharedCoreDataController]  getsearchSubCategery:TRIM(subCategery)];
    if ([categeryIcon count]!=0)
    {
        CategoryList *list=[categeryIcon objectAtIndex:0];
        if ([list.category caseInsensitiveCompare:csvMainCategery] == NSOrderedSame)
        {
            return YES;
        }
    }
    return NO;
}

-(NSArray *)getCategeryAttributeName:(NSString *)attributeName andSearchText:(NSString *)searchText
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CategoryList" inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:attributeName,searchText];
    NSPredicate *p1=[NSPredicate predicateWithFormat:@"token_id = %@",[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    NSPredicate *newPredicate = [NSCompoundPredicate andPredicateWithSubpredicates: @[predicate,p1]];
    [fetchRequest setPredicate:newPredicate];
    [fetchRequest setEntity:entity];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    // Returning Fetched Records
    return fetchedRecords;
}


-(NSArray *)getsearchCategery:(NSString *)searchText
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CategoryList"
                                              inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"category = %@ AND token_id = %@ ",searchText,[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setEntity:entity];
   // [fetchRequest setResultType:NSDictionaryResultType];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    // Returning Fetched Records
    return fetchedRecords;
}


-(NSArray*)getCategeryList:(NSString*)classType
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CategoryList"
                                              inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"class_type = %@ AND hide_status = %@ AND token_id = %@ ",classType,@"0",[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"category" ascending:YES]];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    // Returning Fetched Records
    return fetchedRecords;
}



-(NSArray*)getAllCategoryListToUpdateOnServer
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CategoryList" inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"(server_updation_date <= %@) AND token_id = %@ ",@"0",[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    [fetchRequest setFetchLimit:50];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return fetchedRecords;
}





-(NSArray*)getAllCategoryListToEditOnServer
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CategoryList" inManagedObjectContext:_managedObjectContext];
   
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



-(NSArray*)getDefayultCategoryList
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
     NSEntityDescription *entity = [NSEntityDescription entityForName:@"CategoryList" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setResultType:NSDictionaryResultType];
    [fetchRequest setReturnsDistinctResults:YES];
     NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
     NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
     return fetchedRecords;
}




-(NSMutableArray*)getAllCategoryListwithHideStaus
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
     NSEntityDescription *entity = [NSEntityDescription entityForName:@"CategoryList" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"token_id = %@",[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setResultType:NSDictionaryResultType];
    [fetchRequest setReturnsDistinctResults:YES];
      fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"category" ascending:YES]];
    NSDictionary *entityProperties = [entity propertiesByName];
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObjects:[entityProperties objectForKey:@"category"], nil]];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSMutableArray *array=[[NSMutableArray alloc] init];
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (int i=0; i<[fetchedRecords count]; i++)
    {
        NSString *string=[[fetchedRecords objectAtIndex:i] objectForKey:@"category"];
        [array addObject:TRIM(string)];
    }
    return array;
}

-(NSMutableArray*)getAllSubCategery
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CategoryList" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"token_id = %@",[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setResultType:NSDictionaryResultType];
    [fetchRequest setReturnsDistinctResults:YES];
    NSDictionary *entityProperties = [entity propertiesByName];
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObjects:[entityProperties objectForKey:@"sub_category"], nil]];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSMutableArray *array=[[NSMutableArray alloc] init];
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (int i=0; i<[fetchedRecords count]; i++)
    {
        NSString *string=TRIM([[fetchedRecords objectAtIndex:i] objectForKey:@"sub_category"]);
        if ([string length]!=0)
        {
            [array addObject:string];
        }
    }
    return array;
}


-(NSMutableArray*)getAllCategoryList
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CategoryList" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"token_id = %@ AND hide_status = %@",[Utility userDefaultsForKey:MAIN_TOKEN_ID],@"0"];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setResultType:NSDictionaryResultType];
    [fetchRequest setReturnsDistinctResults:YES];
    NSDictionary *entityProperties = [entity propertiesByName];
      fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"category" ascending:YES]];
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObjects:[entityProperties objectForKey:@"category"], nil]];
    
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    
    NSMutableArray *array=[[NSMutableArray alloc] init];
    
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (int i=0; i<[fetchedRecords count]; i++)
    {
        NSString *string=[[fetchedRecords objectAtIndex:i] objectForKey:@"category"];
        [array addObject:TRIM(string)];
    }
    return array;
}



-(BOOL)updateItemCategoryList:(NSDictionary *)dictionary :(CategoryList*)info
{
    
    [[TransactionHandler sharedCoreDataController] updateSubCategry:info.sub_category :[dictionary objectForKey:@"subCatgery"]];
    [[ReminderHandler sharedCoreDataController] updateSubCategry:info.sub_category :[dictionary objectForKey:@"subCatgery"]];
    [[BudgetHandler sharedCoreDataController] updateSubCategry:info.sub_category :[dictionary objectForKey:@"subCatgery"]];
    [[TransferHandler sharedCoreDataController] updateSubCategry:info.sub_category :[dictionary objectForKey:@"subCatgery"]];
    
    NSError  *error;
    [info setSub_category:[dictionary objectForKey:@"subCatgery"]];
    [info setCategory:[dictionary objectForKey:@"categery"]];
    if([dictionary valueForKey:@"pic"] != nil)
    {
        UIImage *image=[dictionary objectForKey:@"pic"];
        [info setCategory_icon:UIImageJPEGRepresentation(image, 1.0)];
    }
    [info setClass_type:[dictionary objectForKey:@"classtype"]];
    [info setHide_status:[dictionary objectForKey:@"hide_status"]];
    [info setUpdation_date:[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date]];
    [[APP_DELEGATE managedObjectContext] save:&error];
    
    return YES;

}



-(void)updateTokenIdCategoryList:(NSDictionary *)dictionary :(CategoryList*)info
{
    NSError* error;
    [info setToken_id:[dictionary objectForKey:@"TokenId"]];
    [[APP_DELEGATE managedObjectContext] save:&error];
}



-(BOOL)insetItemCategoryList:(NSDictionary *)dictionary
{
    NSError  *error;
    CategoryList   *info = [NSEntityDescription insertNewObjectForEntityForName:@"CategoryList" inManagedObjectContext:_managedObjectContext];
    [info setSub_category:[dictionary objectForKey:@"subCatgery"]];
    [info setCategory:[[dictionary objectForKey:@"categery"] capitalizedString]];
    if([dictionary valueForKey:@"pic"] != nil)
    {
        UIImage *image=[dictionary objectForKey:@"pic"];
        [info setCategory_icon:UIImageJPEGRepresentation(image, 1.0)];
    }
    [info setToken_id:[dictionary objectForKey:@"token_id"]];
    [info setClass_type:[dictionary objectForKey:@"classtype"]];
    [info setHide_status:[dictionary objectForKey:@"hide_status"]];
    [info setUpdation_date:[self getGMT_MillisFromYYYY_MM_DD_HH_SS_Date]];
    [info setTransaction_id:[[self getGMT_MillisFromYYYY_MM_DD_HH_SS_Date] stringValue]];
    [info setServer_updation_date:[NSNumber numberWithInt:0]];
    [[APP_DELEGATE managedObjectContext] save:&error];
    return YES;
}



-(BOOL)insetItemCategoryListFromImport:(NSDictionary *)dictionary
{
    NSError  *error;
    CategoryList   *info = [NSEntityDescription insertNewObjectForEntityForName:@"CategoryList" inManagedObjectContext:_managedObjectContext];
    if ([[dictionary objectForKey:@"sub_category"] isEqualToString:@"null"])
    {
        [info setSub_category:@""];
    }else
    [info setSub_category:TRIM([dictionary objectForKey:@"sub_category"])];
    NSData *data;
    if([[dictionary valueForKey:@"pic"] length]!=0 && [Utility isInternetAvailable])
    {
       NSURL *url = [NSURL URLWithString:[[dictionary valueForKey:@"pic"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        data = [NSData dataWithContentsOfURL:url];
    }
    if ([data length]!=0)
    {
        [info setCategory_icon:data];
        
    }else
    {
        UIImage *image=[UIImage imageNamed:@"Miscellaneous_icon.png"];
        [info setCategory_icon:UIImageJPEGRepresentation(image, 1.0)];
    }
    [info setCategory:TRIM([dictionary objectForKey:@"category"])];
    [info setToken_id:[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    [info setClass_type:[dictionary objectForKey:@"class_type"]];
    [info setHide_status:[dictionary objectForKey:@"hide_status"]];
    [info setTransaction_id:[dictionary objectForKey:@"transaction_id"]];
    [info setUpdation_date:[dictionary objectForKey:@"updation_date"]];
    [info setServer_updation_date:[dictionary objectForKey:@"server_updation_date"]];
    [[APP_DELEGATE managedObjectContext] save:&error];
    return YES;
}

-(void)updateCategoryList:(NSDictionary *)dictionary :(CategoryList*)list
{
    [[TransactionHandler sharedCoreDataController] updateCategeroyToCategery:list.category :[[dictionary objectForKey:@"categery"] capitalizedString]];
    
    [[ReminderHandler sharedCoreDataController] updateCategeroyToCategery:list.category :[[dictionary objectForKey:@"categery"] capitalizedString]];
    
    [[BudgetHandler sharedCoreDataController] updateCategeroyToCategery:list.category :[[dictionary objectForKey:@"categery"] capitalizedString]];
    
    [[TransferHandler sharedCoreDataController] updateCategeroyToCategery:list.category :[[dictionary objectForKey:@"categery"] capitalizedString]];
    
    NSArray *listArray =[[CategoryListHandler sharedCoreDataController] getCategeryAttributeName:@"category = %@" andSearchText:list.category];
    NSLog(@"%@",dictionary);
    for (CategoryList *info in listArray)
    {
        NSError  *error;
        [info setCategory:[[dictionary objectForKey:@"categery"] capitalizedString]];
        if([dictionary valueForKey:@"pic"] != nil)
        {
            UIImage *image=[dictionary objectForKey:@"pic"];
            [info setCategory_icon:UIImageJPEGRepresentation(image, 1.0)];
        }
        [info setHide_status:[dictionary objectForKey:@"hide_status"]];
        [info setUpdation_date:[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date]];
        [[APP_DELEGATE managedObjectContext] save:&error];
    }
   
}


-(void)updateSubCategery:(CategoryList*)infoFrom :(CategoryList*)infoTo
{
    NSError *error;
    [infoFrom setCategory_icon:infoTo.category_icon];
    [infoFrom setCategory:infoTo.category];
    [infoFrom setClass_type:infoTo.class_type];
    [infoFrom setUpdation_date:[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date]];
    [[APP_DELEGATE managedObjectContext] save:&error];
}



-(void)updateCategoryListWithHideStatus:(NSString *)mainCategory :(int)hidestatus
{
    NSError *error;
    NSArray *array=[[CategoryListHandler sharedCoreDataController] getsearchCategery:TRIM(mainCategory)];
    for (CategoryList *list in array)
    {
         [list setHide_status:[NSNumber numberWithInt:hidestatus]];
         [list setUpdation_date:[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date]];
         [[APP_DELEGATE managedObjectContext] save:&error];
    }
}



-(void)updateSubCategeryWithHideStatus:(NSString *)subCategery :(int)hidestatus
{
    NSError *error;
    NSArray *array=[[CategoryListHandler sharedCoreDataController] getsearchSubCategery:subCategery];
    for (CategoryList *list in array)
    {
        [list setHide_status:[NSNumber numberWithInt:hidestatus]];
        [list setUpdation_date:[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date]];
        [[APP_DELEGATE managedObjectContext] save:&error];
    }
}




-(void)updateCategoryListWithSubCategery:(CategoryList*)infoFrom :(CategoryList*)infoTo
{
    NSError *error;
    [infoFrom setCategory_icon:infoTo.category_icon];
    [infoFrom setCategory:infoTo.category];
    [infoFrom setSub_category:infoTo.sub_category];
    [[APP_DELEGATE managedObjectContext] save:&error];
}


-(void)insertDataIntoUpdateOnServerTransactionsTable:(CategoryList*)newInfo
{
    NSError *error;
    UpdateOnServerTransactionsTable   *info = [NSEntityDescription insertNewObjectForEntityForName:@"UpdateOnServerTransactionsTable" inManagedObjectContext:_managedObjectContext];
    [info setTransaction_id:newInfo.transaction_id];
    [info setUser_token_id:@""];
    [info setTransaction_type:[NSNumber numberWithInt:TYPE_CATEGORY]];
    [[APP_DELEGATE managedObjectContext] save:&error];
}


-(BOOL)deleteCategoryList:(CategoryList*)info 
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
