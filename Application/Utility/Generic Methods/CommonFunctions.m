//
//  Last Updated by Alok on 26/02/15.
//  Copyright (c) 2015 Aryansbtloe. All rights reserved.
//

#import "CommonFunctions.h"
#import "AppDelegate.h"
#import "Reachability.h"
#import "TSMessage.h"
#import "JDStatusBarNotification.h"
#import "KVNProgress.h"
#import "AFMInfoBanner.h"

@implementation CommonFunctions


+ (NSString *)documentsDirectory {
    NSArray *paths =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    return [paths objectAtIndex:0];
}

+ (void)openEmail:(NSString *)address {
    NSString *url = [NSString stringWithFormat:@"mailto://%@", address];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+ (void)openPhone:(NSString *)number {
    NSString *url = [NSString stringWithFormat:@"tel://%@", number];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+ (void)openSms:(NSString *)number {
    NSString *url = [NSString stringWithFormat:@"sms://%@", number];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+ (void)openBrowser:(NSString *)url {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+ (void)openMap:(NSString *)address {
    NSString *addressText = [address stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString *url = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@", addressText];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+ (BOOL)isRetinaDisplay {
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {
        return YES;
    }
    else {
        return NO;
    }
}

+ (void)setNavigationTitle:(NSString *)title ForNavigationItem:(UINavigationItem *)navigationItem {
    float width = 320.0f;
    
    if (navigationItem.leftBarButtonItem.customView && navigationItem.rightBarButtonItem.customView) {
        width = 320 - (navigationItem.leftBarButtonItem.customView.frame.size.width + navigationItem.rightBarButtonItem.customView.frame.size.width + 20);
    }
    else if (navigationItem.leftBarButtonItem.customView && !navigationItem.rightBarButtonItem.customView) {
        width = 320 - (navigationItem.leftBarButtonItem.customView.frame.size.width * 2);
    }
    else if (!navigationItem.leftBarButtonItem.customView && !navigationItem.rightBarButtonItem.customView) {
        width = 320 - (2 * navigationItem.rightBarButtonItem.customView.frame.size.width);
    }
    
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:title attributes:@{ NSFontAttributeName: [UIFont fontWithName:FONT_SEMI_BOLD size:20.0] }];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize) {320, 20 }
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize textSize = rect.size;
    textSize.height = ceilf(textSize.height);
    textSize.width  = ceilf(textSize.width);
    
    if (textSize.width < width)
        width = textSize.width;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, 44.0f)];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 6.0f, width, 32.0f)];
    
    //[titleLbl setFont:[UIFont fontWithName:FONT_SEMI_BOLD size:17.0]];
    [titleLbl setFont:[UIFont boldSystemFontOfSize:17.0f]];
    [titleLbl setBackgroundColor:[UIColor clearColor]];
    [titleLbl setTextAlignment:NSTextAlignmentCenter];
    [titleLbl setTextColor:[UIColor whiteColor]];
    [titleLbl setShadowColor:[UIColor clearColor]];
    [titleLbl setShadowOffset:CGSizeMake(0.0f, 1.0f)];
    [titleLbl setText:title];
    
    [view addSubview:titleLbl];
    
    [navigationItem setTitleView:view];
}

#pragma mark - common method for setting navigation bar background image

+ (void)setNavigationBarBackgroundWithImageName:(NSString *)imageName fromViewController:(UIViewController *)viewController {
    if ([self isNotNull:imageName] && [viewController.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:imageName]
                                                                forBarMetrics:UIBarMetricsDefault];
    }
}

+ (void)setNavigationBarBackgroundWithImage:(UIImage *)image fromViewController:(UIViewController *)viewController {
    if ([self isNotNull:image] && [viewController.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [viewController.navigationController.navigationBar setBackgroundImage:image
                                                                forBarMetrics:UIBarMetricsDefault];
        [viewController.navigationController.navigationBar setTranslucent:YES];
        [viewController.navigationController.navigationBar setOpaque:NO];
    }
}

#pragma mark - common method for setting navigation bar  title image view

+ (void)setNavigationBarTitleImage:(NSString *)imageName WithViewController:(UIViewController *)caller {
    UIImage *imageToUse =    [UIImage imageNamed:imageName];
    UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, imageToUse.size.width, imageToUse.size.height)];
    [titleView setImage:imageToUse];
    [caller.navigationItem setTitleView:titleView];
    [AKSMethods addSingleTapGestureRecogniserTo:titleView forSelector:@selector(navigationBarTappedAtCenter) ofObject:[AppCommonFunctions sharedInstance]];
}

#pragma mark - Common method to add navigation bar buttons

#define MINIMUM_BUTTON_WIDTH_FOR_SINGLE_BUTTONS 40
#define MINIMUM_BUTTON_WIDTH_FOR_DOUBLE_BUTTONS 30

+ (void)processSingleNavigationButtons:(UIButton *)button {
    if ([self isNotNull:button] && (button.size.width < MINIMUM_BUTTON_WIDTH_FOR_SINGLE_BUTTONS)) {
        float x = button.frame.origin.x;
        float y = button.frame.origin.y;
        float w = MINIMUM_BUTTON_WIDTH_FOR_SINGLE_BUTTONS;
        float h = button.frame.size.height;
        [button setFrame:CGRectMake(x, y, w, h)];
    }
}

+ (void)processDoubleNavigationButtons:(UIButton *)button {
    if ([self isNotNull:button] && (button.size.width < MINIMUM_BUTTON_WIDTH_FOR_DOUBLE_BUTTONS)) {
        float x = button.frame.origin.x;
        float y = button.frame.origin.y;
        float w = MINIMUM_BUTTON_WIDTH_FOR_DOUBLE_BUTTONS;
        float h = button.frame.size.height;
        [button setFrame:CGRectMake(x, y, w, h)];
    }
}

/**
 common method to add navigation bar buttons
 */
+ (void)addLeftNavigationBarButton:(UIViewController *)caller withImageName:(NSString *)imageName WithNegativeSpacerValue:(int)value {
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBarButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [leftBarButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_hover", imageName]] forState:UIControlStateHighlighted];
    [leftBarButton setFrame:CGRectMake(0.0f, 0.0f, leftBarButton.imageView.image.size.width, NAVIGATION_BAR_HEIGHT)];
    [self processSingleNavigationButtons:leftBarButton];
    
    if ([caller respondsToSelector:@selector(onClickOfLeftNavigationBarButton:)]) [leftBarButton addTarget:caller action:@selector(onClickOfLeftNavigationBarButton:) forControlEvents:UIControlEventTouchUpInside];
    else {
        NSLog(@"\n\n%@ class forgets to implement onClickOfLeftNavigationBarButton method\n", [AKSMethods getClassNameForObject:caller]);
    }
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = value;
    caller.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, [[UIBarButtonItem alloc] initWithCustomView:leftBarButton], nil];
}

+ (void)addRightNavigationBarButton:(UIViewController *)caller withImageName:(NSString *)imageName WithNegativeSpacerValue:(int)value {
    UIButton *rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBarButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [rightBarButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_hover", imageName]] forState:UIControlStateHighlighted];
    [rightBarButton setFrame:CGRectMake(0.0f, 0.0f, rightBarButton.imageView.image.size.width, NAVIGATION_BAR_HEIGHT)];
    [self processSingleNavigationButtons:rightBarButton];
    
    if ([caller respondsToSelector:@selector(onClickOfRightNavigationBarButton:)]) [rightBarButton addTarget:caller action:@selector(onClickOfRightNavigationBarButton:) forControlEvents:UIControlEventTouchUpInside];
    else {
        NSLog(@"\n\n%@ class forgets to implement onClickOfRightNavigationBarButton method\n", [AKSMethods getClassNameForObject:caller]);
    }
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = value;
    caller.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, [[UIBarButtonItem alloc] initWithCustomView:rightBarButton], nil];
}

+ (void)addTwoLeftNavigationBarButton:(UIViewController *)caller withImageName1:(NSString *)imageName1 withImageName2:(NSString *)imageName2 WithNegativeSpacerValue:(int)value {
    UIButton *leftBarButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBarButton1 setImage:[UIImage imageNamed:imageName1] forState:UIControlStateNormal];
    [leftBarButton1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_hover", imageName1]] forState:UIControlStateHighlighted];
    [leftBarButton1 setFrame:CGRectMake(0.0f, 0.0f, leftBarButton1.imageView.image.size.width, NAVIGATION_BAR_HEIGHT)];
    [self processDoubleNavigationButtons:leftBarButton1];
    
    if ([caller respondsToSelector:@selector(onClickOfLeftNavigationBarButton1:)]) [leftBarButton1 addTarget:caller action:@selector(onClickOfLeftNavigationBarButton1:) forControlEvents:UIControlEventTouchUpInside];
    else {
        NSLog(@"\n\n%@ class forgets to implement onClickOfLeftNavigationBarButton1 method\n", [AKSMethods getClassNameForObject:caller]);
    }
    
    
    UIButton *leftBarButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBarButton2 setImage:[UIImage imageNamed:imageName2] forState:UIControlStateNormal];
    [leftBarButton2 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_hover", imageName2]] forState:UIControlStateHighlighted];
    [leftBarButton2 setFrame:CGRectMake(0.0f, 0.0f, leftBarButton2.imageView.image.size.width, NAVIGATION_BAR_HEIGHT)];
    [self processDoubleNavigationButtons:leftBarButton2];
    
    if ([caller respondsToSelector:@selector(onClickOfLeftNavigationBarButton2:)]) [leftBarButton2 addTarget:caller action:@selector(onClickOfLeftNavigationBarButton2:) forControlEvents:UIControlEventTouchUpInside];
    else {
        NSLog(@"\n\n%@ class forgets to implement onClickOfLeftNavigationBarButton2 method\n", [AKSMethods getClassNameForObject:caller]);
    }
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = value;
    caller.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:
                                                negativeSpacer,
                                                [[UIBarButtonItem alloc] initWithCustomView:leftBarButton1],
                                                [[UIBarButtonItem alloc] initWithCustomView:leftBarButton2],
                                                nil];
}

+ (void)addTwoRightNavigationBarButton:(UIViewController *)caller withImageName1:(NSString *)imageName1 withImageName2:(NSString *)imageName2 WithNegativeSpacerValue:(int)value {
    UIButton *rightBarButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBarButton1 setImage:[UIImage imageNamed:imageName1] forState:UIControlStateNormal];
    [rightBarButton1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_hover", imageName1]] forState:UIControlStateHighlighted];
    [rightBarButton1 setFrame:CGRectMake(0.0f, 0.0f, rightBarButton1.imageView.image.size.width, NAVIGATION_BAR_HEIGHT)];
    [self processDoubleNavigationButtons:rightBarButton1];
    
    if ([caller respondsToSelector:@selector(onClickOfRightNavigationBarButton1:)]) [rightBarButton1 addTarget:caller action:@selector(onClickOfRightNavigationBarButton1:) forControlEvents:UIControlEventTouchUpInside];
    else {
        NSLog(@"\n\n%@ class forgets to implement onClickOfRightNavigationBarButton1 method\n", [AKSMethods getClassNameForObject:caller]);
    }
    
    
    UIButton *rightBarButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBarButton2 setImage:[UIImage imageNamed:imageName2] forState:UIControlStateNormal];
    [rightBarButton2 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_hover", imageName2]] forState:UIControlStateHighlighted];
    [rightBarButton2 setFrame:CGRectMake(0.0f, 0.0f, rightBarButton2.imageView.image.size.width, NAVIGATION_BAR_HEIGHT)];
    [self processDoubleNavigationButtons:rightBarButton2];
    
    if ([caller respondsToSelector:@selector(onClickOfRightNavigationBarButton2:)]) [rightBarButton2 addTarget:caller action:@selector(onClickOfRightNavigationBarButton2:) forControlEvents:UIControlEventTouchUpInside];
    else {
        NSLog(@"\n\n%@ class forgets to implement onClickOfRightNavigationBarButton2 method\n", [AKSMethods getClassNameForObject:caller]);
    }
    
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                   target:nil action:nil];
    fixedSpace.width = 10;
    
    negativeSpacer.width = value;
    caller.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:
                                                 negativeSpacer,
                                                 [[UIBarButtonItem alloc] initWithCustomView:rightBarButton2],
                                                 fixedSpace,
                                                 [[UIBarButtonItem alloc] initWithCustomView:rightBarButton1],
                                                 nil];
}

/**
 common method to add navigation bar buttons
 */
+ (void)addLeftNavigationBarButton:(UIViewController *)caller withImageName:(NSString *)imageName WithTitle:(NSString *)title WithNegativeSpacerValue:(int)value {
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (title) {
        [leftBarButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [leftBarButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_hover", imageName]] forState:UIControlStateHighlighted];
    }
    else {
        [leftBarButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [leftBarButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_hover", imageName]] forState:UIControlStateHighlighted];
    }
    
    [leftBarButton setFrame:CGRectMake(0.0f, (NAVIGATION_BAR_HEIGHT - leftBarButton.currentImage.size.height) / 2, leftBarButton.currentImage.size.width + [title sizeWithFont:leftBarButton.font].width, leftBarButton.currentImage.size.height)];
    [leftBarButton setTitle:title forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor colorWithRed:32.0f / 255.0f green:121.0f / 255.0f blue:255.0f / 255.0f alpha:1.0f] forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor colorWithRed:32.0f / 255.0f green:121.0f / 255.0f blue:255.0f / 255.0f alpha:1.0f] forState:UIControlStateHighlighted];
    
    //[[leftBarButton titleLabel]setFont:fontSemiBold17];
    [leftBarButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self processSingleNavigationButtons:leftBarButton];
    
    if ([caller respondsToSelector:@selector(onClickOfLeftNavigationBarButton:)]) [leftBarButton addTarget:caller action:@selector(onClickOfLeftNavigationBarButton:) forControlEvents:UIControlEventTouchUpInside];
    else {
        NSLog(@"\n\n%@ class forgets to implement onClickOfLeftNavigationBarButton method\n", [AKSMethods getClassNameForObject:caller]);
    }
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) negativeSpacer.width = value + 16; else negativeSpacer.width = value;
    caller.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, [[UIBarButtonItem alloc] initWithCustomView:leftBarButton], nil];
}

+ (void)addRightNavigationBarButton:(UIViewController *)caller withImageName:(NSString *)imageName WithTitle:(NSString *)title WithNegativeSpacerValue:(int)value {
    UIButton *rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (title) {
        [rightBarButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [rightBarButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_hover", imageName]] forState:UIControlStateHighlighted];
    }
    else {
        [rightBarButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [rightBarButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_hover", imageName]] forState:UIControlStateHighlighted];
    }
    
    [rightBarButton setFrame:CGRectMake(0.0f, (NAVIGATION_BAR_HEIGHT - rightBarButton.currentImage.size.height) / 2, rightBarButton.currentImage.size.width + [title sizeWithFont:rightBarButton.font].width, rightBarButton.currentImage.size.height)];
    [rightBarButton setTitle:title forState:UIControlStateNormal];
    [rightBarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    //    [[rightBarButton titleLabel]setFont:fontSemiBold15];
    [rightBarButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [self processSingleNavigationButtons:rightBarButton];
    
    if ([caller respondsToSelector:@selector(onClickOfRightNavigationBarButton:)]) [rightBarButton addTarget:caller action:@selector(onClickOfRightNavigationBarButton:) forControlEvents:UIControlEventTouchUpInside];
    else {
        NSLog(@"\n\n%@ class forgets to implement onClickOfRightNavigationBarButton method\n", [AKSMethods getClassNameForObject:caller]);
    }
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = value;
    caller.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, [[UIBarButtonItem alloc] initWithCustomView:rightBarButton], nil];
}

+ (void)clearApplicationCaches {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] cleanDisk];
    [AKSMethods syncroniseNSUserDefaults];
}

#pragma mark - common method to show toast messages

+ (void)showNotificationInViewController:(UIViewController *)viewController
                               withTitle:(NSString *)title
                             withMessage:(NSString *)message
                                withType:(TSMessageNotificationType)type
                            withDuration:(NSTimeInterval)duration {
    [TSMessage showNotificationInViewController:viewController title:title subtitle:message image:nil type:type duration:duration callback:nil buttonTitle:nil buttonCallback:nil atPosition:TSMessageNotificationPositionTop canBeDismissedByUser:NO];
}

+ (void)showStatusBarNotificationWithMessage:(NSString *)message withDuration:(NSTimeInterval)duration {
    dispatch_async(dispatch_get_main_queue(), ^{
        [JDStatusBarNotification setDefaultStyle: ^JDStatusBarStyle *(JDStatusBarStyle *style) {
            style.barColor = [UIColor colorWithRed:0.797 green:0.148 blue:0.227 alpha:1.000];
            style.textColor = [UIColor whiteColor];
            style.animationType = JDStatusBarAnimationTypeMove;
            return style;
        }];
        [JDStatusBarNotification showWithStatus:message dismissAfter:duration];
    });
}

#pragma mark - common method to show toast messages

+ (void)showMessageWithTitle:(NSString *)title
                 withMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:title
                          message:message
                          delegate:nil
	                         cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
}

+ (void)showToastMessageWithMessage:(NSString *)message {
#if 0
    [APPDELEGATE.window.rootViewController.view makeToast:message
                                                 duration:MIN_DUR
                                                 position:@"bottom"
                                                    title:Nil];
#elif 0
    [self setupKVNProgress];
    [KVNProgress showErrorWithParameters:@{ KVNProgressViewParameterStatus: message }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MIN_DUR * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [CommonFunctions removeActivityIndicator];
    });
#else
    [AFMInfoBanner showWithText:message style:AFMInfoBannerStyleError andHideAfter:MIN_DUR];
#endif
}

+ (void)showHUDSErrorInfoMessageWithText:(NSString *)text forDuration:(float)duration onView:(UIView *)view {
    [self setupKVNProgress];
    [KVNProgress showErrorWithParameters:@{ KVNProgressViewParameterStatus: text }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [CommonFunctions removeActivityIndicator];
    });
}

+ (void)showHUDSuccessInfoMessageWithText:(NSString *)text forDuration:(float)duration onView:(UIView *)view {
    [self setupKVNProgress];
    [KVNProgress showSuccessWithParameters:@{ KVNProgressViewParameterStatus: text }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [CommonFunctions removeActivityIndicator];
    });
}

+ (void)showHUDInfoMessageWithText:(NSString *)text forDuration:(float)duration onView:(UIView *)view {
    [self setupKVNProgress];
    [KVNProgress showWithStatus:text];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [CommonFunctions removeActivityIndicator];
    });
}

#pragma mark - common method for showing MBProgressHUD Activity Indicator

/*!
 @function	showActivityIndicatorWithText
 @abstract	shows the MBProgressHUD with custom text for information to user.
 @discussion
 MBProgressHUD will be added to window . hence complete ui will be blocked from any user interaction.
 @param	text
 the text which will be shown while showing progress
 */

+ (void)showActivityIndicatorWithText:(NSString *)text {
    [self setupKVNProgress];
    [self removeActivityIndicator];
    [KVNProgress showWithStatus:text];
}

+ (void)setupKVNProgress {
    static BOOL isConfigured = NO;
    if (isConfigured == NO) {
        isConfigured = YES;
        // See the documentation of all appearance propoerties
        [KVNProgress appearance].statusColor = [UIColor darkGrayColor];
        [KVNProgress appearance].statusFont = [UIFont systemFontOfSize:17.0f];
        [KVNProgress appearance].circleStrokeForegroundColor = [UIColor darkGrayColor];
        [KVNProgress appearance].circleStrokeBackgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.3f];
        [KVNProgress appearance].circleFillBackgroundColor = [UIColor clearColor];
        [KVNProgress appearance].backgroundFillColor = [UIColor colorWithWhite:0.9f alpha:0.9f];
        [KVNProgress appearance].backgroundTintColor = [UIColor whiteColor];
        [KVNProgress appearance].successColor = [UIColor darkGrayColor];
        [KVNProgress appearance].errorColor = [UIColor darkGrayColor];
        [KVNProgress appearance].circleSize = 75.0f;
        [KVNProgress appearance].lineWidth = 2.0f;
    }
}

#define INTENSITY -0.2

+ (UIColor *)lighterColorForColor:(UIColor *)c {
    CGFloat r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MIN(r + INTENSITY, 1.0)
                               green:MIN(g + INTENSITY, 1.0)
                                blue:MIN(b + INTENSITY, 1.0)
                               alpha:a];
    return nil;
}

+ (UIColor *)darkerColorForColor:(UIColor *)c {
    CGFloat r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MAX(r - INTENSITY, 0.0)
                               green:MAX(g - INTENSITY, 0.0)
                                blue:MAX(b - INTENSITY, 0.0)
                               alpha:a];
    return nil;
}

/*!
 @function	removeActivityIndicator
 @abstract	removes the MBProgressHUD (if any) from window.
 */

+ (void)removeActivityIndicator {
    [self performSelectorOnMainThread:@selector(removeActivityIndicatorPrivate) withObject:nil waitUntilDone:YES];
}

+ (void)removeActivityIndicatorPrivate {
    [KVNProgress dismiss];
}

#pragma mark - common method for Internet reachability checking

/*!
 @function	getStatusForNetworkConnectionAndShowUnavailabilityMessage
 @abstract	get internet reachability status and optionally can show network unavailability message.
 @param	showMessage
 to decide whether to show network unreachability message.
 */

+ (BOOL)getStatusForNetworkConnectionAndShowUnavailabilityMessage:(BOOL)showMessage {
    if (([[Reachability reachabilityWithHostname:[[NSURL URLWithString:BASE_URL]host]] currentReachabilityStatus] == NotReachable)) {
        if (showMessage == NO) return NO;
        [JDStatusBarNotification setDefaultStyle: ^JDStatusBarStyle *(JDStatusBarStyle *style) {
            style.barColor = [UIColor colorWithRed:0.797 green:0.148 blue:0.227 alpha:1.000];
            style.textColor = [UIColor whiteColor];
            style.animationType = JDStatusBarAnimationTypeMove;
            return style;
        }];
        [JDStatusBarNotification showWithStatus:MESSAGE_TEXT___FOR_NETWORK_NOT_REACHABILITY dismissAfter:MIN_DUR];
        return NO;
    }
    return YES;
}

+ (BOOL)isSuccess:(NSMutableDictionary *)response {
    if ([response isKindOfClass:[NSDictionary class]]) {
        if ([[[response objectForKey:@"replyCode"] uppercaseString]isEqualToString:@"SUCCESS"]) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)validateNormalTextWithString:(NSString *)text WithIdentifier:(NSString *)identifier {
    if ((text == nil) || (text.length == 0)) {
        [CommonFunctions showToastMessageWithMessage:[NSMutableString stringWithFormat:@"Please enter %@", identifier]];
        return FALSE;
    }
    return TRUE;
}

+ (BOOL)validateEmailWithString:(NSString *)email WithIdentifier:(NSString *)identifier {
    if ((email == nil) || (email.length == 0)) {
        [CommonFunctions showToastMessageWithMessage:[NSMutableString stringWithFormat:@"Please enter %@", identifier]];
        return FALSE;
    }
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if (![emailTest evaluateWithObject:email]) {
        [CommonFunctions showToastMessageWithMessage:[NSMutableString stringWithFormat:@"Please enter valid %@", identifier]];
        return FALSE;
    }
    else return TRUE;
}

+ (BOOL)validateUserNameWithString:(NSString *)name WithIdentifier:(NSString *)identifier {
    if ((name == nil) || (name.length == 0)) {
        [CommonFunctions showToastMessageWithMessage:[NSMutableString stringWithFormat:@"Please enter %@", identifier]];
        return FALSE;
    }
    if ((name.length < MINIMUM_LENGTH_LIMIT_USERNAME)) {
        [CommonFunctions showToastMessageWithMessage:[NSMutableString stringWithFormat:@"%@ should contain atleast %d characters", identifier, MINIMUM_LENGTH_LIMIT_USERNAME]];
        return FALSE;
    }
    if ((name.length > MAXIMUM_LENGTH_LIMIT_USERNAME)) {
        [CommonFunctions showToastMessageWithMessage:[NSMutableString stringWithFormat:@"%@ can contain atmost %d characters", identifier, MAXIMUM_LENGTH_LIMIT_USERNAME]];
        return FALSE;
    }
    NSString *nameRegex = @"[a-zA-Z0-9_.@]+$";
    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegex];
    if (![nameTest evaluateWithObject:name]) {
        [CommonFunctions showToastMessageWithMessage:[NSMutableString stringWithFormat:@"Please enter valid %@", identifier]];
        return FALSE;
    }
    else return TRUE;
}

+ (BOOL)validateNameWithString:(NSString *)name WithIdentifier:(NSString *)identifier {
    if ((name == nil) || (name.length == 0)) {
        [CommonFunctions showToastMessageWithMessage:[NSMutableString stringWithFormat:@"Please enter %@", identifier]];
        return FALSE;
    }
    if ((name.length < MINIMUM_LENGTH_LIMIT_FIRST_NAME)) {
        [CommonFunctions showToastMessageWithMessage:[NSMutableString stringWithFormat:@"%@ should contain atleast %d characters", identifier, MINIMUM_LENGTH_LIMIT_FIRST_NAME]];
        return FALSE;
    }
    if ((name.length > MAXIMUM_LENGTH_LIMIT_FIRST_NAME)) {
        [CommonFunctions showToastMessageWithMessage:[NSMutableString stringWithFormat:@"%@ can contain atmost %d characters", identifier, MAXIMUM_LENGTH_LIMIT_FIRST_NAME]];
        return FALSE;
    }
    NSString *nameRegex = @"[a-zA-Z0-9_.@ ]+$";
    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegex];
    if (![nameTest evaluateWithObject:name]) {
        [CommonFunctions showToastMessageWithMessage:[NSMutableString stringWithFormat:@"Please enter valid %@", identifier]];
        return FALSE;
    }
    else return TRUE;
}

+ (BOOL)validatePasswordWithString:(NSString *)password WithIdentifier:(NSString *)identifier {
    if ((password == nil) || (password.length == 0)) {
        [CommonFunctions showToastMessageWithMessage:[NSMutableString stringWithFormat:@"Please enter %@", identifier]];
        return FALSE;
    }
    if ([[password substringWithRange:NSMakeRange(0, 1)] isEqualToString:@" "]) {
        [CommonFunctions showToastMessageWithMessage:[NSMutableString stringWithFormat:@"%@ cannot start with spaces", identifier]];
        return FALSE;
    }
    if (([password length] > 1) && [[password substringWithRange:NSMakeRange(password.length - 1, 1)] isEqualToString:@" "]) {
        [CommonFunctions showToastMessageWithMessage:[NSMutableString stringWithFormat:@"%@ cannot end with spaces", identifier]];
        return FALSE;
    }
    if ((password.length < MINIMUM_LENGTH_LIMIT_PASSWORD)) {
        [CommonFunctions showToastMessageWithMessage:[NSMutableString stringWithFormat:@"%@ should contain atleast %d characters", identifier, MINIMUM_LENGTH_LIMIT_PASSWORD]];
        return FALSE;
    }
    if ((password.length > MAXIMUM_LENGTH_LIMIT_PASSWORD)) {
        [CommonFunctions showToastMessageWithMessage:[NSMutableString stringWithFormat:@"%@ can contain atmost %d characters", identifier, MAXIMUM_LENGTH_LIMIT_PASSWORD]];
        return FALSE;
    }
    return TRUE;
}

+ (BOOL)validatePhoneNumberWithString:(NSString *)number WithIdentifier:(NSString *)identifier {
    if ((number == nil) || (number.length == 0)) {
        [CommonFunctions showToastMessageWithMessage:[NSMutableString stringWithFormat:@"Please enter %@", identifier]];
        return FALSE;
    }
    
    NSString *numberRegex = @"[0-9]+$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    
    if (![numberTest evaluateWithObject:number]) {
        [CommonFunctions showToastMessageWithMessage:[NSMutableString stringWithFormat:@"Please enter valid %@", identifier]];
        return FALSE;
    }
    else return TRUE;
}

+ (BOOL)validatePinCodeWithString:(NSString *)number WithIdentifier:(NSString *)identifier {
    if ((number == nil) || (number.length == 0)) {
        [CommonFunctions showToastMessageWithMessage:[NSMutableString stringWithFormat:@"Please enter %@", identifier]];
        return FALSE;
    }
    
    if (number.length != 6) {
        [CommonFunctions showToastMessageWithMessage:[NSMutableString stringWithFormat:@"Please enter 6 digit %@", identifier]];
        return FALSE;
    }
    
    NSString *numberRegex = @"[0-9]+$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    
    if (![numberTest evaluateWithObject:number]) {
        [CommonFunctions showToastMessageWithMessage:[NSMutableString stringWithFormat:@"Please enter valid %@", identifier]];
        return FALSE;
    }
    else
        return TRUE;
}

+ (BOOL)validateNumberWithString:(NSString *)number WithIdentifier:(NSString *)identifier {
    if ((number == nil) || (number.length == 0)) {
        [CommonFunctions showToastMessageWithMessage:[NSMutableString stringWithFormat:@"Please enter %@", identifier]];
        return FALSE;
    }
    
    NSString *numberRegex = @"[0-9]+$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    
    if (![numberTest evaluateWithObject:number]) {
        [CommonFunctions showToastMessageWithMessage:[NSMutableString stringWithFormat:@"Please enter valid %@", identifier]];
        return FALSE;
    }
    else
        return TRUE;
}

+ (NSString *)getDeviceSpecificImageNameForName:(NSString *)name {
    NSString *fileName1 = name;
    NSString *fileName2;
    DeviceSize deviceSize = [SDiPhoneVersion deviceSize];
    switch (deviceSize) {
        case iPhone35inch:
            fileName2 = [NSString stringWithFormat:@"%@35inch", name];
            break;
            
        case iPhone4inch:
            fileName2 = [NSString stringWithFormat:@"%@4inch", name];
            break;
            
        case iPhone47inch:
            fileName2 = [NSString stringWithFormat:@"%@47inch", name];
            break;
            
        case iPhone55inch:
            fileName2 = [NSString stringWithFormat:@"%@55inch", name];
            break;
            
        case iPad:
            fileName2 = [NSString stringWithFormat:@"%@iPad", name];
            break;
            
        default:
            break;
    }
    if ([self isNotNull:[UIImage imageNamed:fileName2]]) {
        return fileName2;
    }
    else if ([self isNotNull:[UIImage imageNamed:fileName1]]) {
        return fileName1;
    }
    else {
        return name;
    }
}

+ (void)setPaddingOf:(int)padding onTextFeild:(UITextField *)textfeild {
    UIView *paddingView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, padding, 10)];
    UIView *paddingView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, padding, 10)];
    textfeild.LeftView = paddingView1;
    textfeild.LeftViewMode = UITextFieldViewModeAlways;
    textfeild.rightView = paddingView2;
    textfeild.rightViewMode = UITextFieldViewModeAlways;
}

+ (void)showStausBar:(BOOL)show {
    [[UIApplication sharedApplication]setStatusBarHidden:!show withAnimation:UIStatusBarAnimationNone];
}

+ (void)addLeftNavigationBarEditButton:(UIViewController *)caller withImageName:(NSString *)imageName WithTitle:(NSString *)title WithNegativeSpacerValue:(int)value object:(UIViewController *)vc {
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [leftBarButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [leftBarButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
    
    
    [leftBarButton setFrame:CGRectMake(0.0f, (NAVIGATION_BAR_HEIGHT - leftBarButton.currentImage.size.height) / 2, leftBarButton.currentImage.size.width + [title sizeWithFont:leftBarButton.font].width, leftBarButton.currentImage.size.height)];
    [leftBarButton setTitle:title forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor colorWithRed:32.0f / 255.0f green:121.0f / 255.0f blue:255.0f / 255.0f alpha:1.0f] forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor colorWithRed:32.0f / 255.0f green:121.0f / 255.0f blue:255.0f / 255.0f alpha:1.0f] forState:UIControlStateHighlighted];
    [leftBarButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self processSingleNavigationButtons:leftBarButton];
    
    if ([vc respondsToSelector:@selector(onClickOfCustomisedLeftNavigationBarButton:)]) [leftBarButton addTarget:vc action:@selector(onClickOfCustomisedLeftNavigationBarButton:) forControlEvents:UIControlEventTouchUpInside];
    else {
        NSLog(@"\n\n%@ class forgets to implement onClickOfLeftNavigationBarButton method\n", [AKSMethods getClassNameForObject:vc]);
    }
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) negativeSpacer.width = value + 16; else negativeSpacer.width = value;
    caller.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, [[UIBarButtonItem alloc] initWithCustomView:leftBarButton], nil];
}

+ (void)addLeftNavigationBarEditButton:(UIViewController *)caller withImageName:(NSString *)imageName WithTitle:(NSString *)title WithNegativeSpacerValue:(int)value {
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [leftBarButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [leftBarButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
    
    
    [leftBarButton setFrame:CGRectMake(0.0f, (NAVIGATION_BAR_HEIGHT - leftBarButton.currentImage.size.height) / 2, leftBarButton.currentImage.size.width + [title sizeWithFont:leftBarButton.font].width, leftBarButton.currentImage.size.height)];
    [leftBarButton setTitle:title forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor colorWithRed:32.0f / 255.0f green:121.0f / 255.0f blue:255.0f / 255.0f alpha:1.0f] forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor colorWithRed:32.0f / 255.0f green:121.0f / 255.0f blue:255.0f / 255.0f alpha:1.0f] forState:UIControlStateHighlighted];
    [leftBarButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self processSingleNavigationButtons:leftBarButton];
    
    if ([caller respondsToSelector:@selector(onClickOfLeftNavigationBarButton:)]) [leftBarButton addTarget:caller action:@selector(onClickOfLeftNavigationBarButton:) forControlEvents:UIControlEventTouchUpInside];
    else {
        NSLog(@"\n\n%@ class forgets to implement onClickOfLeftNavigationBarButton method\n", [AKSMethods getClassNameForObject:caller]);
    }
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) negativeSpacer.width = value + 16; else negativeSpacer.width = value;
    caller.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, [[UIBarButtonItem alloc] initWithCustomView:leftBarButton], nil];
}

+ (void)addTwoLeftNavigationBarButton:(UIViewController *)caller withImageName1:(NSString *)imageName1 withTitleName2:(NSString *)titleName2 WithNegativeSpacerValue:(int)value {
    UIButton *leftBarButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBarButton1 setImage:[UIImage imageNamed:imageName1] forState:UIControlStateNormal];
    [leftBarButton1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_hover", imageName1]] forState:UIControlStateHighlighted];
    [leftBarButton1 setFrame:CGRectMake(0.0f, 0.0f, leftBarButton1.imageView.image.size.width, NAVIGATION_BAR_HEIGHT)];
    [self processDoubleNavigationButtons:leftBarButton1];
    
    if ([caller respondsToSelector:@selector(onClickOfLeftNavigationBarButton1:)]) [leftBarButton1 addTarget:caller action:@selector(onClickOfLeftNavigationBarButton1:) forControlEvents:UIControlEventTouchUpInside];
    else {
        NSLog(@"\n\n%@ class forgets to implement onClickOfLeftNavigationBarButton1 method\n", [AKSMethods getClassNameForObject:caller]);
    }
    
    
    UIButton *leftBarButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    [leftBarButton2 setTitle:titleName2 forState:UIControlStateNormal];
    [leftBarButton2 setTitle:titleName2 forState:UIControlStateHighlighted];
    [leftBarButton2 setTitleColor:[UIColor colorWithRed:32.0f / 255.0f green:121.0f / 255.0f blue:255.0f / 255.0f alpha:1.0f] forState:UIControlStateNormal];
    [leftBarButton2 setTitleColor:[UIColor colorWithRed:32.0f / 255.0f green:121.0f / 255.0f blue:255.0f / 255.0f alpha:1.0f] forState:UIControlStateHighlighted];
    
    [leftBarButton2 setFrame:CGRectMake(0.0f, 0.0f, leftBarButton2.imageView.image.size.width + [titleName2 sizeWithFont:leftBarButton2.font].width, NAVIGATION_BAR_HEIGHT)];
    [self processDoubleNavigationButtons:leftBarButton2];
    
    if ([caller respondsToSelector:@selector(onClickOfLeftNavigationBarButton2:)]) [leftBarButton2 addTarget:caller action:@selector(onClickOfLeftNavigationBarButton2:) forControlEvents:UIControlEventTouchUpInside];
    else {
        NSLog(@"\n\n%@ class forgets to implement onClickOfLeftNavigationBarButton2 method\n", [AKSMethods getClassNameForObject:caller]);
    }
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = value;
    caller.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:
                                                negativeSpacer,
                                                [[UIBarButtonItem alloc] initWithCustomView:leftBarButton1],
                                                [[UIBarButtonItem alloc] initWithCustomView:leftBarButton2],
                                                nil];
}

+ (void)addTwoRightNavigationBarButton:(UIViewController *)caller withImageName1:(NSString *)imageName1 withTitleName2:(NSString *)titleName2 WithNegativeSpacerValue:(int)value {
    UIButton *rightBarButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBarButton1 setImage:[UIImage imageNamed:imageName1] forState:UIControlStateNormal];
    [rightBarButton1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_hover", imageName1]] forState:UIControlStateHighlighted];
    [rightBarButton1 setFrame:CGRectMake(0.0f, 0.0f, rightBarButton1.imageView.image.size.width, NAVIGATION_BAR_HEIGHT)];
    [self processDoubleNavigationButtons:rightBarButton1];
    
    if ([caller respondsToSelector:@selector(onClickOfRightNavigationBarButton1:)]) [rightBarButton1 addTarget:caller action:@selector(onClickOfRightNavigationBarButton1:) forControlEvents:UIControlEventTouchUpInside];
    else {
        NSLog(@"\n\n%@ class forgets to implement onClickOfRightNavigationBarButton1 method\n", [AKSMethods getClassNameForObject:caller]);
    }
    
    
    UIButton *rightBarButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    [rightBarButton2 setTitle:titleName2 forState:UIControlStateNormal];
    [rightBarButton2 setTitle:titleName2 forState:UIControlStateHighlighted];
    [rightBarButton2 setTitleColor:[UIColor colorWithRed:32.0f / 255.0f green:121.0f / 255.0f blue:255.0f / 255.0f alpha:1.0f] forState:UIControlStateNormal];
    [rightBarButton2 setTitleColor:[UIColor colorWithRed:32.0f / 255.0f green:121.0f / 255.0f blue:255.0f / 255.0f alpha:1.0f] forState:UIControlStateHighlighted];
    
    [rightBarButton2 setFrame:CGRectMake(0.0f, 0.0f, rightBarButton2.imageView.image.size.width + [titleName2 sizeWithFont:rightBarButton2.font].width, NAVIGATION_BAR_HEIGHT)];
    [self processDoubleNavigationButtons:rightBarButton2];
    
    if ([caller respondsToSelector:@selector(onClickOfRightNavigationBarButton2:)]) [rightBarButton2 addTarget:caller action:@selector(onClickOfRightNavigationBarButton2:) forControlEvents:UIControlEventTouchUpInside];
    else {
        NSLog(@"\n\n%@ class forgets to implement onClickOfRightNavigationBarButton2 method\n", [AKSMethods getClassNameForObject:caller]);
    }
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = value;
    caller.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:
                                                 negativeSpacer,
                                                 [[UIBarButtonItem alloc] initWithCustomView:rightBarButton1],
                                                 [[UIBarButtonItem alloc] initWithCustomView:rightBarButton2],
                                                 nil];
}

+ (void)addRightNavigationBarEditButton:(UIViewController *)caller withImageName:(NSString *)imageName WithTitle:(NSString *)title WithNegativeSpacerValue:(int)value {
    //////////////////////////////////////////////////////////////////////
    UIButton *rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBarButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [rightBarButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
    [rightBarButton setTitle:title forState:UIControlStateNormal];
    [rightBarButton setTitle:title forState:UIControlStateHighlighted];
    
    [rightBarButton setTitleColor:[UIColor colorWithRed:32.0f / 255.0f green:121.0f / 255.0f blue:255.0f / 255.0f alpha:1.0f] forState:UIControlStateNormal];
    [rightBarButton setTitleColor:[UIColor colorWithRed:32.0f / 255.0f green:121.0f / 255.0f blue:255.0f / 255.0f alpha:1.0f] forState:UIControlStateHighlighted];
    [rightBarButton setFrame:CGRectMake(0.0f, (NAVIGATION_BAR_HEIGHT - rightBarButton.currentImage.size.height) / 2, rightBarButton.currentImage.size.width + [title sizeWithFont:rightBarButton.font].width, rightBarButton.currentImage.size.height)];
    
    [rightBarButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [self processSingleNavigationButtons:rightBarButton];
    
    if ([caller respondsToSelector:@selector(onClickOfRightNavigationBarButton:)]) [rightBarButton addTarget:caller action:@selector(onClickOfRightNavigationBarButton:) forControlEvents:UIControlEventTouchUpInside];
    else {
        NSLog(@"\n\n%@ class forgets to implement onClickOfRightNavigationBarButton method\n", [AKSMethods getClassNameForObject:caller]);
    }
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = value;
    caller.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, [[UIBarButtonItem alloc] initWithCustomView:rightBarButton], nil];
}

@end
