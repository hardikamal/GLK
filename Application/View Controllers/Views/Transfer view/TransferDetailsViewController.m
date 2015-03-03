//
//  TransferDetailsViewController.m
//  Daily Expense Manager
//
//  Created by Appbulous on 16/10/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import "TransferDetailsViewController.h"
#import "CategoryListHandler.h"
#import "PaymentmodeHandler.h"
#import "UserInfoHandler.h"
#import "TransferHandler.h"
#import "UIAlertView+Block.h"
#import "TransferDetailsViewController.h"
#import "AddTransferViewController.h"
@interface TransferDetailsViewController ()

@end

@implementation TransferDetailsViewController
@synthesize transaction;
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
   // self.scrollView.contentSize=CGSizeMake(300, 450);
    [[UILabel appearance] setFont:[UIFont fontWithName:Embrima size:16.0]];
    [self.lblTitle setFont:[UIFont fontWithName:Ebrima_Bold size:17.0f]];
}



-(void)viewWillAppear:(BOOL)animated
{
    
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
    
    NSArray *UserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsWithUserTokenid:transaction.fromaccount];
    UserInfo *userInfo =[UserInfoarrray objectAtIndex:0];
    [self.lblUserFrom setText:userInfo.user_name];
    
    UserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsWithUserTokenid:transaction.toaccount];
    userInfo =[UserInfoarrray objectAtIndex:0];
    [self.lblUserTo setText:userInfo.user_name];
    
    NSString *nDate=[transaction.date stringValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:([nDate doubleValue] / 1000)];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd MMMM yyyy"];
    NSLog(@"%@",[dateFormatter stringFromDate:date]);
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
    {
        [self.lblDiscription setText:@"No Description"];
    }
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        if ( [[TransferHandler sharedCoreDataController] deleteTransefer:transaction])
        {
            [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"transferdeletedSuccessfully", nil)];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)BackbtnClick:(id)sender

{
    [self.navigationController popViewControllerAnimated:YES];

}


- (IBAction)btnDeleteClick:(id)sender
{
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Alert" message:NSLocalizedString(@"areyousuretodeletetransfer", nil) delegate:self cancelButtonTitle:@"Continue"  otherButtonTitles: nil];
    [alert addButtonWithTitle:@"Cancel"];
    [alert show];
}

- (IBAction)btnEditClick:(id)sender
{
    NSLog(@"%@",transaction);
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    AddTransferViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"AddTransferViewController"];
    [vc setTransaction:transaction];
    [self.navigationController pushViewController:vc animated:YES];
}



@end
