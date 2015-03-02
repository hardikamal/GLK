//
//  LoginCallbacksViewController.m
//  Daily Expense Manager
//
//  Created by Appbulous on 31/12/14.
//  Copyright (c) 2014 Chandan Kumar. All rights reserved.
//

#import "LoginCallbacksViewController.h"
//#import "MBProgressHUD.h"
#import "SAAPIClient.h"
#import "TransactionHandler.h"
#import "ReminderHandler.h"
#import "TransferHandler.h"
#import "BudgetHandler.h"
#import "UserInfoHandler.h"
#import "CategoryListHandler.h"
#import "PaymentmodeHandler.h"



@interface LoginCallbacksViewController ()
{
    // MBProgressHUD *  progressHUD;
}
@end

@implementation LoginCallbacksViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat xWidth = self.popUpView.frame.size.width;
    CGFloat yHeight = self.popUpView.frame.size.height;
    CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
    [self.activityIndicatorBudgets startAnimating];
    [self.activityIndicatorCategery startAnimating];
    [self.activityIndicatorPaymentMode startAnimating];
    [self.activityIndicatorRemider startAnimating];
    [self.activityIndicatorTransaction startAnimating];
    [self.activityIndicatorTransfer startAnimating];
     [self.lbltitile setFont:[UIFont fontWithName:Ebrima_Bold size:16.0f]];
    
    [self.popUpView setFrame:CGRectMake(10, yOffset, xWidth, yHeight)];
    self.popUpView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.popUpView.layer.borderWidth = 1.0f;
    self.popUpView.clipsToBounds = TRUE;
    
//    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
//    tapRecognizer.numberOfTapsRequired = 1;
//    self.tapView.userInteractionEnabled=YES;
//    [self.tapView addGestureRecognizer:tapRecognizer];
    
    if ([[Utility userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",LAST_TABLE_TYPE,[Utility userDefaultsForKey:MAIN_TOKEN_ID]]] isEqualToString:@"getAllModes"])
    {
        [self.lblCategries setText:NSLocalizedString(@"categories", nil)];
        [self.activityIndicatorCategery stopAnimating];
       
        UIImageView *activityIndicatorCategeryimage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ok_button.png"]];
        activityIndicatorCategeryimage.frame=self.activityIndicatorCategery.frame;
        [self.popUpView addSubview:activityIndicatorCategeryimage];
        
    }else if ([[Utility userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",LAST_TABLE_TYPE,[Utility userDefaultsForKey:MAIN_TOKEN_ID]]] isEqualToString:@"getAllTransfer"])
    {
     
        [self.lblCategries setText:NSLocalizedString(@"categories", nil)];
        [self.activityIndicatorCategery stopAnimating];
        
        UIImageView *activityIndicatorCategeryimage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ok_button.png"]];
        activityIndicatorCategeryimage.frame=self.activityIndicatorCategery.frame;
         [self.popUpView addSubview:activityIndicatorCategeryimage];
        
        [self.activityIndicatorPaymentMode stopAnimating];
        [self.lblPaymentMode setText:NSLocalizedString(@"paymentmodes",nil)];
        UIImageView *activityIndicatorPaymentModeimage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ok_button.png"]];
        activityIndicatorPaymentModeimage.frame=self.activityIndicatorCategery.frame;
         [self.popUpView addSubview:activityIndicatorPaymentModeimage];
    
        
    }else if ([[Utility userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",LAST_TABLE_TYPE,[Utility userDefaultsForKey:MAIN_TOKEN_ID]]] isEqualToString:@"getAllBudget"])
    {
        
        [self.lblCategries setText:NSLocalizedString(@"categories", nil)];
        [self.activityIndicatorCategery stopAnimating];
        
        UIImageView *activityIndicatorCategeryimage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ok_button.png"]];
        activityIndicatorCategeryimage.frame=self.activityIndicatorCategery.frame;
        [self.popUpView addSubview:activityIndicatorCategeryimage];
        
        [self.activityIndicatorPaymentMode stopAnimating];
        [self.lblPaymentMode setText:NSLocalizedString(@"paymentmodes",nil)];
        UIImageView *activityIndicatorPaymentModeimage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ok_button.png"]];
        activityIndicatorPaymentModeimage.frame=self.activityIndicatorCategery.frame;
        [self.popUpView addSubview:activityIndicatorPaymentModeimage];
        
        
        [self.activityIndicatorTransfer stopAnimating];
        [self.lblTransfer setText:NSLocalizedString(@"transfers", nil)];
        
        UIImageView *activityIndicatorTransferimage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ok_button.png"]];
        activityIndicatorTransferimage.frame=self.activityIndicatorCategery.frame;
        [self.popUpView addSubview:activityIndicatorTransferimage];
        
        
    }else if ([[Utility userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",LAST_TABLE_TYPE,[Utility userDefaultsForKey:MAIN_TOKEN_ID]]] isEqualToString:@"getAllReminders"])
    {
        
        [self.lblCategries setText:NSLocalizedString(@"categories", nil)];
        [self.activityIndicatorCategery stopAnimating];
        
        UIImageView *activityIndicatorCategeryimage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ok_button.png"]];
        activityIndicatorCategeryimage.frame=self.activityIndicatorCategery.frame;
        [self.popUpView addSubview:activityIndicatorCategeryimage];
        
        [self.activityIndicatorPaymentMode stopAnimating];
        [self.lblPaymentMode setText:NSLocalizedString(@"paymentmodes",nil)];
        UIImageView *activityIndicatorPaymentModeimage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ok_button.png"]];
        activityIndicatorPaymentModeimage.frame=self.activityIndicatorCategery.frame;
        [self.popUpView addSubview:activityIndicatorPaymentModeimage];
        
        
        [self.activityIndicatorTransfer stopAnimating];
        [self.lblTransfer setText:NSLocalizedString(@"transfers", nil)];
        
        UIImageView *activityIndicatorTransferimage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ok_button.png"]];
        activityIndicatorTransferimage.frame=self.activityIndicatorCategery.frame;
        [self.popUpView addSubview:activityIndicatorTransferimage];
        
        [self.activityIndicatorBudgets stopAnimating];
        [self.lblBudgets setText:NSLocalizedString(@"budgets", nil)];
       
        UIImageView *activityIndicatorBudgets=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ok_button.png"]];
        activityIndicatorBudgets.frame=self.activityIndicatorCategery.frame;
        [self.popUpView addSubview:activityIndicatorBudgets];
        
        
        
    }else if ([[Utility userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",LAST_TABLE_TYPE,[Utility userDefaultsForKey:MAIN_TOKEN_ID]]] isEqualToString:@"getAllTrans"])
    {
        [self.lblCategries setText:NSLocalizedString(@"categories", nil)];
        [self.activityIndicatorCategery stopAnimating];
        
        UIImageView *activityIndicatorCategeryimage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ok_button.png"]];
        activityIndicatorCategeryimage.frame=self.activityIndicatorCategery.frame;
        [self.popUpView addSubview:activityIndicatorCategeryimage];
        
        [self.activityIndicatorPaymentMode stopAnimating];
        [self.lblPaymentMode setText:NSLocalizedString(@"paymentmodes",nil)];
        UIImageView *activityIndicatorPaymentModeimage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ok_button.png"]];
        activityIndicatorPaymentModeimage.frame=self.activityIndicatorCategery.frame;
        [self.popUpView addSubview:activityIndicatorPaymentModeimage];
        
        
        [self.activityIndicatorTransfer stopAnimating];
        [self.lblTransfer setText:NSLocalizedString(@"transfers", nil)];
        
        UIImageView *activityIndicatorTransferimage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ok_button.png"]];
        activityIndicatorTransferimage.frame=self.activityIndicatorCategery.frame;
        [self.popUpView addSubview:activityIndicatorTransferimage];
        
        [self.activityIndicatorBudgets stopAnimating];
        [self.lblBudgets setText:NSLocalizedString(@"budgets", nil)];
        
        UIImageView *activityIndicatorBudgets=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ok_button.png"]];
        activityIndicatorBudgets.frame=self.activityIndicatorCategery.frame;
        [self.popUpView addSubview:activityIndicatorBudgets];
    
        [self.lblReminder setText:NSLocalizedString(@"reminders", nil)];
        [self.activityIndicatorRemider stopAnimating];
        
        UIImageView *activityIndicatorRemiderimage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ok_button.png"]];
        activityIndicatorBudgets.frame=self.activityIndicatorCategery.frame;
        [self.popUpView addSubview:activityIndicatorRemiderimage];
    }
       [self calllLoginMenthode];
}



-(void)calllLoginMenthode
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[Utility userDefaultsForKey:CURRENT_TOKEN_ID] forKey:@"usertoken_id"];
    [dic setObject:[Utility userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",LAST_TABLE_COUNT,[Utility userDefaultsForKey:MAIN_TOKEN_ID]]] forKey:@"start_limit"];
    [dic setObject:[Utility userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",LAST_TABLE_TYPE,[Utility userDefaultsForKey:MAIN_TOKEN_ID]]] forKey:@"cn"];
    [self login:dic];
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)animatedIn
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}

- (void)animatedOut
{
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished)
    {
        if (finished)
        {
            [self.view removeFromSuperview];
        }
    }];
}


- (void)touchForDismissSelf:(id)sender
{
    [self animatedOut];
    
}

-(void)login:(NSDictionary*)dic
{
//    SAAPIClient *manager = [SAAPIClient sharedClient];
//    [[manager responseSerializer]setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
//    [manager postPath:@"" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject)
//     {
//        // [MBProgressHUD hideHUDForView:self.view animated:YES];
//         progressHUD=nil;
//         if([[responseObject objectForKey:@"status"] boolValue])
//         {
//            [self parseResponseFromJson:responseObject];
//            NSLog(@"Success: %@ ***** %@ %lu", operation.responseString, responseObject, (unsigned long)[[responseObject objectForKey:@"data"] count]);
//          }
//         else if(![[responseObject objectForKey:@"status"] boolValue])
//         {
//             UIAlertView *loginAlrt = [[UIAlertView alloc]initWithTitle:@"Error!" message:[responseObject objectForKey:@"message"] delegate:nil cancelButtonTitle:@"ok"  otherButtonTitles:nil, nil];
//             [loginAlrt show];
//             [self.view removeFromSuperview];
//         }
//         NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
//         
//     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
//     {
//         UIAlertView *loginAlrt = [[UIAlertView alloc]initWithTitle:@"Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"ok"  otherButtonTitles:nil, nil];
//         [loginAlrt show];
//         [self.view removeFromSuperview];
//         NSLog(@"Success: %@ ***** %@", operation.responseString, error);
//     }];
}




-(void)parseResponseFromJson:(NSDictionary*)responseObject
{
    if ([[responseObject objectForKey:@"cn"] isEqualToString:@"getAllCategories"])
    {
            [[CategoryListHandler sharedCoreDataController] insertCateGoryListFromServer:responseObject];
        if ([[responseObject objectForKey:@"data"] count]>=[[responseObject objectForKey:@"count"] intValue])
        {
            int cout=[[Utility userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",LAST_TABLE_COUNT,[Utility userDefaultsForKey:MAIN_TOKEN_ID]]] intValue]+[[responseObject objectForKey:@"count"] intValue];
            [Utility saveToUserDefaults:[NSString stringWithFormat:@"%d",cout] withKey:[NSString stringWithFormat:@"%@ @@@@ %@",LAST_TABLE_COUNT,[Utility userDefaultsForKey:MAIN_TOKEN_ID]]];
            [self calllLoginMenthode];
        
        }else
        {
            [self.lblCategries setText:NSLocalizedString(@"categories", nil)];
            [self.activityIndicatorCategery stopAnimating];
            UIImageView *activityIndicatorCategeryimage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ok_button.png"]];
            activityIndicatorCategeryimage.frame=self.activityIndicatorCategery.frame;
            [self.popUpView addSubview:activityIndicatorCategeryimage];
            
            [Utility saveToUserDefaults:@"getAllModes" withKey:[NSString stringWithFormat:@"%@ @@@@ %@",LAST_TABLE_TYPE,[Utility userDefaultsForKey:MAIN_TOKEN_ID]]];
            [Utility saveToUserDefaults:@"0" withKey:[NSString stringWithFormat:@"%@ @@@@ %@",LAST_TABLE_COUNT,[Utility userDefaultsForKey:MAIN_TOKEN_ID]]];
            [self calllLoginMenthode];
        }
        
    }else  if ([[responseObject objectForKey:@"cn"] isEqualToString:@"getAllModes"])
    {
        [[PaymentmodeHandler sharedCoreDataController] insetItemPayemtModeFromServer:responseObject];
        if ([[responseObject objectForKey:@"data"] count]>=[[responseObject objectForKey:@"count"] intValue])
        {
            int cout=[[Utility userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",LAST_TABLE_COUNT,[Utility userDefaultsForKey:MAIN_TOKEN_ID]]] intValue]+[[responseObject objectForKey:@"count"] intValue];
            [Utility saveToUserDefaults:[NSString stringWithFormat:@"%d",cout] withKey:[NSString stringWithFormat:@"%@ @@@@ %@",LAST_TABLE_COUNT,[Utility userDefaultsForKey:MAIN_TOKEN_ID]]];
            [self calllLoginMenthode];
        }else
        {
            [self.activityIndicatorPaymentMode stopAnimating];
            [self.lblPaymentMode setText:NSLocalizedString(@"paymentmodes",nil)];
            [Utility saveToUserDefaults:@"getAllTransfer" withKey:[NSString stringWithFormat:@"%@ @@@@ %@",LAST_TABLE_TYPE,[Utility userDefaultsForKey:MAIN_TOKEN_ID]]];
            [Utility saveToUserDefaults:@"0" withKey:[NSString stringWithFormat:@"%@ @@@@ %@",LAST_TABLE_COUNT,[Utility userDefaultsForKey:MAIN_TOKEN_ID]]];
            
            UIImageView *activityIndicatorCategeryimage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ok_button.png"]];
            activityIndicatorCategeryimage.frame=self.activityIndicatorPaymentMode.frame;
            [self.popUpView addSubview:activityIndicatorCategeryimage];
            [self calllLoginMenthode];
        }
    }else  if ([[responseObject objectForKey:@"cn"] isEqualToString:@"getAllTransfer"])
    {
        [[TransferHandler sharedCoreDataController] insertDataToTransferTableFromServer:responseObject];
        if ([[responseObject objectForKey:@"data"] count]>=[[responseObject objectForKey:@"count"] intValue])
        {
            int cout=[[Utility userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",LAST_TABLE_COUNT,[Utility userDefaultsForKey:MAIN_TOKEN_ID]]] intValue]+[[responseObject objectForKey:@"count"] intValue];
            [Utility saveToUserDefaults:[NSString stringWithFormat:@"%d",cout] withKey:[NSString stringWithFormat:@"%@ @@@@ %@",LAST_TABLE_COUNT,[Utility userDefaultsForKey:MAIN_TOKEN_ID]]];
            [self calllLoginMenthode];
        }else
        {
            [Utility saveToUserDefaults:@"getAllBudget" withKey:[NSString stringWithFormat:@"%@ @@@@ %@",LAST_TABLE_TYPE,[Utility userDefaultsForKey:MAIN_TOKEN_ID]]];
            [Utility saveToUserDefaults:@"0" withKey:[NSString stringWithFormat:@"%@ @@@@ %@",LAST_TABLE_COUNT,[Utility userDefaultsForKey:MAIN_TOKEN_ID]]];
            [self.activityIndicatorTransfer stopAnimating];
            UIImageView *activityIndicatorCategeryimage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ok_button.png"]];
            activityIndicatorCategeryimage.frame=self.activityIndicatorTransfer.frame;
            [self.popUpView addSubview:activityIndicatorCategeryimage];
            
            [self.lblTransfer setText:NSLocalizedString(@"transfers", nil)];
            [self calllLoginMenthode];
        }
    }else  if ([[responseObject objectForKey:@"cn"] isEqualToString:@"getAllBudget"])
    {
        [[BudgetHandler sharedCoreDataController] insertDataIntoBudgetFromServer:responseObject];
        if ([[responseObject objectForKey:@"data"] count]>=[[responseObject objectForKey:@"count"] intValue])
        {
            int cout=[[Utility userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",LAST_TABLE_COUNT,[Utility userDefaultsForKey:MAIN_TOKEN_ID]]] intValue]+[[responseObject objectForKey:@"count"] intValue];
            [Utility saveToUserDefaults:[NSString stringWithFormat:@"%d",cout] withKey:[NSString stringWithFormat:@"%@ @@@@ %@",LAST_TABLE_COUNT,[Utility userDefaultsForKey:MAIN_TOKEN_ID]]];
            [self calllLoginMenthode];
        }else
        {
            [Utility saveToUserDefaults:@"getAllReminders" withKey:[NSString stringWithFormat:@"%@ @@@@ %@",LAST_TABLE_TYPE,[Utility userDefaultsForKey:MAIN_TOKEN_ID]]];
            [Utility saveToUserDefaults:@"0" withKey:[NSString stringWithFormat:@"%@ @@@@ %@",LAST_TABLE_COUNT,[Utility userDefaultsForKey:MAIN_TOKEN_ID]]];
            [self.activityIndicatorBudgets stopAnimating];
            [self.lblBudgets setText:NSLocalizedString(@"budgets", nil)];
            
            UIImageView *activityIndicatorCategeryimage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ok_button.png"]];
            activityIndicatorCategeryimage.frame=self.activityIndicatorBudgets.frame;
            [self.popUpView addSubview:activityIndicatorCategeryimage];
            
            [self calllLoginMenthode];
        }
    }else  if ([[responseObject objectForKey:@"cn"] isEqualToString:@"getAllReminders"])
    {
        [[ReminderHandler sharedCoreDataController] insertDataIntoReminderTablefromServer:responseObject];
        if ([[responseObject objectForKey:@"data"] count]>=[[responseObject objectForKey:@"count"] intValue])
        {
            int cout=[[Utility userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",LAST_TABLE_COUNT,[Utility userDefaultsForKey:MAIN_TOKEN_ID]]] intValue]+[[responseObject objectForKey:@"count"] intValue];
            [Utility saveToUserDefaults:[NSString stringWithFormat:@"%d",cout] withKey:[NSString stringWithFormat:@"%@ @@@@ %@",LAST_TABLE_COUNT,[Utility userDefaultsForKey:MAIN_TOKEN_ID]]];
            [self calllLoginMenthode];
        }else
        {
            [Utility saveToUserDefaults:@"getAllTrans" withKey:[NSString stringWithFormat:@"%@ @@@@ %@",LAST_TABLE_TYPE,[Utility userDefaultsForKey:MAIN_TOKEN_ID]]];
            [Utility saveToUserDefaults:@"0" withKey:[NSString stringWithFormat:@"%@ @@@@ %@",LAST_TABLE_COUNT,[Utility userDefaultsForKey:MAIN_TOKEN_ID]]];
            [self.lblReminder setText:NSLocalizedString(@"reminders", nil)];
            [self.activityIndicatorRemider stopAnimating];
            UIImageView *activityIndicatorCategeryimage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ok_button.png"]];
            activityIndicatorCategeryimage.frame=self.activityIndicatorRemider.frame;
            [self.popUpView addSubview:activityIndicatorCategeryimage];
            
            [self calllLoginMenthode];
        }
    }else  if ([[responseObject objectForKey:@"cn"] isEqualToString:@"getAllTrans"])
    {
        [[TransactionHandler sharedCoreDataController] insertDataIntoTransactionTableFromServer:responseObject];
        if ([[responseObject objectForKey:@"data"] count]>=[[responseObject objectForKey:@"count"] intValue])
        {
            int cout=[[Utility userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",LAST_TABLE_COUNT,[Utility userDefaultsForKey:MAIN_TOKEN_ID]]] intValue]+[[responseObject objectForKey:@"count"] intValue];
            [Utility saveToUserDefaults:[NSString stringWithFormat:@"%d",cout] withKey:[NSString stringWithFormat:@"%@ @@@@ %@",LAST_TABLE_COUNT,[Utility userDefaultsForKey:MAIN_TOKEN_ID]]];
            [self calllLoginMenthode];
        }else
        {
            [self.activityIndicatorTransaction stopAnimating];
            [self.lblIncome setText:NSLocalizedString(@"incomes", nil)];
            UIImageView *activityIndicatorCategeryimage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ok_button.png"]];
            activityIndicatorCategeryimage.frame=self.activityIndicatorTransaction.frame;
            [self.popUpView addSubview:activityIndicatorCategeryimage];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:LOGIN_DONE];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:UPDATION_ON_SERVER_TIME];
            NSString * noticationName =@"LoginCallbacksViewController";
            NSMutableDictionary *bookListing = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:noticationName object:nil userInfo:bookListing];
            [self.view removeFromSuperview];
        }
    }
}


#pragma mark - show or hide self
- (void)show
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:self.view];
    self.view.center = CGPointMake(keywindow.bounds.size.width/2.0f, keywindow.bounds.size.height/2.0f);
    [self animatedIn];
}

- (void)dismiss
{
    [self animatedOut];
}


- (IBAction)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [self animatedOut];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
