//
//  FirstViewController.m
//  Gullak
//
//  Created by Saurabh Singh on 25/02/15.
//  Copyright (c) 2015 Mobulous. All rights reserved.
//

#import "FirstViewController.h"
#import "HomeViewController.h"

@interface FirstViewController () {
    NSArray *imageArray;
    int nextPage;
}
@end

@implementation FirstViewController
@synthesize hFlowView, hPageControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addPageViewController];
    [self addDefaultUserAsGuest];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    HIDE_STATUS_BAR
}

- (void)addDefaultUserAsGuest {
    NSArray *arrray = [[UserInfoHandler sharedCoreDataController] getUserDetailsToUserRegisterTable];
    if ([arrray count] == 0) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:CURRENT_CURRENCY_TIMESTAMP];
        [Utility saveToUserDefaults:DEFAULT_TOKEN_ID withKey:CURRENT_TOKEN_ID];
        [Utility saveToUserDefaults:[[[Utility userDefaultsForKey:CURRENT_TOKEN_ID] componentsSeparatedByString:@"_"] objectAtIndex:1] withKey:CURRENT_USER__TOKEN_ID];
        NSString *mainToken = [[[Utility userDefaultsForKey:CURRENT_TOKEN_ID] componentsSeparatedByString:@"_"] objectAtIndex:0];
        [Utility saveToUserDefaults:mainToken withKey:MAIN_TOKEN_ID];
        [Utility saveToUserDefaults:[[NSLocalizedString(@"items", nil) componentsSeparatedByString:@","] objectAtIndex:107] withKey:[NSString stringWithFormat:@"%@ @@@@ %@", CURRENT_CURRENCY, mainToken]];
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
        NSString *userToke = [Utility userDefaultsForKey:CURRENT_TOKEN_ID];
        [dictionary setObject:userToke forKey:@"user_token_id"];
        [dictionary setObject:NSLocalizedString(@"guest", nil) forKey:@"user_name"];
        [dictionary setObject:[NSNumber numberWithInt:0] forKey:@"hide_status"];
        [dictionary setObject:[NSNumber numberWithInt:0] forKey:@"location"];
        [[UserInfoHandler sharedCoreDataController] addUserToUserRegisterTable:dictionary];
    }
    NSArray *incomeArrray = [[CategoryListHandler sharedCoreDataController] getAllCategoryListwithHideStaus];
    if ([incomeArrray count] == 0) {
        [[CategoryListHandler sharedCoreDataController] addDefaultCategoryList:NSLocalizedString(@"expenses_items", ni):NSLocalizedString(@"income_items", nil)];
    }
    NSArray *paymentModeArray = [[PaymentmodeHandler sharedCoreDataController] getPaymentModeList];
    if ([paymentModeArray count] == 0) {
        [[PaymentmodeHandler sharedCoreDataController] addDefaultPaymentMode:NSLocalizedString(@"medium_of_transaction", ni)];
    }
}

- (void)addPageViewController {
    nextPage = 0;
    imageArray = [[NSArray alloc] initWithObjects:@"dem_title.png", @"multipleaccount.png", @"setreminder.png", @"transaction.png", @"transfer.png", @"viewhistory.png", @"warranty.png", nil];
    hFlowView.delegate = self;
    hFlowView.dataSource = self;
    hFlowView.pageControl = hPageControl;
    hFlowView.minimumPageAlpha = 1.0;
    hFlowView.minimumPageScale = 0.7;
    [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(move_pagination) userInfo:nil repeats:YES];
}

- (void)move_pagination {
    nextPage  = (int)hPageControl.currentPage + 1;
    // if page is not 10, display it
    if (nextPage != [imageArray count]) {
        hPageControl.currentPage = nextPage;
        [hFlowView scrollToPage:nextPage];
    }
    else {
        nextPage = 0;
        hPageControl.currentPage = nextPage;
        [hFlowView scrollToPage:nextPage];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginGuestClickEvent:(id)sender {
    HomeViewController *homeObj = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    [self.navigationController pushViewController:homeObj animated:YES];
}

#pragma mark -
#pragma mark PagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView {
    return [imageArray count];
}

- (UIView *)flowView:(PagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index {
    UIImageView *imageView = (UIImageView *)[flowView dequeueReusableCell];
    if (!imageView) {
        imageView = [[UIImageView alloc] init];
    }
    imageView.image = [UIImage imageNamed:[imageArray objectAtIndex:index]];
    return imageView;
}

- (IBAction)pageControlValueDidChange:(id)sender {
    UIPageControl *pageControl = sender;
    [hFlowView scrollToPage:pageControl.currentPage];
}

#pragma mark PagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(PagedFlowView *)flowView; {
    return CGSizeMake(200, 180);
}

- (void)flowView:(PagedFlowView *)flowView didScrollToPageAtIndex:(NSInteger)index {
}

- (void)flowView:(PagedFlowView *)flowView didTapPageAtIndex:(NSInteger)index {
}

@end
