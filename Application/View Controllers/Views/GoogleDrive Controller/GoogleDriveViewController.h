//
//  GoogleDriveViewController.h
//  BrainDownloader
//
//  Created by ITRENTALINDIA on 8/27/14.
//  Copyright (c) 2014 Mobulous. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHCSVParser.h"
@interface GoogleDriveViewController : UIViewController<CHCSVParserDelegate>

- (IBAction)authButtonClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *authButton;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UILabel *lblGoogleDriveTop;

- (IBAction)backButtonClick:(id)sender;
-(void)sendToGogleDrive:(NSString *)currentFilePath;
@property (strong, nonatomic) NSString *mainTitle;
@end
