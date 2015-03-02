//
//  AppDelegate.h
//  Application
//
//  Created by Alok on 5/6/14.
//  Copyright (c) 2015 aryansbtloe. All rights reserved.
//

#import <UIKit/UIKit.h>

BOOL optionViewFlag;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UINavigationController *navigationController;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
+ (AppDelegate*) getAppDelegate;
@end
