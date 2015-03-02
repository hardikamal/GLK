//
//  Transactions.h
//  Application
//
//  Created by Alok Singh on 26/02/15.
//  Copyright (c) 2015 Mobulous. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Transactions : NSManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * currency;
@property (nonatomic, retain) NSNumber * date;
@property (nonatomic, retain) NSString * discription;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * paymentMode;
@property (nonatomic, retain) NSData * pic;
@property (nonatomic, retain) NSNumber * server_updation_date;
@property (nonatomic, retain) NSNumber * show_on_homescreen;
@property (nonatomic, retain) NSString * sub_category;
@property (nonatomic, retain) NSString * token_id;
@property (nonatomic, retain) NSString * transaction_id;
@property (nonatomic, retain) NSNumber * transaction_inserted_from;
@property (nonatomic, retain) NSString * transaction_reference_id;
@property (nonatomic, retain) NSNumber * transaction_type;
@property (nonatomic, retain) NSNumber * updation_date;
@property (nonatomic, retain) NSString * user_token_id;
@property (nonatomic, retain) NSNumber * warranty;
@property (nonatomic, retain) NSString * with_person;

@end
