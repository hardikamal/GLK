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
    [self.titleLable setFont:[UIFont fontWithName:Ebrima_Bold size:16.0f]];
    
    if ([self backViewController])
    {
        [self.selectImage setImage:[UIImage imageNamed:@"back_button.png"]];
        [self.iconImage setImage:[UIImage imageNamed:@"setting_white_icon.png"]];
        [self.titleLable setFont:[UIFont fontWithName:Ebrima_Bold size:16.0f]];
       if ([self.xlsPath length]!=0)
        {
            [self.titleLable setText:NSLocalizedString(@"viewReports", nil)];
            NSURL *url = [NSURL fileURLWithPath:self.xlsPath];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            
            CGSize maxSize = CGSizeMake(200, 9999);
            CGRect labRect = [self.titleLable.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleLable.font} context:nil];
            [self.btnBack setFrame:CGRectMake(0,19,labRect.size.width+60,44)];
            
            [self.textView loadRequest:request];
        }else
        {
            [self.titleLable setText:NSLocalizedString(@"changelog", nil)];
            body = NSLocalizedString(@"thedemteam9", nil);
            [self.textView loadHTMLString:body baseURL:nil];
            
            CGSize maxSize = CGSizeMake(200, 9999);
            CGRect labRect = [self.titleLable.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleLable.font} context:nil];
            [self.btnBack setFrame:CGRectMake(0,19,labRect.size.width+60,44)];
           
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
 
    CGFloat borderWidth = .3f;
    self.textView.frame = CGRectInset(self.textView.frame, -borderWidth, -borderWidth);
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textView.layer.borderWidth = borderWidth;
    [self webViewDidFinishLoad:self.textView];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGSize mWebViewTextSize = [webView sizeThatFits:CGSizeMake(1.0f, 1.0f)];  // Pass about any size
    CGRect mWebViewFrame = webView.frame;
    mWebViewFrame.size.height = mWebViewTextSize.height;
    webView.frame = mWebViewFrame;
    //Disable bouncing in webview
    for (id subview in webView.subviews)
    {
        if ([[subview class] isSubclassOfClass: [UIScrollView class]])
        {
            [subview setBounces:NO];
        }
    }
}


- (IBAction)btnBackClick:(id)sender
{
    UIImage *secondImage = [UIImage imageNamed:@"back_button.png"];
    NSData *imgData1 = UIImagePNGRepresentation(self.selectImage.image);
    NSData *imgData2 = UIImagePNGRepresentation(secondImage);
    BOOL isCompare =  [imgData1 isEqual:imgData2];
    if(isCompare)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
       //  [[SlideNavigationController sharedInstance]toggleLeftMenu];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
