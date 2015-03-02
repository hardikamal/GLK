//
//  ImageViewController.h
//  Daily Expense Manager
//
//  Created by Appbulous on 13/01/15.
//  Copyright (c) 2015 Chandan Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)backButtonClick:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIImage *image;
@property (strong, nonatomic) NSString *string;
@end
