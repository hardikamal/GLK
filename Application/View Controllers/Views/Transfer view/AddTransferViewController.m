//
//  AddTransferViewController.m
//  Daily Expense Manager
//
//  Created by Appbulous on 10/09/16.
//  Copyright (c) 2016 Jyoti Kumar. All rights reserved.
//

#import "AddTransferViewController.h"
#import "PaymentmodeHandler.h"
#import "Paymentmode.h"
#import "CategoryListHandler.h"
#import "CategoryList.h"
#import "UserInfoHandler.h"
#import "UserInfo.h"
#import "UIPopoverListView.h"
#import "UIAlertView+Block.h"
#import "TransferHandler.h"
#import "TransactionHandler.h"
#import "Transactions.h"

#import "AddAccountViewController.h"
#import "CategeyListViewController.h"
#import "PaymentModeViewController.h"


@interface AddTransferViewController ()
{
    BOOL   isSelected;
    NSDictionary * infoCategery;
    NSDictionary * infoPayment;
}

@end

@implementation AddTransferViewController
@synthesize  transaction;
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
    [self.lblTitle setFont:[UIFont fontWithName:Ebrima_Bold size:16.0f]];
    self.btnCategory.titleLabel.font =[UIFont fontWithName:Embrima size:16.0f];
    self.buttonUnhideCategery.titleLabel.font =[UIFont fontWithName:Embrima size:16.0f];
    self.btnPaymentMode.titleLabel.font =[UIFont fontWithName:Embrima size:16.0f];
    self.btnUserFrom.titleLabel.font =[UIFont fontWithName:Embrima size:16.0f];
    self.btnUserTo.titleLabel.font =[UIFont fontWithName:Embrima size:16.0f];
    [self.lblCarrancy setFont:[UIFont fontWithName:Embrima size:16.0f]];
    [self.lblDay setFont:[UIFont fontWithName:Embrima size:28.0f]];
    [self.lblMonthYear setFont:[UIFont fontWithName:Embrima size:18.0f]];
    [self.lblPmorAm setFont:[UIFont fontWithName:Embrima size:18.0f]];
    [self.lblSabCatagery setFont:[UIFont fontWithName:Embrima size:12.0f]];
    [self.lbltime setFont:[UIFont fontWithName:Embrima size:28.0f]];
    [self.lblTitleName setFont:[UIFont fontWithName:Embrima size:16.0f]];
    [self.lblToday setFont:[UIFont fontWithName:Embrima size:16.0f]];
    self.scrollView.contentSize=CGSizeMake(320, 660);
    
    DoneCancelNumberPadToolbar *toolbar = [[DoneCancelNumberPadToolbar alloc] initWithTextField:_txtAmount];
    toolbar.delegate = self;
    _txtAmount.inputAccessoryView = toolbar;
    
    self.dobView.frame=CGRectMake(0, self.view.frame.size.height, self.dobView.frame.size.width, self.dobView.frame.size.height);
    [self.view addSubview:self.dobView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedCategeryListNotification:) name:@"CategeryList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedPaymentModeNotification:) name:@"PaymentMode" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotification:) name:@"AddTransferViewController" object:nil];
    
    if (transaction.managedObjectContext == nil)
    {
        [self addNewTransaction];
    }else
    {
        [self updateTransaction];
    }
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
            [self.btnCategory setHidden:NO];
            [self.buttonUnhideCategery setHidden:YES];
            [self.lblSabCatagery setText:[arrray objectAtIndex:1]];
            [self.btnCategory setTitle:[arrray objectAtIndex:0] forState:UIControlStateNormal];
        }else
        {
            [self.btnCategory setHidden:YES];
            [self.buttonUnhideCategery setTitle:[arrray objectAtIndex:0] forState:UIControlStateNormal];
            [self.buttonUnhideCategery setHidden:NO];
            [self.lblSabCatagery setText:@""];
        }
        [self.imgCategery setImage:[infoCategery objectForKey:@"image"]];
    }else
    {
        if (transaction.managedObjectContext != nil)
        {
            NSArray *categeryArray=[[CategoryListHandler sharedCoreDataController] getsearchCategeryWithAttributeName:@"category_icon" andSearchText:transaction.category];
            
            self.imgCategery.image=[UIImage imageWithData:[[categeryArray objectAtIndex:0] objectForKey:@"category_icon"]];
            if (![transaction.sub_category isEqualToString:@""])
            {
                [self.lblSabCatagery setHidden:NO];
                [self.btnCategory setHidden:NO];
                [self.buttonUnhideCategery setHidden:YES];
                [self.lblSabCatagery setText:transaction.sub_category];
                [self.btnCategory setTitle:transaction.category forState:UIControlStateNormal];
            }else
                [self.buttonUnhideCategery setTitle:transaction.category forState:UIControlStateNormal];
        }else
        {
            NSArray *categeryIcon=[[CategoryListHandler sharedCoreDataController] getCategeryList:[NSString stringWithFormat:@"%d",TYPE_EXPENSE]];
            if ([categeryIcon count]==0)
            {
                [self.buttonUnhideCategery setTitle:NSLocalizedString(@"noCategory", nil) forState:UIControlStateNormal];
                [self.imgCategery setImage:[UIImage imageNamed:@"Miscellaneous_icon.png"]];
            }else
            {
                CategoryList *list=(CategoryList*)[categeryIcon objectAtIndex:0];
                [self.buttonUnhideCategery setTitle:list.category forState:UIControlStateNormal];
                [self.imgCategery setImage:[UIImage imageWithData:list.category_icon]];
            }
            
        }
    }
    if ([infoPayment count] != 0)
    {
        [self.btnPaymentMode setTitle:[infoPayment objectForKey:@"name"] forState:UIControlStateNormal];
        [self.imgPaymentmode setImage:[infoPayment objectForKey:@"image"]];
    }else
    {
        if (transaction.managedObjectContext != nil)
        {
            NSString *paymentMode=transaction.paymentMode;
            NSArray *paymentModeArray=[[PaymentmodeHandler sharedCoreDataController] getsearchPaymentWithAttributeName:paymentMode];
            NSDictionary * paymentInfo =[paymentModeArray objectAtIndex:0];
            [self.btnPaymentMode setTitle:[paymentInfo objectForKey:@"paymentMode"] forState:UIControlStateNormal];
            [self.imgPaymentmode setImage:[UIImage imageWithData:[paymentInfo objectForKey:@"paymentmode_icon"]]];
        }else
        {
            NSArray *paymentModeArray=[[NSMutableArray alloc]initWithArray:[[PaymentmodeHandler sharedCoreDataController]getPaymentModeList]];
            if ([paymentModeArray count]==0)
            {
                [self.btnPaymentMode setTitle:NSLocalizedString(@"noPaymentMode", nil) forState:UIControlStateNormal];
                [self.imgPaymentmode setImage:[UIImage imageNamed:@"paymentmode.png"]];
            }else
            {
                Paymentmode *mode=[paymentModeArray objectAtIndex:0];
                [self.btnPaymentMode setTitle:mode.paymentMode forState:UIControlStateNormal];
                [self.imgPaymentmode setImage:[UIImage imageWithData:mode.paymentmode_icon]];
            }
        }
    }
}



-(void)updateTransaction
{
    NSString *mainToken=[Utility userDefaultsForKey:MAIN_TOKEN_ID];
    NSString *currency= [Utility  userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",CURRENT_CURRENCY,mainToken]];
    [self.lblCarrancy setText:[NSString stringWithFormat:@"%@",[[currency componentsSeparatedByString:@"-"] objectAtIndex:1]]];
    NSNumber *myDoubleNumber = [NSNumber numberWithDouble:[transaction.amount doubleValue]];
    [self.txtAmount setText:[myDoubleNumber stringValue]];
    
    [self setTitle:NSLocalizedString(@"editTransfer", nil)];
    
    NSArray *fromUserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsWithUserTokenid:transaction.fromaccount];
    
    if ([fromUserInfoarrray count]!=0)
    {
        UserInfo *userInfo =[fromUserInfoarrray objectAtIndex:0];
        [self.btnUserFrom setTitle:userInfo.user_name forState:UIControlStateNormal];
        if (userInfo.user_img != nil)
        {
            self.imgeFromProfile.layer.cornerRadius = self.imgeFromProfile.frame.size.width / 2;
            self.imgeFromProfile.clipsToBounds = YES;
            self.imgeFromProfile.image=[UIImage imageWithData:userInfo.user_img];
        }else
            self.imgeFromProfile.image=[UIImage imageNamed:@"custom_profile.png"];
    }
    
    NSArray *toUserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsWithUserTokenid:transaction.toaccount];
    if ([toUserInfoarrray count]!=0)
    {
        UserInfo *userInfo =[toUserInfoarrray objectAtIndex:0];
        [self.btnUserTo setTitle:userInfo.user_name forState:UIControlStateNormal ];
        if (userInfo.user_img != nil)
        {
            self.imageToProfile.layer.cornerRadius = self.imageToProfile.frame.size.width / 2;
            self.imageToProfile.clipsToBounds = YES;
            self.imageToProfile.image=[UIImage imageWithData:userInfo.user_img];
        }else
            self.imageToProfile.image=[UIImage imageNamed:@"custom_profile.png"];
    }
    
    NSString *nDate=[transaction.date stringValue];
    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:([nDate doubleValue] / 1000)];
    [self.dobPicker setDate:currentDate animated:YES];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalederUnit fromDate:currentDate];
    [self.lblDay setText:[NSString stringWithFormat:@"%li",(long)[components day]]];
    NSString *combined;
    if ([components month]<10)
    {
        combined = [NSString stringWithFormat:@"0%li %li",(long)[components month] ,(long)[components year] ];
    }else
        combined = [NSString stringWithFormat:@"%li %li",(long)[components month] ,(long)[components year] ];    [self.lblMonthYear setText:combined];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    [self.lbltime setText:[[[formatter stringFromDate:currentDate] componentsSeparatedByString:@" "]  objectAtIndex:0]];
    [self.lblPmorAm setText:[[[[formatter stringFromDate:currentDate] componentsSeparatedByString:@" "]  objectAtIndex:1] uppercaseString]];
    if ([transaction.discription length]!=0)
        [self.txtDescription setText:transaction.discription];
}


-(void)receivedNotification:(NSNotification*) notification
{
    NSDictionary * info =notification.userInfo;
    
    if ([[info objectForKey:@"tag"] intValue]==2)
    {
        if ([[info objectForKey:@"object"] isEqualToString:NSLocalizedString(@"addAccount", nil)])
            
        {
                 AddAccountViewController *catageryController=[self.storyboard instantiateViewControllerWithIdentifier:@"AddAccountViewController"];
                [self.navigationController pushViewController:catageryController animated:YES];
            
        }else
        {
            [self.btnUserTo setTitle:[info objectForKey:@"object"] forState:UIControlStateNormal];
            NSArray *UserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsWithUserName:self.btnUserTo.titleLabel.text];
            NSString *userToken;
            if ([UserInfoarrray count]!=0)
            {
                UserInfo *userInfo =[UserInfoarrray objectAtIndex:0];
                userToken=userInfo.user_token_id;
                if (userInfo.user_img != nil)
                {
                    self.imageToProfile.layer.cornerRadius = self.imageToProfile.frame.size.width / 2;
                    self.imageToProfile.clipsToBounds = YES;
                    self.imageToProfile.image=[UIImage imageWithData:userInfo.user_img];
                }else
                    self.imageToProfile.image=[UIImage imageNamed:@"custom_profile.png"];
            }
        }
    }
    if ([[info objectForKey:@"tag"] intValue]==1)
    {
        if ([[info objectForKey:@"object"] isEqualToString:NSLocalizedString(@"addAccount", nil)])
            
        {
            AddAccountViewController *catageryController=[self.storyboard instantiateViewControllerWithIdentifier:@"AddAccountViewController"];
            [self.navigationController pushViewController:catageryController animated:YES];
        }else
        {
            [Utility saveToUserDefaults:[info objectForKey:@"object"]  withKey:CURRENT_USER__TOKEN_ID];
            [self.btnUserFrom setTitle:[info objectForKey:@"object"] forState:UIControlStateNormal];
            NSArray *UserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsWithUserName:self.btnUserFrom.titleLabel.text];
            NSString *userToken;
            if ([UserInfoarrray count]!=0)
            {
                UserInfo *userInfo =[UserInfoarrray objectAtIndex:0];
                userToken=userInfo.user_token_id;
                if (userInfo.user_img != nil)
                {
                    self.imgeFromProfile.layer.cornerRadius = self.imgeFromProfile.frame.size.width / 2;
                    self.imgeFromProfile.clipsToBounds = YES;
                    self.imgeFromProfile.image=[UIImage imageWithData:userInfo.user_img];
                }else
                    self.imgeFromProfile.image=[UIImage imageNamed:@"custom_profile.png"];
            }

        }
    }
  
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

-(void)addAccountFromName:(NSArray *)userInfoarrray
{
    UserInfo *userInfo =[userInfoarrray objectAtIndex:0];
    [self.btnUserFrom setTitle:userInfo.user_name forState:UIControlStateNormal];
    if (userInfo.user_img != nil)
    {
        self.imgeFromProfile.layer.cornerRadius = self.imgeFromProfile.frame.size.width / 2;
        self.imgeFromProfile.clipsToBounds = YES;
        self.imgeFromProfile.image=[UIImage imageWithData:userInfo.user_img];
        
    }else
        self.imgeFromProfile.image=[UIImage imageNamed:@"custom_profile.png"];
}


-(void)addAccountToName:(NSArray *)userInfoarrray
{
    UserInfo *userInfo =[userInfoarrray objectAtIndex:0];
    [self.btnUserTo setTitle:userInfo.user_name forState:UIControlStateNormal];
    if (userInfo.user_img != nil)
    {
        self.imageToProfile.layer.cornerRadius = self.imageToProfile.frame.size.width / 2;
        self.imageToProfile.clipsToBounds = YES;
        self.imageToProfile.image=[UIImage imageWithData:userInfo.user_img];
        
    }else
        self.imageToProfile.image=[UIImage imageNamed:@"custom_profile.png"];
}


-(void)addNewTransaction
{
    NSDate *currentDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalederUnit fromDate:currentDate];
    [self.lblDay setText:[NSString stringWithFormat:@"%li",(long)[components day]]];
    NSString *combined;
    if ([components month]<10)
    {
        combined = [NSString stringWithFormat:@"0%li %li",(long)[components month] ,(long)[components year] ];
    }else
        combined = [NSString stringWithFormat:@"%li %li",(long)[components month] ,(long)[components year] ];
    [self.lblMonthYear setText:combined];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    [self.lbltime setText:[[[formatter stringFromDate:[NSDate date]] componentsSeparatedByString:@" "]  objectAtIndex:0]];
    [self.lblPmorAm setText:[[[[formatter stringFromDate:[NSDate date]] componentsSeparatedByString:@" "]  objectAtIndex:1] uppercaseString]];
    
    NSArray *UserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsWithUserName:[Utility userDefaultsForKey:CURRENT_USER__TOKEN_ID]];
    if ([UserInfoarrray count]!=0)
    {
        [self addAccountFromName:UserInfoarrray];
        [self addAccountToName:UserInfoarrray];
    }else
    {
         NSArray *UserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsToUserRegisterTable];
        [self addAccountFromName:UserInfoarrray];
        [self addAccountToName:UserInfoarrray];
        
    }
    NSString *mainToken=[Utility userDefaultsForKey:MAIN_TOKEN_ID];
    NSString *currency= [Utility  userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",CURRENT_CURRENCY,mainToken]];
    [self.lblCarrancy setText:[[currency componentsSeparatedByString:@"-"] objectAtIndex:1]];
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

- (IBAction)backbtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)backButtonClick:(id)sender
{
    
}
- (IBAction)timePickerbtnClick:(id)sender
{
    RESIGN_KEYBOARD
    [ActionSheetDatePicker showPickerWithTitle : @"Select time" datePickerMode:UIDatePickerModeTime selectedDate:[NSDate date] doneBlock:^(ActionSheetDatePicker *picker, NSDate* selectedDate, id origin)
     {
         NSDateFormatter * formatter=[[NSDateFormatter alloc] init];
         [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
         [formatter setDateFormat:@"dd/MM/yyyy hh:mma"];
         [formatter setDateFormat:@"hh:mma"];
         self.lbltime.text=[[formatter stringFromDate:selectedDate]substringToIndex:5];
         self.lblPmorAm.text=[NSDate stringFromDate:selectedDate withFormat:@"a"];
         
     } cancelBlock:^(ActionSheetDatePicker *picker) {
         
     } origin:[self view]];
    
    // isSelected=YES;
}

- (IBAction)datePickerbtnClick:(id)sender
{
    RESIGN_KEYBOARD
    
    [ActionSheetDatePicker showPickerWithTitle : @"Select date" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] doneBlock:^(ActionSheetDatePicker *picker, NSDate* selectedDate, id origin) {
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:selectedDate];
        NSDateComponents *compsday = [gregorian components:NSCalendarUnitDay fromDate:selectedDate];
        // self.lblDay.text=[[[[NSDateFormatter alloc] init] weekdaySymbols] objectAtIndex:selectedDate.weekday-1];
        self.lblMonthYear.text=[NSString stringWithFormat:@"%@, %ld",[[[[NSDateFormatter alloc] init] monthSymbols] objectAtIndex:selectedDate.month-1],(long)selectedDate.year];
        self.lblDay.text=[NSString stringWithFormat:@"%@,%ld", [[[[NSDateFormatter alloc] init] weekdaySymbols] objectAtIndex:[comps weekday]-1],(long)[compsday day]];
        
    } cancelBlock:^(ActionSheetDatePicker *picker) {
    } origin:[self view]];
    
}

-(void)animateView :(UIView*)aView  xCoordinate:(CGFloat)dx  yCoordinate :(CGFloat) dy
{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	[aView  setTransform:CGAffineTransformMakeTranslation(dx, dy)];
	[UIView commitAnimations];
}



-(void)removeNumberKeyboardWhenDonePressed:(id)sender
{
    [self.view endEditing:TRUE];
    
}


#pragma mark -TextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
      [self animateView:self.dobView xCoordinate:0 yCoordinate:0];
    if (textField==_txtDescription)
    {
        if (self.view.frame.size.height< 500 )
        {
            [UIView animateWithDuration:0.3 animations:^{
                [_scrollView setContentOffset:CGPointMake(0,35) animated:YES];
            }];
        }
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.txtAmount)
    {
        [self.txtDescription becomeFirstResponder];
    }else
    {
        if (self.view.frame.size.height < 500 )
        {
            [UIView animateWithDuration:0.3 animations:^{
                [_scrollView setContentOffset:CGPointMake(0,0) animated:YES];
            }];
        }
        [self.txtDescription resignFirstResponder];
    }
    return YES;
}




- (IBAction)btnDoneClick:(id)sender
{
    
    [_txtAmount resignFirstResponder];
    [_txtDescription resignFirstResponder];
    if ([self CheckTransactionValidity])
    {
        NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
        NSArray *UserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsWithUserName:self.btnUserTo.titleLabel.text];
        UserInfo *userToInfo =[UserInfoarrray objectAtIndex:0];
        [dictionary setObject:userToInfo.user_token_id forKey:@"toaccount"];
        
        NSString *mainToken=[Utility userDefaultsForKey:MAIN_TOKEN_ID];
        NSString *currency= [Utility  userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",CURRENT_CURRENCY,mainToken]];
        [dictionary setObject:currency forKey:@"currency"];
        
        UserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsWithUserName:self.btnUserFrom.titleLabel.text];
        UserInfo *userfromInfo =[UserInfoarrray objectAtIndex:0];
        [dictionary setObject:userfromInfo.user_token_id forKey:@"fromaccount"];
        [dictionary setObject:_txtAmount.text forKey:@"amount"];
        
        if ([[_txtDescription text] length]==0)
        {
            [dictionary setObject:@"" forKey:@"description"];
        }else
            [dictionary setObject:_txtDescription.text forKey:@"description"];
        
       NSArray *arrry =[_lblMonthYear.text componentsSeparatedByString:@" "];
      [dictionary setObject:[NSString stringWithFormat:@"%@ %@",[NSString stringWithFormat:@"%@/%@/%@",_lblDay.text,[arrry objectAtIndex:0],[arrry objectAtIndex:1]],[NSString stringWithFormat:@"%@:%@ %@",_lbltime.text,@"00",[_lblPmorAm.text lowercaseString]]] forKey:@"date"];
           [dictionary setObject:@"0" forKey:@"transaction_reference_id"];
        
        if ([_lblSabCatagery.text length]==0)
        {
            [dictionary setObject:_buttonUnhideCategery.titleLabel.text forKey:@"category"];
        }else
            [dictionary setObject:_btnCategory.titleLabel.text forKey:@"category"];
        
        [dictionary setObject:_lblSabCatagery.text forKey:@"sub_category"];
        [dictionary setObject:_btnPaymentMode.titleLabel.text forKey:@"paymentMode"];
    
        if (transaction.managedObjectContext == nil)
        {
            [dictionary setObject:[NSNumber numberWithInt:TYPE_INCOME] forKey:@"transaction_type"];
            [dictionary setObject:userToInfo.user_token_id forKey:@"user_token_id"];
        
            NSNumber *incomTransactionId=[[TransactionHandler sharedCoreDataController] insertDataIntoTransactionTableFromTransferTable:dictionary];
            
            [dictionary setObject:[NSNumber numberWithInt:TYPE_EXPENSE] forKey:@"transaction_type"];
            [dictionary setObject:userfromInfo.user_token_id forKey:@"user_token_id"];
            
            NSNumber *expenseTransactionId=[[TransactionHandler sharedCoreDataController] insertDataIntoTransactionTableFromTransferTable:dictionary];
            [dictionary setObject:incomTransactionId forKey:@"income_transaction_id"];
            [dictionary setObject:expenseTransactionId forKey:@"expense_transaction_id"];
            
           NSString *transactionid =[[TransferHandler sharedCoreDataController] insertDataIntorTransaferTable:dictionary];
            
           NSArray *arraycount=[[TransactionHandler sharedCoreDataController] getTransactionWithTransactionId:[incomTransactionId stringValue] :userToInfo.user_token_id];
            
            if ([arraycount count]!=0)
            {
               [[TransactionHandler sharedCoreDataController] updateRefrence_idIntoTransactionTableFromTransferTable :transactionid :[arraycount objectAtIndex:0]];
            }
            
            arraycount=[[TransactionHandler sharedCoreDataController] getTransactionWithTransactionId:[expenseTransactionId stringValue] :userfromInfo.user_token_id];
            
            if ([arraycount count]!=0)
            {
                [[TransactionHandler sharedCoreDataController] updateRefrence_idIntoTransactionTableFromTransferTable :transactionid :[arraycount objectAtIndex:0]];
            }
            [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"transferaddedSuccessfully", nil)];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else
        {
            [dictionary setObject:[NSNumber numberWithInt:TYPE_INCOME] forKey:@"transaction_type"];
            [dictionary setObject:transaction.toaccount forKey:@"user_token_id"];
            
            NSArray *incomarray =[[TransactionHandler sharedCoreDataController] getTransactionWithTransactionId:[transaction.income_transaction_id stringValue] :transaction.toaccount];
            if ([incomarray count]!=0)
            {
                 [[TransactionHandler sharedCoreDataController] updateDataIntoTransactionTableFromTransferTable:dictionary :[incomarray objectAtIndex:0]];
            }
          
            [dictionary setObject:[NSNumber numberWithInt:TYPE_EXPENSE] forKey:@"transaction_type"];
            [dictionary setObject:transaction.fromaccount forKey:@"user_token_id"];

            NSArray *expensearray =[[TransactionHandler sharedCoreDataController] getTransactionWithTransactionId:[transaction.expense_transaction_id stringValue] :transaction.fromaccount];
            if ([expensearray count]!=0)
            {
              
                [[TransactionHandler sharedCoreDataController] updateDataIntoTransactionTableFromTransferTable:dictionary :[expensearray objectAtIndex:0]];
            }
            [[TransferHandler sharedCoreDataController] updateDataIntorTransferTable:dictionary :transaction];
            [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"transferupdatedSuccessfully", nil)];
            [self.navigationController popViewControllerAnimated:YES];
            
            // [[SlideNavigationController sharedInstance] popAllAndSwitchToViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"TransferViewController"] withSlideOutAnimation:YES andCompletion:nil];
        }
    }
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
    }
    if ([_buttonUnhideCategery.titleLabel.text isEqualToString:NSLocalizedString(@"noCategory", nil)])
    {
        [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"noCategory", nil)];
        
        return NO;
    }if ([_btnPaymentMode.titleLabel.text isEqualToString:NSLocalizedString(@"noCategory", nil)] )
    {
        [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"noCategory", nil)];
        return NO;
    }
    if ([_btnUserTo.titleLabel.text isEqualToString:_btnUserFrom.titleLabel.text])
    {
        [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"sameAccount", nil)];
        
        return NO;
    }
    if ([self specialCharactersOccurence:_txtDescription.text] || [self specialCharactersOccurence:_txtDescription.text])
    {
        return YES;
    }
    return NO;
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


- (IBAction)btnUserToClick:(id)sender
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
    [poplistview setTag:2];
    [poplistview setNotificationName:@"AddTransferViewController"];
    [poplistview setListArray:userInfoList];
    if (yHeight<300)
    {
    poplistview.listView.scrollEnabled = FALSE;
    }
    [poplistview show];
}

- (IBAction)btnUserFromClick:(id)sender
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
    [poplistview setNotificationName:@"AddTransferViewController"];
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
