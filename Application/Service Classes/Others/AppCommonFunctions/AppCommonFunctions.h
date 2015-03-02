//
//  Last Updated by Alok on 26/02/15.
//  Copyright (c) 2015 Aryansbtloe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "ALAlertBanner.h"
#import "LBLocation.h"
#import "URBMediaFocusViewController.h"
#import "RDVTabBarController.h"
#import <AddressBook/AddressBook.h>
#import "THContact.h"

/**
 
 AppCommonFunctions:-
 This singleton class implements some app specific methods which are frequently needed in application.
 
 */

typedef void (^operationACFFinishedBlock)(id info);

@interface AppCommonFunctions : UIViewController

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) operationACFFinishedBlock finished;
@property (nonatomic, strong) NSMutableDictionary *information;
@property (nonatomic, strong) LBLocation *location;
@property (nonatomic, strong) CLLocation *myLocation;
@property (nonatomic, strong) CLPlacemark *placemark;
@property (nonatomic, strong) URBMediaFocusViewController *mediaFocusController;

+ (AppCommonFunctions *)sharedInstance;
- (void)prepareStartup;
- (void)handleLocalRemoteNotification:(UILocalNotification *)notification;
- (void)handlePushWith:(NSDictionary *)userInfo;
- (void)enableIQKeyboardManager;
- (void)disableIQKeyboardManager;
- (void)disablePartiallyIQKeyboardManager;
- (id)getVCObjectOfClass:(Class)classType;
- (void)presentVCOfClass:(Class)class1 fromVC:(UIViewController *)nc animated:(BOOL)animated modifyVC:(operationACFFinishedBlock)modify;
- (void)pushVCOfClass:(Class)class1 fromNC:(UINavigationController *)nc animated:(BOOL)animated popFirstToVCOfClass:(Class)class2 modifyVC:(operationACFFinishedBlock)modify;
- (void)pushVCOfClass:(Class)class1 fromNC:(UINavigationController *)nc animated:(BOOL)animated setRootViewController:(BOOL)isRootViewController modifyVC:(operationACFFinishedBlock)modify;
- (UIViewController *)popToViewControllerOfKind:(Class)aClass from:(UINavigationController *)navController;
- (NSURL *)getUrlWithComponentPath:(NSString *)path;
- (NSString *)getUrlStringWithComponentPath:(NSString *)path;
- (void)setCommonlyUsedSeperatorOnTableView:(UITableView *)tableView;
- (void)updateLocationRelatedDetails;
+ (NSString *)uniqueVendor;
- (void)playVideoFromUrl:(NSURL *)url fromViewController:(UIViewController *)viewController;
- (void)playVideoFromFilePath:(NSString *)filePath fromViewController:(UIViewController *)viewController;
- (void)setOpenVideoOnTapEventFrom:(UIView *)view forVideoUrl:(NSString *)url_ fromViewController:(UIViewController *)viewController;
- (void)showImage:(UIImage *)image fromView:(UIView *)fromView;
- (void)setAttributedPlaceHolder:(NSString *)ph OnTextFeild:(UITextField *)tf withFont:(UIFont *)f withTextColor:(UIColor *)c;
- (void)prepareViewWhenUserIsLoggedInFrom:(UINavigationController *)navigationController;
- (NSMutableArray *)getContactsFromAddressBook;
- (void)refreshContact:(THContact *)contact from:(ABAddressBookRef)addressBookRef;

@end
