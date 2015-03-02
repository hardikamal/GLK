//
//  countryObject.h
//  CountryDialingCode
//
//  Created by ITRENTALINDIA on 6/9/14.
//  Copyright (c) 2015 Mobulous. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CountryObject : NSObject

@property(strong,nonatomic) NSString *countryName;
@property(strong,nonatomic) NSString *countryDialingCode;
@property(strong,nonatomic) NSString *countryCode;

-(instancetype) initCountryWithName:(NSString *)countryName countryDialingCode:(NSString*)countryDialingCode countryCode:(NSString*)countryCode;
+(instancetype)countryWithName:(NSString *)countryName countryDialingCode:(NSString*)countryDialingCode countryCode:(NSString*)countryCode;
@end
