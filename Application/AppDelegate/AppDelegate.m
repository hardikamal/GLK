//
//  AppDelegate.m
//  Application
//
//  Created by Alok on 5/6/14.
//  Copyright (c) 2015 aryansbtloe. All rights reserved.
//

#import "AppDelegate.h"
#import "AppCommonFunctions.h"

@implementation AppDelegate

@synthesize navigationController;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initializeGlobalData];
    [self copyDatabaseIfNeeded];
    [self initializeContents];
    [self prepareForApplePushNotificationsService];
    [self initializeWindowAndStartUpViewController];
    [self afterInitialisationSetup];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[AppCommonFunctions sharedInstance]handlePushWith:[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]];
    });
    
    [[AppCommonFunctions sharedInstance]getContactsFromAddressBook];
    return YES;
}
- (void) copyDatabaseIfNeeded
{
    //Using NSFileManager we can perform many file system operations.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSString *dbPath = [self getDBPath];
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    
    if(!success) {
        
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"demservices.sqlite"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        
        if (!success)
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}
- (void)initializeGlobalData {    
    fontRegular9  = [UIFont fontWithName:FONT_REGULAR size:9];
    fontRegular10 = [UIFont fontWithName:FONT_REGULAR size:10];
    fontRegular11 = [UIFont fontWithName:FONT_REGULAR size:11];
    fontRegular12 = [UIFont fontWithName:FONT_REGULAR size:12];
    fontRegular13 = [UIFont fontWithName:FONT_REGULAR size:13];
    fontRegular14 = [UIFont fontWithName:FONT_REGULAR size:14];
    fontRegular15 = [UIFont fontWithName:FONT_REGULAR size:15];
    fontRegular16 = [UIFont fontWithName:FONT_REGULAR size:16];
    fontRegular17 = [UIFont fontWithName:FONT_REGULAR size:17];
    fontRegular18 = [UIFont fontWithName:FONT_REGULAR size:18];
    fontRegular19 = [UIFont fontWithName:FONT_REGULAR size:19];
    fontRegular20 = [UIFont fontWithName:FONT_REGULAR size:20];
    fontRegular26 = [UIFont fontWithName:FONT_REGULAR size:26];
    
    fontSemiBold9  = [UIFont fontWithName:FONT_SEMI_BOLD size:9];
    fontSemiBold10 = [UIFont fontWithName:FONT_SEMI_BOLD size:10];
    fontSemiBold11 = [UIFont fontWithName:FONT_SEMI_BOLD size:11];
    fontSemiBold12 = [UIFont fontWithName:FONT_SEMI_BOLD size:12];
    fontSemiBold13 = [UIFont fontWithName:FONT_SEMI_BOLD size:13];
    fontSemiBold14 = [UIFont fontWithName:FONT_SEMI_BOLD size:14];
    fontSemiBold15 = [UIFont fontWithName:FONT_SEMI_BOLD size:15];
    fontSemiBold16 = [UIFont fontWithName:FONT_SEMI_BOLD size:16];
    fontSemiBold17 = [UIFont fontWithName:FONT_SEMI_BOLD size:17];
    fontSemiBold18 = [UIFont fontWithName:FONT_SEMI_BOLD size:18];
    fontSemiBold19 = [UIFont fontWithName:FONT_SEMI_BOLD size:19];
    fontSemiBold20 = [UIFont fontWithName:FONT_SEMI_BOLD size:20];
    fontSemiBold26 = [UIFont fontWithName:FONT_SEMI_BOLD size:26];
    
    fontBold9  = [UIFont fontWithName:FONT_BOLD size:9];
    fontBold10 = [UIFont fontWithName:FONT_BOLD size:10];
    fontBold11 = [UIFont fontWithName:FONT_BOLD size:11];
    fontBold12 = [UIFont fontWithName:FONT_BOLD size:12];
    fontBold13 = [UIFont fontWithName:FONT_BOLD size:13];
    fontBold14 = [UIFont fontWithName:FONT_BOLD size:14];
    fontBold15 = [UIFont fontWithName:FONT_BOLD size:15];
    fontBold16 = [UIFont fontWithName:FONT_BOLD size:16];
    fontBold17 = [UIFont fontWithName:FONT_BOLD size:17];
    fontBold18 = [UIFont fontWithName:FONT_BOLD size:18];
    fontBold19 = [UIFont fontWithName:FONT_BOLD size:19];
    fontBold20 = [UIFont fontWithName:FONT_BOLD size:20];
    fontBold26 = [UIFont fontWithName:FONT_BOLD size:26];

}

- (void)initializeContents {
    navigationController = (UINavigationController *)self.window.rootViewController;
    [[AppCommonFunctions sharedInstance]prepareStartup];
    if ([AKSMethods isApplicationUpdated]) {
        [CommonFunctions clearApplicationCaches];
    }
    if ([self isNull:PUSH_NOTIFICATION_TOKEN] || ((NSString *)PUSH_NOTIFICATION_TOKEN).length == 0) {
        [[NSUserDefaults standardUserDefaults]setObject:@"CD9B999D192133CB346602713B1D831D24896939444B42A97CFE380FADA3098A" forKey:PUSH_NOTIFICATION_DEVICE_TOKEN];
    }
}

#pragma mark - Methods for initialising window and startup view controllers

- (void)initializeWindowAndStartUpViewController {
    [self prepareViews];
    [self.window setBackgroundColor:[UIColor blackColor]];
    [self.window makeKeyAndVisible];
}

- (void)afterInitialisationSetup {
    [[UITextField appearance] setTintColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    [[UIView appearanceWhenContainedIn:[UIAlertController class], nil] setTintColor:GREEN_COLOR];

}

- (void)application:(UIApplication *)application didChangeStatusBarFrame:(CGRect)oldStatusBarFrame {
    NOTIFY_TO_UPDATE_LAYOUT_CUSTOM
}

- (void)prepareViews {
}

#pragma mark - Local Notifications Delegate Methods

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [[AppCommonFunctions sharedInstance]handleLocalRemoteNotification:notification];
}

#pragma mark - Apple Push Notifications Service Methods

- (void)prepareForApplePushNotificationsService {
    CLEAR_NOTIFICATION_BADGE
    REGISTER_APPLICATION_FOR_NOTIFICATION_SERVICE
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[NSUserDefaults standardUserDefaults]setObject:[AKSMethods stringWithDeviceToken:deviceToken] forKey:PUSH_NOTIFICATION_DEVICE_TOKEN];
    NSLog(@"Push notification device token %@", [[NSUserDefaults standardUserDefaults]objectForKey:PUSH_NOTIFICATION_DEVICE_TOKEN]);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Push notification failed");
    [[NSUserDefaults standardUserDefaults]setObject:@"CD9B999D192133CB346602713B1D831D24896939444B42A97CFE380FADA3098A" forKey:PUSH_NOTIFICATION_DEVICE_TOKEN];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[AppCommonFunctions sharedInstance] handlePushWith:userInfo];
}


#pragma mark - Application Life Cycle Methods

- (void)applicationWillResignActive:(UIApplication *)application {
    [AKSMethods syncroniseNSUserDefaults];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [AKSMethods syncroniseNSUserDefaults];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [AKSMethods syncroniseNSUserDefaults];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NOTIFY_TO_UPDATE_LAYOUT_CUSTOM
    if ([AKSMethods isNeedToClearCache]) {
        [CommonFunctions clearApplicationCaches];
    }
    [AKSMethods syncroniseNSUserDefaults];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [AKSMethods syncroniseNSUserDefaults];
}

#pragma mark - Memory management methods

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [CommonFunctions clearApplicationCaches];
}



- (NSString *) getDBPath
{
    //Search for standard documents using NSSearchPathForDirectoriesInDomains
    //First Param = Searching the documents directory
    //Second Param = Searching the Users directory and not the System
    //Expand any tildes and identify home directories.
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    //NSLog(@"dbpath : %@",documentsDir);
    return [documentsDir stringByAppendingPathComponent:@"demservices.sqlite"];
}



+ (AppDelegate*) getAppDelegate
{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    NSURL *demURL = [[NSBundle mainBundle] URLForResource:@"Daily_Expense_Manager" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:demURL];
    
    //    NSURL *appURL = [[NSBundle mainBundle] URLForResource:@"DemApp" withExtension:@"momd"];
    //    NSManagedObjectModel *appModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:appURL];
    //    // merge the models
    //    _managedObjectModel = [NSManagedObjectModel modelByMergingModels:[NSArray arrayWithObjects:appModel, demModel, nil]];
    
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    NSError *error = nil;
    NSURL *appURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"DemApp.sqlite"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:[appURL path]])
    {
        NSURL *preloadURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"demservices" ofType:@"sqlite"]];
        NSError* err = nil;
        if (![[NSFileManager defaultManager] copyItemAtURL:preloadURL toURL:appURL error:&err])
        {
            NSLog(@"Oops, could copy preloaded data");
        }
    }
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:appURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Daily_Expense_Manager.sqlite"];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory
// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
