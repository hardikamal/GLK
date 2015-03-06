//
//  TermAndconditionViewController.h
//  Daily Expense Manager
//
//  Created by Appbulous on 06/11/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TermAndconditionViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *tapView;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIView *topView;
- (IBAction)btnOkClick:(id)sender;

@property(nonatomic) CGFloat  alpha;
@property(nonatomic) CGAffineTransform transform;
- (void)show;
- (void)dismiss;

@end
