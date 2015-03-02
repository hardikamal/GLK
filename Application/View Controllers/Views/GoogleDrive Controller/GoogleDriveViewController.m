//
//  GoogleDriveViewController.m
//  BrainDownloader
//
//  Created by Arvind Barnwal on 8/27/14.
//  Copyright (c) 2014 Mobulous. All rights reserved.
//

#import "GoogleDriveViewController.h"
#import "GTLDrive.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import "GoogleDriveCell.h"
//#import "MBProgressHUD.h"
#import "UIAlertView+Block.h"
#import "VSGGoogleServiceDrive.h"
#import "ImportViewController.h"
#import "ImportHelper.h"

// Constants used for OAuth 2.0 authorization.
//static NSString *const kKeychainItemName = @"iOSDriveSample: Google Drive";
static NSString *const kKeychainItemName = @"PdfReaderRes";//@"PdfReaderRes";
static NSString *const kClientId =@"1009544359695-vfq6m7hltvudgj5ek5l5grcvt62hatoo.apps.googleusercontent.com";//@"102673127935-4c68qg4u5vbldb9vjs46ongsgkslcmk2.apps.googleusercontent.com";*/
static NSString *const kClientSecret =@"UTj3KeexhlkJD58AwwdLX0kQ";//@"CAOBkGq9lFmFKxT_tvDCj4sg";


@interface GoogleDriveViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    //MBProgressHUD *progressHUD;
    NSMutableArray *currentRow;
    NSMutableDictionary *dict;

}

@property (weak, readonly) VSGGoogleServiceDrive *driveService;
@property (retain) NSMutableArray *driveFiles;
@property BOOL isAuthorized;
@property (strong,nonatomic) NSString *isAuth;

- (void)toggleActionButtons:(BOOL)enabled;
- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)auth
                 error:(NSError *)error;
- (void)isAuthorizedWithAuthentication:(GTMOAuth2Authentication *)auth;
- (void)loadDriveFiles;


@end

@implementation GoogleDriveViewController
@synthesize driveFiles = _driveFiles;
@synthesize isAuthorized = _isAuthorized;
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
      [self   authButtonClicked];
      [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated
 {
    [super viewDidAppear:animated];
    // Sort Drive Files by modified date (descending order).
    [self.driveFiles sortUsingComparator:^NSComparisonResult(GTLDriveFile *lhs,
                                                             GTLDriveFile *rhs)
     {
        return [rhs.modifiedDate.date compare:lhs.modifiedDate.date];
    }];
    [self.tableView reloadData];
}

#pragma mark- Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.driveFiles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoogleDriveCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"GoogleDriveCell"];
    if(cell)
    {
       GTLDriveFile *file = [self.driveFiles objectAtIndex:indexPath.row];
       cell.lblTitle.text = file.title;
        //cell.lblSubtitle.text=file.lastModifyingUserName;
       // [cell.lblTitle setFont:[UIFont fontWithName:kFontSignikaRegular size:15]];
        
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3];
       [cell setSelectedBackgroundView:bgColorView];
        
    cell.imageView.image=[UIImage imageNamed:@"csv_image.jpeg"];
    NSString *fileExt= file.fileExtension;
    if([fileExt isEqualToString:@"pdf"])
        cell.imageView.image=[UIImage imageNamed:@"page_white_acrobat"];
    else if ([fileExt isEqualToString:@"docx"]||[fileExt isEqualToString:@"doc"])
          cell.imageView.image=[UIImage imageNamed:@"page_white_word"];
    else if ([fileExt isEqualToString:@"txt"])
            cell.imageView.image=[UIImage imageNamed:@"page_white_text"];
    }
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self startAnimator];
    NSString *downloadURL=[[self.driveFiles objectAtIndex:indexPath.row] downloadUrl];
   // GTLDriveFile *file = [self.driveFiles objectAtIndex:indexPath.row];
    GTMHTTPFetcher *fetcher = [self.driveService.fetcherService fetcherWithURLString:downloadURL];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error)

     {
         GTLDriveFile *file = [_driveFiles objectAtIndex:indexPath.row];
         NSString *filename;
         NSLog(@"%@",file.fileSize);
         NSLog(@"%@",file.title);
         if(file.downloadUrl!= nil)
         {
             if (data!=nil)
                 
             {
                 filename=file.title;
                 
                 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                 
                 NSString *documentsDirectory = [paths objectAtIndex:0];
                 
                 documentsDirectory = [[paths objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",filename]];
                 [data writeToFile:documentsDirectory atomically:YES];
                 NSLog(@"my path:%@",documentsDirectory);
                 NSDictionary *GoogleDriveInfo=@{@"documentDirectory":documentsDirectory,@"fileName":filename};
                 [[NSNotificationCenter defaultCenter]postNotificationName:@"GoogleDrive" object:nil userInfo:GoogleDriveInfo];
                // [Utility showAlertWithMassager:self.navigationController.view :@"File downloaded"];
                 [self loadData:documentsDirectory];
             }
         }
         else
         {
             NSLog(@"Error - %@", error.description);
         }
     }];
}


-(void) parserDidBeginDocument:(CHCSVParser *)parser
{
    currentRow = [[NSMutableArray alloc] init];
}

-(void) parserDidEndDocument:(CHCSVParser *)parser
{
    for(int i=0;i<[currentRow count];i++)
    {
        NSLog(@"%@          %@          %@",[[currentRow objectAtIndex:i] valueForKey:[NSString stringWithFormat:@"0"]],[[currentRow objectAtIndex:i] valueForKey:[NSString stringWithFormat:@"1"]],[[currentRow objectAtIndex:i] valueForKey:[NSString stringWithFormat:@"2"]]);
    }
}


- (void) parser:(CHCSVParser *)parser didFailWithError:(NSError *)error
{
    NSLog(@"Parser failed with error: %@ %@", [error localizedDescription], [error userInfo]);
}

-(void)parser:(CHCSVParser *)parser didBeginLine:(NSUInteger)recordNumber
{
    dict=[[NSMutableDictionary alloc]init];
    
}

-(void)parser:(CHCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex
{
    [dict setObject:field forKey:[NSString stringWithFormat:@"%ld",(long)fieldIndex]];
    
}

- (void) parser:(CHCSVParser *)parser didEndLine:(NSUInteger)lineNumber
{
    [currentRow addObject:dict];
     dict=nil;
}

-(void)loadData:(NSString*)urlString
{
    
    NSURL *fileURL = [NSURL fileURLWithPath:urlString isDirectory:NO];
    CHCSVParser *parser=[[CHCSVParser alloc] initWithContentsOfDelimitedURL:fileURL delimiter:','];
    parser.delegate=self;
    [parser parse];
    if ([currentRow count]!=0)
    {
        NSDictionary *dictionary=[currentRow objectAtIndex:0];
        if ([[dictionary allKeys] count]==40)
        {
            int changeTokenIdOrNot = 0;
            changeTokenIdOrNot= [[ImportHelper sharedCoreDataController] getChangeTokenIdOrNot:[[currentRow objectAtIndex:0] valueForKey:[NSString stringWithFormat:@"%d",1]]];
            if (changeTokenIdOrNot==0)
            {
                [self stopAnimator];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:NSLocalizedString(@"data_not_imported_because_ofaccountmismatch", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
            }else
            {
                [[ImportHelper sharedCoreDataController] ExportNewfile:currentRow];
                [self stopAnimator];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Success" message:NSLocalizedString(@"data_imported_successfully", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
            }
        }
        
    }
}



- (GTLServiceDrive *)driveService
{
    static GTLServiceDrive *service = nil;
    if (!service)
    {
        service = [[GTLServiceDrive alloc] init];
        
        // Have the service object set tickets to fetch consecutive pages
        // of the feed so we do not need to manually fetch them.
        service.shouldFetchNextPages = YES;
        
        // Have the service object set tickets to retry temporary error conditions
        // automatically.
        service.retryEnabled = YES;
    }
    return service;
}



- (void)authButtonClicked
{
    self.isAuth=[[NSUserDefaults standardUserDefaults] objectForKey:@"isAuth"];
    if ([[self isAuth] length]==0)
    {
        // Sign in.
        SEL finishedSelector = @selector(viewController:finishedWithAuth:error:);
        GTMOAuth2ViewControllerTouch *authViewController =[[GTMOAuth2ViewControllerTouch alloc] initWithScope:kGTLAuthScopeDrive
          clientID:kClientId clientSecret:kClientSecret keychainItemName:kKeychainItemName delegate:self finishedSelector:finishedSelector];
        
        [self presentViewController:authViewController animated:YES completion:nil];
    } else
    {
       [self isAuthorizedWithAuthentication:[[VSGGoogleServiceDrive sharedService] authorizer]];
    }
}

- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController finishedWithAuth:(GTMOAuth2Authentication *)auth  error:(NSError *)error
{

    [self dismissViewControllerAnimated:YES completion:nil];
    if (error == nil)
    {
        _isAuth=@"101";
        [self.authButton setTitle:@"Sign out" forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults]setObject:_isAuth forKey:@"isAuth"];
        [self isAuthorizedWithAuthentication:auth];
    }else
    {
        [self showAlert:@"Google Drive" message:@"Sorry, an error occurred!"];
        
    }
}



- (void)isAuthorizedWithAuthentication:(GTMOAuth2Authentication *)auth
{
     [[self driveService] setAuthorizer:auth];
     self.isAuthorized = YES;
     [self loadDriveFiles];
}


- (void)loadDriveFiles
{
    [self startAnimator];
    GTLQueryDrive *query = [GTLQueryDrive queryForFilesList];
    if ([self.mainTitle isEqualToString:NSLocalizedString(@"viewReports", nil)])
    {
      query.q = @"mimeType = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'";
    }else
         query.q = @"mimeType = 'text/csv'";
   
  //  query.q = @"mimeType = 'text/plain' or mimeType = 'application/pdf' or mimeType = 'text/csv' or mimeType = 'application/msword' or mimeType= 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'" ;
    [self.driveService executeQuery:query completionHandler:^(GTLServiceTicket *ticket,  GTLDriveFileList *files,  NSError *error)
    {
        if (error == nil)
        {
            if (self.driveFiles == nil)
            {
                self.driveFiles = [[NSMutableArray alloc] init];
            }
            [self.driveFiles removeAllObjects];
            [self.driveFiles addObjectsFromArray:files.items];
            GTLDriveFile *file = files.items[0]; // assume file is assigned to a valid instance.
            NSMutableDictionary *jsonDict = file.exportLinks.JSON;
            NSLog(@"URL:%@.", [jsonDict objectForKey:@"text/plain"]);
            [self.tableView reloadData];
            [self stopAnimator];
           } else
           {
             NSLog(@"An error occurred: %@", error);
            [self showAlert:@"Google Drive" message:@"Sorry, an error occurred!"];
         }
    }];
}

- (UIAlertView*)showWaitIndicator:(NSString *)title
{
    UIAlertView *progressAlert;
    progressAlert = [[UIAlertView alloc] initWithTitle:title    message:@"Please wait..."   delegate:self  cancelButtonTitle:nil
         otherButtonTitles:nil];
    [progressAlert show];
    UIActivityIndicatorView *activityView;
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityView.center = CGPointMake(progressAlert.bounds.size.width / 2,  progressAlert.bounds.size.height - 45);
    [progressAlert addSubview:activityView];
    [activityView startAnimating];
    return progressAlert;
}

- (void)showAlert:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle: title   message: message  delegate:self cancelButtonTitle: @"OK" otherButtonTitles: nil];
    [alert show];
}

#pragma mark- mb progress HUd
-(void)startAnimator
{
//    progressHUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    progressHUD.labelText=@"Please wait...";
}
-(void)stopAnimator
{
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//     progressHUD=nil;
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)authButtonClicked:(id)sender
{
        [self authButtonClicked];
}
@end
