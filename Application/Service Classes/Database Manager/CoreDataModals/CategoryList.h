//
//  CategoryList.h
//  Application
//
//  Created by Alok Singh on 26/02/15.
//  Copyright (c) 2015 Mobulous. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CategoryList : NSManagedObject

@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSData * category_icon;
@property (nonatomic, retain) NSNumber * class_type;
@property (nonatomic, retain) NSNumber * hide_status;
@property (nonatomic, retain) NSNumber * server_updation_date;
@property (nonatomic, retain) NSString * sub_category;
@property (nonatomic, retain) NSString * token_id;
@property (nonatomic, retain) NSString * transaction_id;
@property (nonatomic, retain) NSNumber * updation_date;

@end
