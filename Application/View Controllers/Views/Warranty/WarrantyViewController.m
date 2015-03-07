//
//  WarrantyViewController.m
//  Daily Expense Manager
//
//  Created by Appbulous on 09/10/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import "WarrantyViewController.h"
#import "TransactionHandler.h"
#import "WarrantyCell.h"
#import "CategoryListHandler.h"
#import "UserInfoHandler.h"

#import "TransactionDetailsViewController.h"
#import "UserInfo.h"
#import "UIPopoverListView.h"
#import "AddAccountViewController.h"
#import "HomeHelper.h"
#import "AddWarrantyViewController.h"
//#import "MBProgressHUD.h"

@interface WarrantyViewController ()

@end

@implementation WarrantyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotification:) name:@"WarrantyViewController" object:nil];
    self.tablview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    if ([[[UserInfoHandler sharedCoreDataController] getUserDetailsToUserRegisterTable] count]==1)
    {
        NSArray *UserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsToUserRegisterTable];
        UserInfo *userInfo =[UserInfoarrray objectAtIndex:0];
        [Utility saveToUserDefaults:userInfo.user_name withKey:CURRENT_USER__TOKEN_ID];
    }
    [self.btnUserName setTitle:[Utility userDefaultsForKey:CURRENT_USER__TOKEN_ID] forState:UIControlStateNormal];
}




-(void)receivedNotification:(NSNotification*) notification
{
    NSDictionary * info =notification.userInfo;
    if ([[info objectForKey:@"object"] isEqualToString:NSLocalizedString(@"addAccount", nil)])
    {
        AddAccountViewController *catageryController=[self.storyboard instantiateViewControllerWithIdentifier:@"AddAccountViewController"];
        [self.navigationController pushViewController:catageryController animated:YES];
        
    }else
    {
        [Utility saveToUserDefaults:[info objectForKey:@"object"]  withKey:CURRENT_USER__TOKEN_ID];
        [self updateAccout];
        [self profressView];
    }
}


-(void)updateAccout
{
  //  [MBProgressHUD showHUDAddedTo:self.emptyWarrantyView animated:YES];
    self.warrantyItems=[[NSMutableArray alloc] init];
    [self.emptyWarrantyView setFrame:CGRectMake(0, 0, self.customeView.frame.size.width, self.customeView.frame.size.height)];
    [self.addWarrantyView setHidden:YES];
    [self.emptyWarrantyView setHidden:NO];
    [self.customeView addSubview:self.emptyWarrantyView];
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
        [self.btnUserName setTitle:NSLocalizedString(@"allAccount", nil) forState:UIControlStateNormal];
    }else
    {
        [self.btnUserName setTitle:userInfo.user_name forState:UIControlStateNormal];
    }
    if ([userInfo.user_img length]!=0)
    {
        self.imageProfile.layer.cornerRadius = self.imageProfile.frame.size.width / 2;
        self.imageProfile.clipsToBounds = YES;
        self.imageProfile.image=[UIImage imageWithData:userInfo.user_img];
    }else
        self.imageProfile.image=[UIImage imageNamed:@"custom_profile.png"];
}




-(void)profressView
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSString *userToken;
        if ([self.btnUserName.titleLabel.text isEqualToString:NSLocalizedString(@"allAccount", nil)])
        {
            userToken=@"";
        }else
        {
            NSArray *UserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsWithUserName:self.btnUserName.titleLabel.text];
            if ([UserInfoarrray count]!=0 )
            {
                UserInfo *userInfo =[UserInfoarrray objectAtIndex:0];
                userToken=userInfo.user_token_id;
            }else
            {
                userToken=@"";
            }
        }
        
        self.warrantyItems=[[TransactionHandler sharedCoreDataController] getAllWarranrty:[NSString stringWithFormat:@"%i",TYPE_WARRANTY] :userToken];
        
        dispatch_async(dispatch_get_main_queue(), ^{
           // [MBProgressHUD hideHUDForView:self.emptyWarrantyView animated:YES];
            if ([self.warrantyItems count]==0)
            {
                [self.emptyWarrantyView setFrame:CGRectMake(0, 0, self.customeView.frame.size.width, self.customeView.frame.size.height)];
                [self.addWarrantyView setHidden:YES];
                [self.emptyWarrantyView setHidden:NO];
                [self.customeView addSubview:self.emptyWarrantyView];
            }else
            {
                [self.addWarrantyView setFrame:CGRectMake(0, 0, self.customeView.frame.size.width, self.customeView.frame.size.height)];
                [self.addWarrantyView setHidden:NO];
                [self.emptyWarrantyView setHidden:YES];
                [self.customeView addSubview:self.addWarrantyView];
            }
             [self.tablview reloadData];
        });
    });
}





-(void)viewDidAppear:(BOOL)animated
{
    [self profressView];
}



-(void)viewWillAppear:(BOOL)animated
{
    [self updateAccout];
    if([[NSUserDefaults standardUserDefaults] boolForKey:UPDATION_ON_SERVER_TIME])
    {
        [[HomeHelper sharedCoreDataController] upgradeBackendDataOnServer];
    }
 
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.warrantyItems count];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier = @"Warranty";
    WarrantyCell *cell = (WarrantyCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WarrantyCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    Transactions *transaction =(Transactions*)[self.warrantyItems objectAtIndex:[indexPath row]];
    NSArray *categeryArray=[[CategoryListHandler sharedCoreDataController] getsearchCategeryWithAttributeName:@"category_normal" andSearchText:transaction.category];
    if ([categeryArray count]!=0)
    {
        cell.imgCatagery.image=[UIImage imageWithData:[[categeryArray objectAtIndex:0] objectForKey:@"category_normal"]];
    }
    [cell.lblCategery setText:transaction.category];
    NSString *nDate=[transaction.date stringValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:([nDate doubleValue] / 1000)];
    
    NSString *warranty=[transaction.warranty stringValue];
    NSDate *warrantydate = [NSDate dateWithTimeIntervalSince1970:([warranty doubleValue] / 1000)];
    cell.progrssView.progress=[self progress:date :warrantydate];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init] ;
    [df setDateFormat:@"dd LLLL yyyy"];
    [cell.lblWarranntyDate setText:[df stringFromDate:date]];
    [cell.lbltDate setText:[NSString stringWithFormat:@"%@ to %@",[df stringFromDate:date],[df stringFromDate:warrantydate]]];
    
    if ([transaction.discription length]!=0)
    {
        [cell.lblDiscription setText:transaction.discription];
    }else
    {
        [cell.lblDiscription setText:@"No Description"];
    }
    
    NSString *mainToken= [Utility userDefaultsForKey:MAIN_TOKEN_ID];
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setPositiveFormat:@"0.##"];
    NSString *currency= [Utility  userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",CURRENT_CURRENCY,mainToken]];
    [cell.lblAmount setText:[NSString stringWithFormat:@"%@ %@",[[currency componentsSeparatedByString:@"-"] objectAtIndex:1],[fmt stringFromNumber:[NSNumber numberWithDouble:[transaction.amount doubleValue]]]]];
    
//    if (![transaction.transaction_type intValue]==TYPE_INCOME)
//        [cell.lblAmount setTextColor:[UIColor whiteColor]];
//    else
//        [cell.lblAmount setTextColor:[UIColor colorWithRed:53/255.0 green:152/255.0 blue:219/255.0 alpha:100.0]];
    
    NSArray *UserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsWithUserTokenid:transaction.user_token_id ];
    if ([UserInfoarrray count]!=0)
    {
        UserInfo *userInfo =[UserInfoarrray objectAtIndex:0];
        [cell.lblUserName setText:userInfo.user_name];
    }
    return cell;
}




-(float) progress:(NSDate*)startDate :(NSDate*)endDate
{
    NSTimeInterval firstsBetween = [endDate timeIntervalSinceDate:startDate];
    float firstsnumberOfDays = firstsBetween / 86400;
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit fromDate:startDate toDate:[NSDate date]
    options:0];
    float secondsnumberOfDays = components.day;
    float toatal= secondsnumberOfDays/firstsnumberOfDays;
    return toatal;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
	TransactionDetailsViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"TransactionDetailsViewController"];
    [vc setTransaction:[self.warrantyItems objectAtIndex:[indexPath row]]];
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addWarrantyBtnClick:(id)sender
{
    [[AppCommonFunctions sharedInstance] pushVCOfClass:[AddWarrantyViewController class] fromNC:self.navigationController animated:YES setRootViewController:NO modifyVC:^(AddWarrantyViewController* info) {
        
    }];
}


- (IBAction)btnBackClick:(id)sender
{
    // [[SlideNavigationController sharedInstance]toggleLeftMenu];
}


- (IBAction)btnUserClick:(id)sender
{
    NSMutableArray *userInfoList=[[NSMutableArray alloc] init];
    NSArray *UserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsToUserRegisterTable];
//    if ([UserInfoarrray count]>1)
//    {
//        [userInfoList addObject:NSLocalizedString(@"allAccount", nil)];
//        for (UserInfo *info in UserInfoarrray)
//        {
//            [userInfoList addObject:info.user_name];
//        }
//    }
//    [userInfoList addObject:NSLocalizedString(@"addAccount", nil)];
    CGFloat xWidth = self.view.bounds.size.width - 120.0f;
    CGFloat yHeight = [userInfoList count]*40;
    if (yHeight>300)
    {
        yHeight=300;
    }
    CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
    UIPopoverListView *poplistview = [[UIPopoverListView alloc] initWithFrame:CGRectMake(10, yOffset, xWidth, yHeight)];
    [poplistview setTag:1];
    [poplistview setNotificationName:@"WarrantyViewController"];
    [poplistview setListArray:userInfoList];
    if (yHeight<300)
    {
    poplistview.listView.scrollEnabled = FALSE;
    }
    [poplistview show];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    UIBarButtonItem *newBackButton =
//    [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain   target:nil  action:nil];
//    [[self navigationItem] setBackBarButtonItem:newBackButton];
}
@end
