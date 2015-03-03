//
//  CustomPopUpViewController.m
//  Daily Expense Manager
//
//  Created by Appbulous on 23/09/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import "CustomPopUpViewController.h"

#import "CategoryListHandler.h"
#import "PaymentmodeHandler.h"
@interface CustomPopUpViewController ()


@end

@implementation CustomPopUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [Utility setFontFamily:Embrima forView:self.popUpView andSubViews:YES];
    [self.lblTitile setFont:[UIFont fontWithName:Ebrima_Bold size:16.0f]];
    [self.lblCategery setFont:[UIFont fontWithName:Embrima size:12.0f]];
    [self.lblPaymentMode setFont:[UIFont fontWithName:Embrima size:12.0f]];
    
    NSString *totalItem=[self.categryList componentsJoinedByString:@", "];
    totalItem=[totalItem stringByReplacingOccurrencesOfString:@"/n" withString:@" "];
    [self.lblCategery setText:totalItem];
   
    CGSize maxSize = CGSizeMake(self.lblCategery.frame.size.width-40, FLT_MAX);
    CGRect labRect = [totalItem boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:Embrima size:12.0f]} context:nil];
   
    [self.lblCategery setFrame:CGRectMake(self.lblCategery.frame.origin.x, self.lblCategery.frame.origin.y, self.lblCategery.frame.size.width, labRect.size.height)];
    
    [self.secondView setFrame:CGRectMake(self.secondView.frame.origin.x, self.secondView.frame.origin.y+labRect.size.height-23, self.secondView.frame.size.width, self.secondView.frame.size.height)];
  
    CGRect frame;
    frame = self.popUpView.frame;
    frame.size.height = frame.size.height+self.lblCategery.frame.size.height-20;
    self.popUpView.frame = frame;
    [self.popUpView addSubview:self.secondView];
   
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    tapRecognizer.numberOfTapsRequired = 1;
    self.tapView.userInteractionEnabled=YES;
    [self.tapView addGestureRecognizer:tapRecognizer];
    
    NSString *paymentMode=[self.paymentModeList componentsJoinedByString:@", "];
    paymentMode=[paymentMode stringByReplacingOccurrencesOfString:@"/n" withString:@" "];
    [self.lblPaymentMode setText:paymentMode];
    
    CGFloat xWidth = self.popUpView.frame.size.width;
    CGFloat yHeight = self.popUpView.frame.size.height;
    CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
    [self.popUpView setFrame:CGRectMake(5, yOffset, xWidth, yHeight)];
    self.popUpView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.popUpView.layer.borderWidth = 1.0f;
    self.popUpView.clipsToBounds = TRUE;
    [self.popUpView didMoveToSuperview];
}


- (void)animatedIn
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}
- (void)animatedOut
{
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished)
        {
            [self.view removeFromSuperview];
        }
    }];
}


- (void)touchForDismissSelf:(id)sender
{
    [self animatedOut];
    
}

#pragma mark - show or hide self
- (void)show
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:self.view];
    self.view.center = CGPointMake(keywindow.bounds.size.width/2.0f, keywindow.bounds.size.height/2.0f);
    [self animatedIn];
}


- (void)dismiss
{
    [self animatedOut];
}


- (IBAction)handleSingleTap:(UITapGestureRecognizer *)sender
{
      [self animatedOut];
}


- (IBAction)handleTapNew:(id)sender
{   self.popUpView.hidden=YES;
    self.tapView.hidden=YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnCategory:(UIButton*)sender
{
    [self.popUpView removeFromSuperview];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:Nil];
    self.objCustomPopUpViewController = [storyboard instantiateViewControllerWithIdentifier:@"SelectedViewController"];
    [self.objCustomPopUpViewController setTitleString:sender.titleLabel.text];
    NSMutableArray *array=[[NSMutableArray alloc] init];
    NSMutableArray *arrayCategery=[[CategoryListHandler sharedCoreDataController] getAllCategoryList];
    for (NSString *string in arrayCategery)
    {
        NSMutableDictionary *dictonary=[[NSMutableDictionary alloc] init];
        [dictonary setObject:string forKey:@"text"];
        if ([self.categryList containsObject:string])
        {
            [dictonary setObject:@"YES" forKey:@"checked"];
        }else
        {
            [dictonary setObject:@"NO" forKey:@"checked"];
        }
        
        [array addObject:dictonary];
    }
    [self.objCustomPopUpViewController setItem:array];
    [self.objCustomPopUpViewController setChekPaymentorCategery:YES];
    [self.view addSubview:self.objCustomPopUpViewController.view];
}


- (IBAction)btnPaymentModeClick:(UIButton*)sender
{
    [self.popUpView removeFromSuperview];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:Nil];
    self.objCustomPopUpViewController = [storyboard instantiateViewControllerWithIdentifier:@"SelectedViewController"];
    [self.objCustomPopUpViewController setTitleString:sender.titleLabel.text];
    NSMutableArray *array=[[NSMutableArray alloc] init];
    NSArray *paymentModeArray=[[PaymentmodeHandler sharedCoreDataController] getPaymentModeList];
    for ( Paymentmode *mode in paymentModeArray)
    {
        NSMutableDictionary *dictonary=[[NSMutableDictionary alloc] init];
        [dictonary setObject:mode.paymentMode forKey:@"text"];
        if ([self.paymentModeList containsObject:mode.paymentMode])
        {
            [dictonary setObject:@"YES" forKey:@"checked"];
        }else
        {
            [dictonary setObject:@"NO" forKey:@"checked"];
        }
        
        [array addObject:dictonary];
    }
    [self.objCustomPopUpViewController setItem:array];
    [self.view addSubview:self.objCustomPopUpViewController.view];
}



- (IBAction)btnApplayFilterClick:(id)sender
{
     NSString * noticationName =@"CustomePopUpViewController";
     NSMutableDictionary *bookListing = [[NSMutableDictionary alloc] init];
    [bookListing setValue:self.categryList forKey:@"categryList"];
    [bookListing setValue:self.paymentModeList forKey:@"paymentModeList"];
    [[NSNotificationCenter defaultCenter] postNotificationName:noticationName object:nil userInfo:bookListing];
    [self.view removeFromSuperview];

}

- (IBAction)btnCancelClick:(id)sender
{
    [self.view removeFromSuperview];
}



@end
