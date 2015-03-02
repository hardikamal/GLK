//
//  ReminderDetailsViewController.m
//  Daily Expense Manager
//
//  Created by Appbulous on 03/11/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import "ReminderDetailsViewController.h"
#import "ReminderHandler.h"
#import "CategoryListHandler.h"
#import "UserInfoHandler.h"
#import "PaymentmodeHandler.h"
#import "AddTransactionViewController.h"
#import "UIAlertView+Block.h"
#import "TransactionHandler.h"
#import "HistoryViewController.h"
#import "UserInfo.h"
#import "CreateReminderViewController.h"
#import "AddReminderViewController.h"
#import "ImageViewController.h"
@interface ReminderDetailsViewController ()

@end

@implementation ReminderDetailsViewController
@synthesize transaction;
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
    [[UILabel appearance] setFont:[UIFont fontWithName:Embrima size:16.0]];
    [self.lblTitle setFont:[UIFont fontWithName:Ebrima_Bold size:17.0f]];
    self.scrollView.contentSize=CGSizeMake(300, 410);
    
}



-(void)viewWillAppear:(BOOL)animated
{
    
    if ([self backViewController])
    {
        [self.btnDeleate setHidden:NO];
        [self.btnEdit setHidden:NO];
        
    }
    else
    {
        [self.btnDeleate setHidden:YES];
        [self.btnEdit setHidden:YES];
    }
    if ([transaction.transaction_type isEqualToString: NSLocalizedString(@"income", nil)])
    {
        [_lblAmount setTextColor:[UIColor colorWithRed:53/255.0 green:152/255.0 blue:219/255.0 alpha:100.0]];
        
    }else if ([transaction.transaction_type isEqualToString:NSLocalizedString(@"expense", nil)])
    {
        [_lblAmount setTextColor:[UIColor colorWithRed:232/255.0f green:76/255.0f blue:61/255.0f alpha:100.0f]];
        
    }else if ([transaction.transaction_type isEqualToString:NSLocalizedString(@"none", nil)])
    {
        [_lblAmount setTextColor:GREEN_COLOR];
    }
    
    NSArray *categeryArray=[[CategoryListHandler sharedCoreDataController] getsearchCategeryWithAttributeName:@"category_icon" andSearchText:transaction.category];
    
    if ([categeryArray count]!=0)
    {
        self.imgCategery.image=[UIImage imageWithData:[[categeryArray objectAtIndex:0] objectForKey:@"category_icon"]];
    }
    
    if (![transaction.sub_category isEqualToString:@""])
    {
        [self.lblCategery setText:[NSString stringWithFormat:@"%@ (%@)",transaction.category,transaction.sub_category]];
    }else
        [self.lblCategery setText:transaction.category];
    
    NSString *mainToken= [Utility userDefaultsForKey:MAIN_TOKEN_ID];
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setPositiveFormat:@"0.##"];
    
    NSString *currency= [Utility  userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",CURRENT_CURRENCY,mainToken]];
    
    [self.lblAmount setText:[NSString stringWithFormat:@"%@ %@",[[currency componentsSeparatedByString:@"-"] objectAtIndex:1],[fmt stringFromNumber:[NSNumber numberWithDouble:[transaction.amount doubleValue]]]]];
    
    NSArray *UserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsWithUserTokenid:transaction.user_token_id];
   
    if ([UserInfoarrray count]!=0)
    {
        UserInfo *userInfo =[UserInfoarrray objectAtIndex:0];
        [self.lblAcccount setText:userInfo.user_name];
    }
    [self.lblRecurring setText:transaction.reminder_recurring_type];
    
    if ([transaction.reminder_alert isEqualToString:@"false"])
    {
        [self.lblAlert setText:[NSString stringWithFormat:@"%@", NSLocalizedString(@"no", nil)]];
    }else
        [self.lblAlert setText:[NSString stringWithFormat:@"%@", NSLocalizedString(@"yes", nil)]];
    
    NSString *nDate=[transaction.date stringValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:([nDate doubleValue] / 1000)];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd MMMM yyyy"];
    [self.lblDate setText:[dateFormatter stringFromDate:date]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    [self.lblTime setText:[formatter stringFromDate:date]];
    
    NSString *paymentMode=transaction.paymentMode;
    NSArray *paymentModeArray=[[PaymentmodeHandler sharedCoreDataController] getsearchPaymentWithAttributeName:paymentMode];
    NSDictionary * paymentInfo =[paymentModeArray objectAtIndex:0];
    [self.lblPaymentMode setText:[paymentInfo objectForKey:@"paymentMode"]];
    [self.imgPaymentMode setImage:[UIImage imageWithData:[paymentInfo objectForKey:@"paymentmode_icon"]]];
    
    if ([transaction.discription length]!=0)
    {
        [self.lblDiscription setText:transaction.discription];
    }else
         [self.lblDiscription setText:@"No Description"];
    
        
    if ([transaction.reminder_heading length]!=0)
    {
        [self.lblHeading setText:transaction.reminder_heading];
    }else
        [self.lblHeading setText:@"No Heading"];
    
    UIImage *image=[UIImage imageWithData:transaction.pic];
    if (image!=nil)
    {
        UITapGestureRecognizer *oneTouch=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(OneTouchHandeler)];
        [oneTouch setNumberOfTouchesRequired:1];
        [self.imgView setImage:[UIImage imageWithData:transaction.pic]];
        [self.imgView addGestureRecognizer:oneTouch];
        self.scrollView.contentSize=CGSizeMake(300, 460);

    }else
        [self.imgView setImage:nil];
    
}


-(void)OneTouchHandeler
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    ImageViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"ImageViewController"];
    [vc setImage:[UIImage imageWithData:transaction.pic]];
    [vc setString:[[NSString alloc] initWithString:NSLocalizedString(@"reminderdetails", nil)] ];
    [self  presentViewController:vc animated:NO completion:nil];
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        if ( [[ReminderHandler sharedCoreDataController] deleteReminder:transaction])
        {
        [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"reminderdeletedSuccessfully", nil)];
        [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


- (BOOL)backViewController
{
    for (UIViewController * viewController in [self.navigationController viewControllers])
    {
        if ([viewController isKindOfClass:[AddReminderViewController class]])
        {
            return  YES;
        }
        
    }
    return NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)BackbtnClick:(id)sender;
{
    if ([self backViewController])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)btnEditClick:(id)sender
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard"	 bundle: nil];
    CreateReminderViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"CreateReminderViewController"];
    [vc setTransaction:transaction];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnDeleteClick:(id)sender
{
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Alert" message:NSLocalizedString(@"areyousuretodeletereminder", nil) delegate:self cancelButtonTitle:@"Continue"  otherButtonTitles: nil];
    [alert addButtonWithTitle:@"Cancel"];
    [alert show];
}


@end
