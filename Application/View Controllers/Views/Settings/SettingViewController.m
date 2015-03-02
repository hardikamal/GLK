//
//  SettingViewController.m
//  Daily Expense Manager
//
//  Created by Appbulous on 21/10/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import "SettingViewController.h"

//#import "DeleteDemDataViewController.h"
//#import "ReSetPasswordViewController.h"
//#import "ExportViewController.h"
//#import "GoogleDriveViewController.h"
#import "HomeHelper.h"
//#import "EmailViewController.h"
#import "HelpViewController.h"
@interface SettingViewController ()

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {// Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [Utility setFontFamily:Embrima forView:self.view andSubViews:YES];
    self.btnCategery.titleLabel.font =[UIFont fontWithName:Embrima size:16.0f];
    self.btnChangeLog.titleLabel.font =[UIFont fontWithName:Embrima size:16.0f];
    self.btnContactDem.titleLabel.font =[UIFont fontWithName:Embrima size:16.0f];
    self.btnCurrency.titleLabel.font =[UIFont fontWithName:Embrima size:16.0f];
    self.btnDeleteDem.titleLabel.font =[UIFont fontWithName:Embrima size:16.0f];
    self.btnExport.titleLabel.font =[UIFont fontWithName:Embrima size:16.0f];
    self.btnImport.titleLabel.font =[UIFont fontWithName:Embrima size:16.0f];
    self.btnPassword.titleLabel.font =[UIFont fontWithName:Embrima size:16.0f];
    self.btnPaymentMode.titleLabel.font =[UIFont fontWithName:Embrima size:16.0f];
    self.btnViewReport.titleLabel.font =[UIFont fontWithName:Embrima size:16.0f];
    [self.lblTitle setFont:[UIFont fontWithName:Ebrima_Bold size:17.0f]];
    [self.lblDatabase setFont:[UIFont fontWithName:Ebrima_Bold size:16.0f]];
    [self.lblDispaly setFont:[UIFont fontWithName:Ebrima_Bold size:16.0f]];
    [self.lblExtra setFont:[UIFont fontWithName:Ebrima_Bold size:16.0f]];
    [self.lblSecurity setFont:[UIFont fontWithName:Ebrima_Bold size:16.0f]];
    [self.lblProfile setFont:[UIFont fontWithName:Ebrima_Bold size:16.0f]];
  
    CGFloat borderWidth = .3f;
    self.scrollView.frame = CGRectInset(self.scrollView.frame, -borderWidth, -borderWidth);
    self.scrollView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.scrollView.layer.borderWidth = borderWidth;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"ImportViewController" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedSelectViewListNotification:) name:@"CustomizeExportViewController" object:nil];
}



-(void)viewWillAppear:(BOOL)animated
{
    NSString *mainToken=[[[Utility userDefaultsForKey:CURRENT_TOKEN_ID] componentsSeparatedByString:@"_"] objectAtIndex:0];
    NSString *currency= [Utility userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",CURRENT_CURRENCY,mainToken]];
   // [self.btnChangeCurrency setTitle:[NSString stringWithFormat:@"%@ (%@)",NSLocalizedString(@"selectCurrency", nil), [[currency componentsSeparatedByString:@"-"] objectAtIndex:1]] forState:UIControlStateNormal];
  
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:LOCK_SCREEN_PASSWORD] length]!=0)
    {
        [self.btnPassword setImage:[UIImage   imageNamed:@"check_box_actives.png"] forState:UIControlStateNormal];
    }
    if ([mainToken isEqualToString:@"0"])
    {
        [self.profileView setUserInteractionEnabled:NO];
        [self.profileView setHidden:YES];
        [self.securityView setFrame:CGRectMake(self.profileView.frame.origin.x, self.profileView.frame.origin.y, self.securityView.frame.size.width, self.securityView.frame.size.height)];
          self.scrollView.contentSize = CGSizeMake(310, 700);
    }else
          self.scrollView.contentSize = CGSizeMake(310, 815);
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:UPDATION_ON_SERVER_TIME])
    {
        [[HomeHelper sharedCoreDataController] upgradeBackendDataOnServer];
    }
}


-(void)receiveNotification:(NSNotification*) notification
{
    HelpViewController *driverController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:Nil]instantiateViewControllerWithIdentifier:@"HelpViewController"];
    NSDictionary * info =notification.userInfo;
    [driverController setXlsPath:[info objectForKey:@"urlpath"]];
    [self.navigationController pushViewController:driverController animated:YES];
}


-(void)receivedSelectViewListNotification:(NSNotification*) notification
{
   // [self.exportViewController.view removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)btnExportClick:(id)sender
{
//    self.exportViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:Nil] instantiateViewControllerWithIdentifier:@"ExportViewController"];
//    [self.exportViewController show];
}

- (IBAction)btnImportClick:(id)sender
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:nil      message:nil     delegate:self     cancelButtonTitle: @"Cancel"  otherButtonTitles:@"Download via Google Drive", @"Import via Existing File", @"Import via Mail", nil];
    [message show];
}

- (IBAction)btnChangeCurrency:(UIButton*)sender
{
    NSString *mainToken=[[[Utility userDefaultsForKey:CURRENT_TOKEN_ID] componentsSeparatedByString:@"_"] objectAtIndex:0];
    NSString *currency= [Utility userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",CURRENT_CURRENCY,mainToken]];
    [sender setTitle:[NSString stringWithFormat:@"%@ (%@)",NSLocalizedString(@"selectCurrency", nil), [[currency componentsSeparatedByString:@"-"] objectAtIndex:1]] forState:UIControlStateNormal];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
//    if([title isEqualToString:@"Download via Google Drive"])
//    {
//        GoogleDriveViewController *driverController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:Nil]instantiateViewControllerWithIdentifier:@"GoogleDriveViewController"];
//        [self.navigationController pushViewController:driverController animated:YES];
//    }
//    else if([title isEqualToString:@"Import via Existing File"])
//    {
//        self.importPopUpViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:Nil]instantiateViewControllerWithIdentifier:@"ImportViewController"];
//        [self.importPopUpViewController setMainTitle:NSLocalizedString(@"importdata", nil
//                                                                      )];
//        [self.view addSubview:self.importPopUpViewController.view];
//        
//    } if([title isEqualToString:@"View via Google Drive"])
//    {
//        GoogleDriveViewController *driverController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:Nil]instantiateViewControllerWithIdentifier:@"GoogleDriveViewController"];
//        [driverController setMainTitle:NSLocalizedString(@"viewReports", nil )];
//        [self.navigationController pushViewController:driverController animated:YES];
//    }
//    else if([title isEqualToString:@"View via Existing File"])
//    {
//         self.importPopUpViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:Nil]instantiateViewControllerWithIdentifier:@"ImportViewController"];
//          [self.importPopUpViewController setMainTitle:NSLocalizedString(@"viewReports", nil )];
//        [self.view addSubview:self.importPopUpViewController.view];
//        
//    }
//    else if([title isEqualToString: @"Import via Mail"])
//    {
//        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Alert"      message:@"Open Mail and long press the selected .csv file to import and you should see Goollak app listed as one of the 'Open in' apps"     delegate:self     cancelButtonTitle: @"OK"  otherButtonTitles:nil, nil];
//        [message show];
//    }
}




- (IBAction)btnUnChekClick:(id)sender
{
    UIImage *secondImage = [UIImage imageNamed:@"check_box_actives.png"];
    NSData *imgData1 = UIImagePNGRepresentation(self.btnPassword.imageView.image);
    NSData *imgData2 = UIImagePNGRepresentation(secondImage);
    BOOL isCompare =  [imgData1 isEqual:imgData2];
    if(isCompare)
    {
        [self.btnPassword setImage:[UIImage   imageNamed:@"check_boxs.png"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:LOCK_SCREEN_PASSWORD];
    }
    else
    {
//        ReSetPasswordViewController *catageryController=[self.storyboard instantiateViewControllerWithIdentifier:@"ReSetPasswordViewController"];
//        [self.navigationController pushViewController:catageryController animated:YES];
    }
}



- (IBAction)btnBackClick:(id)sender
{
   
}



- (IBAction)btnDeleteClick:(id)sender
{
//    self.objCustomPopUpViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:Nil]instantiateViewControllerWithIdentifier:@"DeleteDemDataViewController"];
//    [self.view addSubview: self.objCustomPopUpViewController.view];
}


- (IBAction)btnContactDemSupportClick:(id)sender
{
//    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
//    if (mailClass != nil)
//    {
//        // We must always check whether the current device is configured for sending emails
//        if ([mailClass canSendMail])
//        {
//            EmailViewController* picker = [[EmailViewController alloc] init];
//            // Email Subject
//            NSString *emailTitle = @"Goollak - Expense Manager version 1.0";
//            NSString *bodyText = [[NSString alloc] initWithFormat:@"<html><p><br>Device Name  : %@<br><br>IMEI no :%@ <br><br>Ios Release : %@<br><br>%@<br></p></html",[Utility machineName] ,[Utility uniqueIDForDevice] ,@"1.0.0" ,NSLocalizedString(@"phonenumber", nil)];
//            NSArray *toRecipents = [NSArray arrayWithObject:NSLocalizedString(@"feedback_EMail_ID", nil)];
//            [picker setSubject:emailTitle];
//            [picker setMessageBody:bodyText isHTML:YES];
//            [picker setToRecipients:toRecipents];
//            [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:picker  animated:YES  completion:nil];
//        }
//        else
//        {
//            UIAlertView *newAlertView=[[UIAlertView alloc]initWithTitle:@"" message:@"Email is not configured. Go to iPad settings> mail contacts, calendars > add account." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//            [newAlertView show];
//        }
//    }
//
    
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain   target:nil  action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];
}


- (IBAction)btnViewReportClick:(id)sender
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:nil      message:nil     delegate:self     cancelButtonTitle: @"Cancel"  otherButtonTitles:@"View via Google Drive", @"View via Existing File", nil];
    [message show];
}
@end
