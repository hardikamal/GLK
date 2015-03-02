//
//  countryObject.m
//  CountryDialingCode
//
//  Created by ITRENTALINDIA on 6/9/14.
//  Copyright (c) 2015 Mobulous. All rights reserved.
//

#import "CountryObject.h"

@implementation CountryObject

-(instancetype)initCountryWithName:(NSString *)countryName countryDialingCode:(NSString *)countryDialingCode countryCode:(NSString *)countryCode{

    if (self = [super init]) {
    
        self.countryName = countryName;
        self.countryDialingCode =countryDialingCode;
        self.countryCode = countryCode;
    }
    return self;
}

+(instancetype)countryWithName:(NSString *)countryName countryDialingCode:(NSString *)countryDialingCode countryCode:(NSString *)countryCode{

    return [[self alloc] initCountryWithName:countryName countryDialingCode:countryDialingCode countryCode:countryCode];
}
@end
