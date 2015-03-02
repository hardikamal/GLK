//
//  PaymentmodeHandler.h
//  Daily Expense Manager
//
//  Created by Appbulous on 03/09/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Paymentmode.h"
@interface PaymentmodeHandler : NSObject
{
    NSManagedObjectContext *_managedObjectContext;
}
+(PaymentmodeHandler *) sharedCoreDataController;
-(NSArray*)getPaymentModeListWithNoFilter;
-(void)addDefaultPaymentMode:(NSString *)expenses;
-(NSArray *)getsearchPaymentWithAttributeName:(NSString *)searchText;
-(NSArray*)getDefaultPaymentModeBeanList;
-(BOOL)deletePaymentModeInfo:(Paymentmode*)info;
-(BOOL)insetItemPayemtMode:(NSDictionary *)dictionary;
-(BOOL)updateItemPayemtMode:(NSDictionary *)dictionary :(Paymentmode*)info;
-(NSArray*)getPaymentModeList;
-(NSMutableArray*)getAllPaymetModeListUnhide;
-(BOOL)insetItemPayemtModeFromExport:(NSDictionary *)dictionary;
-(NSArray*)getPaymentModeBeanList;
-(void)updateCategoryListWithHideStatus:(NSString *)paymentMode :(int)hidestatus;
-(void)updateTokenId:(NSDictionary *)dictionary :(Paymentmode*)info;
-(void)insetItemPayemtModeFromServer:(NSDictionary*)responseObject;
-(NSArray*)getPaymentModeBeanListToUpdateOnServer;
-(void)updateServerUpdationDate:(NSString*)data;
-(NSArray*)getPaymentModeBeanListToEditOnServer;
-(void)insetItemPayemtModeFromAllTransactionToServer:(NSDictionary*)dic;
-(void)editItemPayemtModeFromAllTransactionToServer:(NSDictionary*)dic;
-(void)deleteItemPayemtModeFromAllTransactionToServer:(NSDictionary*)dic;
-(NSMutableArray*)getAllPaymetModeListWithHideStatus;
@end
