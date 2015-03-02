//
//  Paymentmode.h
//  Application
//
//  Created by Alok Singh on 26/02/15.
//  Copyright (c) 2015 Mobulous. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Paymentmode : NSManagedObject

@property (nonatomic, retain) NSNumber * hide_status;
@property (nonatomic, retain) NSString * paymentMode;
@property (nonatomic, retain) NSData * paymentmode_icon;
@property (nonatomic, retain) NSNumber * server_updation_date;
@property (nonatomic, retain) NSString * token_id;
@property (nonatomic, retain) NSString * transaction_id;
@property (nonatomic, retain) NSNumber * updation_date;

@end
