//
//  CreateBudgetsViewController.m
//  Daily Expense Manager
//
//  Created by Appbulous on 10/09/16.
//  Copyright (c) 2016 Jyoti Kumar. All rights reserved.
//

#import "CreateBudgetsViewController.h"
#import "CategoryListHandler.h"
#import "PaymentmodeHandler.h"
#import "UserInfoHandler.h"
#import "UIAlertView+Block.h"
#import "BudgetHandler.h"
#import "BudgetViewController.h"
#import "UserInfo.h"
#import "Paymentmode.h"
#import "UIPopoverListView.h"
#import "CategeyListViewController.h"
#import "PaymentModeViewController.h"
#import "AddAccountViewController.h"
@interface CreateBudgetsViewController ()
{
    NSDictionary * infoCategery;
    NSDictionary * infoPayment;
    BOOL isSelected;
}
@end

@implementation CreateBudgetsViewController
@synthesize  transaction;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.dobView.frame=CGRectMake(0, self.view.frame.size.height, self.dobView.frame.size.width, self.dobView.frame.size.height);
    [self.view addSubview:self.dobView];
    
    DoneCancelNumberPadToolbar *toolbar = [[DoneCancelNumberPadToolbar alloc] initWithTextField:_txtAmount];
    toolbar.delegate = self;
    _txtAmount.inputAccessoryView = toolbar;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedCategeryListNotification:) name:@"CategeryList" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(receivedPaymentModeNotification:) name:@"PaymentMode" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotification:) name:@"CreateBudgetsViewController" object:nil];
    
    if (transaction.managedObjectContext == nil)
    {
        [self addNewBudjet];
    }else
        [self updateBudjet];

}


-(void)addAccountName:(NSArray *)userInfoarrray
{
    UserInfo *userInfo =[userInfoarrray objectAtIndex:0];
    [self.btnProfileName setTitle:userInfo.user_name forState:UIControlStateNormal];
    if (userInfo.user_img != nil)
    {
        self.imageProfile.layer.cornerRadius = self.imageProfile.frame.size.width / 2;
        self.imageProfile.clipsToBounds = YES;
        self.imageProfile.image=[UIImage imageWithData:userInfo.user_img];
    }else
        self.imageProfile.image=[UIImage imageNamed:@"custom_profile.png"];
    
}


-(void)doneCancelNumberPadToolbarDelegate:(DoneCancelNumberPadToolbar *)controller didClickDone:(UITextField *)textField
{
    
    NSLog(@"%@", textField.text);
}

-(void)doneCancelNumberPadToolbarDelegate:(DoneCancelNumberPadToolbar *)controller didClickCancel:(UITextField *)textField
{
    [textField setText:@""];
    NSLog(@"Canceled: %@", [textField description]);
}



-(void)viewWillAppear:(BOOL)animated
{
    if ([infoCategery count] != 0)
    {
        [self.lblSabCatagery setHidden:YES];
        NSArray *arrray=[[infoCategery objectForKey:@"name"] componentsSeparatedByString:@","];
        if ([arrray count]==2)
        {
            [self.lblSabCatagery setHidden:NO];
            [self.btnCategery setHidden:NO];
            [self.buttonUnhideCategery setHidden:YES];
            [self.lblSabCatagery setText:[arrray objectAtIndex:1]];
            [self.btnCategery setTitle:[arrray objectAtIndex:0] forState:UIControlStateNormal];
        }else
        {
            [self.btnCategery setHidden:YES];
            [self.buttonUnhideCategery setTitle:[arrray objectAtIndex:0] forState:UIControlStateNormal];
            [self.buttonUnhideCategery setHidden:NO];
            [self.lblSabCatagery setText:@""];
        }
        [self.imgCatagery setImage:[infoCategery objectForKey:@"image"]];
    }else
    {
        if (transaction.managedObjectContext != nil)
        {
            if ([transaction.category isEqualToString:NSLocalizedString(@"all", nil)])
            {
                [self.btnCategery setTitle:NSLocalizedString(@"all", nil) forState:UIControlStateNormal];
                [self.imgCatagery setImage:[UIImage imageNamed:@"All_icon.png"]];
                [self.buttonUnhideCategery setTitle:transaction.category forState:UIControlStateNormal];
            }else
            {
                NSArray *categeryArray=[[CategoryListHandler sharedCoreDataController] getsearchCategeryWithAttributeName:@"category_icon" andSearchText:transaction.category];
                self.imgCatagery.image=[UIImage imageWithData:[[categeryArray objectAtIndex:0] objectForKey:@"category_icon"]];
                if (![transaction.sub_category isEqualToString:@""])
                {
                    [self.lblSabCatagery setHidden:NO];
                    [self.btnCategery setHidden:NO];
                    [self.buttonUnhideCategery setHidden:YES];
                    [self.lblSabCatagery setText:transaction.sub_category];
                    [self.btnCategery setTitle:transaction.category forState:UIControlStateNormal];
                }else
                    [self.buttonUnhideCategery setTitle:transaction.category forState:UIControlStateNormal];
            }
        }else
        {
            NSArray *categeryIcon=[[CategoryListHandler sharedCoreDataController] getCategeryList:[NSString stringWithFormat:@"%d",TYPE_EXPENSE]];
            CategoryList *list=(CategoryList*)[categeryIcon objectAtIndex:0];
            [self.buttonUnhideCategery setTitle:list.category forState:UIControlStateNormal];
            [self.imgCatagery setImage:[UIImage imageWithData:list.category_icon]];
            
        }
    }
    if ([infoPayment count] != 0)
    {
        [self.btnPaymentMode setTitle:[infoPayment objectForKey:@"name"] forState:UIControlStateNormal];
        [self.imgpaymentmode setImage:[infoPayment objectForKey:@"image"]];
    }else
    {
        if (transaction.managedObjectContext != nil)
        {
            if ([transaction.paymentMode isEqualToString:NSLocalizedString(@"all", nil)])
            {
                [self.btnPaymentMode setTitle:NSLocalizedString(@"all", nil) forState:UIControlStateNormal];
                [self.imgpaymentmode setImage:[UIImage imageNamed:@"All_icon.png"]];
            }else
            {
                NSString *paymentMode=transaction.paymentMode;
                NSArray *paymentModeArray=[[PaymentmodeHandler sharedCoreDataController] getsearchPaymentWithAttributeName:paymentMode];
                if ([paymentModeArray count]!=0)
                {
                    NSDictionary * paymentInfo =[paymentModeArray objectAtIndex:0];
                    [self.btnPaymentMode setTitle:[paymentInfo objectForKey:@"paymentMode"] forState:UIControlStateNormal];
                    [self.imgpaymentmode setImage:[UIImage imageWithData:[paymentInfo objectForKey:@"paymentmode_icon"]]];
                }else
                {
                    [self.btnPaymentMode setTitle:NSLocalizedString(@"noPaymentMode", nil) forState:UIControlStateNormal];
                    [self.imgpaymentmode setImage:[UIImage imageNamed:@"paymentmode_icon.png"]];
                }
            }
            
        }else
        {
            NSArray *paymentModeArray=[[NSMutableArray alloc]initWithArray:[[PaymentmodeHandler sharedCoreDataController]getPaymentModeList]];
            Paymentmode *mode=[paymentModeArray objectAtIndex:0];
            [self.btnPaymentMode setTitle:mode.paymentMode forState:UIControlStateNormal];
            [self.imgpaymentmode setImage:[UIImage imageWithData:mode.paymentmode_icon]];
        }
    }
}



-(void)addNewBudjet
{
    NSDate *currentDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalederUnit fromDate:currentDate];
    NSString *combined;
    if ([components month]<10)
    {
        combined = [NSString stringWithFormat:@"0%li %li",(long)[components month] ,(long)[components year] ];
    }else
        combined = [NSString stringWithFormat:@"%li %li",(long)[components month] ,(long)[components year] ];
   
    [self.lblFromDay setText:[NSString stringWithFormat:@"%li",(long)[components day]]];
    [self.lblFromMonthYear setText:combined];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:1];
    NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:currentDate options:0];
    components = [calendar components:NSCalederUnit fromDate:newDate];
    if ([components month]<10)
    {
        combined = [NSString stringWithFormat:@"0%li %li",(long)[components month] ,(long)[components year] ];
    }else
        combined = [NSString stringWithFormat:@"%li %li",(long)[components month] ,(long)[components year] ];
    
    [self.lblToDay setText:[NSString stringWithFormat:@"%li",(long)[components day]]];
    [self.lblToMonthYear setText:combined];

    NSArray *UserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsWithUserName:[Utility userDefaultsForKey:CURRENT_USER__TOKEN_ID]];
    if ([UserInfoarrray count]!=0)
    {
        [self addAccountName:UserInfoarrray];
    }else
    {
        NSArray *UserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsToUserRegisterTable];
        [self addAccountName:UserInfoarrray];
    }
    
  
    NSString *mainToken=[Utility userDefaultsForKey:MAIN_TOKEN_ID];
    NSString *currency= [Utility  userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",CURRENT_CURRENCY,mainToken]];
    [self.lblCurrency setText:[[currency componentsSeparatedByString:@"-"] objectAtIndex:1]];

}


-(void)updateBudjet
{
    NSString *mainToken=[Utility userDefaultsForKey:MAIN_TOKEN_ID];
    NSString *currency= [Utility  userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",CURRENT_CURRENCY,mainToken]];
  
    NSNumber *myDoubleNumber = [NSNumber numberWithDouble:[transaction.amount doubleValue]];
    [self.txtAmount setText:[myDoubleNumber stringValue]];
    
    [self.lblCurrency setText:[[currency componentsSeparatedByString:@"-"] objectAtIndex:1]];
    [self setTitle:NSLocalizedString(@"editBudget", nil)];

    NSArray *UserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsWithUserTokenid:transaction.user_token_id ];
    if ([UserInfoarrray count]!=0)
    {
        [self addAccountName:UserInfoarrray];
    }
    
    if (![transaction.discription isEqualToString:@""])
    {
       [self.txtDescription setText:transaction.discription];
    }
  
    NSDate *toDate =[NSDate dateWithTimeIntervalSince1970:([[transaction.todate stringValue] doubleValue] / 1000)];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalederUnit fromDate:toDate];
    [self.lblToDay setText:[NSString stringWithFormat:@"%li",(long)[components day]]];
    NSString *combined;
    if ([components month]<10)
    {
        combined = [NSString stringWithFormat:@"0%li %li",(long)[components month] ,(long)[components year] ];
    }else
        combined = [NSString stringWithFormat:@"%li %li",(long)[components month] ,(long)[components year] ];
    
    [self.lblToMonthYear setText:combined];

    NSDate *fromDate =[NSDate dateWithTimeIntervalSince1970:([[transaction.fromdate stringValue] doubleValue] / 1000)];
     components = [calendar components:NSCalederUnit fromDate:fromDate];
    [self.lblFromDay setText:[NSString stringWithFormat:@"%li",(long)[components day]]];
    if ([components month]<10)
    {
        combined = [NSString stringWithFormat:@"0%li %li",(long)[components month] ,(long)[components year] ];
    }else
        combined = [NSString stringWithFormat:@"%li %li",(long)[components month] ,(long)[components year] ];
    [self.lblFromMonthYear setText:combined];

}



-(void) receivedCategeryListNotification:(NSNotification*) notification
{
    infoCategery =notification.userInfo;
}


-(void)receivedPaymentModeNotification:(NSNotification*) notification
{
    infoPayment =notification.userInfo;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)animateView :(UIView*)aView  xCoordinate:(CGFloat)dx  yCoordinate :(CGFloat) dy
{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	[aView  setTransform:CGAffineTransformMakeTranslation(dx, dy)];
	[UIView commitAnimations];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField==self.txtAmount)
    {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSArray  *arrayOfString = [newString componentsSeparatedByString:@"."];
        
        if ([arrayOfString count] > 2 )
            return NO;
    }
    return YES;
}


- (IBAction)backbtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)datebtnFrombtnClick:(id)sender
{
    RESIGN_KEYBOARD
    [ActionSheetDatePicker showPickerWithTitle : @"Select date" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] doneBlock:^(ActionSheetDatePicker *picker, NSDate* selectedDate, id origin) {
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:selectedDate];
        NSDateComponents *compsday = [gregorian components:NSCalendarUnitDay fromDate:selectedDate];
        
        self.lblFromDay.text=[[[[NSDateFormatter alloc] init] weekdaySymbols] objectAtIndex:selectedDate.weekday-1];
        self.lblFromMonthYear.text=[NSString stringWithFormat:@"%ld %@, %ld",(long)[compsday day],[[[[NSDateFormatter alloc] init] monthSymbols] objectAtIndex:selectedDate.month-1],(long)selectedDate.year];
    } cancelBlock:^(ActionSheetDatePicker *picker) {
    } origin:[self view]];
}




- (IBAction)datebtnToClick:(id)sender
{
    
    RESIGN_KEYBOARD
    [ActionSheetDatePicker showPickerWithTitle : @"Select date" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] doneBlock:^(ActionSheetDatePicker *picker, NSDate* selectedDate, id origin) {
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:selectedDate];
        NSDateComponents *compsday = [gregorian components:NSCalendarUnitDay fromDate:selectedDate];
        
        self.lblToDay.text=[[[[NSDateFormatter alloc] init] weekdaySymbols] objectAtIndex:selectedDate.weekday-1];
        self.lblToMonthYear.text=[NSString stringWithFormat:@"%ld %@, %ld",(long)[compsday day],[[[[NSDateFormatter alloc] init] monthSymbols] objectAtIndex:selectedDate.month-1],(long)selectedDate.year];
    } cancelBlock:^(ActionSheetDatePicker *picker) {
    } origin:[self view]];
    //----------------------------------
   }

-(void) receivedNotification:(NSNotification*) notification
{
    NSDictionary * info =notification.userInfo;

    if ([[info objectForKey:@"tag"] intValue]==1)
    {
        
        if ([[info objectForKey:@"object"] isEqualToString:NSLocalizedString(@"addAccount", nil)])
        {
            AddAccountViewController *catageryController=[self.storyboard instantiateViewControllerWithIdentifier:@"AddAccountViewController"];
            [self.navigationController pushViewController:catageryController animated:YES];
            
        }else
        {  [self.btnProfileName setTitle:[info objectForKey:@"object"] forState:UIControlStateNormal];
            NSArray *UserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsWithUserName:[info objectForKey:@"object"]];
            if ([UserInfoarrray count]!=0)
            {
                [Utility saveToUserDefaults:[info objectForKey:@"object"]  withKey:CURRENT_USER__TOKEN_ID];
                [self addAccountName:UserInfoarrray];
            }
        }
    }
}




- (IBAction)addBudgetintoDataBase:(id)sender
{
    [_txtAmount resignFirstResponder];
    [_txtDescription resignFirstResponder];
    if ([self CheckTransactionValidity])
    {
        NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
        NSArray *UserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsWithUserName:self.btnProfileName.titleLabel.text];
        if ([UserInfoarrray count]!=0)
        {
            UserInfo *userInfo =[UserInfoarrray objectAtIndex:0];
            [dictionary setObject:userInfo.user_token_id forKey:@"user_token_id"];
        }
        
        [dictionary setObject:_txtAmount.text forKey:@"amount"];
        
        if ([[_txtDescription text] length]==0)
        {
             [dictionary setObject:@"" forKey:@"description"];
        }else
        [dictionary setObject:_txtDescription.text forKey:@"description"];
        
        NSArray *fromDatearrry =[_lblFromMonthYear.text componentsSeparatedByString:@" "];
       
        [dictionary setObject:[NSString stringWithFormat:@"%@ %@",[NSString stringWithFormat:@"%@/%@/%@",_lblFromDay.text,[fromDatearrry objectAtIndex:0],[fromDatearrry objectAtIndex:1]],[NSString stringWithFormat:@"%@:%@:%@",@"00",@"00",@"00"]] forKey:@"fromDate"];

        NSArray *toDatearrry =[_lblToMonthYear.text componentsSeparatedByString:@" "];
        
        [dictionary setObject:[NSString stringWithFormat:@"%@ %@",[NSString stringWithFormat:@"%@/%@/%@",_lblToDay.text,[toDatearrry objectAtIndex:0],[toDatearrry objectAtIndex:1]],[NSString stringWithFormat:@"%@:%@:%@",@"23",@"59",@"59"]] forKey:@"toDate"];
        
        if ([_lblSabCatagery.text length]==0)
        {
            [dictionary setObject:_buttonUnhideCategery.titleLabel.text forKey:@"category"];
        }else
            [dictionary setObject:_btnCategery.titleLabel.text forKey:@"category"];
        
        [dictionary setObject:_lblSabCatagery.text forKey:@"sub_category"];
        [dictionary setObject:_btnPaymentMode.titleLabel.text forKey:@"paymentMode"];
        [dictionary setObject:[NSNumber numberWithInt:0] forKey:@"Shown_on_homescreen"];
        
        if (transaction.managedObjectContext == nil)
        {
            [[BudgetHandler sharedCoreDataController] insertDataIntoBudgetTable:dictionary];
            [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"budgetaddedSuccessfully", nil)];
        }else
        {
            [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"budgetupdatedSuccessfully", nil)];
           [[BudgetHandler sharedCoreDataController] updateDataIntoTransactionTable:dictionary :transaction];
        }
          [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
     [self animateView:self.dobView xCoordinate:0 yCoordinate:0];
    
}


-(BOOL)CheckTransactionValidity
{
    float otherfloat=[_txtAmount.text floatValue];
    float roundedup = ceil(otherfloat);
    NSLog(@"%f",roundedup);
    
    if ([_txtAmount.text isEqual:@""]||[_btnPaymentMode.titleLabel.text isEqual:@""]|| roundedup==0.0)
    {
        [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"entersomeamount", nil)];
        return NO;
    }if ([_buttonUnhideCategery.titleLabel.text isEqualToString:NSLocalizedString(@"noCategory", nil)])
    {
        [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"noCategory", nil)];
        return NO;
    }if ([_btnPaymentMode.titleLabel.text isEqualToString:NSLocalizedString(@"noCategory", nil)] )
    {
        [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"noPaymentMode", nil)];
        return NO;
    }
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
     [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSArray *fromDatearrry =[_lblFromMonthYear.text componentsSeparatedByString:@" "];
    NSDate *startDate = [dateFormat dateFromString:[NSString stringWithFormat:@"%@ %@",[NSString stringWithFormat:@"%@/%@/%@",_lblFromDay.text,[fromDatearrry objectAtIndex:0],[fromDatearrry objectAtIndex:1]],[NSString stringWithFormat:@"%@:%@:%@",@"00",@"00",@"00"]]];
     NSArray *toDatearrry =[_lblToMonthYear.text componentsSeparatedByString:@" "];
    
    NSDate *endDate=[dateFormat dateFromString:[NSString stringWithFormat:@"%@ %@",[NSString stringWithFormat:@"%@/%@/%@",_lblToDay.text,[toDatearrry objectAtIndex:0],[toDatearrry objectAtIndex:1]],[NSString stringWithFormat:@"%@:%@:%@",@"23",@"59",@"59"]]];
    NSTimeInterval interval = [endDate timeIntervalSinceDate:startDate];
    if (interval<0)
    {
        [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"latergreater", nil)];
        return NO;
    }
    if (![self specialCharactersOccurence:_txtDescription.text])
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
        return NO;
    }

    return YES;
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



- (IBAction)btnProfileNameclick:(id)sender
{
    [self.txtAmount resignFirstResponder];
    [self.txtDescription resignFirstResponder];
    NSMutableArray *userInfoList=[[NSMutableArray alloc] init];
    NSArray *UserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsToUserRegisterTable];
    if ([UserInfoarrray count]>1)
    {
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
    [poplistview setNotificationName:@"CreateBudgetsViewController"];
    [poplistview setListArray:userInfoList];
    if (yHeight<300)
    {
    poplistview.listView.scrollEnabled = FALSE;
    }
    [poplistview show];
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (transaction.managedObjectContext != nil)
    {
        if ([[segue identifier] isEqualToString:@"AddCategory"])
        {
            CategeyListViewController *dest = (CategeyListViewController *)[segue destinationViewController];
            [dest setSelectedCategery:transaction.category];
            [dest setSelectedSubCategery:transaction.sub_category];
        } else  if ([[segue identifier] isEqualToString:@"AddPaymentMode"])
        {
            PaymentModeViewController *dest = (PaymentModeViewController *)[segue destinationViewController];
            [dest setPaymentMode:transaction.paymentMode];
        }
    }
  
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain   target:nil  action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];

}


@end
