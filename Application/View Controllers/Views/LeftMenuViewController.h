//
//  MenuViewController.h
//  SlideMenu
//
//  Created by Aryan Gh on 4/24/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RATreeView.h"
#import "RATreeView+TableViewDelegate.h"
#import "RESideMenu.h"
@interface LeftMenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate,RESideMenuDelegate>

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, assign) BOOL slideOutAnimationEnabled;


@end
