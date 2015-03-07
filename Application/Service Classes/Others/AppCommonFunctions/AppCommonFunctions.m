//
//  Last Updated by Alok on 26/02/15.
//  Copyright (c) 2015 Aryansbtloe. All rights reserved.
//

#import "AppCommonFunctions.h"
#import "AppDelegate.h"
#import "CENotifier.h"
#import "KSCrashInstallationEmail.h"
#import "KSCrash.h"
#import "PDKeychainBindings.h"

const char urlKey;
const char viewControllerKey;

@implementation AppCommonFunctions

@synthesize appDelegate;
@synthesize finished;
@synthesize information;
@synthesize location;
@synthesize myLocation;
@synthesize placemark;
@synthesize mediaFocusController;

static AppCommonFunctions *singletonInstance = nil;

+ (AppCommonFunctions *)sharedInstance {
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        if (singletonInstance == nil) {
            singletonInstance = [[AppCommonFunctions alloc]init];
            singletonInstance.appDelegate = APPDELEGATE;
        }
    });
    return singletonInstance;
}

#pragma mark - startup configurations required for this class

- (void)prepareStartup {
    [self enableIQKeyboardManager];
    [self setUpCrashReporter];
    [self firstTimeInitialisations];
    [self registerForNotifications];
}

- (void)firstTimeInitialisations {
    [self getContactsFromAddressBook];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)setUpCrashReporter {return;
   // [self installCrashHandler];
}

- (void)installCrashHandler {
    NSString *userName = @"test user";
    NSString *date = [[NSDate date]string];
    NSString *messageBody = [NSString stringWithFormat:@"Hi ,\n I found this crash on app on %@ .\n Kindly fix this issue :) .\n From \n %@", date, userName];
    NSArray *reciepents = [[NSArray alloc]initWithObjects:@"mobulous041@mobulous.com", nil];
    NSString *subject = @"Crash on application !!!";
    KSCrashInstallationEmail *installation = [KSCrashInstallationEmail sharedInstance];
    installation.recipients = reciepents;
    installation.subject = subject;
    installation.message = messageBody;
    installation.filenameFmt = @"crash-report-%d.txt.gz";
    [installation addConditionalAlertWithTitle:@"Crash Detected"
                                       message:@"The app crashed last time it was launched. Send a crash report?"
                                     yesAnswer:@"Sure!"
                                      noAnswer:@"No thanks"];
    [installation setReportStyle:KSCrashEmailReportStyleApple useDefaultFilenameFormat:YES];
    [installation install];
    [KSCrash sharedInstance].deleteBehaviorAfterSendAll = KSCDeleteAlways;
    [installation sendAllReportsWithCompletion: ^(NSArray *reports, BOOL completed, NSError *error) {
        if (completed) {
            NSLog(@"Sent %d reports", (int)[reports count]);
        }
        else {
            NSLog(@"Failed to send reports: %@", error);
        }
    }];
}

- (void)enableIQKeyboardManager {
    //Enabling keyboard manager
    [[IQKeyboardManager sharedManager] setEnable:YES];
    
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:20];
    //Enabling autoToolbar behaviour. If It is set to NO. You have to manually create IQToolbar for keyboard.
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    
    //Setting toolbar behavious to IQAutoToolbarBySubviews. Set it to IQAutoToolbarByTag to manage previous/next according to UITextField's tag property in increasing order.
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarBySubviews];
    
    //Resign textField if touched outside of UITextField/UITextView.
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
    //Giving permission to modify TextView's frame
    [[IQKeyboardManager sharedManager] setCanAdjustTextView:NO];
    
    //Show TextField placeholder texts on autoToolbar
    [[IQKeyboardManager sharedManager] setShouldShowTextFieldPlaceholder:YES];
    
    [[IQKeyboardManager sharedManager] setShouldPlayInputClicks:YES];
}

- (void)disableIQKeyboardManager {
    //Enabling keyboard manager
    [[IQKeyboardManager sharedManager] setEnable:NO];
    
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:0];
    //Enabling autoToolbar behaviour. If It is set to NO. You have to manually create IQToolbar for keyboard.
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    //Setting toolbar behavious to IQAutoToolbarBySubviews. Set it to IQAutoToolbarByTag to manage previous/next according to UITextField's tag property in increasing order.
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarBySubviews];
    
    //Resign textField if touched outside of UITextField/UITextView.
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:NO];
    
    //Giving permission to modify TextView's frame
    [[IQKeyboardManager sharedManager] setCanAdjustTextView:NO];
    
    //Show TextField placeholder texts on autoToolbar
    [[IQKeyboardManager sharedManager] setShouldShowTextFieldPlaceholder:NO];
    
    [[IQKeyboardManager sharedManager] setShouldPlayInputClicks:NO];
}

- (void)disablePartiallyIQKeyboardManager {
    //Enabling keyboard manager
    [[IQKeyboardManager sharedManager] setEnable:YES];
    
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:20];
    //Enabling autoToolbar behaviour. If It is set to NO. You have to manually create IQToolbar for keyboard.
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    //Setting toolbar behavious to IQAutoToolbarBySubviews. Set it to IQAutoToolbarByTag to manage previous/next according to UITextField's tag property in increasing order.
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarBySubviews];
    
    //Resign textField if touched outside of UITextField/UITextView.
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:NO];
    
    //Giving permission to modify TextView's frame
    [[IQKeyboardManager sharedManager] setCanAdjustTextView:NO];
    
    //Show TextField placeholder texts on autoToolbar
    [[IQKeyboardManager sharedManager] setShouldShowTextFieldPlaceholder:NO];
    
    [[IQKeyboardManager sharedManager] setShouldPlayInputClicks:NO];
}

- (id)getVCObjectOfClass:(Class)classType {
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:[classType description]];
}

#pragma mark - register this class for required notifications

- (void)registerForNotifications {
}

- (void)handleLocalRemoteNotification:(UILocalNotification *)notification {
}

#pragma mark - push notification handler methods

#define ALERT                          @"alert"
#define APS                            @"aps"

- (void)handlePushWith:(NSDictionary *)userInfo {
        NSLog(@"*********\n\nPUSH NOTIFICATION RECEIVED \n%@\n*********", userInfo);
        NSString *alertMessage = [[userInfo objectForKey:APS]objectForKey:ALERT];
        
        ALAlertBannerStyle randomStyle = ALAlertBannerStyleNotify;
        ALAlertBannerPosition position = ALAlertBannerPositionUnderNavBar;
        ALAlertBanner *banner = [ALAlertBanner alertBannerForView:WINDOW_OBJECT style:randomStyle position:position title:@"Application" subtitle:alertMessage tappedBlock: ^(ALAlertBanner *alertBanner) {
            [alertBanner hide];
            information = userInfo;
            [self performSelectorOnMainThread:@selector(openPushNotificationBasedScreen) withObject:nil waitUntilDone:NO];
        }];
        banner.secondsToShow = 8;
        banner.showAnimationDuration = 0.2;
        banner.hideAnimationDuration = 0.1;
        [banner show];
}

- (void)openPushNotificationBasedScreen {
    if ([self isNotNull:information]) {
    }
}

- (NSURL *)getUrlWithComponentPath:(NSString *)path {
    if ([path contains:@"http"]) {
        return [path urlByURLDecode];
    }
    return [[NSString stringWithFormat:@"%@%@", BASE_URL, path] urlByURLDecode];
}

- (NSString *)getUrlStringWithComponentPath:(NSString *)path {
    if ([path contains:@"http"]) {
        return [path stringByURLDecode];
    }
    return [[NSString stringWithFormat:@"%@%@", BASE_URL, path] stringByURLDecode];
}

- (void)presentVCOfClass:(Class)class1 fromVC:(UIViewController *)nc animated:(BOOL)animated modifyVC:(operationACFFinishedBlock)modify {
    RESIGN_KEYBOARD
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:[class1 description]];
    if (modify) {
        modify(vc);
        modify = nil;
    }
    [nc presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:animated completion:nil];
}

- (void)pushVCOfClass:(Class)class1 fromNC:(UINavigationController *)nc animated:(BOOL)animated popFirstToVCOfClass:(Class)class2 modifyVC:(operationACFFinishedBlock)modify {
    RESIGN_KEYBOARD
    [self popToViewControllerOfKind : class2 from : nc];
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:[class1 description]];
    if (modify) {
        modify(vc);
        modify = nil;
    }
    [nc pushViewController:vc animated:animated];
    
    NOTIFY_TO_UPDATE_LAYOUT_CUSTOM
}

- (void)pushVCOfClass:(Class)class1 fromNC:(UINavigationController *)nc animated:(BOOL)animated setRootViewController:(BOOL)isRootViewController modifyVC:(operationACFFinishedBlock)modify {
    RESIGN_KEYBOARD
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:[class1 description]];
    if (modify) {
        modify(vc);
        modify = nil;
    }
    if (isRootViewController) {
        [nc setViewControllers:[NSMutableArray arrayWithObject:vc] animated:animated];
    }
    else {
        [nc pushViewController:vc animated:animated];
    }
    
    NOTIFY_TO_UPDATE_LAYOUT_CUSTOM
}

- (UIViewController *)popToViewControllerOfKind:(Class)aClass from:(UINavigationController *)navController {
    RESIGN_KEYBOARD
    if (aClass) {
        NSArray *arrayOfViewControllersInStack = navController.viewControllers;
        for (int i = 0; i < arrayOfViewControllersInStack.count; i++) {
            if ([[arrayOfViewControllersInStack objectAtIndex:i] isKindOfClass:aClass]) {
                int index = (i > 0) ? (i - 1) : i;
                [navController popToViewController:[arrayOfViewControllersInStack objectAtIndex:index] animated:YES];
                break;
            }
        }
        return [navController topViewController];
    }
    return nil;
}

- (void)setCommonlyUsedSeperatorOnTableView:(UITableView *)tableView {
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)updateLocationRelatedDetails {
    float latitude = [[NSUserDefaults standardUserDefaults]floatForKey:@"latitude"];
    float longitude = [[NSUserDefaults standardUserDefaults]floatForKey:@"longitude"];
    myLocation = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    __weak AppCommonFunctions *weakSelf = self;
    self.location = [[LBLocation alloc] initWithLocationUpdateBlock: ^(CLLocation *location) {
        weakSelf.myLocation = location;
        [weakSelf.location reverseGeocodeCurrentLocationWithCompletionBlock: ^(CLPlacemark *placemark) {
            weakSelf.placemark = placemark;
            [[NSUserDefaults standardUserDefaults]saveFloat:placemark.location.coordinate.latitude forKey:@"latitude"];
            [[NSUserDefaults standardUserDefaults]saveFloat:placemark.location.coordinate.longitude forKey:@"longitude"];
            float latitude = [[NSUserDefaults standardUserDefaults]floatForKey:@"latitude"];
            float longitude = [[NSUserDefaults standardUserDefaults]floatForKey:@"longitude"];
            weakSelf.myLocation = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
        }];
    }];
}

#define kKeyVendor @"ApplicationDeviceIdentifier"

+ (NSString *)uniqueVendor {
    PDKeychainBindings *keychain = [PDKeychainBindings sharedKeychainBindings];
    NSString *uniqueIdentifier = [keychain objectForKey:kKeyVendor];
    if (!uniqueIdentifier || !uniqueIdentifier.length) {
        NSUUID *udid = [[UIDevice currentDevice] identifierForVendor];
        uniqueIdentifier = [udid UUIDString];
        [keychain setObject:uniqueIdentifier forKey:kKeyVendor];
    }
    return uniqueIdentifier;
}

- (void)showImage:(UIImage *)image fromView:(UIView *)fromView {
    mediaFocusController = [[URBMediaFocusViewController alloc] init];
    [mediaFocusController setShouldDismissOnTap:YES];
    [mediaFocusController setShouldDismissOnImageTap:YES];
    [mediaFocusController showImage:image fromView:fromView];
}

#pragma mark - single method to handle open video from url

- (void)setOpenVideoOnTapEventFrom:(UIView *)view forVideoUrl:(NSString *)url_ fromViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[UIViewController class]] && [viewController navigationController]) {
        NSArray *previousllyAddedRecognisers = view.gestureRecognizers;
        for (int i = 0; i < previousllyAddedRecognisers.count; i++) {
            [view removeGestureRecognizer:[previousllyAddedRecognisers objectAtIndex:i]];
        }
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openVideoPlayer:)];
        objc_setAssociatedObject(singleTap, &urlKey, url_, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(singleTap, &viewControllerKey, viewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        singleTap.numberOfTapsRequired = 1;
        [view addGestureRecognizer:singleTap];
        [view setUserInteractionEnabled:TRUE];
    }
    else {
        NSLog(@"one or more of the information is not correct here..............simply ignoring");
    }
}

- (void)openVideoPlayer:(UITapGestureRecognizer *)recogniser {
    RETURN_IF_NO_INTERNET_AVAILABLE_WITH_USER_WARNING
    NSString *url_ = objc_getAssociatedObject(recogniser, &urlKey);
    UIViewController *viewController = objc_getAssociatedObject(recogniser, &viewControllerKey);
    if ([self isNotNull:url_] && [self isNotNull:viewController]) {
        [viewController presentMoviePlayerViewControllerAnimated:[[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:url_]]];
    }
}

- (void)playVideoFromUrl:(NSURL *)url fromViewController:(UIViewController *)viewController {
    NSLog(@"url \n %@", url);
    if ([self isNotNull:url]) {
        [viewController presentMoviePlayerViewControllerAnimated:[[MPMoviePlayerViewController alloc]initWithContentURL:url]];
    }
}

- (void)playVideoFromFilePath:(NSString *)filePath fromViewController:(UIViewController *)viewController {
    NSLog(@"filePath \n %@", filePath);
    if ([FCFileManager isFileItemAtPath:filePath]) {
        BOOL useDefaultPlayer = YES;
        if (useDefaultPlayer) {
            [viewController presentMoviePlayerViewControllerAnimated:[[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL fileURLWithPath:filePath]]];
        }
        else {
        }
    }
    else {
        NSLog(@"filePath \n %@ \ndoesn't exist", filePath);
    }
}

- (void)setAttributedPlaceHolder:(NSString *)ph OnTextFeild:(UITextField *)tf withFont:(UIFont *)f withTextColor:(UIColor *)c {
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithString:ph];
    [attributedText addAttribute:NSForegroundColorAttributeName value:c range:NSMakeRange(0, attributedText.length)];
    [attributedText addAttribute:NSFontAttributeName value:f range:NSMakeRange(0, attributedText.length)];
    [tf setAttributedPlaceholder:attributedText];
}

- (NSMutableArray *)getContactsFromAddressBook {
    {
        CFErrorRef error = nil;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            if (error) {
                NSLog(@"error %@", error);
            }
            else if (granted) {
                // Do what you want with the Address Book
            }
            else {
                NSLog(@"permission denied");
            }
            CFRelease(addressBook);
        });
    }
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    if (addressBook) {
        NSArray *allContacts = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
        NSMutableArray *mutableContacts = [NSMutableArray arrayWithCapacity:allContacts.count];
        NSUInteger i = 0;
        for (i = 0; i < [allContacts count]; i++) {
            THContact *contact = [[THContact alloc] init];
            ABRecordRef contactPerson = (__bridge ABRecordRef)allContacts[i];
            contact.recordId = ABRecordGetRecordID(contactPerson);
            NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
            NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
            contact.firstName = firstName;
            contact.lastName = lastName;
            ABMultiValueRef phonesRef = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
            contact.phone = [self getMobilePhoneProperty:phonesRef];
            if (phonesRef) {
                CFRelease(phonesRef);
            }
            if ((contact.firstName.length > 0) && (contact.phone.length > 0)) {
                [mutableContacts addObject:contact];
            }
        }
        if (addressBook) {
            CFRelease(addressBook);
        }
        return [[NSMutableArray alloc]initWithArray:mutableContacts];
    }
    return [[NSMutableArray alloc]init];
}

- (NSString *)getMobilePhoneProperty:(ABMultiValueRef)phonesRef {
    for (int i = 0; i < ABMultiValueGetCount(phonesRef); i++) {
        CFStringRef currentPhoneLabel = ABMultiValueCopyLabelAtIndex(phonesRef, i);
        CFStringRef currentPhoneValue = ABMultiValueCopyValueAtIndex(phonesRef, i);
        if (currentPhoneLabel) {
            if (CFStringCompare(currentPhoneLabel, kABPersonPhoneMobileLabel, 0) == kCFCompareEqualTo) {
                return (__bridge NSString *)currentPhoneValue;
            }
            if (CFStringCompare(currentPhoneLabel, kABHomeLabel, 0) == kCFCompareEqualTo) {
                return (__bridge NSString *)currentPhoneValue;
            }
        }
        if (currentPhoneLabel) {
            CFRelease(currentPhoneLabel);
        }
        if (currentPhoneValue) {
            CFRelease(currentPhoneValue);
        }
    }
    return nil;
}

- (void)refreshContact:(THContact *)contact from:(ABAddressBookRef)addressBookRef {
    ABRecordRef contactPerson = ABAddressBookGetPersonWithRecordID(addressBookRef, (ABRecordID)contact.recordId);
    contact.recordId = ABRecordGetRecordID(contactPerson);
    NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
    NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
    contact.firstName = firstName;
    contact.lastName = lastName;
    ABMultiValueRef phonesRef = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
    contact.phone = [self getMobilePhoneProperty:phonesRef];
    if (phonesRef) {
        CFRelease(phonesRef);
    }
}

@end
