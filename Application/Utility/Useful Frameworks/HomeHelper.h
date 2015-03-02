//
//  HomeHelper.h
//  Daily Expense Manager
//
//  Created by Appbulous on 05/01/15.
//  Copyright (c) 2015 Chandan Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeHelper : NSObject

+(HomeHelper *)sharedCoreDataController;

-(void)upgradeBackendDataOnServer;
-(void)SignUpwithServer:(NSDictionary*)responseObject;
-(void)clearAllDataInDataDase;
-(void)deleteAllAccountOfCurrentTokenId;
- (void)loginResponceWithServer:(NSDictionary*)responseObject;

@end
