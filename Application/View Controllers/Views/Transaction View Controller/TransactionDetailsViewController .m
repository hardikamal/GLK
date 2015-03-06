//
//  TransactionDetailsViewController.m
//  Daily Expense Manager
//
//  Created by Appbulous on 19/09/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import "TransactionDetailsViewController.h"
#import "CategoryListHandler.h"
#import "UserInfoHandler.h"
#import "PaymentmodeHandler.h"
#import "AddTransactionViewController.h"
#import "UIAlertView+Block.h"
#import "TransactionHandler.h"
#import "HistoryViewController.h"
#import "UserInfo.h"
#import "WarrantyViewController.h"
#import "AddWarrantyViewController.h"
#import "HomeViewController.h"
#import "TransferHandler.h"
#import "Transfer.h"

@interface TransactionDetailsViewController ()
@end

@implementation TransactionDetailsViewController
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
}



-(void)viewWillAppear:(BOOL)animated
{
   
    if ([self backViewController]|| [self WarrantyViewController])
    {
        if ([self.transaction.transaction_inserted_from integerValue]!=TYPE_TRANSFER)
        {
            [self.btnDelete setHidden:NO];
            [self.btnEdit setHidden:NO];
        }else
        {
            [self.btnDelete setHidden:YES];
            [self.btnEdit setHidden:YES];
        }
    }
    else
    {
        [self.btnDelete setHidden:YES];
        [self.btnEdit setHidden:YES];
    }
    
    if ([self.newtitle length]!=0)
    {
        [self.lblTitle setText:self.newtitle];
        CGSize maxSize = CGSizeMake(200, 9999);
        CGRect labRect = [self.lblTitle.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:Ebrima_Bold size:16.0f]} context:nil];
        [self.btnBack setFrame:CGRectMake(0,19,labRect.size.width+51,44)];
    }
    NSArray *categeryArray=[[CategoryListHandler sharedCoreDataController] getsearchCategeryWithAttributeName:@"category_icon" andSearchText:transaction.category];
    
    if (![transaction.transaction_type intValue]==TYPE_INCOME)
        [_lblAmount setTextColor:[UIColor colorWithRed:232/255.0f green:76/255.0f blue:61/255.0f alpha:100.0f]];
    else
        [_lblAmount setTextColor:[UIColor colorWithRed:53/255.0 green:152/255.0 blue:219/255.0 alpha:100.0]];
    
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
    UserInfo *userInfo =[UserInfoarrray objectAtIndex:0];
    [self.lblAcccount setText:userInfo.user_name];
    
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
    {
        [self.lblDiscription setText:@"No Description"];
    }
    
    if ([transaction.location length]!=0)
    {
        [self.lblLocatation setText:transaction.location];
    }else
    {
        [self.lblLocatation setText:NSLocalizedString(@"noLocation", nil)];
    }
    
    if ([transaction.with_person length]!=0)
    {
           [self.lblWithPerson setText:transaction.with_person];
    }else
    {
         [self.lblWithPerson setText:NSLocalizedString(@"noTag", nil)];
    }
    
    if (![transaction.warranty.stringValue isEqualToString:@"0"] )
    {
        NSString *nDate=[transaction.warranty stringValue];
        NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:([nDate doubleValue] / 1000)];
        [self.lblWarranty setText:[dateFormatter stringFromDate:newDate]];
    }
    UIImage *image=[UIImage imageWithData:transaction.pic];
    if (image!=nil)
    {
        UITapGestureRecognizer *oneTouch=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(OneTouchHandeler)];
        [oneTouch setNumberOfTouchesRequired:1];
        [self.imgView setImage:[UIImage imageWithData:transaction.pic]];
        [self.imgView addGestureRecognizer:oneTouch];
       
    }else
    {
          [self.imgView setImage:nil];
    }
    
    if ([transaction.transaction_inserted_from integerValue]==TYPE_REMINDER || [transaction.transaction_inserted_from integerValue]==TYPE_TRANSFER )
    {
        if (image!=nil)
        {
            self.scrollView.contentSize=CGSizeMake(300, 520);
        }else
            self.scrollView.contentSize=CGSizeMake(300, 480);
        
        if ([transaction.transaction_inserted_from integerValue]==TYPE_REMINDER)
        {
            [self.lblTielExtra setText:NSLocalizedString(@"addtoreminder", nil)];
           
        }else
        {
            NSArray *array = [[TransferHandler sharedCoreDataController] getTranferWithTransactionId:transaction.transaction_reference_id];
            Transfer *transfer=[array objectAtIndex:0];
            if ([transaction.transaction_type intValue]==TYPE_INCOME)
            {
                NSArray *UserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsWithUserTokenid:transfer.fromaccount];
                if ([UserInfoarrray count]!=0)
                {
                    UserInfo *userInfo =[UserInfoarrray objectAtIndex:0];
                    [self.lblTielExtra setText:NSLocalizedString(@"fromTransfer", nil)];
                    [self.lblExtra setText:userInfo.user_name];
                }
            }else
            {
                NSArray *UserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsWithUserTokenid:transfer.toaccount];
                if ([UserInfoarrray count]!=0)
                {
                    UserInfo *userInfo =[UserInfoarrray objectAtIndex:0];
                    [self.lblTielExtra setText:NSLocalizedString(@"toTransfer", nil)];
                    [self.lblExtra setText:userInfo.user_name];
                }
                
            }
        }
    }else
    {
        [self.viewExtra setHidden:YES];
        [self.viewImageView setFrame:CGRectMake(self.viewImageView.frame.origin.x, self.viewExtra.frame.origin.y, self.viewImageView.frame.size.width, self.viewImageView.frame.size.height+30)];
        if (image!=nil)
        {
           self.scrollView.contentSize=CGSizeMake(300, 475);
        }else
           self.scrollView.contentSize=CGSizeMake(300, 435);
    }
}



-(void)OneTouchHandeler
{
    [[AppCommonFunctions sharedInstance]showImage:[UIImage imageWithData:transaction.pic] fromView:[self view]];
}

- (BOOL)backViewController
{
    for (UIViewController * viewController in [self.navigationController viewControllers])
    {
        if ([viewController isKindOfClass:[HistoryViewController class]] || [viewController isKindOfClass:[HomeViewController class]])
        {
            return  YES;
        }
    }
    return NO;
}

    
- (BOOL)WarrantyViewController
{
    for (UIViewController * viewController in [self.navigationController viewControllers])
    {
        if ([viewController isKindOfClass:[WarrantyViewController class]])
        {
            return  YES;
        }
    }
    return NO;
}

    
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        if ( [[TransactionHandler sharedCoreDataController] deleteTransaction:transaction])
        {
            NSString *defination;
            if ([self WarrantyViewController])
            {
                defination=NSLocalizedString(@"warrantydeletedSuccessfully", nil);
            }else
                defination=NSLocalizedString(@"transactionsdeletedSuccessfully", nil);
            [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"transactionsdeletedSuccessfully", nil)];
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
    if ([self backViewController] || [self WarrantyViewController])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
         [self dismissViewControllerAnimated:YES completion:nil];
    }
}



- (IBAction)btnEditClick:(id)sender
{
     UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    if ([self WarrantyViewController])
    {
         AddWarrantyViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"AddWarrantyViewController"];
         [vc setTransaction:transaction];
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
         AddTransactionViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"AddTransactionViewController"];
          [vc setTransaction:transaction];
          [self.navigationController pushViewController:vc animated:YES];
    }
}




- (IBAction)btnDeleate:(id)sender
{
    NSString *defination;
    if ([self WarrantyViewController])
    {
        defination=NSLocalizedString(@"areyousuretodeletetwarranty", nil);
    }else
          defination=NSLocalizedString(@"areyousuretodeletetransaction", nil);
    
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Alert" message:defination delegate:self cancelButtonTitle:@"Continue"  otherButtonTitles: nil];
    [alert addButtonWithTitle:@"Cancel"];
    [alert show];
    
}
@end
