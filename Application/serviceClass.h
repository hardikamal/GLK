//
//  serviceClass.h
//  HomeWell
//
//  Created by user on 3/27/14.
//  Copyright (c) 2014 Ajay Awasthi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface serviceClass : NSObject

+(NSDictionary *)showfeedByanotherService:(NSString *)serviceName dictionary:(NSMutableDictionary *)tempDictionary;
+(UIView *)addStattusBarView;
-(void)startAnimator:(UIViewController *)controller;
-(void)stopAnimator:(UIViewController *)controller;
-(void)SignUpwithServer:(NSDictionary*)responseDict :(UIImage*)image;
@end
