//
//  TransactionHandler.h
//  Daily Expense Manager
//
//  Created by Appbulous on 12/09/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Transactions.h"
#import "CategoryListHandler.h"

@interface TransactionHandler : NSObject
{
    NSManagedObjectContext *_managedObjectContext;
}

+(TransactionHandler *) sharedCoreDataController;
-(NSArray*)getAllUserTransactionWithType:(NSString *)type;
-(NSArray*)getAllTransactionToUpdateOnServer;
-(NSArray*)getAllTransactionToEditOnServer;
-(void)updateServerUpdationDate:(NSString*)data;

-(BOOL)insertDataIntoTransactionTable:(NSMutableDictionary*)dictionary;
-(NSArray *)getTransactionWithRemiderId:(NSString*)searchText;
-(NSArray*)getAllTransactionsForID:(NSString*)userTokenid;

-(double)getTotalIncomeForAllAccounts:(NSString*)tokenId;
-(double)getTotalExpenseForAllAccounts:(NSString*)tokenId;

-(BOOL)insertDataIntoTransactionTableFromEmport:(NSMutableDictionary*)dictionary;
-(NSString*)insertDataIntoTransactionTableFromNotification:(NSMutableDictionary*)dictionary;

-(BOOL)updateDataIntoTransactionTable:(NSMutableDictionary*)dictionary :(Transactions*)info;
-(NSArray*)getAllUserTransaction;

-(NSArray*)getAllTransactionsForID:(NSString *)userTokenId :(NSDate*)startDate :(NSDate*)endDate :(NSString*)transaction_type :(NSString*)oderBy :(NSMutableArray*)categery :(NSMutableArray*)paymetnMode;
-(NSArray *)getTransactionWithTransactionRefrenceId:(NSString*)searchText :(NSString*)userTokenId;

-(NSArray *)getMaxDateFromTransactionTable:(NSString*)string;
-(NSArray *)getMinDateFromTransactionTable:(NSString*)string;
-(BOOL)deleteTransaction:(Transactions*)info;
-(NSArray *)getAllUser:(NSString*)searchText :(NSString*)tokenId;
-(NSArray *)getAllWarranrty:(NSString*)searchText :(NSString*)userTokenid;
-(NSArray *)getTransactionWithTransactionRefrenceId:(NSString*)searchText;
-(NSNumber*)insertDataIntoTransactionTableFromTransferTable:(NSMutableDictionary*)dictionary;
-(void)updateDataIntoTransactionTableFromTransferTable:(NSMutableDictionary*)dictionary :(Transactions*)info;
-(BOOL)updateRefrence_idIntoTransactionTableFromTransferTable:(NSString*)string :(Transactions*)info;
-(NSArray *)getTransactionWithTransactionId:(NSString*)searchText :(NSString*)userTokenId;
-(NSArray *)getAllWarranrtyOnHomeScreen:(NSString*)searchText :(NSString*)userTokenid;
-(void)updateCategeroySubCategryToCategery:(NSString*)fromCategery :(NSString*)toCategery;
-(void)updateCategeroyToCategery:(NSString*)fromCategery :(NSString*)toCategery;
-(void)updateCategeroySubCategryToCategerysubcategery:(NSString*)fromCategery :(CategoryList*)toCategery;
-(void)updateTransaction:(Transactions*)info;
-(NSArray*)getAllWarranrtyList;
-(void)updateTokenId :(NSDictionary*)dictionary  :(Transactions*)info;
-(void)updateTokenIdWithUserTokenId:(NSDictionary*)dictionary  :(Transactions*)info;
-(void)insertDataIntoTransactionTableFromServer:(NSDictionary*)dictionary;
-(NSArray*)getAllTransferToDeleteOnServer;
-(void)deleteAccountToDeleteOnServer:(NSDictionary *)responseObject;
-(void)insertDataIntoTransactionTableFromAddedTransactionToServer:(NSDictionary*)dictionary;
-(void)editDataIntoTransactionTableFromAddedTransactionToServer:(NSDictionary*)dictionary;
-(void)deleteDataIntoTransactionTableFromAddedTransactionToServer:(NSDictionary*)dictionary;
-(void)deleteCategeroyList:(NSString *)categery chekServerUpdation:(BOOL)chek;
-(void)deletePaymentMode:(NSString *)paymetMode chekServerUpdation:(BOOL)chek;
-(void)updatePaymentMode:(NSString*)paymetMode :(NSString*)toPaymetMode;
-(void)updateSubCategry:(NSString*)fromSubCategery :(NSString*)toSubCategery;
-(void)updateUserToken:(NSString*)fromAccount :(NSString*)ToAccount;
-(NSArray *)getTransactionWithCategeryAndPaymenMode:(NSString*)categary :(NSString*)paymentMode :(NSString*)subCategery :(NSString*)userToke :(NSNumber*)startDate :(NSNumber*)endDate;
-(double)getTotalExpenseForAllAccountswithCategryAndPaymentMode:(NSString*)categary :(NSString *)paymentMode :(NSString*)userToke :(NSString*)subCategery :(NSNumber*)startDate :(NSNumber*)endeDate;
-(NSArray *)getAllUserwithCategaryandPaymentMode:(NSString *)categary andSearchText:(NSString*)paymentMode :(NSString*)typeExpense :(NSString*)userToke :(NSString*)subCategery :(NSNumber*)startDate :(NSNumber*)endDate;
@end
