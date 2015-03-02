//
//  UpdateOnServerTransactionsTable.h
//  Application
//
//  Created by Alok Singh on 26/02/15.
//  Copyright (c) 2015 Mobulous. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UpdateOnServerTransactionsTable : NSManagedObject

@property (nonatomic, retain) NSString * transaction_id;
@property (nonatomic, retain) NSNumber * transaction_type;
@property (nonatomic, retain) NSString * user_token_id;

@end
