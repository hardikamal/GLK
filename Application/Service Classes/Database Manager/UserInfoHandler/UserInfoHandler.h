//
//  UserInfoHandler.h
//  Daily Expense Manager
//
//  Created by Appbulous on 15/09/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
@interface UserInfoHandler : NSObject
{
    NSManagedObjectContext *_managedObjectContext;
    
}
+(UserInfoHandler *) sharedCoreDataController;
-(void)addUserToUserRegisterTable:(NSMutableDictionary*)dic;
-(void)updateUserToUserRegisterTable:(NSMutableDictionary*)dic :(UserInfo*)info;
-(NSArray*)getUserDetailsToUserRegisterTable;
-(NSArray*)getUserDetailsWithUserTokenid:(NSString *)searchText;
-(NSArray*)getUserDetailsWithUserName:(NSString *)searchText;
-(NSArray*)getAllUserDetails;
-(BOOL)deleteUserInfo:(UserInfo*)info chekServerUpdation :(BOOL)chek;
-(void)insertUserToUserRegisterTableFromEmport:(NSMutableDictionary*)dic;
-(void)updateTokenId:(NSDictionary*)dic :(UserInfo*)info;
-(void)addSubCategeryFromServer:(NSDictionary*)dic :(NSString *)tokenId;
-(void)insertMianAccountFromServer:(NSDictionary*)dic;
-(NSArray*)getUserDetailsToEditOnServer;
-(NSArray*)getUserDetailsToUpdateOnServer;
-(NSArray*)getAllAccountToDeleteOnServer;
-(void)updateServerUpdationDate:(NSString*)data;
-(void)deleteAccountToDeleteOnServer:(NSString *)user_token_id;
-(NSArray*)getUserNameListFromUserRegisterTable;
-(NSArray*)getAllUserDetailsOnServer;
@end
