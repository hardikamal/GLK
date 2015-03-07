//
//  TransferViewController.m
//  Daily Expense Manager
//
//  Created by Appbulous on 10/09/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import "TransferViewController.h"
#import "FPPopoverController.h"
#import "DemoTableController.h"
#import "HomeViewController.h"

#import "TrasferCell.h"
#import "UserInfo.h"
#import "UserInfoHandler.h"
#import "UIPopoverListView.h"
#import "TransferHandler.h"
#import "Transfer.h"
#import "CategoryListHandler.h"
#import "UserInfoHandler.h"
#import "PaymentmodeHandler.h"
#import "TransferDetailsViewController.h"
#import "AddAccountViewController.h"
#import "HomeHelper.h"
#import "AddTransferViewController.h"
@interface TransferViewController ()
@end


@implementation TransferViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotification:) name:@"TransferViewController" object:nil];
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
            NSArray *UserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsWithUserName:@"GUEST"];
            if ([UserInfoarrray count]!=0 )
            {
                UserInfo *userInfo =[UserInfoarrray objectAtIndex:0];
                userToken=userInfo.user_token_id;
            }else
            {
                userToken=@"";
            }
        }

        self.transferItems=[[TransferHandler sharedCoreDataController] getUserDetailsfromTransfer:userToken];
        dispatch_async(dispatch_get_main_queue(), ^{
            //[MBProgressHUD hideHUDForView:self.emptyWarrantyView animated:YES];
            if ([self.transferItems count]==0)
            {
                [self.emptyWarrantyView setFrame:CGRectMake(0, 2, self.customeView.frame.size.width, self.customeView.frame.size.height)];
                [self.addWarrantyView setHidden:YES];
                [self.emptyWarrantyView setHidden:NO];
                [self.customeView addSubview:self.emptyWarrantyView];
            }else
            {
                [self.addWarrantyView setHidden:NO];
                [self.emptyWarrantyView setHidden:YES];
                [self.addWarrantyView setFrame:CGRectMake(0, 2, self.customeView.frame.size.width, self.customeView.frame.size.height)];
                [self.customeView addSubview:self.addWarrantyView];
            }
            [self.tablview reloadData];
        });
    });
}



-(void)updateAccout
{
    self.transferItems=[[NSMutableArray alloc] init];
   // [MBProgressHUD showHUDAddedTo:self.emptyWarrantyView  animated:YES];
    [self.emptyWarrantyView setFrame:CGRectMake(0, 2, self.customeView.frame.size.width, self.customeView.frame.size.height)];
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
    if ([userInfoarrray count]!=0)
    {
        UserInfo *userInfo =[userInfoarrray objectAtIndex:0];
        if ([userInfo.user_img length]!=0)
        {
            self.imageTransfer.layer.cornerRadius = self.imageTransfer.frame.size.width / 2;
            self.imageTransfer.clipsToBounds = YES;
            self.imageTransfer.image=[UIImage imageWithData:userInfo.user_img];
        }else
            self.imageTransfer.image=[UIImage imageNamed:@"custom_profile.png"];
    }
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
    return [self.transferItems count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 109;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrasferCell *cell = (TrasferCell*)[tableView dequeueReusableCellWithIdentifier:@"Transfer"];
    cell.leftUtilityButtons = [self leftButtons];
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    Transfer *transfer=(Transfer*)[self.transferItems objectAtIndex:[indexPath row]];
    NSArray *categeryArray=[[CategoryListHandler sharedCoreDataController] getsearchCategeryWithAttributeName:@"category_icon" andSearchText: transfer.category];
    
    if ([categeryArray count]!=0)
    {
        cell.imgCategery.image=[UIImage imageWithData:[[categeryArray objectAtIndex:0] objectForKey:@"category_icon"]];
    }
    
    [cell.lblCatgery setText:transfer.category];
    
    NSString *nDate=[transfer.date stringValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:([nDate doubleValue] / 1000)];
    NSDateFormatter *df = [[NSDateFormatter alloc] init] ;
    [df setDateFormat:@"dd LLLL yyyy"];
    [cell.lblDate setText:[df stringFromDate:date]];
    
    if ([transfer.discription length]!=0)
        [cell.lblDiscription setText:transfer.discription];
    
    NSString *mainToken=[Utility userDefaultsForKey:MAIN_TOKEN_ID];
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setPositiveFormat:@"0.##"];
    NSString *currency= [Utility  userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",CURRENT_CURRENCY,mainToken]];
    [cell.lblAmount setText:[NSString stringWithFormat:@"%@ %@",[[currency componentsSeparatedByString:@"-"] objectAtIndex:1],[fmt stringFromNumber:[NSNumber numberWithDouble:[transfer.amount doubleValue]]]]];
    
    NSArray *userInfoarrray=[[UserInfoHandler sharedCoreDataController]getUserDetailsWithUserTokenid:transfer.fromaccount];
    UserInfo *fromuserInfo =[userInfoarrray objectAtIndex:0];
    userInfoarrray=[[UserInfoHandler sharedCoreDataController]getUserDetailsWithUserTokenid:transfer.toaccount];
    UserInfo *touserInfo =[userInfoarrray objectAtIndex:0];
    
    [cell.lblTransactionDetails setText:[NSString stringWithFormat:@"%@ -> %@",fromuserInfo.user_name,touserInfo.user_name]];
    CGFloat borderWidth = .3f;
    cell.frame = CGRectInset(cell.frame, -borderWidth, -borderWidth);
    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.layer.borderWidth = borderWidth;
    return cell;
    
}



- (IBAction)backbtnClick:(id)sender
{
    
    // [[SlideNavigationController sharedInstance]toggleLeftMenu];
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
    CGFloat xWidth = self.view.bounds.size.width - 120.0f;
    CGFloat yHeight = [userInfoList count]*40;
    if (yHeight>300)
    {
        yHeight=300;
    }
    CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
    UIPopoverListView *poplistview = [[UIPopoverListView alloc] initWithFrame:CGRectMake(10, yOffset, xWidth, yHeight)];
    [poplistview setTag:1];
    [poplistview setNotificationName:@"TransferViewController"];
    [poplistview setListArray:userInfoList];
    if (yHeight<300)
    {
        poplistview.listView.scrollEnabled = FALSE;
    }
    
    [poplistview show];
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain   target:nil  action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];
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
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    switch (index)
    {
        case 0:
        {
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Alert" message:NSLocalizedString(@"areyousuretodeletetransfer", nil) delegate:self cancelButtonTitle:@"Continue"  otherButtonTitles: nil];
            [alert addButtonWithTitle:@"Cancel"];
            [alert setTag:index];
            [alert show];
            break;
        }
        default:
            break;
    }
}



- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        if ([[TransferHandler sharedCoreDataController] deleteTransefer:[self.transferItems objectAtIndex:alertView.tag]])
        {
            [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"transferdeletedSuccessfully", nil)];
            [self profressView];
        }
    }
}




- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *cellIndexPath = [self.tablview indexPathForCell:cell];
    switch (index)
    {
        case 0:
        {
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
            AddTransferViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"AddTransferViewController"];
            [vc setTransaction:[self.transferItems objectAtIndex:cellIndexPath.row]];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1:
        {
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
            TransferDetailsViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"TransferDetailsViewController"];
            [vc setTransaction:[self.transferItems objectAtIndex:cellIndexPath.row]];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}






- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cell selected at index path %ld:%ld", (long)indexPath.section, (long)indexPath.row);
    NSLog(@"selected cell index path is %@", [self.tablview indexPathForSelectedRow]);
    if (!tableView.isEditing)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:YELLOW_COLOR icon:[UIImage imageNamed:@"edit_icon.png"]];
    [rightUtilityButtons sw_addUtilityButtonWithColor:BLUE_COLOR   icon:[UIImage imageNamed:@"details_icon.png"]];
    
    return rightUtilityButtons;
}

- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    [leftUtilityButtons sw_addUtilityButtonWithColor:RED_COLOR  icon:[UIImage imageNamed:@"delete_icon.png"]];
    return leftUtilityButtons;
}


@end
