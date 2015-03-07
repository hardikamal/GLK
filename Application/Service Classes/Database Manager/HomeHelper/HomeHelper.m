//
//  HomeHelper.m
//  Daily Expense Manager
//
//  Created by Appbulous on 05/01/15.
//  Copyright (c) 2015 Chandan Kumar. All rights reserved.
//

#import "HomeHelper.h"
#import "TransactionHandler.h"
#import "ReminderHandler.h"
#import "TransferHandler.h"
#import "BudgetHandler.h"
#import "UserInfoHandler.h"
#import "CategoryListHandler.h"
#import "PaymentmodeHandler.h"
#import "Utility.h"
//#import "MBProgressHUD.h"
//#import "SAAPIClient.h"
#import "UpdateOnServerAccountsTable.h"
#import "UpdateOnServerTransactionsTable.h"
#import "UserInfoHandler.h"

@implementation HomeHelper

-(id) init
{
    self = [super init];
    if(self)
    {
        
    }
    return self;
}

+(HomeHelper *) sharedCoreDataController
{
    static HomeHelper *singletone=nil;
    if(!singletone)
    {
        singletone=[[HomeHelper alloc] init];
    }
    return singletone;
}

-(void)upgradeBackendDataOnServer
{
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         [self updateDataonServer];
        dispatch_async(dispatch_get_main_queue(), ^(void)
         {
          
        });
     });
}


-(void)getAllAddedTransacationFromServer
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:CALLNAME_GET_ADDED forKey:@"cn"];
    [dic  setObject:[Utility userDefaultsForKey:CURRENT_TOKEN_ID] forKey:@"usertoken_id"];
    [self login:dic];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:UPDATION_ON_SERVER_TIME];
}




-(void)getAllEditedTransacationFromServer
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:CALLNAME_GET_EDITED forKey:@"cn"];
    [dic  setObject:[Utility userDefaultsForKey:CURRENT_TOKEN_ID] forKey:@"usertoken_id"];
    [self login:dic];
}


-(void)getAllDeletedTransacationFromServer
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:CALLNAME_GET_DELETED forKey:@"cn"];
    [dic  setObject:[Utility userDefaultsForKey:CURRENT_TOKEN_ID] forKey:@"usertoken_id"];
    [self login:dic];
}


-(void)editCurrency
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:CALLNAME_EDIT_CURRENCY forKey:@"cn"];
    [dic setObject:[Utility  userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",CURRENT_CURRENCY,[Utility userDefaultsForKey:MAIN_TOKEN_ID]]] forKey:@"currency"];
    [dic setObject:[Utility userDefaultsForKey:MAIN_TOKEN_ID] forKey:@"usertoken_id"];
    [self login:dic];
}



-(void)deleteAccoutonServer
{
    NSArray *deleteAccountArray=[[UserInfoHandler sharedCoreDataController] getAllAccountToDeleteOnServer];
    if ([deleteAccountArray count]!=0)
    {
        UpdateOnServerAccountsTable *tran =[deleteAccountArray objectAtIndex:0];
        NSMutableDictionary *dictionary =[[NSMutableDictionary alloc] init];
        [dictionary setObject:tran.user_token_id forKey:@"usertoken_id"];
        [dictionary setObject:DELETE_SUB_ACCOUNT forKey:@"cn"];
        [self login:dictionary];
    }else
    {
        [self getAllAddedTransacationFromServer];
    }
}


-(void)editAccoutonServer
{
    NSArray *editAccoutArray=[[UserInfoHandler sharedCoreDataController] getUserDetailsToEditOnServer];
    if ([editAccoutArray count]!=0)
    {
        UserInfo *tran = [editAccoutArray objectAtIndex:0];
        NSMutableDictionary *dictionary =[[NSMutableDictionary alloc] init];
        [dictionary setObject:tran.user_token_id forKey:@"usertoken_id"];
        [dictionary setObject:tran.user_name forKey:@"name"];
         NSData *imgData = UIImageJPEGRepresentation([UIImage imageWithData:tran.user_img], 0.9);
        if ([imgData length]!=0)
        {
           
            NSString *imageString = [imgData base64EncodedStringWithOptions:0];
            NSLog(@"%lu",(unsigned long)[imageString length]);
            [dictionary setObject:imageString forKey:@"avatar"];
        }else
            [dictionary setObject:@"" forKey:@"avatar"];
        
        if ([tran.user_token_id isEqualToString:[Utility userDefaultsForKey:CURRENT_TOKEN_ID]])
        {
            [dictionary setObject:UPDATE_MAIN_ACCOUNT forKey:@"cn"];
        }else
        {
            [dictionary setObject:[Utility  userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",CURRENT_CURRENCY,[Utility userDefaultsForKey:MAIN_TOKEN_ID]]] forKey:@"currency"];
            [dictionary setObject:[tran.hide_status stringValue] forKey:@"hide_status"];
            [dictionary setObject:[tran.updation_date stringValue] forKey:@"created_date"];
            [dictionary setObject:EDIT_SUB_ACCOUNT forKey:@"cn"];
        }
        [self login:dictionary];
    }else
    {
        [self deleteAccoutonServer];
    }
}


-(void)updateAccoutonServer
{
    NSArray *addAccountArray=[[UserInfoHandler sharedCoreDataController] getUserDetailsToUpdateOnServer];
    if ([addAccountArray count]!=0)
    {
        UserInfo *tran = [addAccountArray objectAtIndex:0];
        NSMutableDictionary *dictionary =[[NSMutableDictionary alloc] init];
        [dictionary setObject:[NSString stringWithFormat:@"%d",TYPE_REMINDER] forKey:@"databaseType"];
        [dictionary setObject:tran.user_token_id forKey:@"usertoken_id"];
        [dictionary setObject:tran.user_name forKey:@"name"];
        [dictionary setObject:[Utility  userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",CURRENT_CURRENCY,[Utility userDefaultsForKey:MAIN_TOKEN_ID]]] forKey:@"currency"];
        [dictionary setObject:[tran.hide_status stringValue] forKey:@"hide_status"];
        [dictionary setObject:[tran.updation_date stringValue] forKey:@"created_date"];
         NSData *imgData = UIImageJPEGRepresentation([UIImage imageWithData:tran.user_img], 0.9);
        if ([imgData length]!=0)
        {
            NSString *imageString = [imgData base64EncodedStringWithOptions:0];
            NSLog(@"%lu",(unsigned long)[imageString length]);
            [dictionary setObject:imageString forKey:@"avatar"];
        }else
            [dictionary setObject:@"" forKey:@"avatar"];
            [dictionary setObject:ADD_SUB_ACCOUNT forKey:@"cn"];
            [self login:dictionary];
    }else
    {
            [self editAccoutonServer];
    }
}


-(void)editDataonServer
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSString *string;
    NSArray *reminderArray=[[ReminderHandler sharedCoreDataController] getAllReminderToEditOnServer];
    NSArray *transferArray=[[TransferHandler sharedCoreDataController] getAllTransferToEditOnServer];
    NSArray *budgetArray=[[BudgetHandler sharedCoreDataController] getAllBudgetToEditOnServer];
    NSArray *categeryArray=[[CategoryListHandler sharedCoreDataController] getAllCategoryListToEditOnServer];
    NSArray *paymentArray=[[PaymentmodeHandler sharedCoreDataController] getPaymentModeBeanListToEditOnServer];
    NSArray *transactionarray = [[TransactionHandler sharedCoreDataController] getAllTransactionToEditOnServer];
    
    if ([reminderArray count]!=0)
    {
        string= [self  sendDataToServerFromReminderTable:reminderArray];
        
    }else if ([budgetArray count]!=0)
    {
        string= [self  sendDataToServerFromBUdgetTable:budgetArray];
        
    }else if ([transactionarray count]!=0)
    {
        string= [self  sendDataToServerFromTransactionTable:transactionarray];
        
    }else if ([transferArray count]!=0)
    {
        string= [self  sendDataToServerFromTransferTable:transferArray];
        
    }else if ([categeryArray count]!=0)
    {
        string= [self  sendDataToServerFromCategeryTable:categeryArray];
        
    }else if ([paymentArray count]!=0)
    {
        string= [self  sendDataToServerFromPaymenModeTable:paymentArray];
    }
    if ([string length]!=0)
    {
        [dic  setObject:string forKey:@"data"];
        [dic setObject:EDIT_DATA_UPGRADE forKey:@"cn"];
        [dic  setObject:@"true" forKey:@"mode"];
        [self login:dic];
    }else
    {
        [self deleteDataonServer];
    }
}



-(void)deleteDataonServer
{
      NSArray *transactionarray = [[TransactionHandler sharedCoreDataController] getAllTransferToDeleteOnServer];
      NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
      NSString *string;
      if ([transactionarray count]!=0)
      {
        NSMutableArray *dataPaymentModeArray=[[NSMutableArray alloc] init];
        for (UpdateOnServerTransactionsTable *tran in transactionarray)
        {
            NSMutableDictionary *dictionary =[[NSMutableDictionary alloc] init];
            [dictionary setObject:[NSString stringWithFormat:@"%@",tran.transaction_type] forKey:@"databaseType"];
            if([tran.transaction_type intValue]!=4)
            {
                [dictionary setObject:tran.user_token_id forKey:@"usertoken_id"];
            }else
            {
                  [dictionary setObject:tran.user_token_id forKey:@"usertoken_id_from"];
            }
            [dictionary setObject:tran.transaction_id forKey:@"transaction_id"];
            [dataPaymentModeArray addObject:dictionary];
        }
        
        NSError *error;
        NSMutableDictionary *newdic=[[NSMutableDictionary alloc] init];
        [newdic  setObject:dataPaymentModeArray forKey:@"data"];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:newdic options:NSJSONWritingPrettyPrinted error:&error];
        string= [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
     }
    if ([string length]!=0)
    {
        [dic  setObject:string forKey:@"data"];
        [dic setObject:DELEETE_DATA_UPGRADE forKey:@"cn"];
        [dic  setObject:@"true" forKey:@"mode"];
        [self login:dic];
    }else
    {
         [self  updateAccoutonServer];
    }
}

-(void)updateDataonServer
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSString *string;
    NSArray *reminderArray=[[ReminderHandler sharedCoreDataController] getAllReminderToUpdateOnServer];
    NSArray *transferArray=[[TransferHandler sharedCoreDataController] getAllTransferToUpdateOnServer];
    NSArray *budgetArray=[[BudgetHandler sharedCoreDataController] getAllBudgetToUpdateOnServer];
    NSArray *categeryArray=[[CategoryListHandler sharedCoreDataController] getAllCategoryListToUpdateOnServer];
    NSArray *paymentArray=[[PaymentmodeHandler sharedCoreDataController] getPaymentModeBeanListToUpdateOnServer];
    NSArray *transactionarray = [[TransactionHandler sharedCoreDataController] getAllTransactionToUpdateOnServer];

    if ([reminderArray count]!=0)
    {
        string= [self  sendDataToServerFromReminderTable:reminderArray];
        
    }else if ([transferArray count]!=0)
    {
        string= [self  sendDataToServerFromTransferTable:transferArray];
        
    }else if ([budgetArray count]!=0)
    {
        string= [self  sendDataToServerFromBUdgetTable:budgetArray];
        
    }else if ([categeryArray count]!=0)
    {
        string= [self  sendDataToServerFromCategeryTable:categeryArray];
        
    }else if ([paymentArray count]!=0)
    {
        string= [self  sendDataToServerFromPaymenModeTable:paymentArray];
        
    }else if ([transactionarray count]!=0)
    {
        string= [self  sendDataToServerFromTransactionTable:transactionarray];
    }
    if ([string length]!=0)
    {
        
        [dic  setObject:string forKey:@"data"];
        [dic setObject:ADDD_DATA_UPGRADE forKey:@"cn"];
        [dic  setObject:@"true" forKey:@"mode"];
        [self login:dic];
    }else
    {
        [self editDataonServer];
    }
}



-(NSString*)sendDataToServerFromReminderTable:(NSArray*)reminderArray
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSMutableArray *datareminderArray=[[NSMutableArray alloc] init];
    for (Reminder *tran in reminderArray)
    {
        NSMutableDictionary *dictionary =[[NSMutableDictionary alloc] init];
        [dictionary setObject:@"3" forKey:@"databaseType"];
        [dictionary setObject:tran.user_token_id forKey:@"usertoken_id"];
        [dictionary setObject:tran.reminder_when_to_alert forKey:@"reminder_when_to_alert"];
        [dictionary setObject:tran.reminder_time_period forKey:@"reminder_time_period"];
        [dictionary setObject:tran.transaction_type forKey:@"transaction_type"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:([tran.date doubleValue] / 1000)];
        [dictionary setObject:[formatter stringFromDate:date] forKey:@"transaction_date"];
        [dictionary setObject:tran.reminder_alert forKey:@"reminder_alert"];
        
        [dictionary setObject:tran.reminder_recurring_type forKey:@"reminder_recurring_type"];
        [dictionary setObject:tran.reminder_alert forKey:@"reminder_alarm"];
        [dictionary setObject:tran.transaction_id forKey:@"transaction_id"];
        
        [dictionary setObject:tran.reminder_sub_alarm  forKey:@"reminder_sub_alarm"];
        [dictionary setObject:tran.category forKey:@"category"];
        
        [dictionary setObject:tran.sub_category forKey:@"sub_category"];
        
        [dictionary setObject:tran.amount forKey:@"price"];
        [dictionary setObject:tran.reminder_heading forKey:@"reminder_heading"];
        [dictionary setObject:tran.discription forKey:@"description"];
        [dictionary setObject:tran.paymentMode forKey:@"payment_mode"];
        NSData *imgData = UIImageJPEGRepresentation([UIImage imageWithData:tran.pic], 0.9);
        
        if ([imgData length]!=0)
        {
            NSString *imageString = [imgData base64EncodedStringWithOptions:0];
            NSLog(@"%lu",(unsigned long)[imageString length]);
            [dictionary setObject:imageString forKey:@"attachments"];
        }else
            [dictionary setObject:@"" forKey:@"attachments"];
        
        [datareminderArray addObject:dictionary];
    }
        NSError *error;
        NSMutableDictionary *newdic=[[NSMutableDictionary alloc] init];
        [newdic  setObject:datareminderArray forKey:@"data"];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:newdic options:NSJSONWritingPrettyPrinted error:&error];     NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
}




-(NSString*)sendDataToServerFromTransferTable:(NSArray*)transferArray
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSMutableArray *datareminderArray=[[NSMutableArray alloc] init];
    for (Transfer *tran in transferArray)
    {
        NSMutableDictionary *dictionary =[[NSMutableDictionary alloc] init];
        [dictionary setObject:@"4" forKey:@"databaseType"];
        [dictionary setObject:[tran.income_transaction_id stringValue] forKey:@"income_id"];
        [dictionary setObject:tran.category forKey:@"category"];
        [dictionary setObject:tran.amount forKey:@"price"];
        [dictionary setObject:tran.discription forKey:@"description"];
        [dictionary setObject:[tran.expense_transaction_id stringValue] forKey:@"expense_id"];
        [dictionary setObject:tran.fromaccount forKey:@"usertoken_id_from"];
        [dictionary setObject:tran.paymentMode forKey:@"payment_mode"];
        [dictionary setObject:tran.toaccount forKey:@"usertoken_id_to"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:([tran.date doubleValue] / 1000)];
        [dictionary setObject:[formatter stringFromDate:date] forKey:@"transaction_date"];
        [dictionary setObject:tran.sub_category forKey:@"sub_category"];
        [dictionary setObject:tran.transaction_id forKey:@"transaction_id"];
        [datareminderArray addObject:dictionary];
    }
    NSError *error;
    NSMutableDictionary *newdic=[[NSMutableDictionary alloc] init];
    [newdic  setObject:datareminderArray forKey:@"data"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:newdic options:NSJSONWritingPrettyPrinted error:&error];     NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}




-(NSString*)sendDataToServerFromBUdgetTable:(NSArray*)budgetArray
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSMutableArray *dataBudgetArray=[[NSMutableArray alloc] init];
    for (Budget *tran in budgetArray)
    {
        NSMutableDictionary *dictionary =[[NSMutableDictionary alloc] init];
        [dictionary setObject:@"5" forKey:@"databaseType"];
        [dictionary setObject:tran.user_token_id forKey:@"usertoken_id"];
        [dictionary setObject:tran.category forKey:@"category"];
        [dictionary setObject:[tran.amount stringValue] forKey:@"price"];
        [dictionary setObject:tran.discription forKey:@"description"];
        [dictionary setObject:tran.paymentMode forKey:@"payment_mode"];
        [dictionary setObject:tran.sub_category forKey:@"sub_category"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:([tran.todate doubleValue] / 1000)];
        [dictionary setObject:[formatter stringFromDate:date] forKey:@"budget_date_to"];
        date = [NSDate dateWithTimeIntervalSince1970:([tran.fromdate doubleValue] / 1000)];
        [dictionary setObject:[formatter stringFromDate:date] forKey:@"budget_date_from"];
        [dictionary setObject:tran.transaction_id forKey:@"transaction_id"];
        [dictionary setObject:tran.show_on_homescreen forKey:@"isRead"];
        [dataBudgetArray addObject:dictionary];
    }
    NSError *error;
    NSMutableDictionary *newdic=[[NSMutableDictionary alloc] init];
    [newdic  setObject:dataBudgetArray forKey:@"data"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:newdic options:NSJSONWritingPrettyPrinted error:&error];     NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}


-(NSString*)sendDataToServerFromCategeryTable:(NSArray*)categeryArray
{
    NSMutableArray *dataCategeryArray=[[NSMutableArray alloc] init];
    for (CategoryList *tran in categeryArray)
    {
        NSMutableDictionary *dictionary =[[NSMutableDictionary alloc] init];
        [dictionary setObject:@"6" forKey:@"databaseType"];
        [dictionary setObject:tran.token_id forKey:@"usertoken_id"];
        [dictionary setObject:tran.category forKey:@"category"];
        [dictionary setObject:tran.sub_category forKey:@"sub_category"];
        [dictionary setObject:tran.transaction_id forKey:@"transaction_id"];
        [dictionary setObject:[tran.class_type stringValue] forKey:@"transaction_type"];
        [dictionary setObject:[tran.hide_status stringValue] forKey:@"hide_status"];
         NSData *imgData = UIImageJPEGRepresentation([UIImage imageWithData:tran.category_icon], 0.9);
        if ([imgData length]!=0)
        {
            NSString *imageString = [imgData base64EncodedStringWithOptions:0];
            NSLog(@"%lu",(unsigned long)[imageString length]);
            [dictionary setObject:imageString forKey:@"attachments"];
        }else
            [dictionary setObject:@"" forKey:@"attachments"];
        NSLog(@"%@",dictionary);
        
    [dataCategeryArray addObject:dictionary];
    }
    NSError *error;
    NSMutableDictionary *newdic=[[NSMutableDictionary alloc] init];
    [newdic  setObject:dataCategeryArray forKey:@"data"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:newdic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
    return @"";
}


-(NSString*)sendDataToServerFromPaymenModeTable:(NSArray*)paymentArray
{
    NSMutableArray *dataPaymentModeArray=[[NSMutableArray alloc] init];
    for (Paymentmode *tran in paymentArray)
    {
        NSMutableDictionary *dictionary =[[NSMutableDictionary alloc] init];
        [dictionary setObject:@"7" forKey:@"databaseType"];
        [dictionary setObject:tran.paymentMode forKey:@"payment_mode"];
        [dictionary setObject:tran.token_id forKey:@"usertoken_id"];
        [dictionary setObject:tran.transaction_id forKey:@"transaction_id"];
        [dictionary setObject:[tran.hide_status stringValue] forKey:@"hide_status"];
        NSLog(@"%@",dictionary);
        [dataPaymentModeArray addObject:dictionary];
    }
    NSError *error;
    NSMutableDictionary *newdic=[[NSMutableDictionary alloc] init];
    [newdic  setObject:dataPaymentModeArray forKey:@"data"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:newdic options:NSJSONWritingPrettyPrinted error:&error];     NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}


-(NSString*)sendDataToServerFromTransactionTable:(NSArray*)transactionarray
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSMutableArray *dataArray=[[NSMutableArray alloc] init];
    for (Transactions *tran in transactionarray)
    {
        NSMutableDictionary *dictionary =[[NSMutableDictionary alloc] init];
        [dictionary setObject:[tran.transaction_type stringValue] forKey:@"databaseType"];
        [dictionary setObject:tran.user_token_id forKey:@"usertoken_id"];
        [dictionary setObject:tran.with_person forKey:@"person"];
        [dictionary setObject:tran.location forKey:@"location"];
        [dictionary setObject:[tran.transaction_type stringValue] forKey:@"transaction_type"];
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:([tran.date doubleValue] / 1000)];
        [dictionary setObject:[formatter stringFromDate:date] forKey:@"transaction_date"];
        
        [dictionary setObject:tran.transaction_reference_id forKey:@"transaction_reference_id"];
        [dictionary setObject:tran.transaction_id forKey:@"transaction_id"];
        [dictionary setObject:[tran.transaction_inserted_from stringValue] forKey:@"transaction_insert_from"];
        [dictionary setObject:tran.category forKey:@"category"];
        [dictionary setObject:[tran.amount stringValue] forKey:@"price"];
        [dictionary setObject:tran.discription forKey:@"description"];
        [dictionary setObject:tran.paymentMode forKey:@"payment_mode"];
        [dictionary setObject:tran.sub_category forKey:@"sub_category"];
        
        if (![tran.warranty.stringValue isEqualToString:@"0"] )
        {
            date = [NSDate dateWithTimeIntervalSince1970:([tran.warranty doubleValue] / 1000)];
            [dictionary setObject:[formatter stringFromDate:date] forKey:@"warranty"];
        }else
            [dictionary setObject:@"" forKey:@"warranty"];
        NSData *imgData = UIImageJPEGRepresentation([UIImage imageWithData:tran.pic], 0.9);
        if ([imgData length]!=0)
        {
            NSString *imageString = [imgData base64EncodedStringWithOptions:0];
            [dictionary setObject:imageString forKey:@"attachments"];
        }else
            [dictionary setObject:@"" forKey:@"attachments"];
        

        [dataArray addObject:dictionary];
    }
    NSError *error;
    NSMutableDictionary *newdic=[[NSMutableDictionary alloc] init];
    [newdic  setObject:dataArray forKey:@"data"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:newdic options:NSJSONWritingPrettyPrinted error:&error];     NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}



-(void)login:(NSDictionary*)dic
{
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:UPDATION_ON_SERVER_TIME];
//    SAAPIClient *manager = [SAAPIClient sharedClient];
//    [[manager responseSerializer] setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
//    [manager postPath:@"" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject)
//     {
//         if([[responseObject objectForKey:@"status"] boolValue])
//         {
//             NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
//            [self parseResponseFromJson:responseObject];
//         }
//         else if(![[responseObject objectForKey:@"status"] boolValue])
//         {
//             if ([[responseObject objectForKey:@"cn"] isEqualToString:CALLNAME_GET_ADDED])
//             {
//                 [self getAllEditedTransacationFromServer];
//             }else if ([[responseObject objectForKey:@"cn"] isEqualToString:CALLNAME_GET_EDITED])
//             {
//                 [self getAllDeletedTransacationFromServer];
//             }else if ([[responseObject objectForKey:@"cn"] isEqualToString:CALLNAME_GET_DELETED])
//             {
//                 [self editCurrency];
//             }else if ([[responseObject objectForKey:@"cn"] isEqualToString:CALLNAME_EDIT_CURRENCY])
//             {
//                 NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//                 [dateFormatter setDateFormat:@"dd-MM-yyyy hh:mm:ss a"];
//                 [Utility saveToUserDefaults:[dateFormatter stringFromDate:[NSDate date]] withKey:START_END_TIME];
//                 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:UPDATION_ON_SERVER_TIME];
//             }else
//             {
//                   [[NSUserDefaults standardUserDefaults] setBool:YES forKey:UPDATION_ON_SERVER_TIME];
//             }
//         }
//     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
//     {
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:UPDATION_ON_SERVER_TIME];
//         NSLog(@"Success: %@ ***** %@", operation.responseString, error);
//     }];
}


-(void)parseResponseFromJson:(NSDictionary*)responseObject
{
    NSDictionary *diction=[responseObject objectForKey:@"data"];
    if ([[responseObject objectForKey:@"cn"] isEqualToString:ADD_SUB_ACCOUNT])
    {
          [[UserInfoHandler sharedCoreDataController] updateServerUpdationDate:[diction objectForKey:@"usertoken_id"]];
          [self updateAccoutonServer];
        
    }else if ([[responseObject objectForKey:@"cn"] isEqualToString:EDIT_SUB_ACCOUNT])
    {
        [[UserInfoHandler sharedCoreDataController] updateServerUpdationDate:[diction objectForKey:@"usertoken_id"]];
         [self editAccoutonServer];
        
    }else if ([[responseObject objectForKey:@"cn"] isEqualToString:DELETE_SUB_ACCOUNT])
    {
        [[UserInfoHandler sharedCoreDataController] deleteAccountToDeleteOnServer:[diction objectForKey:@"usertoken_id"]];
        [self deleteAccoutonServer];
        
    }else if ([[responseObject objectForKey:@"cn"] isEqualToString:UPDATE_MAIN_ACCOUNT])
    {
         [[UserInfoHandler sharedCoreDataController] updateServerUpdationDate:[diction objectForKey:@"usertoken_id"]];
         [self editAccoutonServer];
        
    }else if ([[responseObject objectForKey:@"cn"] isEqualToString:ADDD_DATA_UPGRADE])
    {
        [self updateTableparseResponseFromJson:responseObject];
        [self updateDataonServer];
    }else if ([[responseObject objectForKey:@"cn"] isEqualToString:EDIT_DATA_UPGRADE])
    {
        [self updateTableparseResponseFromJson:responseObject];
        [self editDataonServer];
        
    }else if ([[responseObject objectForKey:@"cn"] isEqualToString:DELEETE_DATA_UPGRADE])
    {
           //[self deletedTableparseResponseFromJson:responseObject];
        [[TransactionHandler sharedCoreDataController] deleteAccountToDeleteOnServer:responseObject];
        [self deleteDataonServer];
        
    }else if ([[responseObject objectForKey:@"cn"] isEqualToString:CALLNAME_GET_ADDED])
    {
        [self insertTableparseResponseFromJson:responseObject];
        [self getAllEditedTransacationFromServer];
        
    }else if ([[responseObject objectForKey:@"cn"] isEqualToString:CALLNAME_GET_EDITED])
    {
        [self editTableparseResponseFromJson:responseObject];
        [self getAllDeletedTransacationFromServer];
        
    }else if ([[responseObject objectForKey:@"cn"] isEqualToString:CALLNAME_GET_DELETED])
    {
        [self editCurrency];
        [self deletedTableparseResponseFromJson:responseObject];
       
    }else if ([[responseObject objectForKey:@"cn"] isEqualToString:CALLNAME_EDIT_CURRENCY])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:UPDATION_ON_SERVER_TIME];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        [Utility saveToUserDefaults:[dateFormatter stringFromDate:[NSDate date]] withKey:START_END_TIME];
        
    }
}


-(void)deletedTableparseResponseFromJson:(NSDictionary*)responseObject
{
    NSArray *array=[responseObject objectForKey:@"data"];
    for (NSDictionary *dic in array)
    {
        if ([[dic objectForKey:@"databaseType"] intValue]==TYPE_INCOME || [[dic objectForKey:@"databaseType"] intValue]==TYPE_EXPENSE)
        {
            [[TransactionHandler sharedCoreDataController] deleteDataIntoTransactionTableFromAddedTransactionToServer:dic];
            
        }else if ([[dic objectForKey:@"databaseType"] intValue]==TYPE_BUDGET )
        {
            [[BudgetHandler sharedCoreDataController] deleteDataIntoBudgetFromAddedTransactionToServer:dic];
            
        }
        else if ([[dic objectForKey:@"databaseType"] intValue]==TYPE_TRANSFER )
        {
            [[TransferHandler sharedCoreDataController] deleteDataToTransferTableFromAddedTransactionToServer:dic];
        }
        else if ([[dic objectForKey:@"databaseType"] intValue]==TYPE_REMINDER )
        {
            [[ReminderHandler sharedCoreDataController] deleteDataIntoReminderTablefromAddedTranasactionToServer:dic];
        }
        else if ([[dic objectForKey:@"databaseType"] intValue]==TYPE_CATEGORY )
        {
            [[CategoryListHandler sharedCoreDataController] deleteCateGoryListFromAddedTransactionToServer:dic];
            
        }
        else if ([[dic objectForKey:@"databaseType"] intValue]==TYPE_PAYMENT )
        {
            [[PaymentmodeHandler sharedCoreDataController] deleteItemPayemtModeFromAllTransactionToServer:dic];
      
        }
    }
}


-(void)editTableparseResponseFromJson:(NSDictionary*)responseObject
{
    NSArray *array=[responseObject objectForKey:@"data"];
    for (NSDictionary *dic in array)
    {
        if ([[dic objectForKey:@"databaseType"] intValue]==TYPE_INCOME || [[dic objectForKey:@"databaseType"] intValue]==TYPE_EXPENSE)
        {
            [[TransactionHandler sharedCoreDataController] editDataIntoTransactionTableFromAddedTransactionToServer:dic];
            
        }else if ([[dic objectForKey:@"databaseType"] intValue]==TYPE_BUDGET )
        {
            [[BudgetHandler sharedCoreDataController] editDataIntoBudgetFromAddedTransactionToServer:dic];
            
        }
        else if ([[dic objectForKey:@"databaseType"] intValue]==TYPE_TRANSFER )
        {
            
            [[TransferHandler sharedCoreDataController] editDataToTransferTableFromAddedTransactionToServer:dic];
            
        }
        else if ([[dic objectForKey:@"databaseType"] intValue]==TYPE_REMINDER )
        {
            [[ReminderHandler sharedCoreDataController] editDataIntoReminderTablefromAddedTranasactionToServer:dic];
        }
        else if ([[dic objectForKey:@"databaseType"] intValue]==TYPE_CATEGORY )
        {
            
            [[CategoryListHandler sharedCoreDataController] editCateGoryListFromAddedTransactionToServer:dic];
            
        }
        else if ([[dic objectForKey:@"databaseType"] intValue]==TYPE_PAYMENT )
        {
            [[PaymentmodeHandler sharedCoreDataController] editItemPayemtModeFromAllTransactionToServer:dic];
        }
    }
}





-(void)insertTableparseResponseFromJson:(NSDictionary*)responseObject
{
    NSArray *array=[responseObject objectForKey:@"data"];
    for (NSDictionary *dic in array)
    {
        if ([[dic objectForKey:@"databaseType"] intValue]==TYPE_INCOME || [[dic objectForKey:@"databaseType"] intValue]==TYPE_EXPENSE)
        {
            [[TransactionHandler sharedCoreDataController] insertDataIntoTransactionTableFromAddedTransactionToServer:dic];
            
        }else if ([[dic objectForKey:@"databaseType"] intValue]==TYPE_BUDGET )
        {
            [[BudgetHandler sharedCoreDataController] insertDataIntoBudgetFromAddedTransactionToServer:dic];
        
        }
        else if ([[dic objectForKey:@"databaseType"] intValue]==TYPE_TRANSFER )
        {
            
            [[TransferHandler sharedCoreDataController] insertDataToTransferTableFromAddedTransactionToServer:dic];
            
        }
        else if ([[dic objectForKey:@"databaseType"] intValue]==TYPE_REMINDER )
        {
            [[ReminderHandler sharedCoreDataController] insertDataIntoReminderTablefromAddedTranasactionToServer:dic];
        }
        else if ([[dic objectForKey:@"databaseType"] intValue]==TYPE_CATEGORY )
        {
            
           [[CategoryListHandler sharedCoreDataController] insertCateGoryListFromAddedTransactionToServer:dic];
            
        }
        else if ([[dic objectForKey:@"databaseType"] intValue]==TYPE_PAYMENT )
        {
            
            [[PaymentmodeHandler sharedCoreDataController] insetItemPayemtModeFromAllTransactionToServer:dic];
        }
    }
}


-(void)updateTableparseResponseFromJson:(NSDictionary*)responseObject
{
    NSArray *array=[responseObject objectForKey:@"data"];
    for (NSDictionary *dic in array)
    {
        if ([[dic objectForKey:@"databaseType"] intValue]==TYPE_INCOME || [[dic objectForKey:@"databaseType"] intValue]==TYPE_EXPENSE)
        {
            [[TransactionHandler sharedCoreDataController] updateServerUpdationDate:[dic objectForKey:@"transaction_id"]];
            
        }else if ([[dic objectForKey:@"databaseType"] intValue]==TYPE_BUDGET )
        {
            [[BudgetHandler sharedCoreDataController] updateServerUpdationDate:[dic objectForKey:@"transaction_id"]];
        }
        else if ([[dic objectForKey:@"databaseType"] intValue]==TYPE_TRANSFER )
        {
            [[TransferHandler sharedCoreDataController] updateServerUpdationDate:[dic objectForKey:@"transaction_id"]];
        }
        else if ([[dic objectForKey:@"databaseType"] intValue]==TYPE_REMINDER )
        {
            [[ReminderHandler sharedCoreDataController] updateServerUpdationDate:[dic objectForKey:@"transaction_id"]];
        }
        else if ([[dic objectForKey:@"databaseType"] intValue]==TYPE_CATEGORY )
        {
            [[CategoryListHandler sharedCoreDataController] updateServerUpdationDate:[dic objectForKey:@"transaction_id"]];
        }
        else if ([[dic objectForKey:@"databaseType"] intValue]==TYPE_PAYMENT )
        {
            [[PaymentmodeHandler sharedCoreDataController] updateServerUpdationDate:[dic objectForKey:@"transaction_id"]];
        }
    }
}


-(void)SignUpwithServer:(NSDictionary*)responseObject
{
//  NSArray *array =[[UserInfoHandler sharedCoreDataController] getUserDetailsWithUserTokenid:[Utility userDefaultsForKey:CURRENT_TOKEN_ID]];
//    if ([array count]!=0)
//    {
//    [[UserInfoHandler sharedCoreDataController] deleteUserInfo:[array objectAtIndex:0] chekServerUpdation:NO];
//    }
    
    NSMutableDictionary *mainAcounts=[responseObject objectForKey:@"data"];
    [[UserInfoHandler sharedCoreDataController] insertMianAccountFromServer:mainAcounts];
    NSArray *transactionItems=[[TransactionHandler sharedCoreDataController] getAllUserTransaction];
    for (Transactions *transaction  in transactionItems)
    {
        [[TransactionHandler sharedCoreDataController] updateTokenId:mainAcounts :transaction];
    }
    NSArray *transferItems=[[TransferHandler sharedCoreDataController] getAllTransfer];
    for (Transfer *transfer  in transferItems)
    {
        [[TransferHandler sharedCoreDataController] updateTokenId:mainAcounts :transfer];
    }
    NSArray *reminderItems=[[ReminderHandler sharedCoreDataController] getAllReminder];
    for (Reminder  *reminder  in reminderItems)
    {
        [[ReminderHandler sharedCoreDataController] updateTokenId:mainAcounts :reminder];
    }
    NSArray *budgettItems=[[BudgetHandler sharedCoreDataController] getAllBudget];
    for (Budget  *budget  in budgettItems)
    {
        [[BudgetHandler sharedCoreDataController] updateTokenId:mainAcounts :budget];
        
    }
    NSArray *categeryItems=[[CategoryListHandler sharedCoreDataController] getAllCategory];
    for (CategoryList  *list  in categeryItems)
    {
        [[CategoryListHandler sharedCoreDataController] updateTokenIdCategoryList:mainAcounts :list];
    }
    NSArray *PaymentModeItems=[[PaymentmodeHandler sharedCoreDataController] getDefaultPaymentModeBeanList];
    for (Paymentmode  *list  in PaymentModeItems)
    {
        [[PaymentmodeHandler sharedCoreDataController] updateTokenId:mainAcounts :list];
    }
    NSArray *userItems=[[UserInfoHandler sharedCoreDataController] getAllUserDetails];
    for (UserInfo  *user  in userItems)
    {
        [[UserInfoHandler sharedCoreDataController] updateTokenId:mainAcounts :user];
    }
    
    [Utility saveToUserDefaults:[mainAcounts objectForKey:@"AccountId"] withKey:CURRENT_TOKEN_ID];
    [Utility saveToUserDefaults:[mainAcounts objectForKey:@"TokenId"] withKey:MAIN_TOKEN_ID];
    [Utility saveToUserDefaults:[mainAcounts objectForKey:@"currency"] withKey:[NSString stringWithFormat:@"%@ @@@@ %@",CURRENT_CURRENCY,[mainAcounts objectForKey:@"TokenId"]]];
    [Utility saveToUserDefaults:[[mainAcounts objectForKey:@"name"] uppercaseString] withKey:CURRENT_USER__TOKEN_ID];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:UPDATION_ON_SERVER_TIME];
}


-(void)clearAllDataInDataDase
{
    NSArray *reminderArray=[[ReminderHandler sharedCoreDataController] getAllReminderToUpdateOnServer];
    for (Reminder *tran in reminderArray)
    {
        [[ReminderHandler sharedCoreDataController] deleteReminder:tran];
    }
    NSArray *transferArray=[[TransferHandler sharedCoreDataController] getAllTransferToUpdateOnServer];
    for (Transfer *tran in transferArray)
    {
        [[TransferHandler sharedCoreDataController] deleteTransefer:tran];
    }
    
    NSArray *budgetArray=[[BudgetHandler sharedCoreDataController] getAllBudgetToUpdateOnServer];
    for (Budget *tran in budgetArray)
    {
        [[BudgetHandler sharedCoreDataController] deleteBudget:tran];
    }
    NSArray *categeryArray=[[CategoryListHandler sharedCoreDataController] getAllCategoryListToUpdateOnServer];
    for (CategoryList *tran in categeryArray) {
        [[CategoryListHandler sharedCoreDataController] deleteCategoryList:tran];
    }
    NSArray *paymentArray=[[PaymentmodeHandler sharedCoreDataController] getPaymentModeBeanListToUpdateOnServer];
    for (Paymentmode *tran in paymentArray)
    {
        [[PaymentmodeHandler sharedCoreDataController] deletePaymentModeInfo:tran];
    }
    NSArray *transactionarray = [[TransactionHandler sharedCoreDataController] getAllTransactionToUpdateOnServer];
    for (Transactions *tran in transactionarray)
    {
        [[TransactionHandler sharedCoreDataController] deleteTransaction:tran];
    }
    [Utility saveToUserDefaults:@"" withKey:[NSString stringWithFormat:@"%@ @@@@ %@",LOGIN_DONE,[Utility userDefaultsForKey:MAIN_TOKEN_ID]]];
}


- (void)loginResponceWithServer:(NSDictionary*)responseObject
{
    
    NSDictionary *mainAcounts=[responseObject objectForKey:@"data"];
    [[UserInfoHandler sharedCoreDataController] insertMianAccountFromServer:mainAcounts];
    NSArray *arrya=[responseObject objectForKey:@"subaccounts"];
    for (NSDictionary *dictioanry in arrya)
    {
       [[UserInfoHandler sharedCoreDataController] addSubCategeryFromServer:dictioanry :[mainAcounts objectForKey:@"TokenId"]];
    }
    [Utility saveToUserDefaults:[mainAcounts objectForKey:@"AccountId"] withKey:CURRENT_TOKEN_ID];
    [Utility saveToUserDefaults:[mainAcounts objectForKey:@"TokenId"] withKey:MAIN_TOKEN_ID];
    [Utility saveToUserDefaults:[mainAcounts objectForKey:@"currency"] withKey:[NSString stringWithFormat:@"%@ @@@@ %@",CURRENT_CURRENCY,[mainAcounts objectForKey:@"TokenId"]]];
    [Utility saveToUserDefaults:[[mainAcounts objectForKey:@"name"] uppercaseString] withKey:CURRENT_USER__TOKEN_ID];
    [Utility saveToUserDefaults:@"" withKey:[NSString stringWithFormat:@"%@@@@@%@",LOGOUT_DONE_ACCORDINGTOKEN,[mainAcounts objectForKey:@"TokenId"]]];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:LOGIN_DONE];
    [Utility saveToUserDefaults:@"getAllCategories" withKey:[NSString stringWithFormat:@"%@ @@@@ %@",LAST_TABLE_TYPE,[Utility userDefaultsForKey:MAIN_TOKEN_ID]]];
    [Utility saveToUserDefaults:@"0" withKey:[NSString stringWithFormat:@"%@ @@@@ %@",LAST_TABLE_COUNT,[Utility userDefaultsForKey:MAIN_TOKEN_ID]]];
    
    if ([[Utility userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",LOGIN_DONE,[Utility userDefaultsForKey:MAIN_TOKEN_ID]]] isEqualToString:[Utility userDefaultsForKey:MAIN_TOKEN_ID]])
    {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:UPDATION_ON_SERVER_TIME];
    }
}

@end
