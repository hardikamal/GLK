//
//  CategeyListViewController.h
//  Daily Expense Manager
//
//  Created by Appbulous on 02/09/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RATreeView.h"
#import "NavigationLeftButton.h"
@interface CategeyListViewController : UIViewController <RATreeViewDelegate, RATreeViewDataSource,UIAlertViewDelegate>
@property(nonatomic,assign)BOOL isExpenseSelected;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIView *custumView;
@property (nonatomic, strong) NSArray *categeryLists;
@property (strong, nonatomic) IBOutlet NavigationLeftButton *btnBack;
@property (strong, nonatomic) IBOutlet UIImageView *imgTitle;
@property (weak, nonatomic) RATreeView *treeView;
@property (nonatomic) RATreeViewRowAnimation rowsExpandingAnimation;
@property (nonatomic) RATreeViewRowAnimation rowsCollapsingAnimation;

@property (strong, nonatomic) NSString *selectedCategery;
@property (strong, nonatomic) NSString *selectedSubCategery;
- (IBAction)newCatagerybtnClick:(id)sender;
- (IBAction)incomebtnOnClick:(id)sender;
- (IBAction)expensebtnOnClick:(id)sender;
@property  int number;


@end
