//
//  PaymentModeViewController.m
//  Daily Expense Manager
//
//  Created by Appbulous on 03/09/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import "PaymentModeViewController.h"
#import "PaymentmodeHandler.h"
#import "FPPopoverController.h"
#import "DemoTableController.h"
#import "Utility.h"
#import "CreatePaymentModeViewController.h"
#import "BudgetViewController.h"
#import "Paymentmode.h"
#import "SettingViewController.h"
#import "UIAlertView+Block.h"

#import "ReminderHandler.h"
#import "TransferHandler.h"
#import "TransactionHandler.h"
#import "BudgetHandler.h"
#import "HomeHelper.h"

@interface PaymentModeViewController ()
{
    FPPopoverController *popover ;
    NSNumber *index;
}

@end

@implementation PaymentModeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (BOOL)backViewController
{
    for (UIViewController * viewController in [self.navigationController viewControllers])
    {
        if ([viewController isKindOfClass:[SettingViewController class]])
        {
            return  YES;
        }
        
    }
    return NO;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [Utility setFontFamily:Embrima forView:self.view andSubViews:YES];
    [self.lblTitle setFont:[UIFont fontWithName:Ebrima_Bold size:17.0f]];
    
    if ([self backViewController])
    {
        [self setTitle:NSLocalizedString(@"customizepaymentMode", nil)];
    }else
    {
        [self setTitle:NSLocalizedString(@"selectaapyment", nil)];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotification:) name:@"DemoListner" object:nil];
     //self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([[NSUserDefaults standardUserDefaults] boolForKey:UPDATION_ON_SERVER_TIME])
    {
        [[HomeHelper sharedCoreDataController] upgradeBackendDataOnServer];
    }
    self.paymentModeList=[[NSMutableArray alloc] init];
    if ([self backViewController])
    {
    self.paymentModeList=[[NSMutableArray alloc]initWithArray:[[PaymentmodeHandler sharedCoreDataController] getDefaultPaymentModeBeanList]];
    }else
    {
          NSArray *array=[[PaymentmodeHandler sharedCoreDataController] getPaymentModeList];
        if ([self budjetViewController])
        {
           self.paymentModeList=[[NSMutableArray alloc] init];
          [self.paymentModeList addObject:NSLocalizedString(@"all", nil)];
        }
        [self.paymentModeList addObjectsFromArray:array];
    }
    [self.tableView reloadData];
}



- (BOOL)budjetViewController
{
    for (UIViewController * viewController in [self.navigationController viewControllers])
    {
        if ([viewController isKindOfClass:[BudgetViewController class]])
        {
            return  YES;
        }
    }
    return NO;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    UILabel *slogan=(UILabel*)[cell viewWithTag:2];
    slogan.textColor = [UIColor whiteColor];
    UIImageView * imageView =(UIImageView*)[cell viewWithTag:1];
    if (([indexPath row ]==0 && [self budjetViewController]))
    {
        slogan.text= NSLocalizedString(@"all", nil);
        imageView.image=[UIImage imageNamed:@"All_icon.png"];
    }else
    {
        Paymentmode *mode=[self.paymentModeList objectAtIndex:[indexPath row]];
        slogan.text= mode.paymentMode;
        if ([UIImage imageWithData:mode.paymentmode_icon]!=nil)
        {
            imageView.image = [UIImage imageWithData:mode.paymentmode_icon];
        }else
        {
            imageView.image = [UIImage imageNamed:@"paymentmode_icon.png"];
        }
        
        if ([mode.hide_status intValue])
        {
            slogan.textColor = [UIColor whiteColor];
        }
        NavigationLeftButton *button = [NavigationLeftButton buttonWithType:UIButtonTypeInfoLight];
        [button setFrame:CGRectMake(266, 0, 44, 44)];
        [button setImage:[UIImage imageNamed:@"more_button_inactive.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(popover:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:button];
        [button setTag:(int)[indexPath row]];
        cell.textLabel.textColor=[UIColor whiteColor];
        cell.textLabel.font=[UIFont fontWithName:Embrima size:16];
        cell.tintColor=[UIColor whiteColor];
    }
    [imageView setFrame:CGRectMake(10, 6, 38, 30)];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 48;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage  *image;
    NSString *string;
    if (([indexPath row ]==0 && [self budjetViewController]))
    {
         string= NSLocalizedString(@"all", nil);
         image=[UIImage imageNamed:@"All_icon.png"];
        
    }else
    {
        Paymentmode *mode=(Paymentmode*)[self.paymentModeList objectAtIndex:[indexPath row]];
        string=mode.paymentMode;
        image=[UIImage imageWithData:mode.paymentmode_icon];
        
    }
    NSString * noticationName =@"PaymentMode";
    NSMutableDictionary *bookListing = [[NSMutableDictionary alloc] init];
    [bookListing setObject:string forKey:@"name"];
    [bookListing setObject:image forKey:@"image"];
    [[NSNotificationCenter defaultCenter] postNotificationName:noticationName  object:nil userInfo:bookListing];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)popover:(UIButton*)sender
{
    
    //---------------------------
    NSMutableArray *listArray=[[NSMutableArray alloc]initWithObjects:@"Edit",@"Delete",nil];
    [UIActionSheet showInView:self.view withTitle:nil cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:listArray tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex)
    {
        if (buttonIndex==0)
        {
            CreatePaymentModeViewController *createViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"CreatePaymentModeViewController"];
            [createViewController setMode:[self.paymentModeList objectAtIndex:sender.tag]];
            // [createViewController setString:]
            [self.navigationController pushViewController:createViewController animated:YES];
        }else if (buttonIndex==1)
        {
            
            index=[NSNumber numberWithInteger:sender.tag];
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Alert" message:NSLocalizedString(@"deletePaymentMode", nil) delegate:self cancelButtonTitle:@"Continue"  otherButtonTitles: nil];
            [alert addButtonWithTitle:@"Cancel"];
            [alert show];
            
            
        }

    }];
   
    
    
   
}


-(void) receivedNotification:(NSNotification*) notification
{
    
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString *titile=[alertView buttonTitleAtIndex:buttonIndex];
    if ([titile isEqualToString:@"Continue"])
    {
        if ([self.paymentModeList count]!=1)
        {
            Paymentmode *info=[ self.paymentModeList objectAtIndex:[index intValue]];
            [[PaymentmodeHandler sharedCoreDataController] deletePaymentModeInfo:info];
            [[TransactionHandler sharedCoreDataController] deletePaymentMode:info.paymentMode chekServerUpdation:NO];
            [[ReminderHandler sharedCoreDataController]  deletePaymentMode:info.paymentMode chekServerUpdation:NO];
            [[BudgetHandler sharedCoreDataController]  deletePaymentMode:info.paymentMode chekServerUpdation:NO];
            [[TransferHandler sharedCoreDataController] deletePaymentMode:info.paymentMode chekServerUpdation:NO];
            if ([self backViewController])
            {
                self.paymentModeList=[[NSMutableArray alloc]initWithArray:[[PaymentmodeHandler sharedCoreDataController] getDefaultPaymentModeBeanList]];
            }else
                self.paymentModeList=[[NSMutableArray alloc]initWithArray:[[PaymentmodeHandler sharedCoreDataController] getPaymentModeList]];
          [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"paymentmodedeletedSuccessfully", nil)];
            
            [self viewWillAppear:YES];
        }else
        {
        [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"singlePaymentCannotBeDeleted", nil)];
        }
    }
}


-(void) receivedCatgeryNotification:(NSNotification*) notification
{
    NSDictionary * info =notification.userInfo;
    NSString *number=[info objectForKey:@"position"];
    NSLog(@"%@",number);

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
