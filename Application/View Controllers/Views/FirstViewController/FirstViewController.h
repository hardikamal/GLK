//
//  FirstViewController.h
//  Gullak
//
//  Created by Saurabh Singh on 25/02/15.
//  Copyright (c) 2015 Mobulous. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PagedFlowView.h"
@interface FirstViewController : UIViewController<PagedFlowViewDelegate,PagedFlowViewDataSource>
@property (nonatomic, strong) IBOutlet PagedFlowView *hFlowView;
@property (nonatomic, strong) IBOutlet UIPageControl *hPageControl;

- (IBAction)pageControlValueDidChange:(id)sender;

@end
