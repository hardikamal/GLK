//
//  Created by Alok on 07/03/14.
//  Copyright (c) 2015 Aryansbtloe. All rights reserved.
//

#import "SplashVC.h"
#import "FirstViewController.h"

@implementation SplashVC

@synthesize imgView, bottomLabel;

- (void)viewDidLoad {
    LOG_VIEW_CONTROLLER_LOADING
    [super viewDidLoad];
    [self registerForNotifications];
    [self startUpInitialisations];
    [self setUpForNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated {
    LOG_VIEW_CONTROLLER_APPEARING
    [super viewWillAppear : animated];
    [self setUpForNavigationBar];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self checkAndDecideApplicationFlow];
    });
}

#pragma mark - methods to register for important notifications
- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(needLayoutUpdateCustom)
                                                name:NOTIFICATION_NEED_LAYOUT_UPDATE_CUSTOM
                                              object:nil];
}

- (void)needLayoutUpdateCustom {
    if ([SDiPhoneVersion deviceSize] == iPhone35inch) {
        if (getStatusBarHeight() > 20) {
        }
        else {
        }
    }
    else if ([SDiPhoneVersion deviceSize] == iPhone4inch) {
        if (getStatusBarHeight() > 20) {
        }
        else {
        }
    }
    else if ([SDiPhoneVersion deviceSize] == iPhone47inch) {
        if (getStatusBarHeight() > 20) {
        }
        else {
        }
    }
    else if ([SDiPhoneVersion deviceSize] == iPhone55inch) {
        if (getStatusBarHeight() > 20) {
        }
        else {
        }
    }
    else {
        if (getStatusBarHeight() > 20) {
        }
        else {
        }
    }
    [[self view]setNeedsLayout];
    [[self view]layoutIfNeeded];
}

#pragma mark - Start Up Initialisations
- (void)startUpInitialisations {
    [self setNeedsStatusBarAppearanceUpdate];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self animateContents];
        [bottomLabel startAnimating];
    });
}

#pragma mark - Setup for navigation bar
- (void)setUpForNavigationBar {
    HIDE_STATUS_BAR
    HIDE_NAVIGATION_BAR
    FIX_IOS_7_EDGE_START_LAY_OUT_ISSUE
}

- (void)animateContents {
    NSString *text = @"Pocket the best personal financial app.";
    UILabel *welcomeTextLabel = (UILabel *)[self.view viewWithTag:1];
    UILabel *gullakTextLabel = (UILabel *)[self.view viewWithTag:2];
    UILabel *demTextLabel = (UILabel *)[self.view viewWithTag:3];
    bottomLabel.text = text;
    bottomLabel.layer.opacity = 0;
    
    [UIView animateWithDuration:.4 animations: ^{
        imgView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.6, 1.6);
    }                         completion: ^(BOOL finished) {
        [UIView animateWithDuration:.4 animations: ^{
            imgView.transform = CGAffineTransformScale(CGAffineTransformIdentity, .7, .7);
        } completion: ^(BOOL finished) {
            [UIView animateWithDuration:.4 animations: ^{
                imgView.transform = CGAffineTransformIdentity;
                imgView.frame = CGRectMake(imgView.frame.origin.x, imgView.frame.origin.y - 70, imgView.frame.size.width, imgView.frame.size.height);
                welcomeTextLabel.center = CGPointMake(imgView.center.x, CGRectGetMaxY(imgView.frame) + 10);
            } completion: ^(BOOL finished) {
                [UIView animateWithDuration:.4 animations: ^{
                    gullakTextLabel.center = CGPointMake(welcomeTextLabel.center.x, CGRectGetMaxY(welcomeTextLabel.frame) + 20);
                    demTextLabel.center = CGPointMake(gullakTextLabel.center.x - 30, CGRectGetMaxY(gullakTextLabel.frame) + 20);
                } completion: ^(BOOL finished)
                 {
                     [UIView animateWithDuration:.4 animations: ^{
                         demTextLabel.center = CGPointMake(gullakTextLabel.center.x, CGRectGetMaxY(gullakTextLabel.frame) + 20);
                     } completion: ^(BOOL finished) {
                         [UIView animateWithDuration:2 animations: ^{
                         } completion: ^(BOOL finished) {
                             bottomLabel.layer.opacity = 1;
                         }];
                     }];
                 }];
            }];
        }];
    }];
}

- (void)checkAndDecideApplicationFlow {
    [[AppCommonFunctions sharedInstance]pushVCOfClass:[FirstViewController class] fromNC:[self navigationController] animated:YES setRootViewController:YES modifyVC:nil];
}

COMMON_VIEW_CONTROLLER_METHODS

@end
