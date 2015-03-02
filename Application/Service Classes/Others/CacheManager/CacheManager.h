//
//  CacheManager.h
//  IGA Butler
//
//  Created by Alok on 24/09/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheManager : NSObject

+ (CacheManager *)sharedInstance;
- (id)getCachedDataForKey:(NSString *)key;
- (void)setCachedData:(id)data ForKey:(NSString *)key onDisk:(BOOL)onDisk;
- (void)removeObjectForKey:(NSString *)key;
- (void)clearAllData;

@end
