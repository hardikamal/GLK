//
//  AddCatageryListViewController.m
//  Daily Expense Manager
//
//  Created by Appbulous on 08/09/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import "AddCatageryListViewController.h"
#import "CategoryListHandler.h"
#import "UIPopoverListView.h"
#import "CategoryList.h"
#import "UIAlertView+Block.h"
#import "CategoryListHandler.h"
#import "CategeyListViewController.h"

@interface AddCatageryListViewController ()
{
    NSDictionary * infoCategery;
    NSDictionary * infoPayment;
      BOOL alarm;
       int number;
}


@end

@implementation AddCatageryListViewController

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
     self.catageryList=[[NSMutableArray alloc] init];
    [self addDefaultCategoryList];
    [self setTitle:NSLocalizedString(@"addCategory", nil)];
    
    if (self.catgery.managedObjectContext != nil)
    {
        [self.radiobuttonsView setUserInteractionEnabled:NO];
        [self setTitle:NSLocalizedString(@"editCategory", nil)];
        
        if (!self.chekCatgeryOrSubCategry)
        {
            [self.txtCategery setText:self.catgery.category];
            [self mainCategorybtnClick:nil];
            [self.imgSelectCategery setImage:[UIImage imageWithData:self.catgery.category_icon]];
            [self.btnCategery setTitle:self.catgery.category forState:UIControlStateNormal];
            
            if ([self.catgery.hide_status intValue])
            {
                [self.btnHidestatus setOn:YES animated:YES];
                  alarm=YES;
            }else
            {
                [self.btnHidestatus setOn:NO animated:YES];
                  alarm=NO;
            }
            
        }else
        {
            [self subCategorybtnClick:nil];
            [self.txtCategery setText:self.catgery.sub_category];
            [self.btnSubCategary setTitle:self.catgery.category forState:UIControlStateNormal];
        }
        if ([self.catgery.class_type integerValue])
        {
            [_imgIncome setImage:[UIImage imageNamed:@"radial_button_active.png"]];
            [_imgExpense setImage:[UIImage imageNamed:@"radial_button.png"]];
        }
    }else
    {
        if (self.chekforIncomeorExpense)
        {
            [_imgExpense setImage:[UIImage imageNamed:@"radial_button_active.png"]];
            [_imgIncome setImage:[UIImage imageNamed:@"radial_button.png"]];
            number=0;
        }else
        {
            [_imgIncome setImage:[UIImage imageNamed:@"radial_button_active.png"]];
            [_imgMainCategory setImage:[UIImage imageNamed:@"radial_button.png"]];
            number=1;
        }
        alarm=NO;
        [self.radiobuttonsView setUserInteractionEnabled:YES];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotification:) name:@"AddCatageryListViewController" object:nil];
    
    
    [_txtCategery becomeFirstResponder];
}
-(void)viewWillAppear:(BOOL)animated
{
    
   
    
    if ([infoCategery count] != 0)
    {
       // [self.lblSabCatagery setHidden:YES];
        NSArray *arrray=[[infoCategery objectForKey:@"name"] componentsSeparatedByString:@","];
        if ([arrray count]==2)
        {
            [self.lblSubCategery setHidden:NO];
            [self.btnCategery setHidden:NO];
            //[self.buttonUnhideCategery setHidden:YES];
            [self.lblSubCategery setText:[arrray objectAtIndex:1]];
            [self.btnCategery setTitle:[arrray objectAtIndex:0] forState:UIControlStateNormal];
        }else
        {
            [self.btnCategery setHidden:YES];
            [self.lblSubCategery setText:[arrray objectAtIndex:0]];
        }
        [(UIImageView*)[self.view viewWithTag:10] setImage:[infoCategery objectForKey:@"image"]];
        //[self.imgCategery setImage:[infoCategery objectForKey:@"image"]];
    }else
    {
//        if (transaction.managedObjectContext != nil)
//        {
//            NSArray *categeryArray=[[CategoryListHandler sharedCoreDataController] getsearchCategeryWithAttributeName:@"category_icon" andSearchText:transaction.category];
//            self.imgCategery.image=[UIImage imageWithData:[[categeryArray objectAtIndex:0] objectForKey:@"category_icon"]];
//            if (![transaction.sub_category isEqualToString:@""])
//            {
//                [self.lblSabCatagery setHidden:NO];
//                [self.btnCategery setHidden:NO];
//                [self.buttonUnhideCategery setHidden:YES];
//                [self.lblSabCatagery setText:transaction.sub_category];
//                [self.btnCategery setTitle:transaction.category forState:UIControlStateNormal];
//            }else
//            {
//                [self.buttonUnhideCategery setTitle:transaction.category forState:UIControlStateNormal];
//                [self.btnCategery setHidden:YES];
//                [self.buttonUnhideCategery setHidden:NO];
//                [self.lblSabCatagery setText:@""];
//            }
//        }else
//        {
//            NSArray *categeryIcon=[[CategoryListHandler sharedCoreDataController] getCategeryList:[NSString stringWithFormat:@"%d",TYPE_EXPENSE]];
//            if ([categeryIcon count]==0)
//            {
//                [self.buttonUnhideCategery setTitle:NSLocalizedString(@"noCategory", nil) forState:UIControlStateNormal];
//                [self.imgCategery setImage:[UIImage imageNamed:@"Miscellaneous_icon.png"]];
//            }else
//            {
//                CategoryList *list=(CategoryList*)[categeryIcon objectAtIndex:0];
//                [self.buttonUnhideCategery setTitle:list.category forState:UIControlStateNormal];
//                [self.imgCategery setImage:[UIImage imageWithData:list.category_icon]];
//            }
//        }
    }
//    if ([infoPayment count] != 0)
//    {
//        [self.btnPaymentMode setTitle:[infoPayment objectForKey:@"name"] forState:UIControlStateNormal];
//        [self.imgPaymentmode setImage:[infoPayment objectForKey:@"image"]];
//    }else
//    {
//        if (transaction.managedObjectContext != nil)
//        {
//            NSString *paymentMode=transaction.paymentMode;
//            NSArray *paymentModeArray=[[PaymentmodeHandler sharedCoreDataController] getsearchPaymentWithAttributeName:paymentMode];
//            if ([paymentModeArray count]!=0)
//            {
//                NSDictionary * paymentInfo =[paymentModeArray objectAtIndex:0];
//                [self.btnPaymentMode setTitle:[paymentInfo objectForKey:@"paymentMode"] forState:UIControlStateNormal];
//                [self.imgPaymentmode setImage:[UIImage imageWithData:[paymentInfo objectForKey:@"paymentmode_icon"]]];
//            }
//        }else
//        {
//            NSArray *paymentModeArray=[[NSMutableArray alloc]initWithArray:[[PaymentmodeHandler sharedCoreDataController]getPaymentModeList]];
//            if ([paymentModeArray count]==0)
//            {
//                [self.btnPaymentMode setTitle:NSLocalizedString(@"noPaymentMode", nil) forState:UIControlStateNormal];
//                [self.imgPaymentmode setImage:[UIImage imageNamed:@"paymentmode.png"]];
//            }else
//            {
//                Paymentmode *mode=[paymentModeArray objectAtIndex:0];
//                [self.btnPaymentMode setTitle:mode.paymentMode forState:UIControlStateNormal];
//                [self.imgPaymentmode setImage:[UIImage imageWithData:mode.paymentmode_icon]];
//            }
//       }
  //  }
}


-(void) receivedNotification:(NSNotification*) notification
{
    NSDictionary * info =notification.userInfo;
   [self.btnSubCategary setTitle:[info objectForKey:@"object"] forState:UIControlStateNormal];
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
}


- (IBAction)ChoseSelectedCategerybtnClick:(id)sender
{
     [self showImagesOnly];
}


- (void)showImagesOnly
{
    NSInteger numberOfOptions = [self.catageryList count];
    NSMutableArray *mutableArrya=[[NSMutableArray alloc] init];
    for (NSDictionary  *dictinary in self.catageryList)
    {
        [mutableArrya addObject:[dictinary objectForKey:@"image"]];
    }
    RNGridMenu *av = [[RNGridMenu alloc] initWithImages:[mutableArrya subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
}




- (IBAction)incomebtnClick:(id)sender
{
    [_imgIncome setImage:[UIImage imageNamed:@"radial_button_active.png"]];
    [_imgExpense setImage:[UIImage imageNamed:@"radial_button.png"]];
    number=1;
}



- (IBAction)expensenbtnClick:(id)sender
{
    [_imgExpense setImage:[UIImage imageNamed:@"radial_button_active.png"]];
    [_imgIncome setImage:[UIImage imageNamed:@"radial_button.png"]];
     number=0;
}



- (IBAction)mainCategorybtnClick:(id)sender
{
        [_imgMainCategory setImage:[UIImage imageNamed:@"radial_button_active.png"]];
        [_imgSubCategory setImage:[UIImage imageNamed:@"radial_button.png"]];
        [self.selectCatageryIconView setHidden:NO];
        [self.radiobuttonsView setFrame:CGRectMake(self.selectCatageryIconView.frame.origin.x, self.selectCatageryIconView.frame.origin.y+self.selectCatageryIconView.frame.size.height+1, self.radiobuttonsView.frame.size.width, self.radiobuttonsView.frame.size.height)];
        [self.statusView setFrame:CGRectMake(self.radiobuttonsView.frame.origin.x, self.radiobuttonsView.frame.origin.y+self.radiobuttonsView.frame.size.height+1, self.statusView.frame.size.width, 44)];
        [self.btnSubCategary setHidden:YES];
        [self.selectCatageryIconView setUserInteractionEnabled:YES];
        [self.statusView setHidden:NO];
        self.chekCatgeryOrSubCategry=NO;
}


- (IBAction)subCategorybtnClick:(id)sender
{
        [_imgSubCategory setImage:[UIImage imageNamed:@"radial_button_active.png"]];
        [_imgMainCategory setImage:[UIImage imageNamed:@"radial_button.png"]];
        [self.btnSubCategary setHidden:NO];
        [self.selectCatageryIconView setHidden:YES];
        [self.selectCatageryIconView setUserInteractionEnabled:NO];
        [self.radiobuttonsView setFrame:CGRectMake(self.selectCatageryIconView.frame.origin.x, self.selectCatageryIconView.frame.origin.y, self.radiobuttonsView.frame.size.width, self.radiobuttonsView.frame.size.height)];
        [self.statusView setHidden:YES];
        self.chekCatgeryOrSubCategry=YES;
}



- (IBAction)popUpCatagerybtnClick:(id)sender
{
    NSMutableArray *arrray=[[CategoryListHandler sharedCoreDataController] getAllCategoryList];
    CGFloat xWidth = self.view.bounds.size.width - 120.0f;
    CGFloat yHeight = 10*30.0f;
    CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
    UIPopoverListView *poplistview = [[UIPopoverListView alloc] initWithFrame:CGRectMake(10, yOffset, xWidth, yHeight)];
    [poplistview setListArray:arrray];
    [poplistview setNotificationName:@"AddCatageryListViewController"];
    poplistview.listView.scrollEnabled = YES;
    [poplistview setTitle:@"Catagery List"];
    [poplistview show];
}


-(void)addDefaultCategoryList
{
    NSArray *expensesArrray=[NSLocalizedString(@"expenses_items", ni) componentsSeparatedByString:@"."];
    for (NSString *fitststring in expensesArrray)
    {
        NSArray *newArray=[fitststring componentsSeparatedByString:@" -"];
        NSString *categery=[newArray objectAtIndex:0];
        NSString *trimmed=[categery stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        UIImage *image=[UIImage imageNamed:[[NSString stringWithFormat:@"%@_icon.png",trimmed] stringByReplacingOccurrencesOfString:@"/" withString:@" "]];
         NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
        if (!image)
        {
            image=[UIImage imageNamed:@"All_icon.png"];
        }
        [dic setObject:categery forKey:@"name"];
        [dic setObject:image forKey:@"image"];
        [self.catageryList addObject:dic];
    }
    
    NSArray *incomeArrray=[NSLocalizedString(@"income_items", nil) componentsSeparatedByString:@"."];
    for (NSString *fitststring in incomeArrray)
    {
         NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
        NSArray *newArray=[fitststring componentsSeparatedByString:@" -"];
        NSString *categery=[newArray objectAtIndex:0];
        NSString *trimmed=[categery stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        UIImage *image=[UIImage imageNamed:[[NSString stringWithFormat:@"%@_icon.png",trimmed] stringByReplacingOccurrencesOfString:@"/" withString:@" "]];
        if (!image)
        {
            image=[UIImage imageNamed:@"All_icon.png"];
        }
        [dic setObject:categery forKey:@"name"];
        [dic setObject:image forKey:@"image"];
        [self.catageryList addObject:dic];
    }
}


- (void)gridMenu:(RNGridMenu *)gridMenu willDismissWithSelectedItem:(RNGridMenuItem *)item atIndex:(NSInteger)itemIndex
{
      NSDictionary *dictionarry=[self.catageryList objectAtIndex:itemIndex];
     [self.btnCategery setTitle:[dictionarry objectForKey:@"name"] forState:UIControlStateNormal];
     [self.imgSelectCategery setImage:[dictionarry objectForKey:@"image"]];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)btnAddCategeryClick:(id)sender
{
    if ([self CheckTransactionValidity])
    {
        NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
        [dictionary setObject:[NSNumber numberWithInt:number] forKey:@"classtype"];
        if (![self.selectCatageryIconView  isHidden])
        {
            [dictionary setObject:TRIM(self.txtCategery.text) forKey:@"categery"];
            [dictionary setObject:self.imgSelectCategery.image forKey:@"pic"];
            [dictionary setObject:@"" forKey:@"subCatgery"];
        }else
        {
            [dictionary setObject:TRIM(self.btnSubCategary.titleLabel.text) forKey:@"categery"];
            [dictionary setObject:TRIM(self.txtCategery.text) forKey:@"subCatgery"];
            NSArray *categeryIcon=[[CategoryListHandler sharedCoreDataController]  getsearchCategeryWithAttributeName:@"category_icon" andSearchText:self.btnSubCategary.titleLabel.text];
            if ([categeryIcon count]!=0)
            {
              [dictionary setObject:[UIImage imageWithData:[[categeryIcon objectAtIndex:0] objectForKey:@"category_icon"]] forKey:@"pic"];
            }
        }
        [dictionary setObject:[Utility userDefaultsForKey:MAIN_TOKEN_ID] forKey:@"token_id"];
        [dictionary setObject:alarm ?[NSNumber numberWithInt:1] :[NSNumber numberWithInt:0] forKey:@"hide_status"];
        BOOL chek;
        if (self.catgery.managedObjectContext == nil)
        {
             [self updateCategery];
             [[CategoryListHandler sharedCoreDataController] insetItemCategoryList:dictionary];
              [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"categoryaddeSuccessfully", nil)];
        }else
        {
        if (!self.chekCatgeryOrSubCategry)
            {
                [[CategoryListHandler sharedCoreDataController] updateCategoryList:dictionary  :self.catgery];
         
            }else
                chek =[[CategoryListHandler sharedCoreDataController] updateItemCategoryList:dictionary :self.catgery];
            
             [self updateCategery];
             [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"categoryUpdatedSuccessfully", nil)];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}




-(void)updateCategery
{
    for (UIViewController * viewController in [self.navigationController viewControllers])
    {
        if ([viewController isKindOfClass:[CategeyListViewController class]])
        {
            CategeyListViewController *list=(CategeyListViewController*)viewController;
            [list setNumber:number];
            NSLog(@"%d",number);
            break;
        }
    }
    
}

- (IBAction)stateChanged:(id)sender
{
    if ([sender isOn])
    {
        alarm=YES;
        [UIAlertView alertViewWithTitle:@"Alert" message:NSLocalizedString(@"hidingCategory", nil)];
    } else
    {
        alarm=NO;
    }
}




-(BOOL)CheckTransactionValidity
{
    if ([TRIM(self.txtCategery.text) isEqual:@""])
    {
        NSString *title;
        
        if (self.chekCatgeryOrSubCategry)
        {
            title=NSLocalizedString(@"subCategorycannotbeempty", nil);
        }else
        {
            title=NSLocalizedString(@"mainCategorycannotbeempty", nil);
        }
        [Utility showAlertWithMassager:self.navigationController.view :title];
        [self.txtCategery resignFirstResponder];
        return NO;
    }
    if ([_txtCategery.text length]>50)
    {
        [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"morethan50notallowed", nil)];
        [self.txtCategery resignFirstResponder];
        return NO;
    }
    if (![self specialCharactersOccurence:TRIM(self.txtCategery.text)])
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
        [self.txtCategery resignFirstResponder];
        return NO;
    }
    if (!self.chekCatgeryOrSubCategry)
    {
        NSArray *array =[[CategoryListHandler sharedCoreDataController]  getAllCategoryListwithHideStaus];
        BOOL isTheObjectThere = [self chekExitenseCategery:array :self.txtCategery.text];
        if ( isTheObjectThere && [TRIM(self.txtCategery.text) caseInsensitiveCompare:self.catgery.category] != NSOrderedSame )
        {
            [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"categoryExits", nil)];
            [self.txtCategery resignFirstResponder];
            return NO;
        }
    }else
    {
       
        NSArray *array =[[CategoryListHandler sharedCoreDataController]  getAllSubCategery];
        BOOL isTheObjectThere = [self chekExitenseCategery:array :self.txtCategery.text];
        if ((isTheObjectThere && [TRIM(self.txtCategery.text) caseInsensitiveCompare:self.catgery.sub_category] != NSOrderedSame) || [TRIM(self.txtCategery.text) caseInsensitiveCompare:TRIM(self.btnSubCategary.titleLabel.text)] == NSOrderedSame)
        {
            [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"subcategoryExits", nil)];
            return NO;
        }
    }
    return YES;
}

-(BOOL)chekExitenseCategery:(NSArray*)array :(NSString*)searchString
{
    BOOL found = NO;
    for (NSString* str in array)
    {
        if ([str caseInsensitiveCompare:TRIM(searchString)]==NSOrderedSame)
        {
            found = YES;
            break;
        }
    }
    return found;
}


- (IBAction)btnBackClick:(id)sender
{
     [self.navigationController popViewControllerAnimated:YES];
}


@end
