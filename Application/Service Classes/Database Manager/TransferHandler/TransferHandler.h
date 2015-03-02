//
//  TransferHandler.h
//  Daily Expense Manager
//
//  Created by Appbulous on 16/10/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Transfer.h"
#import "CategoryListHandler.h"
@interface TransferHandler : NSObject

+(TransferHandler *)sharedCoreDataController;

-(NSString*)insertDataIntorTransaferTable:(NSMutableDictionary*)dictionary;
-(NSString*)updateDataIntorTransferTable:(NSMutableDictionary*)dictionary :(Transfer*)info;

-(NSArray*)getUserDetailsfromTransfer:(NSString*)searchText;
-(NSArray*)getUserDetailsfromTransferToTable:(NSString*)searchText;

-(NSArray*)getTranferWithTransactionId:(NSString*)searchText;

-(BOOL)deleteTransefer:(Transfer*)info;
-(NSArray*)getcabName;
-(NSArray*)getAllTransfer;

-(void)updateCategeroySubCategryToCategery:(NSString*)fromCategery :(NSString*)toCategery;
-(void)updateCategeroyToCategery:(NSString*)fromCategery :(NSString*)toCategery;
-(void)updateCategeroySubCategryToCategerysubcategery:(NSString*)fromCategery :(CategoryList*)toCategery;
-(void)insertDataIntoTransaferTablefromEmport:(NSMutableDictionary*)dictionary;
-(NSArray*)getAllTransferForID:(NSString *)userTokenId :(NSDate*)startDate :(NSDate*)endDate :(NSString*)transaction_type :(NSString*)oderBy :(NSMutableArray*)categery :(NSMutableArray*)paymetnMode;
-(void)updateTokenId:(NSDictionary*)dictionary :(Transfer*)info;
-(void)insertDataToTransferTableFromServer:(NSDictionary*)dictionary;
-(NSArray*)getAllTransferToUpdateOnServer;
-(void)updateServerUpdationDate:(NSString*)data;
-(NSArray*)getAllTransferToEditOnServer;
-(void)insertDataToTransferTableFromAddedTransactionToServer:(NSDictionary*)dictionary;
-(void)editDataToTransferTableFromAddedTransactionToServer:(NSDictionary*)dictionary;
-(void)deleteDataToTransferTableFromAddedTransactionToServer:(NSDictionary*)dictionary;
-(void)deleteCategeroyList:(NSString *)categery chekServerUpdation:(BOOL)chek;
-(void)deletePaymentMode:(NSString *)paymetMode chekServerUpdation:(BOOL)chek;
-(void)updatePaymentMode:(NSString*)paymetMode :(NSString*)toPaymetMode;
-(void)updateSubCategry:(NSString*)fromSubCategery :(NSString*)toSubCategery;
-(void)updateUserToken:(NSString*)fromAccount :(NSString*)ToAccount;
@end
