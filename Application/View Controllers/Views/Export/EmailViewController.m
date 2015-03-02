//
//  Email.m
//  CoverFlow
//
//  Created by User1 on 22/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EmailViewController.h"


@implementation EmailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        // Custom initialization
		
		self.mailComposeDelegate = self;
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

- (void)viewDidLoad
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        if ([mailClass canSendMail])
        {
            [self setSubject:@""];
            [self setMessageBody:@"" isHTML:NO];
            
        }
        else
        {
            [self launchMailAppOnDevice];
        }
    }
    else
    {
        [self launchMailAppOnDevice];
    }
    [super viewDidLoad];
}




-(void)launchMailAppOnDevice
{
	NSString *recipients = @"";
	NSString *tempEmail = [NSString stringWithFormat:@"%@", recipients];
	tempEmail = [tempEmail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:tempEmail]];
	
}

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{
	NSString *message;
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			message = @"Email Canceled";
			break;
		case MFMailComposeResultSaved:
			message = @"Email Saved";
			break;
		case MFMailComposeResultSent:
			message = @"Email Sent";
			break;
		case MFMailComposeResultFailed:
			message = @"Email Failed";
			break;
		default:
			message = @"Email Not Sent";
			break;
	}
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}



@end
