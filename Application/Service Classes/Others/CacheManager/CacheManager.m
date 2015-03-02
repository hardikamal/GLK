//
//  CacheManager.m
//  IGA Butler
//
//  Created by Alok on 24/09/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#import "CacheManager.h"

/**
 cache maintainence
 */

static CacheManager *cacheManager = nil;

NSMutableDictionary *dictionary = nil;

@implementation CacheManager

+ (CacheManager *)sharedInstance {
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        if (cacheManager == nil) {
            cacheManager = [[CacheManager alloc]init];
            dictionary = [[NSMutableDictionary alloc]init];
        }
    });
    return cacheManager;
}

- (id)getCachedDataForKey:(NSString *)key {
    id data = [dictionary objectForKey:key];
    if (data) {
        if ([data respondsToSelector:@selector(mutableCopy)]) {
            return [data mutableCopy];
        }
        return [data copy];
    }
    else {
        NSData *object = [[NSUserDefaults standardUserDefaults] objectForKey:key];
        if (object) {
            if ([[NSKeyedUnarchiver unarchiveObjectWithData:object] respondsToSelector:@selector(mutableCopy)]) {
                return [[NSKeyedUnarchiver unarchiveObjectWithData:object] mutableCopy];
            }
            return [[NSKeyedUnarchiver unarchiveObjectWithData:object]copy];
        }
        else {
            return nil;
        }
    }
}

- (void)setCachedData:(id)data ForKey:(NSString *)key onDisk:(BOOL)onDisk {
    if (data && onDisk) {
        NSData *object = [NSKeyedArchiver archivedDataWithRootObject:data];
        if (object) {
            [dictionary setObject:data forKey:key];
            [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
        }
    }
    else if (data) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        [dictionary setObject:data forKey:key];
    }
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)removeObjectForKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [dictionary removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)clearAllData {
}

@end
