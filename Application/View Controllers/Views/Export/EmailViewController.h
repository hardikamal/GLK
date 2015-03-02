//
//  Email.h
//  CoverFlow
//
//  Created by User1 on 22/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface EmailViewController : MFMailComposeViewController<MFMailComposeViewControllerDelegate>

-(void)launchMailAppOnDevice;

@end
