//
//  CreatePaymentModeViewController.m
//  Daily Expense Manager
//
//  Created by Appbulous on 10/09/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import "CreatePaymentModeViewController.h"
#import "UIAlertView+Block.h"
#import "PaymentmodeHandler.h"

@interface CreatePaymentModeViewController ()
{
    BOOL hideStatus;
}
@end

@implementation CreatePaymentModeViewController

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
      [Utility setFontFamily:Embrima forView:self.view andSubViews:YES];
     [self.lblHideStaus setFont:[UIFont fontWithName:Embrima size:16.0f]];
     [self.lblTitle setFont:[UIFont fontWithName:Ebrima_Bold size:17.0f]];
    
     if (self.mode.managedObjectContext != nil)
     {
        [self.lblTitle setText:@"Edit Payment Mode"];
        [self.textPayemtnMode setText:self.mode.paymentMode];
        if ([self.mode.hide_status intValue])
        {
            [self.btnHideStaus setOn:YES animated:YES];
            hideStatus=YES;
        }else
        {
            [self.btnHideStaus setOn:NO animated:YES];
            hideStatus=NO;
        }
      
    }else
    {
           hideStatus=NO;
    }
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnHideStausClick:(id)sender
{

    NSArray *array=[[NSMutableArray alloc]initWithArray:[[PaymentmodeHandler sharedCoreDataController] getPaymentModeList]];
    if ([array count]==1)
    {
        [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"singlePaymentCannotBeHidden", nil)];
    }else
    {
        if ([sender isOn])
        {
            hideStatus=YES;
           [UIAlertView alertViewWithTitle:@"Alert" message:NSLocalizedString(@"hidingPayment", nil)];
               
        } else
        {
            hideStatus=NO;
        }
    }
}



- (IBAction)btnDoneClick:(id)sender
{
    if ([self CheckTransactionValidity])
    {
        NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
        [dictionary setObject:hideStatus ?[NSNumber numberWithInt:1] :[NSNumber numberWithInt:0] forKey:@"hide_status"];
        [dictionary setObject:[TRIM(self.textPayemtnMode.text) capitalizedString]forKey:@"paymentMode"];
        if (self.mode.managedObjectContext == nil)
        {
            [dictionary setObject:[UIImage imageNamed:@"paymentmode.png"] forKey:@"paymentmode_icon"];
            [[PaymentmodeHandler sharedCoreDataController] insetItemPayemtMode:dictionary];
            [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"paymentModeaddeSuccessfully", nil)];
        }else
        {
            [dictionary setObject:self.mode.token_id forKey:@"token_id"];
            [dictionary setObject:[UIImage imageWithData:self.mode.paymentmode_icon] forKey:@"paymentmode_icon"];
            [[PaymentmodeHandler sharedCoreDataController] updateItemPayemtMode:dictionary :self.mode];
            [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"paymentModeUpdatedSuccessfully", nil)];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(BOOL)CheckTransactionValidity
{
    
    if ([TRIM(self.textPayemtnMode.text) isEqual:@""])
    {
        [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"nameNull", nil)];
        [self.textPayemtnMode resignFirstResponder];
        return NO;
    }
    if ([TRIM(self.textPayemtnMode.text) length]>50)
    {
        [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"morethan50notallowed", nil)];
        [self.textPayemtnMode resignFirstResponder];
        return NO;
    }
    if (![self specialCharactersOccurence:TRIM(self.textPayemtnMode.text)])
    {
        return NO;
    }
    return YES;
}



-(BOOL)specialCharactersOccurence:(NSString*)aString
{
   NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789 "] invertedSet];
    if ([aString rangeOfCharacterFromSet:set].location != NSNotFound)
    {
        
    [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"specialCharactersNotAllowed", nil)];
        [self.textPayemtnMode resignFirstResponder];
    return NO;
    }
    NSArray *paymentModeArray=[[PaymentmodeHandler sharedCoreDataController] getDefaultPaymentModeBeanList];
    for ( Paymentmode *paymetmode in paymentModeArray)
    {
        if ([paymetmode.paymentMode caseInsensitiveCompare:[TRIM(self.textPayemtnMode.text) capitalizedString]]==NSOrderedSame && [TRIM(self.textPayemtnMode.text) caseInsensitiveCompare:self.mode.paymentMode] != NSOrderedSame )
        {
            [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"paymentModeExists", nil)];
            [self.textPayemtnMode resignFirstResponder];
            return NO;
        }
    }
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



@end
