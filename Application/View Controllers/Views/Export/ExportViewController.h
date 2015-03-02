//
//  ExportViewController.h
//  Daily Expense Manager
//
//  Created by Appbulous on 25/11/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "CHCSVParser.h"
#import "CustomizeExportViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "GTMOAuth2ViewControllerTouch.h"
#import "GTLDrive.h"
#import "VSGGoogleServiceDrive.h"

@interface ExportViewController : UIViewController<CHCSVParserDelegate,UIAlertViewDelegate >
@property (strong, nonatomic) IBOutlet UILabel *lblExport;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIView *tapView;
@property (strong, nonatomic) IBOutlet UIImageView *imgTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic)  CustomizeExportViewController *objCustomPopUpViewController;
@property(nonatomic) CGFloat  alpha;
@property(nonatomic) CGAffineTransform transform;

@property (weak, readonly) VSGGoogleServiceDrive *driveService;
@property (retain) NSMutableArray *driveFiles;
@property BOOL isAuthorized;
@property (strong,nonatomic) NSString *isAuth;

- (void)show;
- (void)dismiss;

@end
