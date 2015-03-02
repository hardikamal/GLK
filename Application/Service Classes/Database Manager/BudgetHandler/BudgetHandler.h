//
//  BudgetHandler.h
//  Daily Expense Manager
//
//  Created by Appbulous on 29/09/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Budget.h"
#import "CategoryListHandler.h"

@interface BudgetHandler : NSObject

+(BudgetHandler *) sharedCoreDataController;

-(BOOL)insertDataIntoBudgetTable:(NSMutableDictionary*)dictionary;
-(NSArray *)getAllBudget:(NSString*)searchText;
-(BOOL)updateDataIntoTransactionTable:(NSMutableDictionary*)dictionary :(Budget*)info;
-(BOOL)deleteBudget:(Budget*)info;
-(double)getBudget:(NSString *)categary andSearchText:(NSString*)paymentMode;
-(NSArray *)getAllBudgetOnHomeScereeen:(NSString*)searchText;
-(void)updateCategeroySubCategryToCategery:(NSString*)fromCategery :(NSString*)toCategery;
-(void)updateCategeroyToCategery:(NSString*)fromCategery :(NSString*)toCategery;
-(void)updateCategeroySubCategryToCategerysubcategery:(NSString*)fromCategery :(CategoryList*)toCategery;
-(void)updateBudget:(Budget*)info;
-(NSArray *)getAllBudget;
-(BOOL)insertDataIntoBudgetFromImport:(NSMutableDictionary*)dictionary;
-(NSArray*)getAllBudgetForID:(NSString *)userTokenId :(NSDate*)startDate :(NSDate*)endDate :(NSString*)transaction_type :(NSString*)oderBy :(NSMutableArray*)categery :(NSMutableArray*)paymetnMode;
-(void)updateTokenId:(NSDictionary*)dictionary :(Budget*)info;
-(void)insertDataIntoBudgetFromServer:(NSDictionary*)dictionary;
-(NSArray*)getAllBudgetToUpdateOnServer;
-(void)updateServerUpdationDate:(NSString*)data;
-(NSArray*)getAllBudgetToEditOnServer;
-(void)insertDataIntoBudgetFromAddedTransactionToServer:(NSDictionary*)dictionary;
-(void)editDataIntoBudgetFromAddedTransactionToServer:(NSDictionary*)dictionary;
-(void)deleteDataIntoBudgetFromAddedTransactionToServer:(NSDictionary*)dictionary;
-(void)deleteCategeroyList:(NSString *)categery chekServerUpdation:(BOOL)chek;
-(void)deletePaymentMode:(NSString *)paymetMode chekServerUpdation:(BOOL)chek;
-(void)updatePaymentMode:(NSString*)paymetMode :(NSString*)toPaymetMode;
-(void)updateSubCategry:(NSString*)fromSubCategery :(NSString*)toSubCateg;
-(void)updateUserToken:(NSString*)fromAccount :(NSString*)ToAccount;
@end
