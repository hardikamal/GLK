
//
//  AddTransactionViewController.m
//  Daily Expense Manager
//
//  Created by Appbulous on 01/09/16.
//  Copyright (c) 2016 Jyoti Kumar. All rights reserved.
//

#import "AddTransactionViewController.h"
#import "UIAlertView+Block.h"
#import "CategoryListHandler.h"
#import "PaymentmodeHandler.h"
#import "TransactionHandler.h"
#import "UserInfoHandler.h"
#import "Utility.h"
#import "UserInfo.h"
#import "PaymentmodeHandler.h"
#import "Paymentmode.h"
//#import "AddAccountViewController.h"

#import "AutocompletionTableView.h"
#import <AddressBookUI/AddressBookUI.h>
#import <QuartzCore/QuartzCore.h>

#import "NumberPadDoneBtn.h"
#import "HomeViewController.h"
//#import "HistoryViewController.h"
#import "CategeyListViewController.h"
#import "PaymentModeViewController.h"
//#import "MBProgressHUD.h"

@interface AddTransactionViewController ()
{
    NSDictionary * infoCategery;
    NSDictionary * infoPayment;
    NSMutableArray *contactArray;
    UIImageView *imageVw;
}


@property (nonatomic, readwrite) BOOL addDone;
@property (nonatomic, readwrite) BOOL isSelected;
@property (nonatomic, strong) AutocompletionTableView *autoCompleter;
@end

@implementation AddTransactionViewController
@synthesize transaction;
@synthesize addDone,isSelected;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    
    }
    return self;
}
- (IBAction)clothingAction:(id)sender

{
    [[AppCommonFunctions sharedInstance] pushVCOfClass:[CategeyListViewController class] fromNC:self.navigationController animated:YES setRootViewController:NO modifyVC:^(CategeyListViewController* info) {
        switch ([self.segmentBtn selectedSegmentIndex])
        {
            case 0:
            {
                [info setIsExpenseSelected:0];
            }
                break;
            case 1:
                [info setIsExpenseSelected:1];

                break;
            default:
                break;
        }
        
    }];
}
- (IBAction)cashAction:(id)sender {
//    PaymentModeViewController *dest = (PaymentModeViewController *)[segue destinationViewController];
//    [dest setPaymentMode:transaction.paymentMode];
    [[AppCommonFunctions sharedInstance]pushVCOfClass:[PaymentModeViewController class] fromNC:[self navigationController] animated:YES setRootViewController:NO modifyVC:^(id info) {
    }];
    
}

-(void)timeDateConfigCurrent
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    NSDateComponents *compsm = [gregorian components:NSCalendarUnitMonth fromDate:[NSDate date]];
    NSDateComponents *compsy = [gregorian components:NSCalendarUnitYear fromDate:[NSDate date]];

    self.dayLabel.text=[[[[NSDateFormatter alloc] init] weekdaySymbols] objectAtIndex:[comps weekday]-1];
    self.monthDateLabel.text=[NSString stringWithFormat:@"%@, %ld",[[[[NSDateFormatter alloc] init] monthSymbols] objectAtIndex:[compsm month]-1],(long)[compsy year]];
    NSDateFormatter * formatter=[[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [formatter setDateFormat:@"dd/MM/yyyy hh:mma"];
    [formatter setDateFormat:@"hh:mma"];
    self.timeLabel.text=[[formatter stringFromDate:[NSDate date]]substringToIndex:5];
    self.primeTimeLabel.text=[NSDate stringFromDate:[NSDate date] withFormat:@"a"];
    
}
- (void)viewDidLoad
{
      [super viewDidLoad];
      [self timeDateConfigCurrent];
      [self.btnExpense setSelected:YES];
      [self getAllContacts];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedCategeryListNotification:) name:@"CategeryList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedPaymentModeNotification:) name:@"PaymentMode" object:nil];
    
    if (transaction.managedObjectContext == nil)
    {
        [self addNewTransaction];
    }else
    {
        [self addUpdateTransacton];
    }
    
}


-(void)viewWillAppear:(BOOL)animated
{
    
    if ([self.moreDetailsView isHidden])
    {
        self.scrollView.contentSize=CGSizeMake(320, 320);
    }else
    {
        self.scrollView.contentSize=CGSizeMake(320, 630);
    }
    
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
                [self.btnCategery setHidden:NO];
                [self.buttonUnhideCategery setHidden:YES];
                [self.lblSabCatagery setText:transaction.sub_category];
                [self.btnCategery setTitle:transaction.category forState:UIControlStateNormal];
            }else
            {
                [self.buttonUnhideCategery setTitle:transaction.category forState:UIControlStateNormal];
                [self.btnCategery setHidden:YES];
                [self.buttonUnhideCategery setHidden:NO];
                [self.lblSabCatagery setText:@""];
            }
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
            if ([paymentModeArray count]!=0)
            {
                NSDictionary * paymentInfo =[paymentModeArray objectAtIndex:0];
                [self.btnPaymentMode setTitle:[paymentInfo objectForKey:@"paymentMode"] forState:UIControlStateNormal];
                [self.imgPaymentmode setImage:[UIImage imageWithData:[paymentInfo objectForKey:@"paymentmode_icon"]]];
            }
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



-(void)addNewTransaction
{
    NSArray *UserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsWithUserName:[Utility userDefaultsForKey:CURRENT_USER__TOKEN_ID]];
    [self.segmentBtn setSelectedSegmentIndex:1];

    if ([UserInfoarrray count]!=0)
    {
    }else
    {
        NSArray *UserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsToUserRegisterTable];
   
    }
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
    
    [self.lblTime setText:[[[formatter stringFromDate:[NSDate date]] componentsSeparatedByString:@" "]  objectAtIndex:0]];
    [self.lblPmorAm setText:[[[[formatter stringFromDate:[NSDate date]] componentsSeparatedByString:@" "]  objectAtIndex:1] uppercaseString]];
    
    NSString *mainToken=[Utility userDefaultsForKey:MAIN_TOKEN_ID];
    NSString *currency= [Utility  userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",CURRENT_CURRENCY,mainToken]];
    [self.lblCarrency setText:[[currency componentsSeparatedByString:@"-"] objectAtIndex:1]];

}




-(void)addUpdateTransacton
{
    NSString *mainToken=[Utility userDefaultsForKey:MAIN_TOKEN_ID];
    NSString *currency= [Utility  userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",CURRENT_CURRENCY,mainToken]];
    [self.lblCarrency setText:[NSString stringWithFormat:@"%@",[[currency componentsSeparatedByString:@"-"] objectAtIndex:1]]];
    NSNumber *myDoubleNumber = [NSNumber numberWithDouble:[transaction.amount doubleValue]];
    [self.txtAmount setText:[myDoubleNumber stringValue]];
    self.title = NSLocalizedString(@"editTransaction", nil);
    NSArray *UserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsWithUserTokenid:transaction.user_token_id];
    if ([UserInfoarrray count]!=0)
    {
  //   [self addAccountName:UserInfoarrray];
    }
    NSString *nDate=[transaction.date stringValue];
    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:([nDate doubleValue] / 1000)];
    [self.dobPicker setDate:currentDate animated:YES];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    //;
    
    NSDateComponents* components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay fromDate:currentDate];
    
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
    
    [self.lblTime setText:[[[formatter stringFromDate:currentDate] componentsSeparatedByString:@" "]  objectAtIndex:0]];
    [self.lblPmorAm setText:[[[[formatter stringFromDate:currentDate] componentsSeparatedByString:@" "]  objectAtIndex:1] uppercaseString]];
    if ([transaction.transaction_type isEqualToNumber:[NSNumber numberWithInt:TYPE_EXPENSE]])
    {
        [self.segmentBtn setSelectedSegmentIndex:1];
    }else
    {
        [self.segmentBtn setSelectedSegmentIndex:0];
    }
    if (transaction.pic != nil || ![transaction.warranty.stringValue isEqualToString:@"0"] || [transaction.with_person length]!=0 || [transaction.discription length]!=0 ||[transaction.with_person length]!=0 )
    {
        [self.btnAddmoreDetails setImage:[UIImage imageNamed:@"downward_button.png"] forState:UIControlStateNormal];
        [self.moreDetailsView setHidden:NO];
         self.scrollView.contentSize=CGSizeMake(320, 625);
     
    }else
    {  [self.btnAddmoreDetails setImage:[UIImage imageNamed:@"downward_button.png"] forState:UIControlStateNormal];
        [self.moreDetailsView setHidden:YES];
        self.scrollView.contentSize=CGSizeMake(320, 520);
    }
    
    if ([transaction.transaction_type isEqualToNumber:[NSNumber numberWithInt:TYPE_EXPENSE]])
    {
            [self.btnExpense setSelected:YES];
            [self.btnIncome setSelected:NO];
            [self.btnExpense setBackgroundColor:[UIColor colorWithRed:13/255.0 green:198/255.0 blue:170/255.0 alpha:1.0f]];
            [self.btnIncome setBackgroundColor:[UIColor colorWithRed:186/255.0 green:239/255.0 blue:228/255.0 alpha:1.0f]];
    }else
    {
        [self.btnIncome setSelected:YES];
        [self.btnExpense setBackgroundColor:[UIColor colorWithRed:186/255.0f green:239/255.0f blue:228/255.0f alpha:1.0f]];
        [self.btnIncome setBackgroundColor:[UIColor colorWithRed:13/255.0f green:198/255.0f blue:170/255.0f alpha:1.0f]];
        [self.btnExpense setSelected:NO];
    }
    if (transaction.pic != nil)
    {
         imageVw =[[UIImageView alloc] init];
        [imageVw setTag:10];
        [imageVw setFrame:self.imgView.frame];
        [imageVw setUserInteractionEnabled:YES];
        [imageVw setImage:[UIImage imageWithData:transaction.pic]];
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
        [self.moreDetailsView addSubview:imageVw];
    }
    
    if ([transaction.discription length]!=0)
        [self.txtDescription setText:transaction.discription];
    
    if ([transaction.location length]!=0)
        [ self.txtEnterLocation setText:transaction.location];
    
    if ([transaction.with_person length]!=0)
        [ self.txtTagaPerson setText:transaction.with_person];

    if (![transaction.warranty.stringValue isEqualToString:@"0"] )
    {
        NSString *nDate=[transaction.warranty stringValue];
        NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:([nDate doubleValue] / 1000)];
        [self updateWarratyDate:endDate];
    }
}



-(void)updateWarratyDate:(NSDate*)endDate
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
      [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSString *nDate=[transaction.date stringValue];
    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:([nDate doubleValue] / 1000)];
    
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *componentsForReferenceDate= [calendar components:(NSDayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit|NSWeekCalendarUnit ) fromDate:currentDate];
    [componentsForReferenceDate setHour:0];
    [componentsForReferenceDate setMinute:0];
    [componentsForReferenceDate setSecond:0] ;
    
    NSDate  *startDate = [calendar dateFromComponents:componentsForReferenceDate] ;
    NSUInteger units = NSYearCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit;
    NSDateComponents *components = [calendar components:units fromDate:startDate toDate:endDate options:0];
    NSInteger years = [components year];
    NSInteger months = [components month];
    NSInteger days = [components day];
    if (years!=0)
    {
        [_txtwarranty setText:[NSString stringWithFormat:@"%li",(long)years]];
        [_btnWarranty setTitle:NSLocalizedString(@"years", nil) forState:UIControlStateNormal];
        [self.lblExpiryDate setText:[dateFormatter stringFromDate:endDate]];
        
    }else if (months!=0)
    {
        [_txtwarranty setText:[NSString stringWithFormat:@"%li",(long)months]];
        [_btnWarranty setTitle:NSLocalizedString(@"months", nil) forState:UIControlStateNormal];
        [self.lblExpiryDate setText:[dateFormatter stringFromDate:endDate]];
    }else if (days!=0)
    {
        [_txtwarranty setText:[NSString stringWithFormat:@"%li",(long)days]];
        [_btnWarranty setTitle:NSLocalizedString(@"days", nil) forState:UIControlStateNormal];
        [self.lblExpiryDate setText:[dateFormatter stringFromDate:endDate]];
    }
}



-(void)doneCancelNumberPadToolbarDelegate:(DoneCancelNumberPadToolbar *)controller didClickDone:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField==_txtwarranty )
    {
        if (self.view.frame.size.height >500 ) {
            [UIView animateWithDuration:0.3 animations:^{
                [_scrollView setContentOffset:CGPointMake(0,160) animated:YES];
            }];
        }else
            [UIView animateWithDuration:0.3 animations:^{
                [_scrollView setContentOffset:CGPointMake(0,260) animated:YES];
            }];
    }
}


-(void)doneCancelNumberPadToolbarDelegate:(DoneCancelNumberPadToolbar *)controller didClickCancel:(UITextField *)textField
{
     textField.text=@"";
    [textField resignFirstResponder];
}


- (AutocompletionTableView *)autoCompleter
{
    if (!_autoCompleter)
    {
        NSMutableDictionary *options = [NSMutableDictionary dictionaryWithCapacity:2];
        [options setValue:[NSNumber numberWithBool:YES] forKey:ACOCaseSensitive];
        [options setValue:nil forKey:ACOUseSourceFont];
        _autoCompleter = [[AutocompletionTableView alloc] initWithTextField:self.txtTagaPerson inViewController:self withOptions:options];
        _autoCompleter.autoCompleteDelegate = self;
        _autoCompleter.suggestionsDictionary = [NSArray arrayWithObjects:@"hostel",@"caret",@"carrot",@"house",@"horse", nil];
    }
    return _autoCompleter;
}


#pragma mark - AutoCompleteTableViewDelegate

- (NSArray*) autoCompletion:(AutocompletionTableView*) completer suggestionsFor:(NSString*) string
{
    // with the prodided string, build a new array with suggestions - from DB, from a service, etc.
    return contactArray;
}

- (void) autoCompletion:(AutocompletionTableView*) completer didSelectAutoCompleteSuggestionWithIndex:(NSInteger) index{
    // invoked when an available suggestion is selected
    NSLog(@"%@ - Suggestion chosen: %ld", completer, (long)index);
}


-(void)getAllContacts
{
   /*
    CFErrorRef *error = nil;
    
    contactArray = [NSMutableArray array];
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    
    __block BOOL accessGranted = NO;
    if (ABAddressBookRequestAccessWithCompletion != NULL) { // we're on iOS 6
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
    }
    else { // we're on iOS 5 or older
        accessGranted = YES;
    }
    
    if (accessGranted)
    {
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
        ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, kABPersonSortByFirstName);
        CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
        for (int i = 0; i < nPeople; i++)
        {
            NSString *firstName ;
            NSString *lastName;
              ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
            (__bridge_transfer NSString *)ABRecordCopyValue(person,
                                                            kABPersonFirstNameProperty);
            
            if ([(__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty) length]==0)
            {
                firstName=@"";
            }else
            {
                 firstName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
            }
            
            if ([(__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty) length]==0)
            {
                lastName=@"";
            }else
            {
                lastName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
            }

            NSLog(@"FirstName ::%@ LastName ::%@",firstName,lastName);
            [contactArray addObject:[NSString stringWithFormat:@"%@ %@",firstName,lastName]];
        }
       
    }
    */
}




- (IBAction)addingTransactionToDBbtnClick:(id)sender
{
    if ([self CheckTransactionValidity])
    {
        NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
        NSString *mainToken=[Utility userDefaultsForKey:MAIN_TOKEN_ID];
        NSString *currency= [Utility  userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",CURRENT_CURRENCY,mainToken]];
        [dictionary setObject:currency forKey:@"currency"];
        
        NSArray *UserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsWithUserName:self.btnUserName.titleLabel.text];
        if ([UserInfoarrray count]!=0)
        {
            UserInfo *userInfo =[UserInfoarrray objectAtIndex:0];
            [dictionary setObject:userInfo.user_token_id forKey:@"user_token_id"];
        }
        
        [dictionary setObject:_txtAmount.text forKey:@"amount"];
        [dictionary setObject:_txtDescription.text forKey:@"discription"];
        
        NSArray *arrry =[_lblMonthYear.text componentsSeparatedByString:@" "];
        
        [dictionary setObject:[NSString stringWithFormat:@"%@ %@",[NSString stringWithFormat:@"%@/%@/%@",_lblDay.text,[arrry objectAtIndex:0],[arrry objectAtIndex:1]],[NSString stringWithFormat:@"%@:%@ %@",_lblTime.text,@"00",[_lblPmorAm.text lowercaseString]]] forKey:@"date"];
        
        
        if ([_lblSabCatagery.text length]==0)
        {
            [dictionary setObject:_buttonUnhideCategery.titleLabel.text forKey:@"category"];
        }else
            [dictionary setObject:_btnCategery.titleLabel.text forKey:@"category"];
        
        [dictionary setObject:_lblSabCatagery.text forKey:@"sub_category"];
        [dictionary setObject:_txtEnterLocation.text forKey:@"location"];
        [dictionary setObject:_txtTagaPerson.text forKey:@"with_person"];
        [dictionary setObject:_btnPaymentMode.titleLabel.text forKey:@"paymentMode"];
        [dictionary setObject:@"0" forKey:@"transaction_reference_id"];
        UIImageView* imageView=(UIImageView *)[self.moreDetailsView viewWithTag:10];
        if (imageView.image!=nil)
            [dictionary setObject:imageView.image forKey:@"pic"];
        
        [dictionary setObject:[NSNumber numberWithInt:0] forKey:@"shown_on_homescreen"];
        
        if ([_lblExpiryDate.text isEqualToString:@"Expiry Date"])
        {
            [dictionary setObject:[NSNumber numberWithInt:0] forKey:@"transaction_inserted_from"];
            [dictionary setObject:@"" forKey:@"Waranty"];
        }else
        {
            NSArray *array=[_lblExpiryDate.text componentsSeparatedByString:@"-"];
            NSString *string=[NSString stringWithFormat:@"%@/%@/%@",[array objectAtIndex:1],[array objectAtIndex:0],[array objectAtIndex:2]];
            [dictionary setObject:string forKey:@"Waranty"];
            [dictionary setObject:[NSNumber numberWithInt:TYPE_WARRANTY] forKey:@"transaction_inserted_from"];
        }
        
        if ([self.segmentBtn selectedSegmentIndex]==1)
        {
            [dictionary setObject:[NSNumber numberWithInt:TYPE_INCOME] forKey:@"transaction_type"];
        }else
            [dictionary setObject:[NSNumber numberWithInt:TYPE_EXPENSE] forKey:@"transaction_type"];
        
        
        if (transaction.managedObjectContext == nil)
        {
            [[TransactionHandler sharedCoreDataController] insertDataIntoTransactionTable:dictionary];
            [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"transactionaddedSuccessfully", nil)];
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            [[TransactionHandler sharedCoreDataController] updateDataIntoTransactionTable:dictionary :transaction ];
            [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"transactionsUpdatedSuccessfully", nil)];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


- (BOOL)backViewController
{
    for (UIViewController * viewController in [self.navigationController viewControllers])
    {
//        if ([viewController isKindOfClass:[HistoryViewController class]])
//        {
//            return  YES;
//        }
        
    }
    return NO;
}


-(BOOL)CheckTransactionValidity
{
    float otherfloat=[_txtAmount.text floatValue];
    float roundedup = ceil(otherfloat);
    NSLog(@"%@",_btnPaymentMode.titleLabel.text);
    if ([[_txtAmount.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqual:@""]||[_btnPaymentMode.titleLabel.text isEqual:@""]||[_lblTime isEqual:@""]|| roundedup==0.0)
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
    if (![self specialCharactersOccurence:_txtDescription.text] || ![self specialCharactersOccurence:_txtTagaPerson.text] || ![self specialCharactersOccurence:_txtEnterLocation.text])
    {
         return NO;
    
    }if ([_txtwarranty.text isEqualToString:@"0"])
    {
        [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"enterwarranty", nil)];
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


- (IBAction)galarybtnClick:(id)sender
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


- (IBAction)camrabtnClick:(id)sender
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



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:NULL];
	if([[info valueForKey:@"UIImagePickerControllerMediaType"] isEqualToString:@"public.image"])
	{
        imageVw =[[UIImageView alloc] init];
        [imageVw setTag:10];
        [imageVw setFrame:self.imgView.frame];
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
        [self.moreDetailsView addSubview:imageVw];
	}
}




-(void)OneTouchHandeler
{
    [[AppCommonFunctions sharedInstance]showImage:imageVw.image fromView:[self view]];
}



- (void)imageAction:(id)sender
{
    UIImageView* image=(UIImageView *)[self.moreDetailsView viewWithTag:10];
    image.image=nil;
    [image removeFromSuperview];
    [sender removeFromSuperview];
}

-(void) receivedCategeryListNotification:(NSNotification*) notification
{
       infoCategery =notification.userInfo;
}

-(void)receivedPaymentModeNotification:(NSNotification*) notification
{
    infoPayment =notification.userInfo;
}



-(void) receivedNotification:(NSNotification*) notification
{
    NSDictionary * info =notification.userInfo;
    if ([[info objectForKey:@"tag"] intValue]==2)
    {
//        [self.btnWarranty setTitle:[info objectForKey:@"object"] forState:UIControlStateNormal];
//        if (![self.txtwarranty.text isEqualToString:@""])
//            [self textFieldDidChange:self.txtwarranty];
    }
    if ([[info objectForKey:@"tag"] intValue]==1)
    {
        
        if ([[info objectForKey:@"object"] isEqualToString:NSLocalizedString(@"addAccount", nil)])
        {
//            AddAccountViewController *catageryController=[self.storyboard instantiateViewControllerWithIdentifier:@"AddAccountViewController"];
//            [self.navigationController pushViewController:catageryController animated:YES];
            
        }else
        {  [self.btnUserName setTitle:[info objectForKey:@"object"] forState:UIControlStateNormal];
            NSArray *UserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsWithUserName:[info objectForKey:@"object"]];
            if ([UserInfoarrray count]!=0)
            {
                [Utility saveToUserDefaults:[info objectForKey:@"object"]  withKey:CURRENT_USER__TOKEN_ID];
            }
        }
    }
}


- (IBAction)backbtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)addMoreDetailsClick:(id)sender
{
    if ([self.moreDetailsView isHidden])
    {
        [sender setImage:[UIImage imageNamed:@"downward_button.png"] forState:UIControlStateNormal];
        [self.moreDetailsView setHidden:NO];
        
        if (self.view.frame.size.height>500 )
        {
           [self.scrollView setContentOffset:CGPointMake(0,170) animated:YES];
        }else
           [self.scrollView setContentOffset:CGPointMake(0,250) animated:YES];
        
        self.scrollView.contentSize=CGSizeMake(320, 620);
    }else
    {
        [self.moreDetailsView setHidden:YES];
         self.scrollView.contentSize=CGSizeMake(320, 420);
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [sender setImage:[UIImage imageNamed:@"downward_button.png"] forState:UIControlStateNormal];
    }
}


-(void)textFieldDidChange :(UITextField *)theTextField
{
    NSString *combined = [NSString stringWithFormat:@"%@-%@-%@",[[self.lblMonthYear.text componentsSeparatedByString:@" "] objectAtIndex:0],self.lblDay.text ,[[self.lblMonthYear.text componentsSeparatedByString:@" "] objectAtIndex:1]];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init] ;
    [fmt setDateFormat:@"MM-dd-yyyy"];
    NSDate *originalDate=[fmt dateFromString:combined];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    if ([self.btnWarranty.titleLabel.text isEqualToString:NSLocalizedString(@"days", nil)])
    {
        NSRange monthDays = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:originalDate];
        if ([theTextField.text intValue]>monthDays.length)
        {
        [Utility showAlertWithMassager:self.navigationController.view :[NSString stringWithFormat:@"%@ %lu",NSLocalizedString(@"numberofdays", nil),(unsigned long)monthDays.length]];
            [dateComponents setDay:monthDays.length];
            [theTextField setText:@""];
        }else
        {
            [dateComponents setDay:[theTextField.text intValue]];
        }
        NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:originalDate options:0];
        [self.lblExpiryDate setText:[fmt stringFromDate:newDate]];
    }else if ([self.btnWarranty.titleLabel.text isEqualToString:NSLocalizedString(@"months", nil)])
    {
        if ([theTextField.text intValue]>12)
        {
            [Utility showAlertWithMassager:self.navigationController.view :[NSString stringWithFormat:@"%@ %d",NSLocalizedString(@"numberofmonths", nil),12]];
            [dateComponents setDay:12];
            [theTextField setText:@""];
        }else
        {
            [dateComponents setMonth:[theTextField.text intValue]];
        }
        NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:originalDate options:0];
        [self.lblExpiryDate setText:[fmt stringFromDate:newDate]];
        
    }else if ([self.btnWarranty.titleLabel.text  isEqualToString:NSLocalizedString(@"years", nil)])
    {
        [dateComponents setYear:[theTextField.text intValue]];
        NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:originalDate options:0];
        [self.lblExpiryDate setText:[fmt stringFromDate:newDate]];
    }
}



-(void)UpdateExpireDate
{
    NSString *combined = [NSString stringWithFormat:@"%@-%@-%@",[[self.lblMonthYear.text componentsSeparatedByString:@" "] objectAtIndex:0],self.lblDay.text,[[self.lblMonthYear.text componentsSeparatedByString:@" "] objectAtIndex:1]];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init] ;
    [fmt setDateFormat:@"MM-dd-yyyy"];
    NSDate *originalDate=[fmt dateFromString:combined];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    if ([self.btnWarranty.titleLabel.text isEqualToString:NSLocalizedString(@"days", nil)])
    {
        [dateComponents setDay:[self.txtwarranty.text intValue]];
        NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:originalDate options:0];
        [self.lblExpiryDate setText:[fmt stringFromDate:newDate]];
        
    }else if ([self.btnWarranty.titleLabel.text isEqualToString:NSLocalizedString(@"months", nil)])
    {
        [dateComponents setMonth:[self.txtwarranty.text intValue]];
        NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:originalDate options:0];
        [self.lblExpiryDate setText:[fmt stringFromDate:newDate]];
        
    }else if ([self.btnWarranty.titleLabel.text  isEqualToString:NSLocalizedString(@"years", nil)])
    {
        [dateComponents setYear:[self.txtwarranty.text intValue]];
        NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:originalDate options:0];
        [self.lblExpiryDate setText:[fmt stringFromDate:newDate]];
    }
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
        self.timeLabel.text=[[formatter stringFromDate:selectedDate]substringToIndex:5];
        self.primeTimeLabel.text=[NSDate stringFromDate:selectedDate withFormat:@"a"];
        
    } cancelBlock:^(ActionSheetDatePicker *picker) {
        
    } origin:[self view]];
}




-(IBAction)datePickerbtnClick:(id)sender{
    RESIGN_KEYBOARD
    [ActionSheetDatePicker showPickerWithTitle : @"Select date" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] doneBlock:^(ActionSheetDatePicker *picker, NSDate* selectedDate, id origin) {
        self.dayLabel.text=[[[[NSDateFormatter alloc] init] weekdaySymbols] objectAtIndex:selectedDate.weekday-1];
        self.monthDateLabel.text=[NSString stringWithFormat:@"%@, %ld",[[[[NSDateFormatter alloc] init] monthSymbols] objectAtIndex:selectedDate.month-1],(long)selectedDate.year];
    } cancelBlock:^(ActionSheetDatePicker *picker) {
    } origin:[self view]];
    
    
   
}

- (IBAction)cancelDobPickerClick:(id)sender
{
    [self animateView:self.dobView xCoordinate:0 yCoordinate:0];
}


- (IBAction)doneDobPickerClick:(id)sender
{
    [self animateView:self.dobView xCoordinate:0 yCoordinate:0];
	NSDate *myDate = self.dobPicker.date;
    NSString *string=nil;
	if (isSelected)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"hh:mm a"];
        string=[formatter stringFromDate:myDate];
        isSelected=NO;
        [self.lblTime setText:[[[formatter stringFromDate:myDate] componentsSeparatedByString:@" "]  objectAtIndex:0]];
        [self.lblPmorAm setText:[[[[formatter stringFromDate:myDate] componentsSeparatedByString:@" "]  objectAtIndex:1] uppercaseString]];
    }else
    {
        NSDate *currentDate = myDate;
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [calendar components:NSCalederUnit fromDate:currentDate];
        [self.lblDay setText:[NSString stringWithFormat:@"%li",(long)[components day]]];
        NSString *combined;
        if ([components month]<10)
        {
            combined = [NSString stringWithFormat:@"0%li %li",(long)[components month] ,(long)[components year]];
        }else
            combined = [NSString stringWithFormat:@"%li %li",(long)[components month] ,(long)[components year]];
        
        [self.lblMonthYear setText:combined];
    }
    if ([_txtwarranty.text length]!=0)
    {
         [self UpdateExpireDate];
    }
}


- (IBAction)incomebtnClick:(id)sender
{
    [sender setSelected:YES];
    [self.btnExpense setBackgroundColor:[UIColor colorWithRed:186/255.0f green:239/255.0f blue:228/255.0f alpha:1.0f]];
    [sender setBackgroundColor:[UIColor colorWithRed:13/255.0f green:198/255.0f blue:170/255.0f alpha:1.0f]];
    [self.btnExpense setSelected:NO];
    [self.view reloadInputViews];
}



- (IBAction)warrantybtnClick:(id)sender
{
    [UIActionSheet showInView:self.view withTitle:nil cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:[NSArray arrayWithObjects:NSLocalizedString(@"years", nil),NSLocalizedString(@"months", nil),NSLocalizedString(@"days", nil), nil] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        if (![[actionSheet buttonTitleAtIndex:buttonIndex]isEqualToString:@"Cancel"])
        {
            [self.btnWarranty setTitle:[actionSheet buttonTitleAtIndex:buttonIndex] forState:UIControlStateNormal];
            if (![self.txtwarranty.text isEqualToString:@""])
                [self textFieldDidChange:self.txtwarranty];
        }
        
        
    }];
}


- (IBAction)expensebtnClick:(id)sender
{
    [sender setSelected:YES];
    [self.btnIncome setSelected:NO];
    [sender setBackgroundColor:[UIColor colorWithRed:13/255.0 green:198/255.0 blue:170/255.0 alpha:1.0f]];
    [self.btnIncome setBackgroundColor:[UIColor colorWithRed:186/255.0 green:239/255.0 blue:228/255.0 alpha:1.0f]];
    [self.view reloadInputViews];
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField.text length]>0)
    {
        self.saveBarBtn.enabled=1;
    }
    else
    {
        self.saveBarBtn.enabled=0;

    }
    if ([textField.text length]==1&&string.length==0)
    {
        self.saveBarBtn.enabled=0;

    }
    if (string.length>0)
    {
        self.saveBarBtn.enabled=1;
 
    }
    if (textField==self.txtAmount)
    {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSArray  *arrayOfString = [newString componentsSeparatedByString:@"."];
        
        if ([arrayOfString count] > 2 )
            return NO;
    }
    if (textField==self.txtwarranty)
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 2) ? NO : YES;
    }
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateView:self.dobView xCoordinate:0 yCoordinate:0];
    if (textField==_txtEnterLocation)
    {
        if (self.view.frame.size.height >500 )
        {
            [UIView animateWithDuration:0.3 animations:^{
                [_scrollView setContentOffset:CGPointMake(0,235) animated:YES];
            }];
        }else
            [UIView animateWithDuration:0.3 animations:^{
                [_scrollView setContentOffset:CGPointMake(0,320) animated:YES];
            }];
    }
    if (textField==_txtTagaPerson)
    {
        if (self.view.frame.size.height >500 )
        {
            [UIView animateWithDuration:0.3 animations:^{
                [_scrollView setContentOffset:CGPointMake(0,285) animated:YES];
            }];
            
        }else
            [UIView animateWithDuration:0.3 animations:^{
                [_scrollView setContentOffset:CGPointMake(0,370) animated:YES];
            }];
    }
    
    if (textField==_txtwarranty)
    {
        if (self.view.frame.size.height >500 )
        {
            [UIView animateWithDuration:0.3 animations:^{
                [_scrollView setContentOffset:CGPointMake(0,395) animated:YES];
            }];
            
        }else
            [UIView animateWithDuration:0.3 animations:^{
                [_scrollView setContentOffset:CGPointMake(0,480) animated:YES];
            }];
    }
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==_txtEnterLocation || textField==_txtTagaPerson || textField==_txtwarranty )
    {
        if (self.view.frame.size.height >500 ) {
            [UIView animateWithDuration:0.3 animations:^{
                [_scrollView setContentOffset:CGPointMake(0,160) animated:YES];
            }];
        }else
            [UIView animateWithDuration:0.3 animations:^{
                [_scrollView setContentOffset:CGPointMake(0,260) animated:YES];
            }];
    }
    [textField resignFirstResponder];
    return YES;
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



- (IBAction)btnUserNameClick:(id)sender
{
    [self.txtAmount resignFirstResponder];
    [self.txtDescription resignFirstResponder];
    [self.txtEnterLocation resignFirstResponder];
    [self.txtTagaPerson resignFirstResponder];
    [self.txtwarranty resignFirstResponder];
    [self animateView:self.dobView xCoordinate:0 yCoordinate:0];
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
    [poplistview setNotificationName:@"AddAccountViewController"];
    [poplistview setListArray:userInfoList];
    if (yHeight<300)
    {
        poplistview.listView.scrollEnabled = FALSE;
    }
    [poplistview show];
}


//-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if (transaction.managedObjectContext != nil)
//    {
//        if ([[segue identifier] isEqualToString:@"AddCategory"])
//        {
//            CategeyListViewController *dest = (CategeyListViewController *)[segue destinationViewController];
//            [dest setSelectedCategery:transaction.category];
//            [dest setSelectedSubCategery:transaction.sub_category];
//        } else  if ([[segue identifier] isEqualToString:@"AddPaymentMode"])
//        {
//            PaymentModeViewController *dest = (PaymentModeViewController *)[segue destinationViewController];
//            [dest setPaymentMode:transaction.paymentMode];
//        }
//    }
//
//}



- (IBAction)indexChanged:(id)sender
{
    for (int i=0; i<[self.segmentBtn.subviews count]; i++)
    {
        for (UIControl *subview in self.segmentBtn.subviews)
        {
            subview.backgroundColor = [subview isSelected] ? GREEN_COLOR : nil;
        }
    }
}


@end
