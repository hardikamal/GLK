//
//  ImageViewController.m
//  Daily Expense Manager
//
//  Created by Appbulous on 13/01/15.
//  Copyright (c) 2015 Chandan Kumar. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.imageView setImage:self.image];
    [self.lblTitle setText:self.string];
    [self.lblTitle setFont:[UIFont fontWithName:Ebrima_Bold size:16.0f]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backButtonClick:(id)sender
{
     [self dismissViewControllerAnimated:NO completion:nil];
}

@end
