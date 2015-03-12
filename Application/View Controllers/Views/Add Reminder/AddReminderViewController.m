
//
//  AddReminderViewController.m
//  Daily Expense Manager
//
//  Created by Appbulous on 04/09/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import "AddReminderViewController.h"
#import "FPPopoverController.h"
#import "DemoTableController.h"
#import "ReminderHandler.h"
#import "ReminderCell.h"
#import "CategoryListHandler.h"
#import "UserInfoHandler.h"
#import "UserInfo.h"
#import "UIPopoverListView.h"
#import "AddAccountViewController.h"
#import "Reminder.h"
#import "ReminderDetailsViewController.h"
#import "HomeHelper.h"
#import "CreateReminderViewController.h"
//#import "MBProgressHUD.h"

@interface AddReminderViewController ()
@end

@implementation AddReminderViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotification:) name:@"AddReminderViewController" object:nil];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self updateAccout];
    if([[NSUserDefaults standardUserDefaults] boolForKey:UPDATION_ON_SERVER_TIME])
    {
        [[HomeHelper sharedCoreDataController] upgradeBackendDataOnServer];
    }
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
        self.reminderItems=[[ReminderHandler sharedCoreDataController] getAllReminderWithUserToken:userToken];
        dispatch_async(dispatch_get_main_queue(), ^{
           // [MBProgressHUD hideHUDForView:self.noReminderView animated:YES];
            if ([self.reminderItems count]==0)
            {
                [self.addReminderView setHidden:YES];
                [self.noReminderView setHidden:NO];
                [self.noReminderView setFrame:CGRectMake(0, 0, self.customeView.frame.size.width, self.customeView.frame.size.height)];
                [self.customeView addSubview:self.noReminderView];
            }else
            {
                [self.addReminderView setHidden:NO];
                [self.noReminderView setHidden:YES];
                [self.addReminderView setFrame:CGRectMake(0, 10, self.customeView.frame.size.width, self.customeView.frame.size.height)];
                [self.customeView addSubview:self.addReminderView];
            }
            [self.tableView reloadData];
        });
    });
}



-(void)viewDidAppear:(BOOL)animated
{
    [self profressView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)showLeft
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
	UIViewController *vc  = [mainStoryboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.reminderItems count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 137;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier = @"Reminder";
    ReminderCell *cell = (ReminderCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    Reminder *info=[self.reminderItems objectAtIndex:[indexPath row]];
    NSLog(@"%@",info);
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ReminderCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if ([info.transaction_type isEqualToString: NSLocalizedString(@"income", nil)])
    {
         [cell.lblAmount setTextColor:[UIColor colorWithRed:53/255.0 green:152/255.0 blue:219/255.0 alpha:100.0]];
        
    }else if ([info.transaction_type isEqualToString:NSLocalizedString(@"expense", nil)])
    {
       [cell.lblAmount setTextColor:[UIColor colorWithRed:232/255.0f green:76/255.0f blue:61/255.0f alpha:100.0f]];
        
    }else if ([info.transaction_type isEqualToString:NSLocalizedString(@"none", nil)])
    {
       [cell.lblAmount setTextColor:GREEN_COLOR];
    }
    
    NSArray *categeryArray=[[CategoryListHandler sharedCoreDataController] getsearchCategeryWithAttributeName:@"category_icon" andSearchText:info.category];
    if ([categeryArray count]!=0)
    {
        cell.imgCategery.image=[UIImage imageWithData:[[categeryArray objectAtIndex:0] objectForKey:@"category_icon"]];
    }
    [cell.lblCategery setText:info.category];
    
    if ([info.reminder_heading length]!=0)
        [cell.lblDiscription setText:info.reminder_heading];
    
    NSString *mainToken=[Utility userDefaultsForKey:MAIN_TOKEN_ID];
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setPositiveFormat:@"0.##"];
    
    NSString *currency= [Utility  userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",CURRENT_CURRENCY,mainToken]];
    [cell.lblAmount setText:[NSString stringWithFormat:@"%@ %@",[[currency componentsSeparatedByString:@"-"] objectAtIndex:1],[fmt stringFromNumber:[NSNumber numberWithDouble:[info.amount doubleValue]]]]];
    
    NSArray *UserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsWithUserTokenid:info.user_token_id];
    if ([UserInfoarrray count]!=0)
    {
        UserInfo *userInfo =[UserInfoarrray objectAtIndex:0];
        [cell.lblProfileName setText:userInfo.user_name];
    }

    NSString *nDate=[info.date stringValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:([nDate doubleValue] / 1000)];
    NSDateFormatter *df = [[NSDateFormatter alloc] init] ;
    [df setDateFormat:@"dd LLLL yyyy"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [cell.lblNextTransationDate setText:[NSString stringWithFormat:@"%@ at %@",[df stringFromDate:date],[formatter stringFromDate:date]]];
    if ([info.reminder_when_to_alert intValue]==0)
    {
        [dateComponents setHour:-[info.reminder_time_period intValue]];
        NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:date options:0];
        [cell.lblNextReminderDate setText:[NSString stringWithFormat:@"%@ at %@",[df stringFromDate:newDate],[formatter stringFromDate:newDate]]];
    }else  if ([info.reminder_when_to_alert intValue]==1)
    {
        [dateComponents setDay:-[info.reminder_time_period intValue]];
        NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:date options:0];
        [cell.lblNextReminderDate setText:[NSString stringWithFormat:@"%@ at %@",[df stringFromDate:newDate],[formatter stringFromDate:newDate]]];
        
    }else  if ([info.reminder_when_to_alert intValue]==2)
    {
        [dateComponents setHour:-[info.reminder_time_period  intValue]];
        NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:date options:0];
        [cell.lblNextReminderDate setText:[NSString stringWithFormat:@"%@ at %@",[df stringFromDate:newDate],[formatter stringFromDate:newDate]]];
    }
    
    if ([info.reminder_alert isEqualToString:@"false"])
    {
        [cell.lblAlarmChek setText:[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"alert", nil), NSLocalizedString(@"OFF", nil)]];
    }else
        [cell.lblAlarmChek setText:[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"alert", nil), NSLocalizedString(@"ON", nil)]];
    
    CGFloat borderWidth = .3f;
    cell.frame = CGRectInset(cell.frame, -borderWidth, -borderWidth);
    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.layer.borderWidth = borderWidth;
	return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    ReminderDetailsViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"ReminderDetailsViewController"];
    [vc setTransaction:[self.reminderItems objectAtIndex:[indexPath row]]];
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)backbtnClick:(id)sender
{
   // [[SlideNavigationController sharedInstance]toggleLeftMenu];
}

- (BOOL)allowsHeaderViewsToFloat
{
    return NO;
}


- (IBAction)btnUserNameClick:(id)sender
{
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
    [UIActionSheet showInView:self.view withTitle:nil cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:userInfoList tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex)
     {
         if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]) {
             return ;
         }
         if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"addAccount", nil)])
         {
             AddAccountViewController *catageryController=[self.storyboard instantiateViewControllerWithIdentifier:@"AddAccountViewController"];
             [self.navigationController pushViewController:catageryController animated:YES];
             
         }else
         {
             [Utility saveToUserDefaults:[actionSheet buttonTitleAtIndex:buttonIndex]  withKey:CURRENT_USER__TOKEN_ID];
             [self updateAccout];
             [self profressView];
         }

     }];}

-(void)pushCreateReminder
{
    [[AppCommonFunctions sharedInstance] pushVCOfClass:[CreateReminderViewController class] fromNC:self.navigationController animated:YES popFirstToVCOfClass:nil modifyVC:^(CreateReminderViewController* info)
    {
        [info setTransaction:nil];
    }];
}
-(void)updateAccout
{
    self.reminderItems=[[NSMutableArray alloc] init];
    [self.addReminderView setHidden:YES];
    [self.noReminderView setHidden:NO];
    [self.noReminderView setFrame:CGRectMake(0, 0, self.customeView.frame.size.width, self.customeView.frame.size.height)];
    [self.customeView addSubview:self.noReminderView];
    [self.btnUserName setTitle:[Utility userDefaultsForKey:CURRENT_USER__TOKEN_ID] forState:UIControlStateNormal];
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
    
}




-(void)receivedNotification:(NSNotification*) notification
{
    NSDictionary * info =notification.userInfo;
    }


@end
