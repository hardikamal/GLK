//
//  CategoryListHandler.h
//  Daily Expense Manager
//
//  Created by Appbulous on 02/09/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryList.h"
@interface CategoryListHandler : NSObject

+(CategoryListHandler *) sharedCoreDataController;

-(NSArray*)getAllCategory;
-(NSArray*)getAllUnHideCategery;


-(void)addDefaultCategoryList:(NSString *)expenses :(NSString *)income;
-(NSMutableArray*)getDefaultList;
-(NSMutableArray*)getAllCategoryListwithHideStaus;
-(NSMutableArray*)getAllCategoryList;
-(NSMutableArray*)getDefayultCategoryList;
-(NSArray *)getsearchSubCategery:(NSString *)searchText;
-(void)saveDefaultDataInCateGoryList:(NSString*)categery :(NSString*)subCatgery :(NSNumber*)number;
-(NSArray *)getsearchCategeryWithAttributeName:(NSString *)attributeName andSearchText:(NSString *)searchText;
-(NSArray *)getsearchCategery:(NSString *)searchText;
-(NSArray *)getCategeryAttributeName:(NSString *)attributeName andSearchText:(NSString *)searchText;
-(NSArray*)getCategeryList:(NSString*)classType;
-(BOOL)insetItemCategoryList:(NSDictionary *)dictionary;
-(BOOL)updateItemCategoryList:(NSDictionary *)dictionary :(CategoryList*)info;
-(BOOL)deleteCategoryList:(CategoryList*)info;
-(void)updateCategoryList:(NSDictionary *)dictionary :(CategoryList*)info;
-(void)updateSubCategery:(CategoryList*)infoFrom :(CategoryList*)infoTo;
-(void)updateCategoryListWithSubCategery:(CategoryList*)infoFrom :(CategoryList*)infoTo;
-(BOOL)insetItemCategoryListFromImport:(NSDictionary *)dictionary;
-(void)updateCategoryListWithHideStatus:(NSString *)mainCategory :(int)hidestatus;
-(NSMutableArray*)getAllSubCategery;
-(BOOL)getCategoryKeyByValue:(NSString*)subCategery :(NSString*)csvMainCategery;
-(void)updateTokenIdCategoryList:(NSDictionary *)dictionary :(CategoryList*)info;
-(void)insertCateGoryListFromServer:(NSDictionary*)dic;
-(NSArray*)getAllCategoryListToUpdateOnServer;
-(void)updateServerUpdationDate:(NSString*)data;
-(NSArray*)getAllCategoryListToEditOnServer;
-(void)insertCateGoryListFromAddedTransactionToServer:(NSDictionary*)dic;
-(void)editCateGoryListFromAddedTransactionToServer:(NSDictionary*)dic;
-(void)deleteCateGoryListFromAddedTransactionToServer:(NSDictionary*)dic;

-(void)updateSubCategeryWithHideStatus:(NSString *)subCategery :(int)hidestatus;

@end
