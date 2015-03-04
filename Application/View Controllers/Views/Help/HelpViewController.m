//
//  HelpViewController.m
//  Daily Expense Manager
//
//  Created by Appbulous on 06/11/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import "HelpViewController.h"

#import "SettingViewController.h"

@interface HelpViewController ()

@property (strong, nonatomic) IBOutlet UIWebView *textView;
@end
@implementation HelpViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}


- (BOOL)backViewController
{
    for (UIViewController * viewController in [self.navigationController viewControllers])
    {
        if ([viewController isKindOfClass:[SettingViewController class]])
        {
            return  YES;
        }
        
    }
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     NSString *body;
    //[self.titleLable setFont:[UIFont fontWithName:Ebrima_Bold size:16.0f]];
    
    if ([self backViewController])
    {
        
       if ([self.xlsPath length]!=0)
        {
            self.title=NSLocalizedString(@"viewReports", nil);
            NSURL *url = [NSURL fileURLWithPath:self.xlsPath];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [self.textView loadRequest:request];
        }else
        {
            self.title=NSLocalizedString(@"changelog", nil);

            body = NSLocalizedString(@"thedemteam9", nil);
            [self.textView loadHTMLString:body baseURL:nil];
            
        }
        
    }else
    {
        body = NSLocalizedString(@"help_heading", nil);
        [self.textView loadHTMLString:body baseURL:nil];
    }
    
    NSString *html;
    for (int i=0; i<5; i++)
    {
        html = [html stringByAppendingString:@"<html><head></head><body><form><input type=\"checkbox\" ><br></form></body></html>"];
    }
   // [self webViewDidFinishLoad:self.textView];
}



- (IBAction)btnBackClick:(id)sender
{
   }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
