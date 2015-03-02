//
//  Budget.h
//  Application
//
//  Created by Alok Singh on 26/02/15.
//  Copyright (c) 2015 Mobulous. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Budget : NSManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * discription;
@property (nonatomic, retain) NSNumber * fromdate;
@property (nonatomic, retain) NSString * paymentMode;
@property (nonatomic, retain) NSNumber * server_updation_date;
@property (nonatomic, retain) NSNumber * show_on_homescreen;
@property (nonatomic, retain) NSString * sub_category;
@property (nonatomic, retain) NSNumber * todate;
@property (nonatomic, retain) NSString * token_id;
@property (nonatomic, retain) NSString * transaction_id;
@property (nonatomic, retain) NSNumber * updation_date;
@property (nonatomic, retain) NSString * user_token_id;

@end
