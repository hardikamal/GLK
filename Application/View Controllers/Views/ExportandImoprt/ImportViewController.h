//
//  ImportViewController.h
//  Daily Expense Manager
//
//  Created by Appbulous on 25/11/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHCSVParser.h"
//#import "MBProgressHUD.h"

@interface ImportViewController : UIViewController<CHCSVParserDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIView *tapView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *imgTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblImport;
-(void) handleOpenURL:(NSURL *)url;

- (IBAction)btnCancelClick:(id)sender;
@property(nonatomic) CGFloat  alpha;
@property(nonatomic) CGAffineTransform transform;
@property (strong, nonatomic) NSString *mainTitle;

- (void)show;
- (void)dismiss;


@end
