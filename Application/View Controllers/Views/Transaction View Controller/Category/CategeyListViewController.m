//
//  CategeyListViewController.m
//  Daily Expense Manager
//

#import "CategeyListViewController.h"
#import "FPPopoverController.h"
#import "DemoTableController.h"
#import "AddTransactionViewController.h"
#import "AddCatageryListViewController.h"
#import "RATreeView.h"
#import "RADataObject.h"
#import "BudgetViewController.h"
#import "CategoryList.h"
#import "RATreeView+Private.h"
#import "RATreeNode.h"
#import "UIAlertView+Block.h"
#import "NavigationLeftButton.h"
#import "SettingViewController.h"
#import "TitielPopoverListView.h"
#import "TransactionHandler.h"
#import "ReminderHandler.h"
#import "TransferHandler.h"
#import "BudgetHandler.h"
#include "CategoryListHandler.h"
#import "CategoryList.h"
#import "HomeHelper.h"
@interface CategeyListViewController ()
{
    FPPopoverController *popover;
}
@property (strong, nonatomic) NSArray *data;
@end

@implementation CategeyListViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)backViewController {
    for (UIViewController *viewController in[self.navigationController viewControllers]) {
        if ([viewController isKindOfClass:[SettingViewController class]]) {
            return YES;
        }
    }
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    FIX_IOS_7_EDGE_START_LAY_OUT_ISSUE
    if ([self backViewController]) {
        [self setTitle:NSLocalizedString(@"customizecategories", nil)];
    }
    else {
        [self setTitle:NSLocalizedString(@"selectacategory", nil)];
    }
    self.number = TYPE_EXPENSE;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedDemoListNotification:) name:@"DemoListner" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotification:) name:@"TielPopoverList" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:UPDATION_ON_SERVER_TIME]) {
        [[HomeHelper sharedCoreDataController] upgradeBackendDataOnServer];
    }
    
    if ([self isExpenseSelected]) {
        self.data = [[self getDefaultCategoryWithSubcategoryList] objectAtIndex:1];
    }
    else {
        self.data = [[self getDefaultCategoryWithSubcategoryList] objectAtIndex:0];
    }
    self.rowsExpandingAnimation = RATreeViewRowAnimationTop;
    self.rowsCollapsingAnimation = RATreeViewRowAnimationBottom;
    
    if (self.treeView == nil) {
        self.treeView = [[RATreeView alloc] initWithFrame:self.view.bounds];
        self.treeView.delegate = self;
        self.treeView.dataSource = self;
        self.treeView.separatorStyle = RATreeViewCellSeparatorStyleSingleLine;
        [self.treeView setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:self.treeView];
    }
    [self.treeView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)popover:(UIButton *)sender {
    //the controller we want to present as a popover
    DemoTableController *controller = [[DemoTableController alloc] init];
    [controller setPosition:sender.tag];
    
    NSMutableArray *listArray = [[NSMutableArray alloc] init];
    NSMutableArray *categeryName = [[NSMutableArray alloc]initWithObjects:@"Edit", @"Delete", @"Merge", nil];
    NSMutableArray *imageName = [[NSMutableArray alloc]initWithObjects:@"edit_icon.png", @"delete_icon.png", @"merge_icon", nil];
    for (int i = 0; i < [imageName count]; i++) {
        NSMutableDictionary *bookListing = [[NSMutableDictionary alloc] init];
        [bookListing setObject:[categeryName objectAtIndex:i] forKey:@"name"];
        [bookListing setObject:[imageName objectAtIndex:i] forKey:@"image"];
        [listArray addObject:bookListing];
    }
    
    popover = [[FPPopoverController alloc] initWithViewController:controller];
    popover.arrowDirection = FPPopoverNoArrow;
    popover.border = NO;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    RATreeNode *treeNode = [self.treeView treeNodeForIndex:indexPath.row];
    if ([self.selectedCategery isEqualToString:[treeNode.item name]] || [self.selectedSubCategery isEqualToString:[treeNode.item name]]) {
        [listArray removeObjectAtIndex:1];
        popover.contentSize = CGSizeMake(110, 86);
    }
    else {
        popover.contentSize = CGSizeMake(110, 126);
    }
    [controller setListArray:listArray];
    
    //    //popover.arrowDirection = FPPopoverArrowDirectionAny;
    //    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    //    {
    //        popover.contentSize = CGSizeMake(300, 500);
    //    }
    
    
    //sender is the UIButton view
    [popover presentPopoverFromView:sender];
    [self.view addSubview:popover.view];
}

#pragma mark TreeView Delegate methods
- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo {
    return 50;
}

- (NSInteger)treeView:(RATreeView *)treeView indentationLevelForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo {
    return 2 * treeNodeInfo.treeDepthLevel;
}

- (BOOL)treeView:(RATreeView *)treeView shouldExpandItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo {
    return YES;
}

- (BOOL)treeView:(RATreeView *)treeView shouldItemBeExpandedAfterDataReload:(id)item treeDepthLevel:(NSInteger)treeDepthLevel {
    return YES;
}

#pragma mark TreeView Data Source

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    UILabel *slogan = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, cell.frame.size.width, cell.frame.size.height)];
    slogan.text = [((RADataObject *)item).name stringByTrimmingCharactersInSet :[NSCharacterSet whitespaceCharacterSet]];
    slogan.font = [UIFont boldSystemFontOfSize:20];
    // slogan.backgroundColor=[UIColor clearColor];
    [cell.contentView addSubview:slogan];
    slogan.textColor = [UIColor whiteColor];
    // slogan.font=[UIFont fontWithName:Embrima size:16];
    if (([self.treeView indexPathForItem:item].row == 0 && [self budjetViewController])) {
        //UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        imageView.image = [UIImage imageNamed:@"overall_icon.png"];
        // [view addSubview:imageView];
        [cell.contentView addSubview:imageView];
    }
    else {
        if (treeNodeInfo.treeDepthLevel == 1) {
            NSArray *categeryIcon = [[CategoryListHandler sharedCoreDataController] getsearchSubCategery:((RADataObject *)item).name];
            if ([categeryIcon count] != 0) {
                CategoryList *list = [categeryIcon objectAtIndex:0];
                if ([list.category intValue]) {
                    slogan.textColor = [UIColor lightGrayColor];
                }
            }
        }
        if (treeNodeInfo.treeDepthLevel == 0) {
            NSArray *categeryIcon = [[CategoryListHandler sharedCoreDataController] getsearchCategeryWithAttributeName:@"category = %@" andSearchText:((RADataObject *)item).name];
            UIImage *image;
            if ([categeryIcon count] != 0) {
                image = [UIImage imageWithData:[[categeryIcon objectAtIndex:0] objectForKey:@"category_icon"]];
            }
            else {
                image = [UIImage imageNamed:@"Miscellaneous_icon.png"];
            }
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
            imageView.image = image;
            [view addSubview:imageView];
            [cell.contentView addSubview:view];
            if ([[[categeryIcon objectAtIndex:0] objectForKey:@"hide_status"] intValue]) {
                slogan.textColor = [UIColor lightGrayColor];
            }
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(infoImageTapped:)];
            [tap setNumberOfTapsRequired:1];
            [view setGestureRecognizers:[NSArray arrayWithObject:tap]];
            [view setTag:[self.treeView indexPathForItem:item].row];
            [view setUserInteractionEnabled:YES];
        }
        else {
            cell.imageView.image = [Utility imageWithImage:[UIImage imageNamed:@"subcategory_line.png"] scaledToSize:CGSizeMake(20, 20)];
            [cell setSeparatorInset:UIEdgeInsetsMake(10, 45, 40, 50)];
        }
        NavigationLeftButton *button = [NavigationLeftButton buttonWithType:UIButtonTypeInfoLight];
        [button setFrame:CGRectMake(266, 0, 44, 50)];
        [button setImage:[UIImage imageNamed:@"option_button.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(popover:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:button];
        [button setTag:(int)[self.treeView indexPathForItem:item].row];
        cell.tintColor = [UIColor whiteColor];
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)infoImageTapped:(UITapGestureRecognizer *)sender {
    UIGestureRecognizer *recognizer = (UIGestureRecognizer *)sender;
    UIView *imageView = (UIView *)recognizer.view;
    NSLog(@"%ld", (long)imageView.tag);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:imageView.tag inSection:0];
    RATreeNode *treeNode = [self.treeView treeNodeForIndex:indexPath.row];
    if (treeNode.isExpanded) {
        [self.treeView collapseCellForTreeNode:treeNode withRowAnimation:self.rowsCollapsingAnimation];
    }
    else {
        [self.treeView expandCellForTreeNode:treeNode withRowAnimation:self.rowsExpandingAnimation];
    }
}

- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo {
    NSString *string;
    UIImage *image;
    if (([self.treeView indexPathForItem:item].row == 0 && [self budjetViewController])) {
        string = ((RADataObject *)item).name;
        image = [UIImage imageNamed:@"All_icon.png"];
    }
    else {
        NSCharacterSet *whitespace = [NSCharacterSet whitespaceCharacterSet];
        if (![self isExpenseSelected]) {
            string = [string stringByTrimmingCharactersInSet:whitespace];
            if (treeNodeInfo.treeDepthLevel == 0) {
                NSArray *categeryIcon = [[CategoryListHandler sharedCoreDataController] getsearchCategeryWithAttributeName:@"category_icon" andSearchText:((RADataObject *)item).name];
                if ([categeryIcon count] != 0) {
                    image = [UIImage imageWithData:[[categeryIcon objectAtIndex:0] objectForKey:@"category_icon"]];
                }
                string = ((RADataObject *)item).name;
            }
            else if (treeNodeInfo.treeDepthLevel == 1) {
                NSArray *categeryName = [[CategoryListHandler sharedCoreDataController] getCategeryAttributeName:@"sub_category = %@" andSearchText:((RADataObject *)item).name];
                CategoryList *catgeryList = (CategoryList *)[categeryName objectAtIndex:0];
                image = [UIImage imageWithData:catgeryList.category_icon];
                string = [NSString stringWithFormat:@"%@,%@", catgeryList.category, ((RADataObject *)item).name];
            }
        }
        else {
            string = [string stringByTrimmingCharactersInSet:whitespace];
            if (treeNodeInfo.treeDepthLevel == 0) {
                NSArray *categeryIcon = [[CategoryListHandler sharedCoreDataController] getsearchCategeryWithAttributeName:@"category_icon" andSearchText:((RADataObject *)item).name];
                if ([categeryIcon count] != 0) {
                    image = [UIImage imageWithData:[[categeryIcon objectAtIndex:0] objectForKey:@"category_icon"]];
                }
                else
                    image = [UIImage imageNamed:@"All_icon.png"];
                string = ((RADataObject *)item).name;
            }
            else if (treeNodeInfo.treeDepthLevel == 1) {
                NSArray *categeryName = [[CategoryListHandler sharedCoreDataController] getCategeryAttributeName:@"sub_category = %@" andSearchText:((RADataObject *)item).name];
                CategoryList *catgeryList = (CategoryList *)[categeryName objectAtIndex:0];
                image = [UIImage imageWithData:catgeryList.category_icon];
                string = [NSString stringWithFormat:@"%@,%@", catgeryList.category, ((RADataObject *)item).name];
            }
        }
    }
    NSString *noticationName = @"CategeryList";
    NSMutableDictionary *bookListing = [[NSMutableDictionary alloc] init];
    [bookListing setObject:string forKey:@"name"];
    [bookListing setObject:image forKey:@"image"];
    [[NSNotificationCenter defaultCenter] postNotificationName:noticationName object:nil userInfo:bookListing];
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item {
    if (item == nil) {
        return [self.data count];
    }
    RADataObject *data = item;
    return [data.children count];
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item {
    RADataObject *data = item;
    if (item == nil) {
        return [self.data objectAtIndex:index];
    }
    return [data.children objectAtIndex:index];
}

- (IBAction)segmentValueChangeAction:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.data = [[self getDefaultCategoryWithSubcategoryList] objectAtIndex:0];
        [self.treeView reloadData];
    }
    else {
        self.data = [[self getDefaultCategoryWithSubcategoryList] objectAtIndex:1];
        [self.treeView reloadData];
    }
}

- (IBAction)btnBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)newCatagerybtnClick:(id)sender {
    [[AppCommonFunctions sharedInstance]pushVCOfClass:[AddCatageryListViewController class] fromNC:[self navigationController] animated:YES setRootViewController:NO modifyVC: ^(id info) {
        if ([self isExpenseSelected]) {
            [((AddCatageryListViewController *)(info))setChekforIncomeorExpense : YES];
        }
    }];
}

- (BOOL)budjetViewController {
    for (UIViewController *viewController in[self.navigationController viewControllers]) {
        if ([viewController isKindOfClass:[BudgetViewController class]]) {
            return YES;
        }
    }
    return NO;
}

- (NSArray *)getCategery {
    NSArray *fetchedRecords;
    if ([self backViewController]) {
        fetchedRecords = [[CategoryListHandler sharedCoreDataController]  getAllCategoryListwithHideStaus];
    }
    else
        fetchedRecords = [[CategoryListHandler sharedCoreDataController]  getAllCategoryList];
    
    return fetchedRecords;
}

- (NSArray *)getDefaultCategoryWithSubcategoryList {
    NSMutableArray *incomeList = [[NSMutableArray alloc] init];
    NSMutableArray *expenseList = [[NSMutableArray alloc] init];
    
    if ([self budjetViewController]) {
        RADataObject *phone = [RADataObject dataObjectWithName:@"All" children:nil];
        [incomeList addObject:phone];
        [expenseList addObject:phone];
    }
    
    NSArray *fetchedRecords = [self getCategery];
    for (int i = 0; i < [fetchedRecords count]; i++) {
        NSString *string = [fetchedRecords objectAtIndex:i];
        NSArray *classType = [[CategoryListHandler sharedCoreDataController] getsearchCategeryWithAttributeName:@"class_type" andSearchText:string];
        if ([[[classType objectAtIndex:0] objectForKey:@"class_type"] intValue]) {
            RADataObject *phone;
            NSArray *relatedSubCategeryLists = [[CategoryListHandler sharedCoreDataController] getsearchCategeryWithAttributeName:@"categry" andSearchText:string];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (int j = 0; j < [relatedSubCategeryLists count]; j++) {
                NSString *substring = [[relatedSubCategeryLists objectAtIndex:j] objectForKey:@"sub_category"];
                if ([substring length] != 0) {
                    RADataObject *phone1 = [RADataObject dataObjectWithName:substring children:nil];
                    [array addObject:phone1];
                }
                else {
                    phone = [RADataObject dataObjectWithName:string children:nil];
                }
            }
            if (phone != nil) {
                [incomeList addObject:phone];
            }
            
            if ([array count] != 0) {
                [phone setChildren:array];
            }
        }
        else {
            RADataObject *phone;
            NSArray *relatedSubCategeryLists = [[CategoryListHandler sharedCoreDataController] getsearchCategeryWithAttributeName:@"categry" andSearchText:string];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (int j = 0; j < [relatedSubCategeryLists count]; j++) {
                NSString *substring = [[relatedSubCategeryLists objectAtIndex:j] objectForKey:@"sub_category"];
                if ([substring length] != 0) {
                    RADataObject *phone1 = [RADataObject dataObjectWithName:substring children:nil];
                    [array addObject:phone1];
                }
                else {
                    phone = [RADataObject dataObjectWithName:string children:nil];
                }
            }
            if (phone != nil) {
                [expenseList addObject:phone];
            }
            if ([array count] != 0) {
                [phone setChildren:array];
            }
        }
    }
    return [[NSMutableArray alloc] initWithObjects:incomeList, expenseList, nil];
}

- (void)receivedNotification:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    if ([[info objectForKey:@"tag"]isEqualToString:@"0"]) {
        NSArray *arrya = [[CategoryListHandler sharedCoreDataController]getCategeryAttributeName:@"category = %@" andSearchText:[info objectForKey:@"categeryOrsubcategery"]];
        if ([arrya count] == 0) {
            NSArray *newarrya = [[CategoryListHandler sharedCoreDataController] getCategeryAttributeName:@"sub_category = %@" andSearchText:[info objectForKey:@"categeryOrsubcategery"]];
            
            NSArray *secondarrya = [[CategoryListHandler sharedCoreDataController]getCategeryAttributeName:@"category = %@" andSearchText:[[info objectForKey:@"name"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            
            CategoryList *newarryalist = (CategoryList *)[newarrya objectAtIndex:0];
            CategoryList *secondarrayalist = (CategoryList *)[secondarrya objectAtIndex:0];
            
            [[CategoryListHandler sharedCoreDataController] updateSubCategery:[newarrya objectAtIndex:0]:[secondarrya objectAtIndex:0]];
            [[TransactionHandler sharedCoreDataController] updateCategeroySubCategryToCategery:newarryalist.sub_category:secondarrayalist.category];
            [[ReminderHandler sharedCoreDataController] updateCategeroySubCategryToCategery:newarryalist.sub_category:secondarrayalist.category];
            [[BudgetHandler sharedCoreDataController] updateCategeroySubCategryToCategery:newarryalist.sub_category:secondarrayalist.category];
            [[TransferHandler sharedCoreDataController] updateCategeroySubCategryToCategery:newarryalist.sub_category:secondarrayalist.category];
        }
        else {
            NSArray *newarrya = [[CategoryListHandler sharedCoreDataController]getCategeryAttributeName:@"category = %@" andSearchText:[[info objectForKey:@"name"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            for (CategoryList *list in self.categeryLists) {
                [[TransactionHandler sharedCoreDataController] updateCategeroyToCategery:list.category:[info objectForKey:@"name"]];
                [[ReminderHandler sharedCoreDataController] updateCategeroyToCategery:list.category:[info objectForKey:@"name"]];
                [[BudgetHandler sharedCoreDataController] updateCategeroyToCategery:list.category:[info objectForKey:@"name"]];
                [[TransferHandler sharedCoreDataController] updateCategeroyToCategery:list.category:[info objectForKey:@"name"]];
                [[CategoryListHandler sharedCoreDataController] updateSubCategery:list:[newarrya objectAtIndex:0]];
            }
        }
    }
    else {
        NSArray *arrya = [[CategoryListHandler sharedCoreDataController]getCategeryAttributeName:@"sub_category = %@" andSearchText:[info objectForKey:@"categeryOrsubcategery"]];
        CategoryList *categerylist = (CategoryList *)[arrya objectAtIndex:0];
        
        NSArray *newarrya = [[CategoryListHandler sharedCoreDataController] getCategeryAttributeName:@"sub_category = %@" andSearchText:[[info objectForKey:@"name"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        
        [[TransactionHandler sharedCoreDataController] updateCategeroySubCategryToCategerysubcategery:categerylist.sub_category:[newarrya objectAtIndex:0]];
        
        [[ReminderHandler sharedCoreDataController] updateCategeroySubCategryToCategerysubcategery:categerylist.sub_category:[newarrya objectAtIndex:0]];
        
        [[BudgetHandler sharedCoreDataController] updateCategeroySubCategryToCategerysubcategery:categerylist.sub_category:[newarrya objectAtIndex:0]];
        
        [[TransferHandler sharedCoreDataController] updateCategeroySubCategryToCategerysubcategery:categerylist.sub_category:[newarrya objectAtIndex:0]];
    }
    if (![self isExpenseSelected]) {
        self.data = [[self getDefaultCategoryWithSubcategoryList] objectAtIndex:0];
    }
    else {
        self.data = [[self getDefaultCategoryWithSubcategoryList] objectAtIndex:1];
    }
    [self.treeView reloadData];
}

- (void)receivedDemoListNotification:(NSNotification *)notification {
    [popover dismissPopoverAnimated:YES];
    NSDictionary *info = notification.userInfo;
    NSString *number = [info objectForKey:@"index"];
    NSNumber *positon = [info objectForKey:@"position"];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[positon integerValue] inSection:0];
    RATreeNode *treeNode = [self.treeView treeNodeForIndex:indexPath.row];
    self.categeryLists = [[CategoryListHandler sharedCoreDataController] getCategeryAttributeName:@"category = %@" andSearchText:[treeNode.item name]];
    if ([number intValue] == 0) {
        BOOL chek;
        if ([self.categeryLists count] == 0) {
            chek = YES;
            self.categeryLists = [[CategoryListHandler sharedCoreDataController] getCategeryAttributeName:@"sub_category = %@" andSearchText:[treeNode.item name]];
        }
        else
            chek = NO;
        
        AddCatageryListViewController *catageryController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddCatageryListViewController"];
        [catageryController setChekCatgeryOrSubCategry:chek];
        [catageryController setCatgery:[self.categeryLists objectAtIndex:0]];
        [self.navigationController pushViewController:catageryController animated:YES];
    }
    else if ([number intValue] == 2) {
        if ([self.categeryLists count] != 0) {
            NSMutableArray *arrray = [[CategoryListHandler sharedCoreDataController] getAllCategoryList];
            NSMutableArray *incomeList = [[NSMutableArray alloc] init];
            for (NSString *string in arrray) {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                [dic setObject:string forKey:@"name"];
                [dic setObject:@"0" forKey:@"tag"];
                [incomeList addObject:dic];
            }
            CGFloat xWidth = self.view.bounds.size.width - 100.0f;
            CGFloat yHeight = 10 * 30.0f;
            CGFloat yOffset = (self.view.bounds.size.height - yHeight) / 2.0f;
            TitielPopoverListView *poplistview = [[TitielPopoverListView alloc] initWithFrame:CGRectMake(10, yOffset, xWidth, yHeight)];
            [poplistview setListArray:incomeList];
            [poplistview setCategeryOrsubcategery:[treeNode.item name]];
            poplistview.listView.scrollEnabled = YES;
            [poplistview setTitle:@"Select Category"];
            [poplistview show];
        }
        else {
            CGFloat xWidth = self.view.bounds.size.width - 100.0f;
            CGFloat yHeight = 10 * 30.0f;
            CGFloat yOffset = (self.view.bounds.size.height - yHeight) / 2.0f;
            TitielPopoverListView *poplistview = [[TitielPopoverListView alloc] initWithFrame:CGRectMake(10, yOffset, xWidth, yHeight)];
            NSMutableArray *fetchedRecords = [[CategoryListHandler sharedCoreDataController]  getDefaultList];
            [poplistview setListArray:fetchedRecords];
            [poplistview setCategeryOrsubcategery:[treeNode.item name]];
            poplistview.listView.scrollEnabled = YES;
            [poplistview setTitle:@"Select Category"];
            [poplistview show];
        }
    }
    else if ([number intValue] == 1) {
        if ([self.categeryLists count] == 0) {
            self.categeryLists = [[CategoryListHandler sharedCoreDataController] getCategeryAttributeName:@"sub_category = %@" andSearchText:[treeNode.item name]];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:NSLocalizedString(@"deletingthiscategorywilldeleteitstransactions", nil) delegate:self cancelButtonTitle:@"Continue"  otherButtonTitles:nil];
        [alert addButtonWithTitle:@"Cancel"];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        for (CategoryList *list in self.categeryLists) {
            [[TransactionHandler sharedCoreDataController] deleteCategeroyList:list.category chekServerUpdation:NO];
            [[ReminderHandler sharedCoreDataController] deleteCategeroyList:list.category chekServerUpdation:NO];
            [[BudgetHandler sharedCoreDataController] deleteCategeroyList:list.category chekServerUpdation:NO];
            [[TransferHandler sharedCoreDataController] deleteCategeroyList:list.category chekServerUpdation:NO];
            [[CategoryListHandler sharedCoreDataController] deleteCategoryList:list];
        }
        if (![self isExpenseSelected]) {
            self.data = [[self getDefaultCategoryWithSubcategoryList] objectAtIndex:0];
        }
        else {
            self.data = [[self getDefaultCategoryWithSubcategoryList] objectAtIndex:1];
        }
        [self.treeView reloadData];
        [Utility showAlertWithMassager:self.navigationController.view:NSLocalizedString(@"categorydeletedSuccessfully", nil)];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"segueTocategery"]) {
        AddCatageryListViewController *dest = (AddCatageryListViewController *)[segue destinationViewController];
        if ([self isExpenseSelected]) {
            [dest setChekforIncomeorExpense:YES];
        }
    }
}

@end
