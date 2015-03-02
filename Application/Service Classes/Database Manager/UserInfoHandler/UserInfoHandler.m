//
//  UserInfoHandler.m
//  Daily Expense Manager
//
//  Created by Appbulous on 15/09/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import "UserInfoHandler.h"
#import "UserInfo.h"
#import "UpdateOnServerAccountsTable.h"
#import "TransactionHandler.h"
#import "ReminderHandler.h"
#import "TransferHandler.h"
#import "BudgetHandler.h"
#import "AppDelegate.h"
#import "Utility.h"
@implementation UserInfoHandler


-(id) init
{
    self = [super init];
    if(self)
    {
        _managedObjectContext = [[AppDelegate getAppDelegate] managedObjectContext];
    }
    return self;
}

+(UserInfoHandler *) sharedCoreDataController
{
    static UserInfoHandler *singletone=nil;
    if(!singletone)
    {
        singletone=[[UserInfoHandler alloc] init];
    }
    return singletone;
}

-(void)addUserToUserRegisterTable:(NSMutableDictionary*)dic
{
    NSError *error;
    UserInfo   *info = [NSEntityDescription insertNewObjectForEntityForName:@"UserInfo" inManagedObjectContext:_managedObjectContext];
    [info setUser_name:[[dic objectForKey:@"user_name"] uppercaseString]];
    [info setUser_token_id:[dic objectForKey:@"user_token_id"]];
    [info setHide_status:[dic objectForKey:@"hide_status"]];
    [info setPassword:@""];
    [info setEmail_id:@""];
    [info setAddress:@""];
    [info setUser_dob:@""];
    [info setLocation:[dic objectForKey:@"location"]];
    if([dic valueForKey:@"pic"] != nil)
    {
        UIImage *image=[dic objectForKey:@"pic"];
        [info setUser_img:UIImageJPEGRepresentation(image, 1.0)];
    }
    [info setToken_id:[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    [info setUpdation_date:[self getGMT_MillisFromYYYY_MM_DD_HH_SS_Date]];
    [info setServer_updation_date:[NSNumber numberWithInt:0]];
    [[[AppDelegate getAppDelegate] managedObjectContext] save:&error];
      NSLog(@"%@",info);
}

-(void)insertUserToUserRegisterTableFromEmport:(NSMutableDictionary*)dic
{
    NSError *error;
    UserInfo   *info = [NSEntityDescription insertNewObjectForEntityForName:@"UserInfo" inManagedObjectContext:_managedObjectContext];
    [info setUser_name:[[dic objectForKey:@"user_name"] uppercaseString]];
    [info setUser_token_id:[dic objectForKey:@"user_token_id"]];
    [info setHide_status:[dic objectForKey:@"hide_status"]];
    [info setPassword:[dic objectForKey:@"password"]];
    [info setEmail_id:[dic objectForKey:@"email_id"]];
    [info setAddress:[dic objectForKey:@"address"]];
    [info setUser_dob:[dic objectForKey:@"user_dob"]];
    [info setLocation:[dic objectForKey:@"location"]];
    
    if([dic valueForKey:@"pic"] != nil)
    {
        UIImage *image=[dic objectForKey:@"pic"];
        [info setUser_img:UIImageJPEGRepresentation(image, 1.0)];
    }
    [info setToken_id:[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    [info setUpdation_date:[dic objectForKey:@"updation_date"]];
    [info setServer_updation_date:[dic objectForKey:@"server_updation_date"]];
    [[[AppDelegate getAppDelegate] managedObjectContext] save:&error];
}


-(void)updateUserToUserRegisterTable:(NSMutableDictionary*)dic :(UserInfo*)info
{
    NSError *error;
    [info setUser_name:[[dic objectForKey:@"user_name"] uppercaseString]];
    [info setHide_status:[dic objectForKey:@"hide_status"]];
    [info setLocation:[dic objectForKey:@"location"]];
    [info setUpdation_date:[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date]];
    if([dic valueForKey:@"pic"] != nil)
    {
        UIImage *image=[dic objectForKey:@"pic"];
        [info setUser_img:UIImageJPEGRepresentation(image, 1.0)];
    }
    if([[dic valueForKey:@"password"] length]!=0)
    {
        [info setPassword:[dic objectForKey:@"password"]];
    }
    [[[AppDelegate getAppDelegate] managedObjectContext] save:&error];
}


-(NSNumber*)getGMT_MillisFromYYYY_MM_DD_HH_SS_Date
{
    long long milliseconds = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
    return [NSNumber numberWithUnsignedLongLong:milliseconds];
}


-(NSArray*)getUserDetailsToUserRegisterTable
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserInfo" inManagedObjectContext:_managedObjectContext];
       NSPredicate *predicate =[NSPredicate predicateWithFormat:@"hide_status = %@  AND token_id = %@",@"0",[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *listArray =[[NSMutableArray alloc] init];
    
    for (UserInfo *info in fetchedRecords)
    {
        if ([info.user_token_id isEqualToString:[Utility userDefaultsForKey:CURRENT_TOKEN_ID]])
        {
            [listArray addObject:info];
        }
    }
    for (UserInfo *info in fetchedRecords)
    {
        if ([info.user_token_id isEqualToString:[Utility userDefaultsForKey:CURRENT_TOKEN_ID]])
        {
            
        }else
            [listArray addObject:info];
    }
    return listArray;
}


-(NSArray*)getUserNameListFromUserRegisterTable
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserInfo" inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"hide_status = %@  AND token_id = %@",@"0",[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *listArray=[[NSMutableArray alloc] init];
    for (UserInfo *info in fetchedRecords)
    {
        [listArray addObject:info.user_token_id];
    }
    return listArray;
}



-(NSArray*)getAllUserDetailsOnServer
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserInfo" inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"updation_date < server_updation_date AND token_id = %@",[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return fetchedRecords;
}



-(NSArray*)getAllUserDetails
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserInfo" inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"token_id = %@",[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *listArray=[[NSMutableArray alloc] init];
    for (UserInfo *info in fetchedRecords)
    {
        if ([info.user_token_id isEqualToString:[Utility userDefaultsForKey:CURRENT_TOKEN_ID]])
        {
            [listArray addObject:info];
        }
    }
    for (UserInfo *info in fetchedRecords)
    {
        if ([info.user_token_id isEqualToString:[Utility userDefaultsForKey:CURRENT_TOKEN_ID]])
        {
           
        }else
         [listArray addObject:info];
    }
    return listArray;
}


-(NSArray*)getUserDetailsWithUserTokenid:(NSString *)searchText
{
    NSLog(@"%@",searchText);
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserInfo" inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"user_token_id = %@  AND token_id = %@",searchText,[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    // Returning Fetched Records
    return fetchedRecords;
}


-(NSArray*)getUserDetailsToUpdateOnServer
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserInfo" inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"(server_updation_date <= %@) AND token_id = %@",@"0",[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    [fetchRequest setFetchLimit:50];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return fetchedRecords;
}

-(NSArray*)getUserDetailsToEditOnServer
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserInfo" inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"updation_date > server_updation_date AND token_id = %@",[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    [fetchRequest setFetchLimit:50];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return fetchedRecords;
}


-(void)updateServerUpdationDate:(NSString*)data
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserInfo"  inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"user_token_id = %@",data];
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
    for (UserInfo *info in fetchedRecords)
    {
        NSNumber *number= [Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date];
        [info setServer_updation_date:number];
        [info setUpdation_date:[NSNumber numberWithLongLong:[number longLongValue]-10]];
        [[[AppDelegate getAppDelegate] managedObjectContext] save:&error];
    }
}

-(void)insertDataIntoUpdateOnServerTransactionsTable:(UserInfo*)newInfo
{
    NSError *error;
    UpdateOnServerAccountsTable   *info = [NSEntityDescription insertNewObjectForEntityForName:@"UpdateOnServerAccountsTable" inManagedObjectContext:_managedObjectContext];
    [info setUser_token_id:newInfo.user_token_id];
    [[[AppDelegate getAppDelegate] managedObjectContext] save:&error];
}

-(NSArray*)getUserDetailsWithUserName:(NSString *)searchText;
{
    NSLog(@"%@",[Utility userDefaultsForKey:MAIN_TOKEN_ID]);
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserInfo" inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate;
    predicate =[NSPredicate predicateWithFormat:@"user_name = %@ AND token_id = %@",searchText,[Utility userDefaultsForKey:MAIN_TOKEN_ID]];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    // Returning Fetched Records
    return fetchedRecords;
}



-(void)addSubCategeryFromServer:(NSDictionary*)dic :(NSString *)tokenId
{
    NSError *error;
    UserInfo   *info = [NSEntityDescription insertNewObjectForEntityForName:@"UserInfo" inManagedObjectContext:_managedObjectContext];
    [info setUser_name:[[dic objectForKey:@"name"] uppercaseString]];
    [info setUser_token_id:[dic objectForKey:@"account_id"]];
    [info setHide_status:[NSNumber numberWithBool:[[dic objectForKey:@"hide_status"] boolValue]]];
    [info setPassword:@""];
    [info setEmail_id:@""];
    [info setAddress:@""];
    [info setUser_dob:@""];
    [info setLocation:[NSNumber numberWithInt:0]];
    if([[dic objectForKey:@"avatar"] length]==0)
    {
        NSURL *url = [NSURL URLWithString:[dic objectForKey:@"avatar"]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        [info setUser_img:data];
    }
    [info setToken_id:tokenId];
    NSNumber *number= [Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date];
    [info setServer_updation_date:number];
    [info setUpdation_date:[NSNumber numberWithLongLong:[number longLongValue]-10]];
    [[[AppDelegate getAppDelegate] managedObjectContext] save:&error];
}



-(void)insertMianAccountFromServer:(NSDictionary*)dic
{
    NSError *error;
    UserInfo   *info = [NSEntityDescription insertNewObjectForEntityForName:@"UserInfo" inManagedObjectContext:_managedObjectContext];
    [info setUser_name:[[dic objectForKey:@"name"] uppercaseString]];
    [info setUser_token_id:[dic objectForKey:@"account_id"]];
    [info setHide_status:[NSNumber numberWithBool:[[dic objectForKey:@"hide_status"] boolValue]]];
    [info setPassword:[dic objectForKey:@"password"]];
    [info setEmail_id:[dic objectForKey:@"email"]];
    [info setAddress:@""];
    [info setUser_dob:[dic objectForKey:@"dob"]];
    [info setLocation:[NSNumber numberWithInt:0]];
    [info setUser_token_id:[dic objectForKey:@"AccountId"]];
    NSData* imageData = [[NSUserDefaults standardUserDefaults]objectForKey:@"key_for_your_image"];
    if ([imageData length])
     {
        [info setUser_img:imageData];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"key_for_your_image"];
     }else
     {
        if([[dic objectForKey:@"avatar"] length]!=0)
        {
            NSURL *url = [NSURL URLWithString:[dic objectForKey:@"avatar"]];
            NSData *data = [NSData dataWithContentsOfURL:url];
            [info setUser_img:data];
        }
     }
    [info setToken_id:[dic objectForKey:@"TokenId"]];
     NSNumber *number= [Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date];
    [info setServer_updation_date:number];
    [info setUpdation_date:[NSNumber numberWithLongLong:[number longLongValue]-10]];
    [[[AppDelegate getAppDelegate] managedObjectContext] save:&error];
}


-(void)updateTokenId:(NSDictionary*)dic :(UserInfo*)info
{
    if (![info.user_token_id isEqualToString:[Utility userDefaultsForKey:CURRENT_TOKEN_ID]])
    {
         NSError* error;
        [info setToken_id:[dic objectForKey:@"TokenId"]];
         NSString *string=[[info.user_token_id  componentsSeparatedByString:@"_"] objectAtIndex:1];
        [info setUser_token_id:[NSString stringWithFormat:@"%@_%@",[dic objectForKey:@"TokenId"],string]];
        [[[AppDelegate getAppDelegate] managedObjectContext] save:&error];
    }
}

-(NSArray*)getAllAccountToDeleteOnServer
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UpdateOnServerAccountsTable" inManagedObjectContext:_managedObjectContext];
    //   NSPredicate *predicate=[NSPredicate predicateWithFormat:@"(server_updation_date <= %@)",@"0"];
    [fetchRequest setFetchLimit:50];
    // [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return fetchedRecords;
}



-(void)deleteAccountToDeleteOnServer:(NSString *)user_token_id
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UpdateOnServerAccountsTable"
                                              inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"user_token_id = %@",user_token_id];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsDistinctResults:YES];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    // Returning Fetched Records
    for (UpdateOnServerAccountsTable *info in fetchedRecords)
    {
        [[[AppDelegate getAppDelegate] managedObjectContext] deleteObject:info];
        [[[AppDelegate getAppDelegate] managedObjectContext] save:&error];
    }
}


-(BOOL)deleteUserInfo:(UserInfo*)info chekServerUpdation :(BOOL)chek
{
     NSError *error;
    if (![info.token_id isEqualToString:@"0"] && !chek)
    {
        [self insertDataIntoUpdateOnServerTransactionsTable:info];
    }
    
    [[[AppDelegate getAppDelegate] managedObjectContext] deleteObject:info];
    [[[AppDelegate getAppDelegate] managedObjectContext] save:&error];
    
    return YES;
}

@end
