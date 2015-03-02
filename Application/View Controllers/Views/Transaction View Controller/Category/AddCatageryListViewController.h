//
//  AddCatageryListViewController.h
//  Daily Expense Manager
//
//  Created by Appbulous on 08/09/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNGridMenu.h"
#import "NavigationLeftButton.h"
#import "CategoryList.h"

@interface AddCatageryListViewController : UIViewController<RNGridMenuDelegate>
- (IBAction)btnBackClick:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

@property (strong, nonatomic) IBOutlet NavigationLeftButton *btnCategery;
@property (nonatomic, assign)BOOL chekCatgeryOrSubCategry;
@property (strong, nonatomic) IBOutlet UITextField *txtCategery;
- (IBAction)btnAddCategeryClick:(id)sender;
- (IBAction)stateChanged:(id)sender;
@property (strong, nonatomic) IBOutlet UISwitch *btnHidestatus;

@property (strong, nonatomic) IBOutlet UILabel *lblExpense;
@property (strong, nonatomic) IBOutlet UILabel *lblHideStatus;
@property (strong, nonatomic) NSMutableArray *catageryList;
@property (strong, nonatomic) IBOutlet UIButton *btnSubCategary;
@property (strong, nonatomic) IBOutlet UILabel *lbleMaincategory;
@property (strong, nonatomic) IBOutlet UILabel *lblSubCategery;
@property (strong, nonatomic) IBOutlet UILabel *lblIncome;
@property (strong, nonatomic) IBOutlet UIView *selectCatageryIconView;
@property (strong, nonatomic) IBOutlet UIView *radiobuttonsView;
@property (strong, nonatomic) IBOutlet UIView *statusView;
@property (strong, nonatomic) IBOutlet UIImageView *imgIncome;
@property (strong, nonatomic) IBOutlet UIImageView *imgExpense;
@property (strong, nonatomic) IBOutlet UIImageView *imgMainCategory;
@property (strong, nonatomic) IBOutlet UIImageView *imgSubCategory;
@property (strong, nonatomic) IBOutlet UIImageView *imgSelectCategery;

@property ( nonatomic) BOOL chekforIncomeorExpense;

@property (strong, nonatomic) CategoryList *catgery;

- (IBAction)ChoseSelectedCategerybtnClick:(id)sender;

@property (strong, nonatomic) NSString *catageryName;




- (IBAction)incomebtnClick:(id)sender;
- (IBAction)expensenbtnClick:(id)sender;
- (IBAction)mainCategorybtnClick:(id)sender;
- (IBAction)subCategorybtnClick:(id)sender;
- (IBAction)popUpCatagerybtnClick:(id)sender;



@end
