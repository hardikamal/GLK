//
//  ImportHelper.m
//  Daily Expense Manager
//
//  Created by Appbulous on 12/02/15.
//  Copyright (c) 2015 Chandan Kumar. All rights reserved.
//

#import "ImportHelper.h"
#import "Transactions.h"
#import "TransactionHandler.h"
#import "Transfer.h"
#import "TransferHandler.h"
#import "ReminderHandler.h"
#import "Reminder.h"
#import "Budget.h"
#import "BudgetHandler.h"
#import "CategoryList.h"
#import "CategoryList.h"
#import "Paymentmode.h"
#import "PaymentmodeHandler.h"
#import "UserInfoHandler.h"
#import "UserInfo.h"


@implementation ImportHelper
static int type = 0, token_id = 1, transaction_type = 2, transaction_id = 3, pic = 4, user_token_id = 5, categoryInd = 6, sub_category = 7, amount = 8, updation_date = 9, server_updation_date = 10, dateInd = 11, location = 12, description = 13, paymentModeInd = 14, with_person = 15, shown_on_homescreen = 16, warranty = 17, transactionreference_id = 18, reminder_heading = 19, reminder_when_to_alert = 20, reminder_time_period = 21, reminder_sub_alarm = 22, reminder_recurring_type = 23, reminder_alarm = 24, reminder_alert = 25, fromaccount = 26, toaccount = 27, income_transaction_id = 28, expense_transaction_id = 29, email_id = 30, address = 31, password = 32, hide_status = 33, user_dob = 34, user_name = 35, fromdate = 36, todate = 37, transaction_inserted_from = 38, classIndex = 39;

static int addMillies = 0;


-(id) init
{
    self = [super init];
    if(self)
    {

    }
    return self;
}

+(ImportHelper *) sharedCoreDataController
{
    static ImportHelper *singletone=nil;
    if(!singletone)
    {
        singletone=[[ImportHelper alloc] init];
    }
    return singletone;
}


-(void)ExportNewfile:(NSArray *)currentRow
{
    
    for(int i=1;i<[currentRow count];i++)
    {
        if (TYPE_TRANSACTION==[[[currentRow objectAtIndex:i] valueForKey:[NSString stringWithFormat:@"0"]] integerValue])
        {
            [self importAllTransactions:[currentRow objectAtIndex:i]];
        }
        if (TYPE_BUDGET==[[[currentRow objectAtIndex:i] valueForKey:[NSString stringWithFormat:@"0"]] integerValue])
        {
            [self importAllBudgets:[currentRow objectAtIndex:i]];
            addMillies=0;
        }
        if (TYPE_CATEGORY==[[[currentRow objectAtIndex:i] valueForKey:[NSString stringWithFormat:@"0"]] integerValue])
        {
            [self importAllCategories:[currentRow objectAtIndex:i]];
            addMillies=0;
            
        }   if (TYPE_PAYMENT==[[[currentRow objectAtIndex:i] valueForKey:[NSString stringWithFormat:@"0"]] integerValue])
        {
            [self importAllPaymentModes:[currentRow objectAtIndex:i]];
            addMillies=0;;
        }
        if (TYPE_TRANSFER==[[[currentRow objectAtIndex:i] valueForKey:[NSString stringWithFormat:@"0"]] integerValue])
        {
            [self importAllTransfers:[currentRow objectAtIndex:i]];
            addMillies=0;;
        }
        if (TYPE_REMINDER==[[[currentRow objectAtIndex:i] valueForKey:[NSString stringWithFormat:@"0"]] integerValue])
        {
            [self importAllReminder:[currentRow objectAtIndex:i]];
            addMillies=0;
        }
        if (USER_ACCOUNT==[[[currentRow objectAtIndex:i] valueForKey:[NSString stringWithFormat:@"0"]] integerValue])
        {
            [self importAllUsers:[currentRow objectAtIndex:i]];
            addMillies=0;
        }
    }
   [self updateCategeryandPaymenMode];
}



-(void)updateCategeryandPaymenMode
{
    NSArray *transactionItems=[[TransactionHandler sharedCoreDataController] getAllUserTransaction];
    for (Transactions *transaction  in transactionItems)
    {
        [self insertCategery:transaction.category :transaction.sub_category :transaction.transaction_type];
        if (![self checkExistenseInPaymentMode:transaction.paymentMode])
        {
            [[PaymentmodeHandler sharedCoreDataController] addDefaultPaymentMode:transaction.paymentMode];
        }
    }
    NSArray *transferItems=[[TransferHandler sharedCoreDataController] getAllTransfer];
    for (Transfer *transfer  in transferItems)
    {
        [self insertCategery:transfer.category :transfer.sub_category :[NSNumber numberWithInt:1]];
        if (![self checkExistenseInPaymentMode:transfer.paymentMode])
        {
            [[PaymentmodeHandler sharedCoreDataController] addDefaultPaymentMode:transfer.paymentMode];
        }
    }
    
    NSArray *reminderItems=[[ReminderHandler sharedCoreDataController] getAllReminder];
    for (Reminder  *reminder  in reminderItems)
    {
        [self insertCategery:reminder.category :reminder.sub_category :[NSNumber numberWithInt:1]];
        if (![self checkExistenseInPaymentMode:reminder.paymentMode])
        {
            [[PaymentmodeHandler sharedCoreDataController] addDefaultPaymentMode:reminder.paymentMode];
        }
    }
    
    NSArray *budgettItems=[[BudgetHandler sharedCoreDataController] getAllBudget];
    for (Budget  *budget  in budgettItems)
    {
        
        NSMutableArray *categeryarray=[[CategoryListHandler sharedCoreDataController]  getAllCategoryListwithHideStaus];
        [categeryarray addObject:NSLocalizedString(@"all", nil)];
        NSMutableArray *paymetnMode=(NSMutableArray*)[[PaymentmodeHandler sharedCoreDataController] getPaymentModeBeanList];
        [paymetnMode addObject:NSLocalizedString(@"all", nil)];
        
        if ([self chekExitenseCategery:categeryarray :budget.category])
        {
            if ([budget.sub_category length]!=0)
            {
                NSArray *subCategeryarray = [[CategoryListHandler sharedCoreDataController] getAllSubCategery];
                if (![self chekExitenseCategery:subCategeryarray :TRIM(budget.sub_category)] && !budget.sub_category)
                {
                    [[CategoryListHandler sharedCoreDataController] saveDefaultDataInCateGoryList:budget.category  :budget.sub_category :[NSNumber numberWithInt:1]];
                }
            }
        }else
        {
            [[CategoryListHandler sharedCoreDataController] saveDefaultDataInCateGoryList:budget.sub_category  :@"" :[NSNumber numberWithInt:1]];
            if ([budget.sub_category length]!=0)
            {
                NSArray *subCategeryarray = [[CategoryListHandler sharedCoreDataController] getAllSubCategery];
                if (![self chekExitenseCategery:subCategeryarray :budget.sub_category])
                {
                    [[CategoryListHandler sharedCoreDataController] saveDefaultDataInCateGoryList:budget.category  :budget.sub_category :[NSNumber numberWithInt:1]];
                }
            }
        }
        
        if (![self chekExitenseCategery:paymetnMode :budget.paymentMode])
        {
            [[PaymentmodeHandler sharedCoreDataController] addDefaultPaymentMode:budget.paymentMode];
        }
    }
}


-(void)insertCategery:(NSString*)category :(NSString*)sub_category :(NSNumber*)number
{
    NSArray *categeryarray = [[CategoryListHandler sharedCoreDataController]  getAllCategoryListwithHideStaus];
    if ([self chekExitenseCategery:categeryarray :category])
    {
        if ([sub_category length]!=0)
        {
            NSArray *subCategeryarray = [[CategoryListHandler sharedCoreDataController] getAllSubCategery];
            if (![self chekExitenseCategery:subCategeryarray :sub_category] && !sub_category)
            {
                [[CategoryListHandler sharedCoreDataController] saveDefaultDataInCateGoryList:category  :sub_category :number];
            }
        }
    }else
    {
        [[CategoryListHandler sharedCoreDataController] saveDefaultDataInCateGoryList:category  :@"" :number];
        if ([sub_category length]!=0)
        {
            NSArray *subCategeryarray = [[CategoryListHandler sharedCoreDataController] getAllSubCategery];
            if (![self chekExitenseCategery:subCategeryarray :sub_category])
            {
                [[CategoryListHandler sharedCoreDataController] saveDefaultDataInCateGoryList:category  :sub_category :number];
            }
        }
    }
    
}



-(void)importAllTransactions:(NSDictionary *)dic
{
   	NSString *tokenId = @"";
    NSString *mainTokenId =[Utility userDefaultsForKey:MAIN_TOKEN_ID] ;
    int changeTokenIdOrNot= [self getChangeTokenIdOrNot:[dic valueForKey:[NSString stringWithFormat:@"%d",token_id]]];
    if (changeTokenIdOrNot==0)
    {
        return;
    }else
    {
        if (changeTokenIdOrNot==2)
        {
            if ([[dic valueForKey:[NSString stringWithFormat:@"%d",user_token_id]] isEqualToString:DEFAULT_TOKEN_ID])
            {
                tokenId=[Utility userDefaultsForKey:CURRENT_TOKEN_ID];
            }else
                tokenId =[NSString stringWithFormat:@"%@_%@",mainTokenId,[[[dic valueForKey:[NSString stringWithFormat:@"%d",user_token_id]] componentsSeparatedByString:@"_"] objectAtIndex:1]];
        }else
            tokenId=[dic valueForKey:[NSString stringWithFormat:@"%d",user_token_id]];
        
        
        NSString* mainCategory = @"", *subCategoryName = @"";
        mainCategory = [dic valueForKey:[NSString stringWithFormat:@"%d",categoryInd]];
        subCategoryName = [dic valueForKey:[NSString stringWithFormat:@"%d",sub_category]];
        
        NSArray  *categoryData=[self checkForCatgoryDuplicacyAndMerging:TRIM(mainCategory) :TRIM(subCategoryName) :dic :0 :false];
        mainCategory = [categoryData objectAtIndex:1];
        subCategoryName =[categoryData objectAtIndex:2];
        
        int transactionType =[self getTransactionTypeP:[dic valueForKey:[NSString stringWithFormat:@"%d",transaction_type]]];
        
        NSString* transactionId = [dic valueForKey:[NSString stringWithFormat:@"%d",transaction_id]];
        
        if (![self checkExistenseInTrasaction:transactionId])
        {
            NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
            [dictionary setObject:mainTokenId forKey:@"token_id"];
            [dictionary setObject:mainCategory forKey:@"category"];
            [dictionary setObject:subCategoryName forKey:@"sub_category"];
            
            [dictionary setObject:[NSNumber numberWithInt:transactionType] forKey:@"transaction_type"];
            
            [dictionary setObject:transactionId forKey:@"transaction_id"];
            [dictionary setObject:tokenId forKey:@"user_token_id"];
            [dictionary setObject:[NSNumber numberWithDouble:[[dic valueForKey:[NSString stringWithFormat:@"8"]] doubleValue]] forKey:@"amount"];
            [dictionary setObject:[dic valueForKey:[NSString stringWithFormat:@"14"]] forKey:@"paymentMode"];
            
            if ([[[dic valueForKey:[NSString stringWithFormat:@"11"]] componentsSeparatedByString:@"-"] count]==1)
            {
                
                NSNumberFormatter * formate = [[NSNumberFormatter alloc] init];
                [formate setNumberStyle:NSNumberFormatterDecimalStyle];
                
                [dictionary setObject:[formate numberFromString:[dic valueForKey:[NSString stringWithFormat:@"11"]]] forKey:@"date"];
                [dictionary setObject:[formate numberFromString:[dic valueForKey:[NSString stringWithFormat:@"17"]]] forKey:@"warranty"];
                
            }else
            {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.S"];
                
                NSDate *date=[formatter dateFromString:[dic valueForKey:[NSString stringWithFormat:@"11"]]];
                long long milliseconds = (long long)([date timeIntervalSince1970] * 1000.0);
                [dictionary setObject: [NSNumber numberWithUnsignedLongLong:milliseconds] forKey:@"date"];
                
                date=[formatter dateFromString:[dic valueForKey:[NSString stringWithFormat:@"17"]]];
                milliseconds = (long long)([date timeIntervalSince1970] * 1000.0);
                [dictionary setObject:[NSNumber numberWithUnsignedLongLong:milliseconds] forKey:@"warranty"];
            }
            
            [dictionary setObject:[NSNumber numberWithInt:0] forKey:@"server_updation_date"];
            addMillies=addMillies+1;
            [dictionary setObject:[NSNumber numberWithLongLong:[[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date] longLongValue] + addMillies] forKey:@"updation_date"];
            [dictionary setObject:[dic valueForKey:[NSString stringWithFormat:@"13"]] forKey:@"discription"];
            [dictionary setObject:[NSNumber numberWithInteger:[[dic valueForKey:[NSString stringWithFormat:@"33"]] integerValue]] forKey:@"hide_status"];
            [dictionary setObject:[dic valueForKey:[NSString stringWithFormat:@"4"]] forKey:@"pic"];
            [dictionary setObject:[dic valueForKey:[NSString stringWithFormat:@"12"]] forKey:@"location"];
            [dictionary setObject:[dic valueForKey:[NSString stringWithFormat:@"15"]] forKey:@"with_person"];
            NSLog(@"%@",[dic valueForKey:[NSString stringWithFormat:@"%d",transactionreference_id]]);
            [dictionary setObject:[dic valueForKey:[NSString stringWithFormat:@"%d",transactionreference_id]] forKey:@"transaction_reference_id"];
            [dictionary setObject:[NSNumber numberWithInteger:[[dic valueForKey:[NSString stringWithFormat:@"16"]] integerValue]] forKey:@"show_on_homescreen"];
            [dictionary setObject:[NSNumber numberWithInteger:[[dic valueForKey:[NSString stringWithFormat:@"38"]] integerValue]] forKey:@"transaction_inserted_from"];
            [[TransactionHandler sharedCoreDataController] insertDataIntoTransactionTableFromEmport:dictionary];
        }
    }
}


-(void)importAllBudgets:(NSDictionary *)dic
{
    NSString *tokenId = @"";
    NSString *mainTokenId =[Utility userDefaultsForKey:MAIN_TOKEN_ID] ;
    int changeTokenIdOrNot= [self getChangeTokenIdOrNot:[dic valueForKey:[NSString stringWithFormat:@"%d",token_id]]];
    if (changeTokenIdOrNot==0)
    {
        return;
    }else
    {
        if (changeTokenIdOrNot==2)
        {
            if ([[dic valueForKey:[NSString stringWithFormat:@"%d",user_token_id]] isEqualToString:DEFAULT_TOKEN_ID])
            {
                tokenId=[Utility userDefaultsForKey:CURRENT_TOKEN_ID];
            }else
                tokenId =[NSString stringWithFormat:@"%@_%@",mainTokenId,[[[dic valueForKey:[NSString stringWithFormat:@"%d",user_token_id]] componentsSeparatedByString:@"_"] objectAtIndex:1]];
        }else
            tokenId=[dic valueForKey:[NSString stringWithFormat:@"%d",user_token_id]];
        
        NSString* mainCategory = @"", *subCategoryName = @"";
        mainCategory = [dic valueForKey:[NSString stringWithFormat:@"%d",categoryInd]];
        subCategoryName = [dic valueForKey:[NSString stringWithFormat:@"%d",sub_category]];
        NSArray  *categoryData=[self checkForCatgoryDuplicacyAndMerging:TRIM(mainCategory) :TRIM(subCategoryName) :dic :0 :false];
        mainCategory = [categoryData objectAtIndex:1];
        subCategoryName =[categoryData objectAtIndex:2];
        NSString* transactionId = [dic valueForKey:[NSString stringWithFormat:@"%d",transaction_id]];
        if (![self checkExistenseInBudget:transactionId])
        {
            NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
            [dictionary setObject:mainTokenId forKey:@"token_id"];
            [dictionary setObject:mainCategory forKey:@"category"];
            [dictionary setObject:subCategoryName forKey:@"sub_category"];
            NSNumberFormatter * formate = [[NSNumberFormatter alloc] init];
            [formate setNumberStyle:NSNumberFormatterDecimalStyle];
            [dictionary setObject:[NSNumber numberWithInt:0] forKey:@"server_updation_date"];
            addMillies=addMillies+1;
            [dictionary setObject:[NSNumber numberWithLongLong:[[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date] longLongValue] + addMillies] forKey:@"updation_date"];
            [dictionary setObject:transactionId forKey:@"transaction_id"];
            [dictionary setObject:tokenId forKey:@"user_token_id"];
            [dictionary setObject:[dic valueForKey:[NSString stringWithFormat:@"14"]] forKey:@"paymentMode"];
            [dictionary setObject:[NSNumber numberWithDouble:[[dic valueForKey:[NSString stringWithFormat:@"8"]] doubleValue]] forKey:@"amount"];
            if ([[[dic valueForKey:[NSString stringWithFormat:@"%d",fromdate]] componentsSeparatedByString:@"-"] count]==1)
            {
                NSNumberFormatter * formate = [[NSNumberFormatter alloc] init];
                [formate setNumberStyle:NSNumberFormatterDecimalStyle];
                [dictionary setObject:[formate numberFromString:[dic valueForKey:[NSString stringWithFormat:@"%d",fromdate]]] forKey:@"fromdate"];
                [dictionary setObject:[formate numberFromString:[dic valueForKey:[NSString stringWithFormat:@"%d",todate]]] forKey:@"todate"];
                
            }else
            {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.S"];
                NSDate *date=[formatter dateFromString:[dic valueForKey:[NSString stringWithFormat:@"%d",fromdate]]];
                long long milliseconds = (long long)([date timeIntervalSince1970] * 1000.0);
                [dictionary setObject: [NSNumber numberWithUnsignedLongLong:milliseconds] forKey:@"fromdate"];
                
                date=[formatter dateFromString:[dic valueForKey:[NSString stringWithFormat:@"%d",todate]]];
                milliseconds = (long long)([date timeIntervalSince1970] * 1000.0);
                [dictionary setObject: [NSNumber numberWithUnsignedLongLong:milliseconds] forKey:@"todate"];
            }
            
            [dictionary setObject:[dic valueForKey:[NSString stringWithFormat:@"13"]] forKey:@"discription"];
            [dictionary setObject:[NSNumber numberWithInteger:[[dic valueForKey:[NSString stringWithFormat:@"16"]] integerValue]] forKey:@"show_on_homescreen"];
            [[BudgetHandler sharedCoreDataController] insertDataIntoBudgetFromImport:dictionary];
        }
        
    }
    
}


-(void)importAllCategories:(NSDictionary *)dic
{
    NSString* weatherDuplicateTransactionID =@"0";
    int changeTokenIdOrNot= [self getChangeTokenIdOrNot:[dic valueForKey:[NSString stringWithFormat:@"%d",token_id]]];
    if (changeTokenIdOrNot==0)
    {
        return;
        
    } else
    {
        NSString* mainCategory = @"", *subCategoryName = @"";
        mainCategory = [[dic valueForKey:[NSString stringWithFormat:@"%d",categoryInd]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        subCategoryName = [[dic valueForKey:[NSString stringWithFormat:@"%d",sub_category]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        int hideStatus =[[dic valueForKey:[NSString stringWithFormat:@"%d",hide_status]] intValue];
        NSArray  *categoryData=[self checkForCatgoryDuplicacyAndMerging:TRIM(mainCategory) :TRIM(subCategoryName) :dic :hideStatus :YES];
        weatherDuplicateTransactionID = [categoryData objectAtIndex:0];
        mainCategory = [categoryData objectAtIndex:1];
        subCategoryName =[categoryData objectAtIndex:2];
        
        NSString* catClass = [categoryData objectAtIndex:3];
        NSString* transactionId = [dic valueForKey:[NSString stringWithFormat:@"%d",transaction_id]];
        
        if ([weatherDuplicateTransactionID isEqualToString:@"1"])
        {
            NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
            [dictionary setObject:[NSNumber numberWithInt:[catClass intValue]] forKey:@"class_type"];
            [dictionary setObject:[dic valueForKey:[NSString stringWithFormat:@"1"]] forKey:@"token_id"];
            [dictionary setObject:mainCategory forKey:@"category"];
            [dictionary setObject:subCategoryName forKey:@"sub_category"];
            [dictionary setObject:[dic valueForKey:[NSString stringWithFormat:@"4"]] forKey:@"pic"];
            NSNumberFormatter * formate = [[NSNumberFormatter alloc] init];
            [formate setNumberStyle:NSNumberFormatterDecimalStyle];
            [dictionary setObject:[NSNumber numberWithInt:0] forKey:@"server_updation_date"];
            addMillies=addMillies+1;
            [dictionary setObject:[NSNumber numberWithLongLong:[[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date] longLongValue] + addMillies] forKey:@"updation_date"];
            [dictionary setObject:transactionId forKey:@"transaction_id"];
            [dictionary setObject:[NSNumber numberWithInt:hideStatus] forKey:@"hide_status"];
            [[CategoryListHandler sharedCoreDataController] insetItemCategoryListFromImport:dictionary];
        }
    }
}


-(void)importAllPaymentModes:(NSDictionary *)dic
{
    int changeTokenIdOrNot= [self getChangeTokenIdOrNot:[dic valueForKey:[NSString stringWithFormat:@"%d",token_id]]];
    if (changeTokenIdOrNot==0)
    {
        return;
    }else
    {
        NSString* paymentMode =[dic valueForKey:[NSString stringWithFormat:@"14"]];
        if (![self checkExistenseInPaymentMode:paymentMode])
        {
            NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
            [dictionary setObject:[dic valueForKey:[NSString stringWithFormat:@"1"]] forKey:@"token_id"];
            [dictionary setObject:[dic valueForKey:[NSString stringWithFormat:@"14"]] forKey:@"paymentMode"];
            NSNumberFormatter * formate = [[NSNumberFormatter alloc] init];
            [formate setNumberStyle:NSNumberFormatterDecimalStyle];
            [dictionary setObject:[NSNumber numberWithInt:0] forKey:@"server_updation_date"];
            addMillies=addMillies+1;
            [dictionary setObject:[NSNumber numberWithLongLong:[[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date] longLongValue] + addMillies] forKey:@"updation_date"];
            [dictionary setObject:[dic valueForKey:[NSString stringWithFormat:@"3"]] forKey:@"transaction_id"];
            [dictionary setObject:[NSNumber numberWithInteger:[[dic valueForKey:[NSString stringWithFormat:@"33"]] integerValue]] forKey:@"hide_status"];
            [[PaymentmodeHandler sharedCoreDataController] insetItemPayemtModeFromExport:dictionary];
        }else
        {
            [[PaymentmodeHandler sharedCoreDataController] updateCategoryListWithHideStatus:[dic valueForKey:[NSString stringWithFormat:@"%d",paymentModeInd]] :[[dic valueForKey:[NSString stringWithFormat:@"%d",hide_status]] intValue]];
        }
    }
}


-(void)importAllUsers:(NSDictionary *)dic
{
    NSString *tokenId =@"";
    int changeTokenIdOrNot= [self getChangeTokenIdOrNot:[dic valueForKey:[NSString stringWithFormat:@"%d",token_id]]];
    NSString *mainTokenId =[Utility userDefaultsForKey:MAIN_TOKEN_ID] ;
    if (changeTokenIdOrNot == 0)
    {
        return;
        
    }else
    {
        if (changeTokenIdOrNot == 2)
        {
            NSString *data=[dic valueForKey:[NSString stringWithFormat:@"%d",user_token_id]];
            if ([[dic valueForKey:[NSString stringWithFormat:@"%d",user_token_id]] isEqualToString:DEFAULT_TOKEN_ID])
            {
                tokenId= [Utility userDefaultsForKey:CURRENT_TOKEN_ID];
            }else
            {
                tokenId =[NSString stringWithFormat:@"%@_%@",mainTokenId,[[data componentsSeparatedByString:@"_"] objectAtIndex:1]];
            }
        }else
            tokenId=[dic valueForKey:[NSString stringWithFormat:@"%d",user_token_id]];
        
        if (![self checkExistenseUserAcccount:tokenId])
        {
            NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
            NSNumberFormatter * formate = [[NSNumberFormatter alloc] init];
            [formate setNumberStyle:NSNumberFormatterDecimalStyle];
            [dictionary setObject:[NSNumber numberWithInt:0] forKey:@"server_updation_date"];
            addMillies=addMillies+1;
            [dictionary setObject:[NSNumber numberWithLongLong:[[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date] longLongValue] + addMillies] forKey:@"updation_date"];
            [dictionary setObject:[dic valueForKey:[NSString stringWithFormat:@"%d",address]] forKey:@"address"];
            [dictionary setObject:[dic valueForKey:[NSString stringWithFormat:@"%d",email_id]] forKey:@"email_id"];
            [dictionary setObject:[dic valueForKey:[NSString stringWithFormat:@"%d",password]] forKey:@"password"];
            [dictionary setObject:[NSNumber numberWithInteger:[[dic valueForKey:[NSString stringWithFormat:@"%d",hide_status]] integerValue]] forKey:@"hide_status"];
            
            if ([[dic valueForKey:[NSString stringWithFormat:@"%d",location]] isEqualToString:@"null"])
            {
                [dictionary setObject:[NSNumber numberWithInteger:0] forKey:@"location"];
            }else
                [dictionary setObject:[NSNumber numberWithInteger:[[dic valueForKey:[NSString stringWithFormat:@"%d",location]] integerValue]] forKey:@"location"];
            
            [dictionary setObject:[dic valueForKey:[NSString stringWithFormat:@"%d",token_id]] forKey:@"token_id"];
            [dictionary setObject:[dic valueForKey:[NSString stringWithFormat:@"%d",user_dob]] forKey:@"user_dob"];
            [dictionary setObject:[dic valueForKey:[NSString stringWithFormat:@"%d",user_name]] forKey:@"user_name"];
            [dictionary setObject:tokenId forKey:@"user_token_id"];
            [[UserInfoHandler sharedCoreDataController] insertUserToUserRegisterTableFromEmport:dictionary];
        }
    }
}



-(UserInfo*)getChangedTokenID
{
    NSArray *array =[[UserInfoHandler sharedCoreDataController] getAllUserDetails];
    for (UserInfo *info in array)
    {
        if ([info.email_id length] !=0)
        {
            return info;
        }
    }
    
    return[array objectAtIndex:0];
}


-(void)importAllReminder:(NSDictionary *)dic
{
    NSString *tokenId = @"";
    NSString *mainTokenId =[Utility userDefaultsForKey:MAIN_TOKEN_ID] ;
    
    int changeTokenIdOrNot= [self getChangeTokenIdOrNot:[dic valueForKey:[NSString stringWithFormat:@"%d",token_id]]];
    if (changeTokenIdOrNot==0)
    {
        return;
    }else
    {
        if (changeTokenIdOrNot==2)
        {
            if ([[dic valueForKey:[NSString stringWithFormat:@"%d",user_token_id]] isEqualToString:DEFAULT_TOKEN_ID])
            {
                tokenId=[Utility userDefaultsForKey:CURRENT_TOKEN_ID];
            }else
                tokenId =[NSString stringWithFormat:@"%@_%@",mainTokenId,[[[dic valueForKey:[NSString stringWithFormat:@"%d",user_token_id]] componentsSeparatedByString:@"_"] objectAtIndex:1]];
        }else
            tokenId=[dic valueForKey:[NSString stringWithFormat:@"%d",user_token_id]];
        
        NSString* mainCategory = @"", *subCategoryName = @"";
        mainCategory = [dic valueForKey:[NSString stringWithFormat:@"%d",categoryInd]];
        subCategoryName = [dic valueForKey:[NSString stringWithFormat:@"%d",sub_category]];
        NSArray  *categoryData=[self checkForCatgoryDuplicacyAndMerging:TRIM(mainCategory) :TRIM(subCategoryName) :dic :0 :false];
        mainCategory = [categoryData objectAtIndex:1];
        subCategoryName =[categoryData objectAtIndex:2];
        
        NSString* transactionId = [dic valueForKey:[NSString stringWithFormat:@"%d",transaction_id]];
        if (![self checkExistenseInReminder:transactionId])
        {
            NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
            [dictionary setObject:mainTokenId forKey:@"token_id"];
            [dictionary setObject:mainCategory forKey:@"category"];
            [dictionary setObject:subCategoryName forKey:@"sub_category"];
            
            [dictionary setObject:[dic valueForKey:[NSString stringWithFormat:@"%d",transaction_type]] forKey:@"transaction_type"];
            [dictionary setObject:transactionId forKey:@"transaction_id"];
            [dictionary setObject:tokenId forKey:@"user_token_id"];
            [dictionary setObject:[dic valueForKey:[NSString stringWithFormat:@"8"]] forKey:@"amount"];
            [dictionary setObject:[dic valueForKey:[NSString stringWithFormat:@"14"]] forKey:@"paymentMode"];
            
            if ([[[dic valueForKey:[NSString stringWithFormat:@"11"]] componentsSeparatedByString:@"-"] count]==1)
            {
                
                NSNumberFormatter * formate = [[NSNumberFormatter alloc] init];
                [formate setNumberStyle:NSNumberFormatterDecimalStyle];
                [dictionary setObject:[formate numberFromString:[dic valueForKey:[NSString stringWithFormat:@"11"]]] forKey:@"date"];
                
            }else
            {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.S"];
                
                NSDate *date=[formatter dateFromString:[dic valueForKey:[NSString stringWithFormat:@"11"]]];
                long long milliseconds = (long long)([date timeIntervalSince1970] * 1000.0);
                [dictionary setObject: [NSNumber numberWithUnsignedLongLong:milliseconds] forKey:@"date"];
            }
            [dictionary setObject:[dic valueForKey:[NSString stringWithFormat:@"4"]] forKey:@"pic"];
            [dictionary setObject:[NSNumber numberWithInt:0] forKey:@"server_updation_date"];
            addMillies=addMillies+1;
            [dictionary setObject:[NSNumber numberWithLongLong:[[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date] longLongValue] + addMillies] forKey:@"updation_date"];
            [dictionary setObject:[dic valueForKey:[NSString stringWithFormat:@"13"]] forKey:@"discription"];
            
            [dictionary setObject:[dic valueForKey:[NSString stringWithFormat:@"%d",reminder_recurring_type]] forKey:@"reminder_recurring_type"];
            [dictionary setObject:[dic valueForKey:[NSString stringWithFormat:@"%d",reminder_heading]] forKey:@"reminder_heading"];
            
            if([[dic valueForKey:[NSString stringWithFormat:@"%d",reminder_alarm]] isEqualToString:@"true"] || [[dic valueForKey:[NSString stringWithFormat:@"%d",reminder_alarm]] isEqualToString:@"false"])
            {
                [dictionary setObject:[dic valueForKey:[NSString stringWithFormat:@"%d",reminder_alarm]] forKey:@"reminder_alarm"];
                [dictionary setObject:[dic valueForKey:[NSString stringWithFormat:@"%d",reminder_alert]] forKey:@"reminder_alert"];
                [dictionary setObject:[dic valueForKey:[NSString stringWithFormat:@"%d",reminder_sub_alarm]] forKey:@"reminder_sub_alarm"];
            }else
            {
                if ([[dic valueForKey:[NSString stringWithFormat:@"%d",reminder_alarm]] isEqualToString:@"1"])
                {
                    [dictionary setObject:@"true" forKey:@"reminder_alarm"];
                }else
                    [dictionary setObject:@"false" forKey:@"reminder_alarm"];
                
                if ([[dic valueForKey:[NSString stringWithFormat:@"%d",reminder_alert]] isEqualToString:@"1"])
                {
                    [dictionary setObject:@"false" forKey:@"reminder_alert"];
                }else
                    [dictionary setObject:@"true" forKey:@"reminder_alert"];
                
                if ([[dic valueForKey:[NSString stringWithFormat:@"%d",reminder_sub_alarm]] isEqualToString:@"1"])
                {
                    [dictionary setObject:@"true" forKey:@"reminder_sub_alarm"];
                }else
                    [dictionary setObject:@"false" forKey:@"reminder_sub_alarm"];
            }
            
            [dictionary setObject:[dic valueForKey:[NSString stringWithFormat:@"%d",reminder_time_period]] forKey:@"reminder_time_period"];
            [dictionary setObject:[dic valueForKey:[NSString stringWithFormat:@"%d",reminder_when_to_alert]] forKey:@"reminder_when_to_alert"];
            [[ReminderHandler sharedCoreDataController] insertDataIntoReminderTableFromImport:dictionary];
        }
    }
}



-(BOOL)checkExistenseInTrasaction:(NSString *)string
{
    NSArray *transactionItems=[[TransactionHandler sharedCoreDataController] getAllUserTransaction];
    for (Transactions *transaction  in transactionItems)
    {
        if ([transaction.transaction_id isEqualToString:TRIM(string)])
        {
            return YES;
        }
    }
    return NO;
}



-(BOOL)checkExistenseInReminder:(NSString *)string
{
    NSArray *transactionItems=[[ReminderHandler sharedCoreDataController] getAllReminder];
    for (Reminder *remindre  in transactionItems)
    {
        if ([remindre.transaction_id isEqualToString:TRIM(string)])
        {
            return YES;
        }
    }
    return NO;
}

-(BOOL)checkExistenseTransfer:(NSString *)string
{
    NSArray *transactionItems=[[TransferHandler sharedCoreDataController] getAllTransfer];
    for (Transfer *transaction  in transactionItems)
    {
        if ([transaction.transaction_id isEqualToString:TRIM(string)])
        {
            return YES;
        }
    }
    return NO;
}

-(BOOL)checkExistenseUserAcccount:(NSString *)string
{
    NSArray *transactionItems=[[UserInfoHandler sharedCoreDataController] getAllUserDetails];
    for (UserInfo *transaction  in transactionItems)
    {
        if ([transaction.user_token_id caseInsensitiveCompare:TRIM(string)]== NSOrderedSame)
        {
            return YES;
        }
    }
    return NO;
}



-(BOOL)checkExistenseInPaymentMode:(NSString *)string
{
    NSArray *transactionItems=[[PaymentmodeHandler sharedCoreDataController] getDefaultPaymentModeBeanList];
    for (Paymentmode *transaction  in transactionItems)
    {
        if ([transaction.paymentMode isEqualToString:TRIM(string)])
        {
            return YES;
        }
    }
    return NO;
}



-(BOOL)checkExistenseInBudget:(NSString *)string
{
    NSArray *transactionItems=[[BudgetHandler sharedCoreDataController] getAllBudget];
    for (Budget *transaction  in transactionItems)
    {
        if ([transaction.transaction_id isEqualToString:TRIM(string)])
        {
            return YES;
        }
    }
    return NO;
}


-(int) getTransactionTypeP:(NSString*)transactionType
{
    if ([transactionType isEqualToString:NSLocalizedString(@"income", nil)])
    {
        return TYPE_INCOME;
    }else
    {
        return TYPE_EXPENSE;
    }
}



-(BOOL)chekExitenseCategery:(NSArray*)array :(NSString*)searchString
{
    BOOL found = NO;
    for (NSString* str in array)
    {
        if ([str isEqualToString:TRIM(searchString)])
        {
            found = YES;
            break;
        }
    }
    return found;
}



-(NSArray*)checkForCatgoryDuplicacyAndMerging:(NSString*)mainCategory :(NSString*)subCategoryName :(NSDictionary *)dic :(int)hideStatus :(BOOL) setHideStatus
{
    
    NSString *isAddedOrNot =@"";
    NSString *resultData=@"";
    NSArray *categeryarray = [[CategoryListHandler sharedCoreDataController]  getAllCategoryListwithHideStaus];
    NSArray *subCategeryarray = [[CategoryListHandler sharedCoreDataController] getAllSubCategery];
    if ([self chekExitenseCategery:categeryarray :mainCategory])
    {
        if ([subCategoryName length]==0)
        {
            if (setHideStatus)
            {
                [[CategoryListHandler sharedCoreDataController] updateCategoryListWithHideStatus:mainCategory :hideStatus];
            }
            resultData =[dic valueForKey:[NSString stringWithFormat:@"%d",classIndex]];
            isAddedOrNot =@"0";
        }else
        {
            if ([[CategoryListHandler sharedCoreDataController] getCategoryKeyByValue:subCategoryName :mainCategory])
            {
                if (setHideStatus)
                {
                    [[CategoryListHandler sharedCoreDataController] updateSubCategeryWithHideStatus:subCategoryName :setHideStatus];
                }
                isAddedOrNot =@"0";
            }else if ([self chekExitenseCategery:subCategeryarray :subCategoryName] && ![[CategoryListHandler sharedCoreDataController] getCategoryKeyByValue:subCategoryName :mainCategory])
            {
                NSArray *array =[[CategoryListHandler sharedCoreDataController] getsearchSubCategery:TRIM(subCategoryName)];
                if ([array count]==0)
                {
                    CategoryList *list=[array objectAtIndex:0];
                    mainCategory=list.category;
                    subCategoryName=[dic valueForKey:[NSString stringWithFormat:@"%d",sub_category]];
                    resultData=[self getChangedCategoryClass:mainCategory :dic];
                    isAddedOrNot = @"1";
                }
            }else
            {
                mainCategory = [dic valueForKey:[NSString stringWithFormat:@"%d",categoryInd]];
                subCategoryName = [dic valueForKey:[NSString stringWithFormat:@"%d",sub_category]];
                resultData=[dic valueForKey:[NSString stringWithFormat:@"%d",classIndex]];
                isAddedOrNot =@"1";
            }
        }
    }else if ([subCategeryarray containsObject:mainCategory])
    {
        if (subCategoryName.length==0)
        {
            NSArray *array=[[CategoryListHandler sharedCoreDataController] getsearchCategery:mainCategory];
            if ([array count]!=0)
            {
                CategoryList *list=[array objectAtIndex:0];
                mainCategory=list.category;
                subCategoryName =@"";
                resultData=[self getChangedCategoryClass:mainCategory :dic] ;
                isAddedOrNot =@"1";
            }
        }
        else
        {
            NSArray *array=[[CategoryListHandler sharedCoreDataController] getsearchCategery:mainCategory];
            if ([array count]!=0)
            {
                CategoryList *list=[array objectAtIndex:0];
                mainCategory=list.category;
                subCategoryName =@"";
                resultData =[self getChangedCategoryClass:mainCategory :dic] ;
                isAddedOrNot =@"1";
            }
        }
    }else
    {
        if (subCategoryName.length == 0)
        {
            resultData =[dic valueForKey:[NSString stringWithFormat:@"%d",classIndex]];
            isAddedOrNot =@"1";
        }else if (![self chekExitenseCategery:subCategeryarray :subCategoryName])
        {
            resultData =[dic valueForKey:[NSString stringWithFormat:@"%d",classIndex]];
            isAddedOrNot =@"1";
            
        }else if ([self chekExitenseCategery:subCategeryarray :subCategoryName])
        {
            NSArray *array =[[CategoryListHandler sharedCoreDataController] getsearchSubCategery:subCategoryName];
            if ([array count]==0)
            {
                CategoryList *list=[array objectAtIndex:0];
                mainCategory=list.category;
                subCategoryName=[dic valueForKey:[NSString stringWithFormat:@"%d",sub_category]];
                resultData=[self getChangedCategoryClass:mainCategory :dic];
                isAddedOrNot = @"1";
            }
        }
    }
    
    NSMutableArray *array=[[NSMutableArray alloc] init];
    [array addObject:isAddedOrNot];
    [array addObject:mainCategory];
    [array addObject:subCategoryName];
    [array addObject:resultData];
    return array;
}



-(NSString *)getChangedCategoryClass:(NSString*)mainCategory :(NSDictionary*)dic
{
    NSArray *array =[[CategoryListHandler sharedCoreDataController] getsearchCategery:mainCategory];
    if ([array count]==0)
    {
        CategoryList *list=(CategoryList*)[array objectAtIndex:0];
        if (list.class_type ==[NSNumber numberWithInteger:[[dic valueForKey:[NSString stringWithFormat:@"39"]] integerValue]])
        {
            return [list.class_type stringValue];
        }
    }
    return  [dic valueForKey:[NSString stringWithFormat:@"39"]];
}




-(int)getChangeTokenIdOrNot:(NSString *)csvTokenId
{
    NSString *mainTokenid=[Utility userDefaultsForKey:MAIN_TOKEN_ID];
    if ([mainTokenid isEqualToString:csvTokenId])
    {
        return 1;
        
    }else if (([csvTokenId isEqualToString:@"0"] || [mainTokenid isEqualToString:@"0"]) && ![mainTokenid isEqualToString:csvTokenId])
    {
        return 2;
    }else
    {
        return 0;
    }
}


- (NSString *)applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


-(void)importAllTransfers:(NSDictionary *)dic
{
    NSString* fromAccTokenId =@"", *toAccTokenId =@"";
    int changeTokenIdOrNot= [self getChangeTokenIdOrNot:[dic valueForKey:[NSString stringWithFormat:@"%d",token_id]]];
    NSString *mainTokenId =[Utility userDefaultsForKey:MAIN_TOKEN_ID] ;
    if (changeTokenIdOrNot == 0)
    {
        return;
    }else
    {
        if (changeTokenIdOrNot == 2)
        {
            fromAccTokenId = [self getUserTokenIDWhenUserRegistered:[dic valueForKey:[NSString stringWithFormat:@"%d",fromaccount]] :mainTokenId];
            toAccTokenId =[self getUserTokenIDWhenUserRegistered:[dic valueForKey:[NSString stringWithFormat:@"%d",toaccount]] :mainTokenId];
        } else
        {
            fromAccTokenId =[dic valueForKey:[NSString stringWithFormat:@"%d",fromaccount]] ;
            toAccTokenId = [dic valueForKey:[NSString stringWithFormat:@"%d",toaccount]];
        }
        
        NSString* mainCategory = @"", *subCategoryName = @"";
        mainCategory = [dic valueForKey:[NSString stringWithFormat:@"%d",categoryInd]];
        subCategoryName = [dic valueForKey:[NSString stringWithFormat:@"%d",sub_category]];
        NSArray  *categoryData=[self checkForCatgoryDuplicacyAndMerging:TRIM(mainCategory) :TRIM(subCategoryName) :dic :0 :false];
        mainCategory = [categoryData objectAtIndex:1];
        subCategoryName =[categoryData objectAtIndex:2];
        int transactionType =[self getTransactionTypeP:[dic valueForKey:[NSString stringWithFormat:@"%d",transaction_type]]];
        NSString* transactionId = [dic valueForKey:[NSString stringWithFormat:@"%d",transaction_id]];
        if (![self checkExistenseTransfer:transactionId])
        {
            NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
            [dictionary setObject:mainTokenId forKey:@"token_id"];
            [dictionary setObject:mainCategory forKey:@"category"];
            [dictionary setObject:subCategoryName forKey:@"sub_category"];
            [dictionary setObject:[NSNumber numberWithInt:transactionType] forKey:@"transaction_type"];
            [dictionary setObject:transactionId forKey:@"transaction_id"];
            [dictionary setObject:[NSNumber numberWithDouble:[[dic valueForKey:[NSString stringWithFormat:@"8"]] doubleValue]] forKey:@"amount"];
            [dictionary setObject:[dic valueForKey:[NSString stringWithFormat:@"14"]] forKey:@"paymentMode"];
            
            NSNumberFormatter * formate = [[NSNumberFormatter alloc] init];
            [formate setNumberStyle:NSNumberFormatterDecimalStyle];
            
            if ([[[dic valueForKey:[NSString stringWithFormat:@"11"]] componentsSeparatedByString:@"-"] count]==1)
            {
                [dictionary setObject:[formate numberFromString:[dic valueForKey:[NSString stringWithFormat:@"11"]]] forKey:@"date"];
                
            }else
            {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.S"];
                
                NSDate *date=[formatter dateFromString:[dic valueForKey:[NSString stringWithFormat:@"11"]]];
                long long milliseconds = (long long)([date timeIntervalSince1970] * 1000.0);
                [dictionary setObject: [NSNumber numberWithUnsignedLongLong:milliseconds] forKey:@"date"];
                
            }
            [dictionary setObject:[NSNumber numberWithInt:0] forKey:@"server_updation_date"];
            addMillies=addMillies+1;
            
            [dictionary setObject:[NSNumber numberWithLongLong:[[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date] longLongValue] + addMillies] forKey:@"updation_date"];
            
            [dictionary setObject:[dic valueForKey:[NSString stringWithFormat:@"13"]] forKey:@"discription"];
            
            [dictionary setObject:[formate numberFromString:[dic valueForKey:[NSString stringWithFormat:@"%d",expense_transaction_id]]] forKey:@"expense_transaction_id"];
            
            [dictionary setObject:[formate numberFromString:[dic valueForKey:[NSString stringWithFormat:@"%d",income_transaction_id]]] forKey:@"income_transaction_id"];
            [dictionary setObject:fromAccTokenId forKey:@"fromaccount"];
            [dictionary setObject:toAccTokenId forKey:@"toaccount"];
            [[TransferHandler sharedCoreDataController] insertDataIntoTransaferTablefromEmport:dictionary];
        }
    }
}


-(NSString*)getUserTokenIDWhenUserRegistered:(NSString*)data :(NSString*)mainToke
{
    if ([data isEqualToString:[Utility userDefaultsForKey:CURRENT_TOKEN_ID]])
    {
        return [Utility userDefaultsForKey:CURRENT_TOKEN_ID];
    }else
    {
        return  [NSString stringWithFormat:@"%@_%@",mainToke,[[data componentsSeparatedByString:@"_"] objectAtIndex:1]];
    }
}

@end
