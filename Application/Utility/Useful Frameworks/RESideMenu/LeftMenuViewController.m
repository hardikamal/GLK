//
//  MenuViewController.m
//  SlideMenu
//
//  Created by Aryan Gh on 4/24/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//


#import "LeftMenuViewController.h"
//#import "BudgetViewController.h"
//#import "TransferViewController.h"
//#import "LogInViewController.h"
//#import "UserInfoHandler.h"
//#import "GoogleDriveViewController.h"
//#import "MBProgressHUD.h"
//#import "MBProgressHUD.h"
//#import "SAAPIClient.h"
#import "FirstViewController.h"


@implementation LeftMenuViewController
{
    NSMutableArray *listArray,*accountListArray;
}


#pragma mark - UIViewController Methods -

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self.slideOutAnimationEnabled = YES;
	return [super initWithCoder:aDecoder];
}
- (IBAction)pageClickEvent:(UIPageControl *)sender
{
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [Utility setFontFamily:Embrima forView:self.view andSubViews:YES];
    

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedSelectViewListNotification:) name:@"LeftMenuViewController" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedSelectViewListNotification:) name:@"ChangeProfileViewController" object:nil];
}




-(void)viewWillAppear:(BOOL)animated
{
    listArray=[[NSMutableArray alloc] init];
    accountListArray=[[NSMutableArray alloc] init];
    [self updateTable];
}

-(void)updateTable
{
    NSMutableArray *categeryName=[[NSMutableArray alloc]initWithObjects:NSLocalizedString(@"SignIn / New User", nil),NSLocalizedString(@"Dashboard", nil),NSLocalizedString(@"History", nil),NSLocalizedString(@"Reminder / Recurring", nil),NSLocalizedString(@"Budget", nil),NSLocalizedString(@"Warranty", nil),NSLocalizedString(@"Transfer", nil),NSLocalizedString(@"Settings", nil),NSLocalizedString(@"Goollak Directory", nil),NSLocalizedString(@"Rate Us", nil),NSLocalizedString(@"Like Us on Facebook", nil),NSLocalizedString(@"Help", nil),NSLocalizedString(@"Logout", nil),nil];
    NSMutableArray *accountNameTable=[[NSMutableArray alloc]initWithObjects:NSLocalizedString(@"All Acounts", nil),NSLocalizedString(@"User 1", nil),NSLocalizedString(@"User2", nil),NSLocalizedString(@"Add Account", nil),NSLocalizedString(@"Manage Accounts", nil),nil];
    
    NSMutableArray *imageNameNormal=[[NSMutableArray alloc]initWithObjects:@"signin_normal.png",@"dashboard_normal.png",@"history_normal.png",@"reminder_normal.png",@"budgets_normal.png",@"warranty_normal.png",@"transfer_normal.png",@"setting_normal.png",@"category_normal.png",@"rateus_normal.png",@"likeus_normal.png",@"help_normal.png",@"logout_normal.png",nil];
    NSMutableArray *imageNameNormalAccount=[[NSMutableArray alloc]initWithObjects:@"signin_normal.png",@"dashboard_normal.png",@"history_normal.png",@"reminder_normal.png",@"budgets_normal.png",nil];
    NSMutableArray *imageNameActive=[[NSMutableArray alloc]initWithObjects:@"signin_active.png",@"dashboard_active.png",@"history_active.png",@"reminder_active.png",@"budgets_active.png",@"warranty_active.png",@"transfer_active.png",@"setting_active.png",@"category_active.png",@"rateus_active.png",@"likeus_active.png",@"help_active.png",@"logout_active.png",nil];
    NSMutableArray *imageNameActiveAccount=[[NSMutableArray alloc]initWithObjects:@"signin_active.png",@"dashboard_active.png",@"history_active.png",@"reminder_active.png",@"budgets_active.png",nil];
    
    for (int i=0; i<[imageNameNormal count]; i++)
    {
        NSMutableDictionary *bookListing = [[NSMutableDictionary alloc] init];
        [bookListing setObject:[categeryName objectAtIndex:i] forKey: @"name"];
        [bookListing setObject:[imageNameNormal objectAtIndex:i] forKey:@"imageNormal"];
        [bookListing setObject:[imageNameActive objectAtIndex:i] forKey:@"imageActive"];

        [listArray addObject:bookListing];
       
    }
    for (int i=0; i<[imageNameNormalAccount count]; i++)
    {
       
        NSMutableDictionary *dictAccount = [[NSMutableDictionary alloc] init];
        [dictAccount setObject:[accountNameTable objectAtIndex:i] forKey: @"name"];
        [dictAccount setObject:[imageNameNormalAccount objectAtIndex:i] forKey:@"imageNormal"];
        [dictAccount setObject:[imageNameActiveAccount objectAtIndex:i] forKey:@"imageActive"];
        
        [accountListArray addObject:dictAccount];
    }
     [self.tableView reloadData];
}

#pragma mark - UITableView Delegate & Datasrouce -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.pageControl.currentPage!=1)
    {
        return [listArray count];

        
        
    }
    else
    {
       	return [accountListArray count];
 
    }

}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftMenuCell"];
    UILabel *titleLabel=(UILabel *)[cell.contentView viewWithTag:2];
    titleLabel.textColor=[UIColor whiteColor];
    if ([indexPath row]>6)
    {
        [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:16]];
    }else
         [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceCharacterSet];
	cell.backgroundColor = [UIColor clearColor];
    UIImageView *imageView=(UIImageView *)[cell.contentView viewWithTag:1];
    if (self.pageControl.currentPage!=1)
    {
       	titleLabel.text=[[[listArray objectAtIndex:[indexPath row]] objectForKey:@"name"] stringByTrimmingCharactersInSet:whitespace];
        imageView.image=[UIImage imageNamed:[[listArray objectAtIndex:[indexPath row]] objectForKey:@"imageNormal"]];

 
    }
    else
    {
        titleLabel.text=[[[accountListArray objectAtIndex:[indexPath row]] objectForKey:@"name"] stringByTrimmingCharactersInSet:whitespace];
        imageView.image=[UIImage imageNamed:[[accountListArray objectAtIndex:[indexPath row]] objectForKey:@"imageNormal"]];
    }
	return cell;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageControl.currentPage!=1)
    {
        [(UIImageView*)[[[tableView cellForRowAtIndexPath:indexPath] contentView] viewWithTag:1] setImage:[UIImage imageNamed:[[listArray objectAtIndex:[indexPath row]] objectForKey:@"imageNormal"]]];
        [(UIImageView*)[[[tableView cellForRowAtIndexPath:indexPath] contentView] viewWithTag:3] setHidden:1];
        
        
    }
    else
    {
        [(UIImageView*)[[[tableView cellForRowAtIndexPath:indexPath] contentView] viewWithTag:1] setImage:[UIImage imageNamed:[[accountListArray objectAtIndex:[indexPath row]] objectForKey:@"imageNormal"]]];
        [(UIImageView*)[[[tableView cellForRowAtIndexPath:indexPath] contentView] viewWithTag:3] setHidden:1];
    }
    
    


}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageControl.currentPage!=1)
    {
        [(UIImageView*)[[[tableView cellForRowAtIndexPath:indexPath] contentView] viewWithTag:1] setImage:[UIImage imageNamed:[[listArray objectAtIndex:[indexPath row]] objectForKey:@"imageActive"]]];
        [(UIImageView*)[[[tableView cellForRowAtIndexPath:indexPath] contentView] viewWithTag:3] setHidden:0];
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        NSString *string=[[ listArray objectAtIndex:indexPath.row] objectForKey:@"name"];
        
        if ([NSLocalizedString(@"Dashboard", nil) isEqualToString:string])
        {
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[mainStoryboard instantiateViewControllerWithIdentifier: @"HomeViewController"]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            
        }
        else if ([NSLocalizedString(@"Budget", nil) isEqualToString:string])
        {
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[mainStoryboard instantiateViewControllerWithIdentifier: @"BudgetViewController"]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            
        }
        else if ([NSLocalizedString(@"Reminder / Recurring", nil) isEqualToString:string])
        {
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[mainStoryboard instantiateViewControllerWithIdentifier: @"AddReminderViewController"]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            
        }
        else if ([NSLocalizedString(@"Warranty", nil) isEqualToString:string])
        {
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[mainStoryboard instantiateViewControllerWithIdentifier: @"WarrantyViewController"]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            
        }
        else if ([NSLocalizedString(@"Transfer", nil) isEqualToString:string])
        {
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[mainStoryboard instantiateViewControllerWithIdentifier: @"TransferViewController"]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            
        }
        else if ([NSLocalizedString(@"Settings", nil) isEqualToString:string])
        {
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[mainStoryboard instantiateViewControllerWithIdentifier: @"SettingViewController"]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            
        }
    }
    else
    {
        [(UIImageView*)[[[tableView cellForRowAtIndexPath:indexPath] contentView] viewWithTag:1] setImage:[UIImage imageNamed:[[accountListArray objectAtIndex:[indexPath row]] objectForKey:@"imageActive"]]];
        [(UIImageView*)[[[tableView cellForRowAtIndexPath:indexPath] contentView] viewWithTag:3] setHidden:0];
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        NSString *string=[[ accountListArray objectAtIndex:indexPath.row] objectForKey:@"name"];
        
        

    }
    
//    else if ([NSLocalizedString(@"likeus", nil) isEqualToString:string])
//    {
//        if (![[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"https://www.facebook.com/pages/Daily-Expenses-Manager/471305579634266"]])
//        {
//            NSURL *url = [NSURL URLWithString:@"https://www.facebook.com/pages/Daily-Expenses-Manager/471305579634266"];
//            [[UIApplication sharedApplication] openURL:url];
//        }
//    }else if ([NSLocalizedString(@"home", nil) isEqualToString:string])
//    {
//
//        [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[mainStoryboard instantiateViewControllerWithIdentifier: @"HomeViewController"]]
//                                                     animated:YES];
//        [self.sideMenuViewController hideMenuViewController];
//        
//        
//    }else if ([NSLocalizedString(@"viewTrnsaction", nil) isEqualToString:string])
//    {
//        [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[mainStoryboard instantiateViewControllerWithIdentifier: @"HistoryViewController"]]
//                                                     animated:YES];
//        [self.sideMenuViewController hideMenuViewController];
//        
//        
//    }else if ([NSLocalizedString(@"reminder", nil) isEqualToString:string])
//    {
//        [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[mainStoryboard instantiateViewControllerWithIdentifier: @"AddReminderViewController"]]
//                                                     animated:YES];
//        [self.sideMenuViewController hideMenuViewController];
//        
//        
//    }else if ([NSLocalizedString(@"budgetTransaction", nil) isEqualToString:string])
//    {
//        [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[mainStoryboard instantiateViewControllerWithIdentifier: @"BudgetViewController"]]
//                                                     animated:YES];
//        [self.sideMenuViewController hideMenuViewController];
//        
//        
//    }else if ([NSLocalizedString(@"waranty", nil) isEqualToString:string])
//    {
//        
//        [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[mainStoryboard instantiateViewControllerWithIdentifier: @"WarrantyViewController"]]
//                                                     animated:YES];
//        [self.sideMenuViewController hideMenuViewController];
//        
//        
//    }else if ([NSLocalizedString(@"transferTransaction", nil) isEqualToString:string])
//    {
//        [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[mainStoryboard instantiateViewControllerWithIdentifier: @"TransferViewController"]]
//                                                     animated:YES];
//        [self.sideMenuViewController hideMenuViewController];
//        
//
//    }else if ([NSLocalizedString(@"settings", nil) isEqualToString:string])
//    {
//        [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[mainStoryboard instantiateViewControllerWithIdentifier: @"SettingViewController"]]
//                                                     animated:YES];
//        [self.sideMenuViewController hideMenuViewController];
//        
//    }else if ([NSLocalizedString(@"accountSettings", nil) isEqualToString:string])
//    {
//        
//        [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[mainStoryboard instantiateViewControllerWithIdentifier: @"AccountViewController"]]
//                                                     animated:YES];
//        [self.sideMenuViewController hideMenuViewController];
//        
//        
//    }else if ([NSLocalizedString(@"subheading", nil) isEqualToString:string])
//    {
//        [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[mainStoryboard instantiateViewControllerWithIdentifier: @"DemDicViewController"]]
//                                                     animated:YES];
//        [self.sideMenuViewController hideMenuViewController];
//        
//        
//    }else if ([NSLocalizedString(@"rateUs", nil) isEqualToString:string])
//    {
//        
//    }else if ([NSLocalizedString(@"likeus", nil) isEqualToString:string])
//    {
//        
//    }else if ([NSLocalizedString(@"help", nil) isEqualToString:string])
//    {
//        [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[mainStoryboard instantiateViewControllerWithIdentifier: @"HelpViewController"]]
//                                                    animated:YES];
//        [self.sideMenuViewController hideMenuViewController];
//    }else if ([NSLocalizedString(@"logout", nil) isEqualToString:string])
//    {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//              //  [self logOutUserFromServer];
//    }
}

-(void)logOutUserFromServer
{
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Alert" message:NSLocalizedString(@"loggingout", nil) delegate:self cancelButtonTitle:@"Continue"  otherButtonTitles: nil];
    [alert addButtonWithTitle:@"Cancel"];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
//    NSString *titile=[alertView buttonTitleAtIndex:buttonIndex];
//    if ([titile isEqualToString:@"Continue"])
//    {
//        progressHUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        progressHUD.labelText=@"Please wait...";
//        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//        [dic setObject:LOGOUT forKey:@"cn"];
//        [dic  setObject:[Utility userDefaultsForKey:MAIN_TOKEN_ID] forKey:@"usertoken_id"];
//        [dic setObject:[Utility uniqueIDForDevice] forKey:DEVICE_ID];
//        [self login:dic];
//    }
}


-(void)login:(NSDictionary*)dic
{
//    SAAPIClient *manager = [SAAPIClient sharedClient];
//    [[manager responseSerializer] setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
//    [manager postPath:@"" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject)
//     {
//         [MBProgressHUD hideHUDForView:self.view animated:YES];
//         progressHUD=nil;
//         if([[responseObject objectForKey:@"status"] boolValue])
//         {
//             NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
//             [self parseResponseFromJson:responseObject];
////             UIAlertView *loginAlrt = [[UIAlertView alloc]initWithTitle:@"Suceess" message:[responseObject objectForKey:@"message"] delegate:self cancelButtonTitle:@"ok"  otherButtonTitles:nil, nil];
////             [loginAlrt show];
//         }
//         else if(![[responseObject objectForKey:@"status"] boolValue])
//         {
//             progressHUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//             progressHUD.labelText=@"Please wait....";
//             
//             UIAlertView *loginAlrt = [[UIAlertView alloc]initWithTitle:@"Error!" message:[responseObject objectForKey:@"message"] delegate:nil cancelButtonTitle:@"ok"  otherButtonTitles:nil, nil];
//             [loginAlrt show];
//         }
//     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
//     {
//         [MBProgressHUD hideHUDForView:self.view animated:YES];
//         progressHUD=nil;
//         UIAlertView *loginAlrt = [[UIAlertView alloc]initWithTitle:@"Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"ok"  otherButtonTitles:nil, nil];
//         [loginAlrt show];
//     }];
}


-(void)parseResponseFromJson:(NSDictionary*)responseObject
{
//    [self deleteAllAccountOfCurrentTokenId];
//    [Utility saveToUserDefaults:[Utility userDefaultsForKey:MAIN_TOKEN_ID] withKey:[NSString stringWithFormat:@"%@ @@@@ %@",LOGIN_DONE,[Utility userDefaultsForKey:MAIN_TOKEN_ID]]];
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:LOGIN_DONE];
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@@@@@%@",LOGOUT_DONE_ACCORDINGTOKEN,[Utility userDefaultsForKey:MAIN_TOKEN_ID]]];
//    [Utility saveToUserDefaults:DEFAULT_TOKEN_ID withKey:CURRENT_TOKEN_ID];
//    NSString *mainToken=[[[Utility userDefaultsForKey:CURRENT_TOKEN_ID] componentsSeparatedByString:@"_"] objectAtIndex:0];
//    [Utility saveToUserDefaults:mainToken withKey:MAIN_TOKEN_ID];
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:UPDATION_ON_SERVER_TIME];
//    [self updateTable];
//    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)deleteAllAccountOfCurrentTokenId
{
//    NSArray *userItems=[[UserInfoHandler sharedCoreDataController] getAllUserDetails];
//    for (UserInfo  *user  in userItems)
//    {
//        [[UserInfoHandler sharedCoreDataController] deleteUserInfo:user chekServerUpdation:YES];
//    }
}


-(void)receivedSelectViewListNotification:(NSNotification*) notification
{
     [self updateTable];
}

@end
