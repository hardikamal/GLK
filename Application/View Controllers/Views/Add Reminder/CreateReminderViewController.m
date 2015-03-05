
//
//  CreateReminderViewController.m
//  Daily Expense Manager
//
//  Created by Appbulous on 05/09/16.
//  Copyright (c) 2016 Jyoti Kumar. All rights reserved.
//

#import "CreateReminderViewController.h"
#import "CategeyListViewController.h"
#import "PaymentModeViewController.h"
#import "UIAlertView+Block.h"
#import "ImageViewController.h"
#import "ReminderHandler.h"
#import "CategoryListHandler.h"
#import "PaymentmodeHandler.h"
#import "UserInfoHandler.h"
#import "ReminderManger.h"
#import "UIAlertView+Block.h"
#import "UserInfo.h"
#import "Paymentmode.h"
#import "AKPickerView.h"

#import "AddAccountViewController.h"
#import "CategeyListViewController.h"
#import "PaymentModeViewController.h"

@interface CreateReminderViewController ()<AKPickerViewDataSource, AKPickerViewDelegate>

{
    BOOL chosePicker;
    int reminderSchedulling;
    BOOL alarmOn;
    int currentSelectionDays, currentSelectionHours;
    NSDictionary * infoCategery;
    NSDictionary * infoPayment;
    UIImageView *imageVw;
}
@property (weak, nonatomic) IBOutlet AKPickerView *pickerViewHours;
@property (weak, nonatomic) IBOutlet AKPickerView *pickerViewDays;
@property (nonatomic, strong) NSMutableArray *titlesDaysArray;
@property (nonatomic, strong) NSMutableArray *titlesHoursArray;

@end

@implementation CreateReminderViewController
@synthesize transaction,pickerViewDays,pickerViewHours;

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
    [self setUpDayHourPicker];
    self.scrollView.contentSize=CGSizeMake(320, 790);
    
    DoneCancelNumberPadToolbar *toolbar = [[DoneCancelNumberPadToolbar alloc] initWithTextField:_txtAmount];
    toolbar.delegate = self;
    _txtAmount.inputAccessoryView = toolbar;
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotification:) name:@"CreateReminderViewController" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedCatgeryNotification:)  name:@"CategeryList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedPaymentModeNotification:) name:@"PaymentMode" object:nil];
    self.btnClass.titleLabel.font =[UIFont fontWithName:Embrima size:16.0f];
    self.dobView.frame=CGRectMake(0, self.view.frame.size.height, self.dobView.frame.size.width, self.dobView.frame.size.height);
    [self.view addSubview:self.dobView];
    
    if (transaction.managedObjectContext == nil)
    {
        [self addNewReminder];
    }else
        [self addUpdateReminder];

}
-(void)viewWillAppear:(BOOL)animated
{
    if ([infoCategery count] != 0)
    {
        [self.lblSubcategery setHidden:YES];
        NSArray *arrray=[[infoCategery objectForKey:@"name"] componentsSeparatedByString:@","];
        if ([arrray count]==2)
        {
            [self.lblSubcategery setHidden:NO];
            [self.btnCategery setHidden:NO];
            [self.buttonUnhideCategery setHidden:YES];
            [self.lblSubcategery setText:[arrray objectAtIndex:1]];
            [self.btnCategery setTitle:[arrray objectAtIndex:0] forState:UIControlStateNormal];
        }else
        {
            [self.btnCategery setHidden:YES];
            [self.buttonUnhideCategery setTitle:[arrray objectAtIndex:0] forState:UIControlStateNormal];
            [self.buttonUnhideCategery setHidden:NO];
            [self.lblSubcategery setText:@""];
        }
        [self.imgCatagery setImage:[infoCategery objectForKey:@"image"]];
    }else
    {
        if (transaction.managedObjectContext != nil)
        {
             NSArray *categeryArray=[[CategoryListHandler sharedCoreDataController]  getsearchCategeryWithAttributeName:@"categry" andSearchText:TRIM(transaction.category)];
            self.imgCatagery.image=[UIImage imageWithData:[[categeryArray objectAtIndex:0] objectForKey:@"category_icon"]];
            if (![transaction.sub_category isEqualToString:@""])
            {
                [self.lblSubcategery setHidden:NO];
                [self.btnCategery setHidden:NO];
                [self.buttonUnhideCategery setHidden:YES];
                [self.lblSubcategery setText:transaction.sub_category];
                [self.btnCategery setTitle:transaction.category forState:UIControlStateNormal];
            }else
                [self.buttonUnhideCategery setTitle:transaction.category forState:UIControlStateNormal];
        }else
        {
            NSArray *categeryIcon=[[CategoryListHandler sharedCoreDataController] getCategeryList:[NSString stringWithFormat:@"%d",TYPE_EXPENSE]];
            if ([categeryIcon count]==0)
            {
                [self.buttonUnhideCategery setTitle:NSLocalizedString(@"noCategory", nil) forState:UIControlStateNormal];
                [self.imgCatagery setImage:[UIImage imageNamed:@"Miscellaneous_icon.png"]];
            }else
            {
                CategoryList *list=(CategoryList*)[categeryIcon objectAtIndex:0];
                [self.buttonUnhideCategery setTitle:list.category forState:UIControlStateNormal];
                [self.imgCatagery setImage:[UIImage imageWithData:list.category_icon]];
            }
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
            NSString *paymentMode=transaction.paymentMode;
            NSArray *paymentModeArray=[[PaymentmodeHandler sharedCoreDataController] getsearchPaymentWithAttributeName:paymentMode];
            NSDictionary * paymentInfo =[paymentModeArray objectAtIndex:0];
            [self.btnPaymentMode setTitle:[paymentInfo objectForKey:@"paymentMode"] forState:UIControlStateNormal];
            [self.imgpaymentmode setImage:[UIImage imageWithData:[paymentInfo objectForKey:@"paymentmode_icon"]]];
        }else
        {
            NSArray *paymentModeArray=[[NSMutableArray alloc]initWithArray:[[PaymentmodeHandler sharedCoreDataController]getPaymentModeList]];
            if ([paymentModeArray count]==0)
            {
                [self.btnPaymentMode setTitle:NSLocalizedString(@"noPaymentMode", nil) forState:UIControlStateNormal];
                [self.imgpaymentmode setImage:[UIImage imageNamed:@"paymentmode.png"]];
            }else
            {
                Paymentmode *mode=[paymentModeArray objectAtIndex:0];
                [self.btnPaymentMode setTitle:mode.paymentMode forState:UIControlStateNormal];
                [self.imgpaymentmode setImage:[UIImage imageWithData:mode.paymentmode_icon]];
            }
        }
    }
}





-(void)addNewReminder
{
    alarmOn = YES;
    currentSelectionDays = 1;
    currentSelectionHours = 1;
    [self.btnRecurring setTitle:NSLocalizedString(@"yearly", nil) forState:UIControlStateNormal];
    [self.btnClass setTitle:NSLocalizedString(@"income", nil) forState:UIControlStateNormal];
    chosePicker=NO;
    reminderSchedulling=0;
   
    NSArray *UserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsWithUserName:[Utility userDefaultsForKey:CURRENT_USER__TOKEN_ID]];
    if ([UserInfoarrray count]!=0)
    {
       // [self addAccountName:UserInfoarrray];
    }else
    {
        NSArray *UserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsToUserRegisterTable];
       // [self addAccountName:UserInfoarrray];
    }
    
    NSDate *currentDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate];
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
    [self.lblTime setText:[[[formatter stringFromDate:[NSDate date]] componentsSeparatedByString:@" "]  objectAtIndex:0]];
    [self.lblPmorAm setText:[[[[formatter stringFromDate:[NSDate date]] componentsSeparatedByString:@" "]  objectAtIndex:1] uppercaseString]];
    
    NSString *mainToken=[Utility userDefaultsForKey:MAIN_TOKEN_ID];
    NSString *currency= [Utility  userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",CURRENT_CURRENCY,mainToken]];
    [self.lblCurrency setText:[[currency componentsSeparatedByString:@"-"] objectAtIndex:1]];
    }



-(void)addUpdateReminder
{
    NSString *mainToken=[Utility userDefaultsForKey:MAIN_TOKEN_ID];
    NSString *currency= [Utility  userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",CURRENT_CURRENCY,mainToken]];
    [self.lblCurrency setText:[NSString stringWithFormat:@"%@",[[currency componentsSeparatedByString:@"-"] objectAtIndex:1]]];
   
    NSNumber *myDoubleNumber = [NSNumber numberWithDouble:[transaction.amount doubleValue]];
    [self.txtAmount setText:[myDoubleNumber stringValue]];
    
    NSArray *UserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsWithUserTokenid:transaction.user_token_id];
    [self  setTitle:NSLocalizedString(@"editReminder", nil)];
    
    if ([UserInfoarrray count]!=0)
    {
       // [self addAccountName:UserInfoarrray];
    }
    
    [self.btnRecurring setTitle:transaction.reminder_recurring_type forState:UIControlStateNormal];
    NSString *nDate=[transaction.date stringValue];
    NSDate *updateDate = [NSDate dateWithTimeIntervalSince1970:([nDate doubleValue] / 1000)];
    [self.dobPicker setDate:updateDate animated:YES];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:updateDate];
    [self.lblDay setText:[NSString stringWithFormat:@"%li",(long)[components day]]];
    NSString *combined;
    
    if ([components month]<10)
    {
        combined = [NSString stringWithFormat:@"0%li %li",(long)[components month] ,(long)[components year]];
    }else
        combined = [NSString stringWithFormat:@"%li %li",(long)[components month] ,(long)[components year]];
    
    [self.lblMonthYear setText:combined];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    
    [self.lblTime setText:[[[formatter stringFromDate:updateDate] componentsSeparatedByString:@" "]  objectAtIndex:0]];
    [self.lblPmorAm setText:[[[[formatter stringFromDate:updateDate] componentsSeparatedByString:@" "]  objectAtIndex:1] uppercaseString]];
    
    if ([transaction.discription length]!=0)
        [self.txtDiscription setText:transaction.discription];
   
    if ([transaction.reminder_heading length]!=0)
        [self.txtHeading setText:transaction.reminder_heading];
    
    if (transaction.pic != nil)
    {
        imageVw =[[UIImageView alloc] init];
        [imageVw setTag:10];
        [imageVw setFrame:self.customImageView.frame];
        [imageVw setUserInteractionEnabled:YES];
        imageVw.image=[UIImage imageWithData:transaction.pic];
        UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        imageButton.frame = CGRectMake(270, 0, 50, 35);
        [imageButton setImage:[UIImage imageNamed:@"cancel_button_budget.png"] forState:UIControlStateNormal];
        imageButton.adjustsImageWhenHighlighted = NO;
        [imageButton addTarget:self action:@selector(imageAction:) forControlEvents:UIControlEventTouchUpInside];
        [imageButton setBackgroundColor:[UIColor clearColor]];
        [imageVw addSubview:imageButton];
        UITapGestureRecognizer *oneTouch=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(OneTouchHandeler)];
        [oneTouch setNumberOfTouchesRequired:1];
        [imageVw addGestureRecognizer:oneTouch];
        [self.firstView addSubview:imageVw];
    }

    if ([transaction.transaction_type isEqualToString: NSLocalizedString(@"income", nil)])
    {
        [self.btnClass setTitle:NSLocalizedString(@"income", nil) forState:UIControlStateNormal];
       
    }else if ([transaction.transaction_type isEqualToString:NSLocalizedString(@"expense", nil)])
    {
       [self.btnClass setTitle:NSLocalizedString(@"expense", nil) forState:UIControlStateNormal];
    
    }else if ([transaction.transaction_type isEqualToString:NSLocalizedString(@"none", nil)])
    {
        [self.btnClass setTitle:NSLocalizedString(@"none", nil) forState:UIControlStateNormal];
    }

    if ([self.transaction.reminder_alert isEqualToString:@"true"])
    {
        [self.btnHidestatus setOn:YES animated:YES];
         alarmOn=YES;
    }else
    {
         [self.btnHidestatus setOn:NO animated:YES];
          alarmOn=NO;
    }
    
    if ([transaction.reminder_when_to_alert isEqualToString:@"0"])
    {
        currentSelectionDays = 1;
        currentSelectionHours = 1;
        reminderSchedulling = 0;
        [_imgReminder setImage:[UIImage imageNamed:@"radial_button_active.png"]];
        [_imgDayBefore setImage:[UIImage imageNamed:@"radial_button.png"]];
        [_imgHoutBefore setImage:[UIImage imageNamed:@"radial_button.png"]];

        
    }else   if ([transaction.reminder_when_to_alert isEqualToString:@"1"])
    {
        currentSelectionDays =[transaction.reminder_time_period intValue] ;
        currentSelectionHours = 1;
        reminderSchedulling = 1;
        [_imgDayBefore setImage:[UIImage imageNamed:@"radial_button_active.png"]];
        [_imgReminder setImage:[UIImage imageNamed:@"radial_button.png"]];
        [_imgHoutBefore setImage:[UIImage imageNamed:@"radial_button.png"]];
        
    }else   if ([transaction.reminder_when_to_alert isEqualToString:@"2"])
    {
        currentSelectionDays = 1;
        currentSelectionHours =[transaction.reminder_time_period intValue];
        reminderSchedulling = 2;
        [_imgHoutBefore setImage:[UIImage imageNamed:@"radial_button_active.png"]];
        [_imgDayBefore setImage:[UIImage imageNamed:@"radial_button.png"]];
        [_imgReminder setImage:[UIImage imageNamed:@"radial_button.png"]];
    }
   
}




- (IBAction)daybeforebtnClick:(id)sender
{
    reminderSchedulling = 1;
    [_imgDayBefore setImage:[UIImage imageNamed:@"radial_button_active@3x.png"]];
    [_imgReminder setImage:[UIImage imageNamed:@"radial_button_active@3x.png"]];
    [_imgHoutBefore setImage:[UIImage imageNamed:@"radial_button_active@3x.png"]];
}

- (IBAction)reminderbtnClick:(id)sender
{
    reminderSchedulling = 0;
    [_imgReminder setImage:[UIImage imageNamed:@"radial_button_active@3x.png"]];
    [_imgDayBefore setImage:[UIImage imageNamed:@"radial_button_active@3x.png"]];
    [_imgHoutBefore setImage:[UIImage imageNamed:@"radial_button_active@3x.png"]];
    
}

- (IBAction)hourbeforebtnClick:(id)sender
{
    reminderSchedulling = 2;
    [_imgHoutBefore setImage:[UIImage imageNamed:@"radial_button_active.png"]];
    [_imgDayBefore setImage:[UIImage imageNamed:@"radial_button.png"]];
    [_imgReminder setImage:[UIImage imageNamed:@"radial_button.png"]];
    
}



- (IBAction)addingReminderToDB:(id)sender
{
    if ([self CheckTransactionValidity])
    {
        NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
        NSArray *UserInfoarrray=[[UserInfoHandler sharedCoreDataController] getAllUserDetails];
        if ([UserInfoarrray count]!=0)
        {
            UserInfo *userInfo =[UserInfoarrray objectAtIndex:0];
            [dictionary setObject:userInfo.user_token_id forKey:@"user_token_id"];
        }
        
        [dictionary setObject:_txtAmount.text forKey:@"amount"];
        [dictionary setObject:_txtDiscription.text forKey:@"description"];
         NSArray *arrry =[_lblMonthYear.text componentsSeparatedByString:@" "];
        [dictionary setObject:[NSString stringWithFormat:@"%@ %@",[NSString stringWithFormat:@"%@/%@/%@",_lblDay.text,[arrry objectAtIndex:0],[arrry objectAtIndex:1]],[NSString stringWithFormat:@"%@:%@ %@",_lblTime.text,@"00",[_lblPmorAm.text lowercaseString]]] forKey:@"date"];
     
         [dictionary setObject:self.btnClass.titleLabel.text forKey:@"transaction_type"];
        
        if ([_lblSubcategery.text length]==0)
        {
            [dictionary setObject:_buttonUnhideCategery.titleLabel.text forKey:@"category"];
        }else
            [dictionary setObject:_btnCategery.titleLabel.text forKey:@"category"];
      
        [dictionary setObject:_lblSubcategery.text forKey:@"sub_category"];
        [dictionary setObject:_btnPaymentMode.titleLabel.text forKey:@"paymentMode"];
        
        if (imageVw.image!=nil)
        [dictionary setObject:imageVw.image forKey:@"pic"];
        
        [dictionary setObject:[NSString stringWithFormat:@"%i", reminderSchedulling]forKey:@"reminder_when_to_alert"];
        
        NSLog(@"%@",_btnRecurring.titleLabel.text);
        
        [dictionary setObject:_btnRecurring.titleLabel.text forKey:@"reminder_recurring_type"];
        
        [dictionary setObject:_txtHeading.text forKey:@"reminder_heading"];
        
        if (reminderSchedulling == 1)
        {
            [dictionary setObject:[NSString stringWithFormat:@"%i", currentSelectionDays] forKey:@"reminder_time_period"];

        } else if (reminderSchedulling == 2)
        {
            [dictionary setObject:[NSString stringWithFormat:@"%i", currentSelectionHours] forKey:@"reminder_time_period"];
        }else
          [dictionary setObject:[NSString stringWithFormat:@"%i", 0] forKey:@"reminder_time_period"];
    
        
        [dictionary setObject:[NSString stringWithFormat:@"%s", reminderSchedulling ? "true" : "false"] forKey:@"reminder_sub_alarm"];
        
       [dictionary setObject:[NSString stringWithFormat:@"%s", alarmOn ? "true" : "false"] forKey:@"reminder_alert"];
       [dictionary setObject:@"false" forKey:@"reminder_alarm"];
        
        if (transaction.managedObjectContext == nil)
        {
            NSString *uuid= [[ReminderHandler sharedCoreDataController] insertDataIntoReminderTable:dictionary];
            [[ReminderManger sharedMager] initReminder:uuid :uuid];
            [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"reminderaddedSuccessfully", nil)];
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            [[ReminderHandler sharedCoreDataController] updateDataIntoReminderTable:dictionary :transaction];
            [[ReminderManger sharedMager] cancelAlarm:transaction.transaction_id];
            [[ReminderManger sharedMager] initReminder:transaction.transaction_id :transaction.transaction_id];
            [self.navigationController popViewControllerAnimated:YES];
            [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"reminderupdatedSuccessfully", nil)];
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




- (IBAction)stateChanged:(UISwitch*)sender
{
    if ([sender isOn])
    {
        alarmOn=YES;
        
    } else
    {
        alarmOn=NO;
    }
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
                UserInfo *userInfo =[UserInfoarrray objectAtIndex:0];
                if (userInfo.user_img != nil)
                {
                    _imageProfile.layer.cornerRadius = _imageProfile.frame.size.width / 2;
                    _imageProfile.clipsToBounds = YES;
                    _imageProfile.image=[UIImage imageWithData:userInfo.user_img];
                }else
                    _imageProfile.image=[UIImage imageNamed:@"custom_profile.png"];
            }
            [Utility saveToUserDefaults:[info objectForKey:@"object"]  withKey:CURRENT_USER__TOKEN_ID];
        }
    }
    if ([[info objectForKey:@"tag"] intValue]==3)
    {
        [self.btnRecurring setTitle:[info objectForKey:@"object"] forState:UIControlStateNormal];
    }
}



-(void)receivedCatgeryNotification:(NSNotification*) notification
{
    infoCategery =notification.userInfo;
}


-(void)receivedPaymentModeNotification:(NSNotification*) notification
{
    infoPayment =notification.userInfo;
    
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
         self.lblTime.text=[[formatter stringFromDate:selectedDate]substringToIndex:5];
         self.lblPmorAm.text=[NSDate stringFromDate:selectedDate withFormat:@"a"];
         
     } cancelBlock:^(ActionSheetDatePicker *picker) {
         
     } origin:[self view]];
}
-(IBAction)datePickerbtnClick:(id)sender{
    RESIGN_KEYBOARD
    [ActionSheetDatePicker showPickerWithTitle : @"Select date" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] doneBlock:^(ActionSheetDatePicker *picker, NSDate* selectedDate, id origin) {
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:selectedDate];
        NSDateComponents *compsday = [gregorian components:NSCalendarUnitDay fromDate:selectedDate];

        self.lblDay.text=[[[[NSDateFormatter alloc] init] weekdaySymbols] objectAtIndex:selectedDate.weekday-1];
        self.lblMonthYear.text=[NSString stringWithFormat:@"%ld %@, %ld",(long)[compsday day],[[[[NSDateFormatter alloc] init] monthSymbols] objectAtIndex:selectedDate.month-1],(long)selectedDate.year];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateView:self.dobView xCoordinate:0 yCoordinate:0];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)classbtnClick:(id)sender
{
   
[UIActionSheet showInView:self.view withTitle:@"Transaction" cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:[[NSArray alloc]initWithObjects:NSLocalizedString(@"income", nil),NSLocalizedString(@"expense", nil),NSLocalizedString(@"none", nil),nil] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex)
    {
        if (![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]) {

        [self.btnClass setTitle:[actionSheet buttonTitleAtIndex:buttonIndex] forState:UIControlStateNormal];
        }

    }];
}


- (IBAction)recurringbtnClick:(id)sender
{
       NSArray *arrray=[[NSArray alloc] initWithObjects:NSLocalizedString(@"yearly", nil),NSLocalizedString(@"monthly", nil),NSLocalizedString(@"weekly", nil),NSLocalizedString(@"daily", nil),NSLocalizedString(@"none", nil),nil];
    [UIActionSheet showInView:self.view withTitle:@"Choose Duration" cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:arrray tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex)
     {
         if (![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]) {
             [self.btnRecurring setTitle:[actionSheet buttonTitleAtIndex:buttonIndex] forState:UIControlStateNormal];

         }

     }];
    
}



- (IBAction)BackbtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(BOOL)CheckTransactionValidity
{
    float otherfloat=[_txtAmount.text floatValue];
    float roundedup = ceil(otherfloat);
    NSLog(@"%f",roundedup);
    if ([[_txtAmount.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqual:@""]||[_btnPaymentMode.titleLabel.text isEqual:@""]||[_btnClass.titleLabel isEqual:@""]||[_btnRecurring.titleLabel.text isEqual:@""]|| roundedup==0.0)
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
    if (![self specialCharactersOccurence:_txtDiscription.text] || ![self specialCharactersOccurence:_txtHeading.text])
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



- (IBAction)takeCamrabtbClick:(id)sender
{
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc]init];
    imgPicker.delegate = self;
    imgPicker.navigationBar.barStyle = UIBarStyleBlackOpaque;
    UIImagePickerControllerSourceType sourceType =UIImagePickerControllerSourceTypeCamera;
    imgPicker.allowsEditing=YES;
    
    if([UIImagePickerController isSourceTypeAvailable: sourceType])
    {
        imgPicker.sourceType=sourceType;
        imgPicker.cameraCaptureMode=UIImagePickerControllerCameraCaptureModePhoto;
        [self presentViewController:imgPicker animated:YES completion:NULL];
    }
    else
    {
        [Utility showAlertWithMassager:self.navigationController.view :@"You don't have camera"];
    }
}



- (IBAction)gallaryImagebtnClick:(id)sender
{
    UIImagePickerController *imgPicker=[[UIImagePickerController alloc]init];
    imgPicker.delegate = self;
    imgPicker.navigationBar.barStyle = UIBarStyleBlackOpaque;
    UIImagePickerControllerSourceType sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
    imgPicker.allowsEditing=NO;
    if([UIImagePickerController isSourceTypeAvailable: sourceType])
    {
        imgPicker.sourceType=sourceType;
        [self presentViewController:imgPicker animated:YES completion:NULL];
    }
    else
    {
        [Utility showAlertWithMassager:self.navigationController.view :@"You don't have camera"];
    }
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[self dismissViewControllerAnimated:YES completion:NULL];
	if([[info valueForKey:@"UIImagePickerControllerMediaType"] isEqualToString:@"public.image"])
	{
        imageVw =[[UIImageView alloc] init];
        [imageVw setTag:10];
        [imageVw setFrame:self.customImageView.frame];
        [imageVw setUserInteractionEnabled:YES];
        imageVw.image=[info valueForKey:@"UIImagePickerControllerOriginalImage"];
        
        UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        imageButton.frame = CGRectMake(270, 0, 50, 35);
        [imageButton setImage:[UIImage imageNamed:@"cancel_button_budget.png"] forState:UIControlStateNormal];
        imageButton.adjustsImageWhenHighlighted = NO;
        [imageButton addTarget:self action:@selector(imageAction:) forControlEvents:UIControlEventTouchUpInside];
        [imageButton setBackgroundColor:[UIColor clearColor]];
        [imageVw addSubview:imageButton];
        UITapGestureRecognizer *oneTouch=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(OneTouchHandeler)];
        [oneTouch setNumberOfTouchesRequired:1];
        [imageVw addGestureRecognizer:oneTouch];
        [self.firstView addSubview:imageVw];
	}
}





-(void)OneTouchHandeler
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    ImageViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"ImageViewController"];
    [vc setImage:imageVw.image];
    [vc setString:[[NSString alloc] initWithString:NSLocalizedString(@"addReminder", nil)]];
    [self.navigationController  presentViewController:vc animated:YES completion:nil];
}


- (void)imageAction:(id)sender
{    imageVw.image=nil;
    [imageVw removeFromSuperview];
    [sender removeFromSuperview];
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
}




- (void)setUpDayHourPicker
{
    self.titlesDaysArray=[[NSMutableArray alloc] init];
    self.pickerViewDays.delegate = self;
    self.pickerViewDays.dataSource = self;
    self.pickerViewDays.tag=1;
    self.pickerViewDays.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.pickerViewDays.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    self.pickerViewDays.highlightedFont = [UIFont fontWithName:@"HelveticaNeue" size:20];
    self.pickerViewDays.interitemSpacing = 20.0;
    self.pickerViewDays.fisheyeFactor = 0.001;
    self.pickerViewDays.pickerViewStyle = AKPickerViewStyle3D;
    self.pickerViewDays.maskDisabled = false;
    for (int i=1; i<=31; i++)
    {
        [self.titlesDaysArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    [self.pickerViewDays reloadData];
    //-----------------
    self.titlesHoursArray=[[NSMutableArray alloc] init];
    self.pickerViewHours.delegate = self;
    self.pickerViewHours.dataSource = self;
    self.pickerViewHours.tag=2;
    self.pickerViewHours.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.pickerViewHours.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    self.pickerViewHours.highlightedFont = [UIFont fontWithName:@"HelveticaNeue" size:20];
    self.pickerViewHours.interitemSpacing = 20.0;
    self.pickerViewHours.fisheyeFactor = 0.001;
    self.pickerViewHours.pickerViewStyle = AKPickerViewStyle3D;
    self.pickerViewHours.maskDisabled = false;
    for (int i=1; i<=24; i++)
    {
        [self.titlesHoursArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    [self.pickerViewHours reloadData];
}

#pragma mark - AKPickerViewDataSource

- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView
{
    if (pickerView.tag==1)
    {
       return [self.titlesDaysArray count];
    }
    return [self.titlesHoursArray count];
}

/*
 * AKPickerView now support images!
 *
 * Please comment '-pickerView:titleForItem:' entirely
 * and uncomment '-pickerView:imageForItem:' to see how it works.
 *
 */

- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item
{
    if (pickerView.tag!=1)
    {
        return  self.titlesHoursArray[item];
    }
    return self.titlesDaysArray[item];
}

/*
 - (UIImage *)pickerView:(AKPickerView *)pickerView imageForItem:(NSInteger)item
 {
	return [UIImage imageNamed:self.titles[item]];
 }
 */

#pragma mark - AKPickerViewDelegate

- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item
{
    if (pickerView.tag!=1)
    {
currentSelectionHours=[self.titlesHoursArray[item] intValue];
        NSLog(@"%@", self.titlesHoursArray[item]);

    }else
    {
    currentSelectionDays=[self.titlesDaysArray[item] intValue];
        NSLog(@"%@", self.titlesDaysArray[item]);

    }
}


/*
 * Label Customization
 *
 * You can customize labels by their any properties (except font,)
 * and margin around text.
 * These methods are optional, and ignored when using images.
 *
 */


 - (void)pickerView:(AKPickerView *)pickerView configureLabel:(UILabel *const)label forItem:(NSInteger)item
 {
	label.textColor = [UIColor lightGrayColor];
	label.highlightedTextColor = GREEN_COLOR;
//	label.backgroundColor = [UIColor colorWithHue:(float)item/(float)self.titlesDaysArray.count
// saturation:1.0
// brightness:1.0
// alpha:1.0];
 }


/*
 - (CGSize)pickerView:(AKPickerView *)pickerView marginForItem:(NSInteger)item
 {
	return CGSizeMake(40, 20);
 }
 */

-(void)doneCancelNumberPadToolbarDelegate:(DoneCancelNumberPadToolbar *)controller didClickDone:(UITextField *)textField
{
    
    NSLog(@"%@", textField.text);
}


-(void)doneCancelNumberPadToolbarDelegate:(DoneCancelNumberPadToolbar *)controller didClickCancel:(UITextField *)textField
{
    [textField setText:@""];
    NSLog(@"Canceled: %@", [textField description]);
}


@end
