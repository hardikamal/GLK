//
//  HistoryViewController.m
//  Daily Expense Manager
//
//  Created by Appbulous on 11/09/16.
//  Copyright (c) 2016 Jyoti Kumar. All rights reserved.
//

#import "HistoryViewController.h"
#import "HomeViewCell.h"
#import "TransactionHandler.h"
#import "CategoryListHandler.h"
#import "PaymentmodeHandler.h"
#import "UserInfoHandler.h"

#import "UIPopoverListView.h"
#import "TransactionDetailsViewController.h"
#import "Transactions.h"
#import "HistoryDetailsViewController.h"
#import "AddAccountViewController.h"
//#import "MBProgressHUD.h"

@interface HistoryViewController ()

@property (strong, nonatomic) NSMutableArray *categryList;
@property (strong, nonatomic) NSMutableArray *paymentModeList;
@property (strong, nonatomic) NSString *selectedViewBy;
@property (strong, nonatomic) NSString *SelectedOrderby;
@property BOOL chek;
@property BOOL chosePicker;

@end
@implementation HistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.slideOutAnimationEnabled = YES;
    }
    return self;
}


- (void)viewDidLoad
{
   
    [super viewDidLoad];
    [Utility setFontFamily:Embrima forView:self.view andSubViews:YES];
    _chosePicker=NO;
    _selectedViewBy=NSLocalizedString(@"both", nil);
    _SelectedOrderby=NSLocalizedString(@"Recent Transactions", nil);
    
    self.btnFrom.titleLabel.font =[UIFont fontWithName:Embrima size:16.0f];
    self.btnProfileName.titleLabel.font =[UIFont fontWithName:Embrima size:16.0f];
    self.btnRecurring.titleLabel.font =[UIFont fontWithName:Embrima size:16.0f];
    self.btnShowHistroy.titleLabel.font =[UIFont fontWithName:Embrima size:16.0f];
    self.btnTo.titleLabel.font =[UIFont fontWithName:Embrima size:16.0f];
    self.btnView.titleLabel.font =[UIFont fontWithName:Embrima size:16.0f];
    self.btnFilter.titleLabel.font =[UIFont fontWithName:Embrima size:16.0f];
    self.btnOrder.titleLabel.font =[UIFont fontWithName:Embrima size:16.0f];
    [self.lblTitle setFont:[UIFont fontWithName:Ebrima_Bold size:17.0f]];
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedSelectViewListNotification:) name:@"SelectedViewController" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedZSYPopListViewNotification:)
      name:@"ZSYPopListView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotification:) name:@"HistoryViewController" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CustomePopUpViewControllerNotification:) name:@"CustomePopUpViewController" object:nil];
    
    self.dobView.frame=CGRectMake(0, self.view.frame.size.height+30, self.dobView.frame.size.width, self.dobView.frame.size.height);
    [self.view addSubview:self.dobView];
    _chosePicker=NO;
    [self.containerView setFrame:CGRectMake(0, self.custumView.frame.origin.y+2, 320, self.containerView.frame.size.height+self.custumView.frame.size.height)];
    [self.custumView setHidden:YES];
    _chek=YES;
    self.categryList=[[NSMutableArray alloc] init];
    self.paymentModeList=[[NSMutableArray alloc] init];
    self.categryList=[[CategoryListHandler sharedCoreDataController] getAllCategoryList];
    self.paymentModeList=[[PaymentmodeHandler sharedCoreDataController] getAllPaymetModeListUnhide];
    [self updateViewAccNotify];
    
}


-(void)viewDidAppear:(BOOL)animated
{
    [self updateAccout];
     NSString * noticationName =@"History";
    [[NSNotificationCenter defaultCenter] postNotificationName:noticationName   object:nil userInfo:nil];
}


-(void)updateAccout
{
    NSLog(@"%@",[Utility userDefaultsForKey:CURRENT_USER__TOKEN_ID]);
    NSArray *userInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsWithUserName:[Utility userDefaultsForKey:CURRENT_USER__TOKEN_ID]];
    if ([userInfoarrray count]!=0)
    {
        [self addAccountName:userInfoarrray];
    }else
    {
        NSArray *userInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsToUserRegisterTable];
        [self addAccountName:userInfoarrray];
    }
    
}


-(void)addAccountName:(NSArray *)userInfoarrray
{
    UserInfo *userInfo =[userInfoarrray objectAtIndex:0];
    if ([NSLocalizedString(@"allAccount", nil) isEqualToString:[Utility userDefaultsForKey:CURRENT_USER__TOKEN_ID]])
    {
        [self.btnProfileName setTitle:NSLocalizedString(@"allAccount", nil) forState:UIControlStateNormal];
    }else
    {
        [self.btnProfileName setTitle:userInfo.user_name forState:UIControlStateNormal];
    }
    if (userInfo.user_img != nil)
    {
        self.imageProfile.layer.cornerRadius = self.imageProfile.frame.size.width / 2;
        self.imageProfile.clipsToBounds = YES;
        self.imageProfile.image=[UIImage imageWithData:userInfo.user_img];
    }else
        self.imageProfile.image=[UIImage imageNamed:@"defaultprofile_pic.png"];
}


-(void)CustomePopUpViewControllerNotification:(NSNotification*) notification
{
    [self updateViewAccNotify];
}


-(void)receivedNotification:(NSNotification*) notification
{
    NSDictionary * info =notification.userInfo;
    if ([[info objectForKey:@"tag"] intValue]==3)
    {
        
        [self.btnRecurring setTitle:[info objectForKey:@"object"] forState:UIControlStateNormal];
        
        [self updateViewAccNotify];
        
    }else  if ([[info objectForKey:@"tag"] intValue]==2)
    {
        [self.btnShowHistroy setTitle:[info objectForKey:@"object"] forState:UIControlStateNormal];
    }
    else  if ([[info objectForKey:@"tag"] intValue]==1)
    {
        if ([[info objectForKey:@"object"] isEqualToString:NSLocalizedString(@"addAccount", nil)])
        {
            AddAccountViewController *catageryController=[self.storyboard instantiateViewControllerWithIdentifier:@"AddAccountViewController"];
            [self.navigationController pushViewController:catageryController animated:YES];
        }else
        {
            [Utility saveToUserDefaults:[info objectForKey:@"object"]  withKey:CURRENT_USER__TOKEN_ID];
            [self updateAccout];
            [self updateViewAccNotify];
        }
    }
}


-(void)receivedSelectViewListNotification:(NSNotification*) notification
{
    [self.objCustomPopUpViewController.view removeFromSuperview];
    NSDictionary * info =notification.userInfo;
    if ([[info objectForKey:@"chek"]isEqualToString:@"YES"])
    {
        [self.categryList removeAllObjects];
        self.categryList= [NSMutableArray arrayWithArray:[info objectForKey:@"object"]];
    }else
    {
        [self.paymentModeList removeAllObjects];
        self.paymentModeList= [NSMutableArray arrayWithArray:[info objectForKey:@"object"]];
    }
     [self updateViewAccNotify];
}


-(void)receivedZSYPopListViewNotification:(NSNotification*) notification
{
    [self.transcationItems removeAllObjects];
     NSDictionary * info =notification.userInfo;
    if ([[info objectForKey:@"title"]isEqualToString:NSLocalizedString(@"selectview", nil)])
    {
        if ([[info objectForKey:@"object"]isEqualToString:  NSLocalizedString(@"both", nil)])
        {
            _selectedViewBy=NSLocalizedString(@"both", nil);
        }else if ([[info objectForKey:@"object"]isEqualToString:  NSLocalizedString(@"income", nil)])
        {
           _selectedViewBy= NSLocalizedString(@"income", nil);
        }else if ([[info objectForKey:@"object"]isEqualToString:  NSLocalizedString(@"expense", nil)])
        {
          _selectedViewBy=NSLocalizedString(@"expense", nil);
        }
    }else
    {
        if ([[info objectForKey:@"object"]isEqualToString:  NSLocalizedString(@"Recent Transactions", nil)])
        {
             _SelectedOrderby=NSLocalizedString(@"Recent Transactions", nil);
            
        }else if ([[info objectForKey:@"object"]isEqualToString:  NSLocalizedString(@"Old Transactions", nil)])
        {
             _SelectedOrderby= NSLocalizedString(@"Old Transactions", nil);
            
        }else if ([[info objectForKey:@"object"]isEqualToString:  NSLocalizedString(@"Highest Amount", nil)])
        {
              _SelectedOrderby= NSLocalizedString(@"Highest Amount", nil);
        }else if ([[info objectForKey:@"object"]isEqualToString:  NSLocalizedString(@"Lowest Amount", nil)])
        {
              _SelectedOrderby=  NSLocalizedString(@"Lowest Amount", nil);
        }
    }
     [self updateViewAccNotify];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backbtnClick:(id)sender
{
   // [[SlideNavigationController sharedInstance]toggleLeftMenu];
}

//
//- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
//{
//    return self.diffrence;
//    
//}
//
//- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
//{
//    return 0;
//    
//}


- (IBAction)btnRecurringClick:(id)sender
{
      [self animateView:self.dobView xCoordinate:0 yCoordinate:0];
    CGFloat xWidth = self.view.bounds.size.width - 120.0f;
    CGFloat yHeight = 200.0f;
    CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
    UIPopoverListView *poplistview = [[UIPopoverListView alloc] initWithFrame:CGRectMake(10, yOffset, xWidth, yHeight)];
    NSMutableArray *arrray=[[NSMutableArray alloc] initWithObjects:NSLocalizedString(@"yearly", nil),NSLocalizedString(@"monthly", nil),NSLocalizedString(@"weekly", nil),NSLocalizedString(@"daily", nil),NSLocalizedString(@"custom", nil),nil];
    [poplistview setListArray:arrray];
    [poplistview setTag:3];
    [poplistview setNotificationName:@"HistoryViewController"];
    poplistview.listView.scrollEnabled = FALSE;
    [poplistview show];
}



- (IBAction)cancelDobPickerClick:(id)sender
{
    [self animateView:self.dobView xCoordinate:0 yCoordinate:0];
}



- (IBAction)doneDobPickerClick:(id)sender
{
 
	NSDate *myDate = self.dobPicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
	if (_chosePicker)
    {
        [self.btnTo setTitle:[formatter stringFromDate:myDate] forState:UIControlStateNormal];
        _chosePicker=NO;
    }else
    {
        [self.btnFrom setTitle:[formatter stringFromDate:myDate] forState:UIControlStateNormal];
    }
    _diffrence=0;
    if (self.pageViewController!=nil)
    {
        [self.pageViewController.view removeFromSuperview];
    }
    [self addPageViewContollerOnView:_diffrence];
}



- (IBAction)btnFilterClick:(id)sender
{
    [self animateView:self.dobView xCoordinate:0 yCoordinate:0];
    self.objCustomPopUpViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:Nil] instantiateViewControllerWithIdentifier:@"CustomPopUpViewController"];
    [self.objCustomPopUpViewController setCategryList:self.categryList];
    [self.objCustomPopUpViewController setPaymentModeList:self.paymentModeList];
    [self.objCustomPopUpViewController show];
}


- (IBAction)btnClassClick:(id)sender
{
    
    CGFloat xWidth = self.view.bounds.size.width - 120.0f;
    CGFloat yHeight = 85.0f;
    CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
    UIPopoverListView *poplistview = [[UIPopoverListView alloc] initWithFrame:CGRectMake(10, yOffset, xWidth, yHeight)];
    NSMutableArray *arrray=[[NSMutableArray alloc] initWithObjects:@"List",@"Graph",nil];
    [poplistview setListArray:arrray];
    [poplistview setNotificationName:@"HistoryViewController"];
    [poplistview setTag:2];
     poplistview.listView.scrollEnabled = FALSE;
    [poplistview show];
}



- (IBAction)btnOrderClick:(id)sender
{
    ZSYPopoverListView *listView = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(0, 0, 300, 260)];
    listView.titleName.text =NSLocalizedString(@"selectorder", nil);
    listView.imageView.image=[UIImage imageNamed:@"order_icon_white.png"];
    [listView setItems:[NSArray arrayWithObjects:NSLocalizedString(@"Recent Transactions", nil),NSLocalizedString(@"Old Transactions", nil),NSLocalizedString(@"Highest Amount", nil),NSLocalizedString(@"Lowest Amount", nil),nil]];
    [listView setType:_SelectedOrderby];
      NSLog(@"%@",_SelectedOrderby);
    [listView setCancelButtonTitle:@"Cancel" block:^{
        NSLog(@"cancel");
    }];
    [listView setDoneButtonWithTitle:@"OK" block:^{
    }];
    [listView show];
}


- (IBAction)btnViewClic:(id)sender
{
    ZSYPopoverListView *listView = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(0, 0, 300, 220)];
    listView.titleName.text = NSLocalizedString(@"selectview", nil);
    listView.imageView.image=[UIImage imageNamed:@"overview_icon_white.png"];
    [listView setItems:[NSArray arrayWithObjects:NSLocalizedString(@"both", nil),NSLocalizedString(@"income", nil),NSLocalizedString(@"expense", nil),nil]];
    NSLog(@"%@",_selectedViewBy);
    [listView setType:_selectedViewBy];
    [listView setCancelButtonTitle:@"Cancel" block:^{
        NSLog(@"cancel");
    }];
    [listView setDoneButtonWithTitle:@"OK" block:^{
    }];
    [listView show];
}


- (IBAction)btnProfileName:(id)sender
{
    [self animateView:self.dobView xCoordinate:0 yCoordinate:0];
    NSMutableArray *userInfoList=[[NSMutableArray alloc] init];
    NSArray *UserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsToUserRegisterTable];
    if ([UserInfoarrray count]>1)
    {
        [userInfoList addObject:NSLocalizedString(@"allAccount", nil)];
        for (UserInfo *info in UserInfoarrray)
        {
            [userInfoList addObject:info.user_name];
        }
    }
    [userInfoList addObject:NSLocalizedString(@"addAccount", nil)];
    CGFloat xWidth = self.view.bounds.size.width - 120.0f;
    CGFloat yHeight = [userInfoList count]*40;
    if (yHeight>300)
    {
        yHeight=300;
    }
    CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
    UIPopoverListView *poplistview = [[UIPopoverListView alloc] initWithFrame:CGRectMake(10, yOffset, xWidth, yHeight)];
    [poplistview setTag:1];
    [poplistview setNotificationName:@"HistoryViewController"];
    [poplistview setListArray:userInfoList];
    if (yHeight<300)
    {
    poplistview.listView.scrollEnabled = FALSE;
    }
    [poplistview show];
    
}


- (IBAction)btnToClick:(id)sender
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    NSDate *currentDate =[formatter dateFromString:self.btnTo.titleLabel.text];
    [self.dobPicker setDate:currentDate animated:YES];
    self.dobPicker.datePickerMode = UIDatePickerModeDate;
    float height=self.dobView.frame.size.height;
    [self animateView:self.dobView xCoordinate:0 yCoordinate:-height];
    _chosePicker=YES;
}

-(IBAction)btnFromClick:(id)sender
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    NSDate *currentDate =[formatter dateFromString:self.btnFrom.titleLabel.text];
    [self.dobPicker setDate:currentDate animated:YES];
    self.dobPicker.datePickerMode = UIDatePickerModeDate;
    float height=self.dobView.frame.size.height;
    [self animateView:self.dobView xCoordinate:0 yCoordinate:-height];
    
}


-(void)animateView :(UIView*)aView  xCoordinate:(CGFloat)dx  yCoordinate :(CGFloat) dy
{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	[aView  setTransform:CGAffineTransformMakeTranslation(dx, dy)];
	[UIView commitAnimations];
}





-(void)addPageViewContollerOnView:(NSInteger)index
{
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
  
//    for (UIView *subview in self.pageViewController.view.subviews)
//    {
//        if ([subview isKindOfClass:[UIPageControl class]])
//        {
//            UIPageControl *pageControl = (UIPageControl *)subview;
//            pageControl.pageIndicatorTintColor = [UIColor yellowColor];
//            pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
//           // pageControl.backgroundColor = [UIColor blueColor];
//        }
//    }
    
   // hide indicater view
    NSArray *subviews = self.pageViewController.view.subviews;
    UIPageControl *thisControl = nil;
    for (int i=0; i<[subviews count]; i++)
    {
        if ([[subviews objectAtIndex:i] isKindOfClass:[UIPageControl class]])
        {
            thisControl = (UIPageControl *)[subviews objectAtIndex:i];
        }
    }
    thisControl.hidden = true;
    
    self.pageViewController.view.frame=CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
    NSLog(@"%f",self.pageViewController.view.frame.origin.x);
    UIViewController *initialViewController = [self viewControllerAtIndex:index];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self.containerView addSubview:[self.pageViewController view]];
    [self addChildViewController:self.pageViewController];
    [self.pageViewController didMoveToParentViewController:self];
}



- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [(HistoryDetailsViewController *)viewController index];
    
    if (index == 0)
    {
        
        return nil;
    }
    // Decrease the index by 1 to return
    index--;
    return [self viewControllerAtIndex:index];
}



- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [(HistoryDetailsViewController *)viewController index];
    if (index ==_diffrence)
    {
        return nil;
    }
    index++;
    return [self viewControllerAtIndex:index];
}


-(HistoryDetailsViewController *)viewControllerAtIndex:(NSUInteger)index
{
    HistoryDetailsViewController *childViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"HistoryDetailsViewController"];
    childViewController.index=index;
    [childViewController setUserName:self.btnProfileName.titleLabel.text];
    [childViewController setRecurringString:self.btnRecurring.titleLabel.text];
    [childViewController setCategeryList:self.categryList];
    [childViewController setPaymentList:self.paymentModeList];
    [childViewController setDiffrence:_diffrence];
    [childViewController setStrFrom:self.btnFrom.titleLabel.text];
    [childViewController setStrTo:self.btnTo.titleLabel.text];
    [childViewController setSelectedOrderby:_SelectedOrderby];
    [childViewController setSelectedViewBy:_selectedViewBy];
     childViewController.transcationItems=self.transcationItems;
    return childViewController;
}



-(void)updateViewAccNotify
{
    if (!_chek)
    {
        [self.containerView setFrame:CGRectMake(0, self.custumView.frame.origin.y, self.containerView.frame.size.width, self.containerView.frame.size.height+self.custumView.frame.size.height)];
        [self.custumView setHidden:YES];
        _chek=YES;
    }
    NSArray *UserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsWithUserName:self.btnProfileName.titleLabel.text];
    _diffrence=0;
    NSString *userToke;
    if ([UserInfoarrray count]!=0)
    {
        UserInfo *userInfo =[UserInfoarrray objectAtIndex:0];
        userToke=userInfo.user_token_id;
    }
    else
        userToke=@"";
    self.diffrence=0;
    
    NSArray *maxarray=[[TransactionHandler sharedCoreDataController] getMaxDateFromTransactionTable:userToke];
    NSArray *minarray=[[TransactionHandler sharedCoreDataController] getMinDateFromTransactionTable:userToke];
    
    if ([maxarray count]!=0 && [minarray count]!=0)
    {
    
        Transactions *transation=(Transactions*)[maxarray objectAtIndex:0];
        NSDate *endDate =[NSDate dateWithTimeIntervalSince1970:([[transation.date stringValue] doubleValue] / 1000)];
        
        Transactions   *tran=(Transactions*)[minarray objectAtIndex:0];
        NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:([[tran.date stringValue] doubleValue] / 1000)];
        
        NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
        NSDateComponents *componentsForReferenceDate;
        
        if ([NSLocalizedString(@"yearly", nil) isEqualToString:self.btnRecurring.titleLabel.text])
        {
            componentsForReferenceDate = [calendar components:NSCalendarUnitYear  fromDate:startDate];
            [componentsForReferenceDate setDay:01];
            [componentsForReferenceDate setMonth:01];
            [componentsForReferenceDate setHour:0];
            [componentsForReferenceDate setMinute:0];
            [componentsForReferenceDate setSecond:0] ;
            startDate = [calendar dateFromComponents:componentsForReferenceDate];
            
            componentsForReferenceDate = [calendar components:NSCalendarUnitYear  fromDate:endDate];
            NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[calendar dateFromComponents:componentsForReferenceDate]];
            [componentsForReferenceDate setDay:range.length];
            [componentsForReferenceDate setMonth:12];
            [componentsForReferenceDate setHour:23];
            [componentsForReferenceDate setMinute:59];
            [componentsForReferenceDate setSecond:59];
            endDate = [calendar dateFromComponents:componentsForReferenceDate];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy"];
            int maxyear = [[dateFormatter stringFromDate:endDate] intValue];
            int minYear = [[dateFormatter stringFromDate:startDate] intValue];
            _diffrence=maxyear-minYear;
            
            
        }else if ([NSLocalizedString(@"monthly", nil) isEqualToString:self.btnRecurring.titleLabel.text])
        {
            
            componentsForReferenceDate = [calendar components:(NSCalendarUnitDay | NSCalendarUnitYear | NSCalendarUnitMonth ) fromDate:startDate];
            [componentsForReferenceDate setDay:01];
            [componentsForReferenceDate setHour:0];
            [componentsForReferenceDate setMinute:0];
            [componentsForReferenceDate setSecond:0] ;
            startDate = [calendar dateFromComponents:componentsForReferenceDate];
            componentsForReferenceDate = [calendar components:(NSCalendarUnitDay | NSCalendarUnitYear | NSCalendarUnitMonth ) fromDate:endDate];
            
            NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[calendar dateFromComponents:componentsForReferenceDate]];
            [componentsForReferenceDate setDay:range.length];
            [componentsForReferenceDate setHour:23];
            [componentsForReferenceDate setMinute:59];
            [componentsForReferenceDate setSecond:59] ;
            endDate = [calendar dateFromComponents:componentsForReferenceDate];
            
            NSInteger month = [[[NSCalendar currentCalendar] components: NSCalendarUnitMonth  fromDate: startDate   toDate: endDate options: 0] month];
            _diffrence=month;
        }else if ([NSLocalizedString(@"weekly", nil) isEqualToString:self.btnRecurring.titleLabel.text])
        {
            componentsForReferenceDate = [calendar components:(NSCalendarUnitDay | NSCalendarUnitYear | NSCalendarUnitMonth|NSWeekCalendarUnit ) fromDate:startDate];
            [componentsForReferenceDate setHour:0];
            [componentsForReferenceDate setMinute:0];
            [componentsForReferenceDate setSecond:0] ;
            startDate = [calendar dateFromComponents:componentsForReferenceDate] ;
            componentsForReferenceDate = [calendar components:(NSCalendarUnitDay | NSCalendarUnitYear | NSCalendarUnitMonth ) fromDate:endDate];
            [componentsForReferenceDate setHour:23];
            [componentsForReferenceDate setMinute:59];
            [componentsForReferenceDate setSecond:59] ;
            endDate = [calendar dateFromComponents:componentsForReferenceDate];
            NSDateComponents *comps = [calendar components:NSCalendarUnitDay fromDate:startDate  toDate:endDate  options:0];
            _diffrence=[comps day]/7;
            
        }else if ([NSLocalizedString(@"daily", nil) isEqualToString:self.btnRecurring.titleLabel.text])
        {
            componentsForReferenceDate = [calendar components:(NSCalendarUnitDay | NSCalendarUnitYear | NSCalendarUnitMonth|NSWeekCalendarUnit ) fromDate:startDate];
            [componentsForReferenceDate setHour:0];
            [componentsForReferenceDate setMinute:0];
            [componentsForReferenceDate setSecond:0] ;
            startDate = [calendar dateFromComponents:componentsForReferenceDate] ;
            componentsForReferenceDate = [calendar components:(NSCalendarUnitDay | NSCalendarUnitYear | NSCalendarUnitMonth ) fromDate:endDate];
            [componentsForReferenceDate setHour:23];
            [componentsForReferenceDate setMinute:59];
            [componentsForReferenceDate setSecond:59] ;
            endDate = [calendar dateFromComponents:componentsForReferenceDate];
            _diffrence = [componentsForReferenceDate day];
            NSDateComponents *comps = [calendar components:NSCalendarUnitDay fromDate:startDate  toDate:endDate  options:0];
            _diffrence=[comps day];
            
        }else if ([NSLocalizedString(@"custom", nil) isEqualToString:self.btnRecurring.titleLabel.text])
        {
            [self.custumView setHidden:NO];
            [self.containerView setFrame:CGRectMake(0, self.custumView.frame.origin.y+self.custumView.frame.size.height,self.containerView.frame.size.width, self.containerView.frame.size.height-self.custumView.frame.size.height)];
            _chek=NO;
            NSDate *currentDate = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"dd-MM-yyyy"];
            [self.btnTo setTitle:[formatter stringFromDate:currentDate] forState:UIControlStateNormal];
             NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
            [dateComponents setMonth:1];
             NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:currentDate options:0];
            
            [self.btnFrom setTitle:[formatter stringFromDate:newDate] forState:UIControlStateNormal];
            _diffrence=0;
        }
    }
    
    if (self.pageViewController!=nil)
    {
        [self.pageViewController.view removeFromSuperview];
    }
    [self addPageViewContollerOnView:_diffrence];
}

@end
