//
//  Transfer.h
//  Application
//
//  Created by Alok Singh on 26/02/15.
//  Copyright (c) 2015 Mobulous. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Transfer : NSManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSNumber * date;
@property (nonatomic, retain) NSString * discription;
@property (nonatomic, retain) NSNumber * expense_transaction_id;
@property (nonatomic, retain) NSString * fromaccount;
@property (nonatomic, retain) NSNumber * income_transaction_id;
@property (nonatomic, retain) NSString * paymentMode;
@property (nonatomic, retain) NSNumber * server_updation_date;
@property (nonatomic, retain) NSString * sub_category;
@property (nonatomic, retain) NSString * toaccount;
@property (nonatomic, retain) NSString * token_id;
@property (nonatomic, retain) NSString * transaction_id;
@property (nonatomic, retain) NSNumber * updation_date;

@end
