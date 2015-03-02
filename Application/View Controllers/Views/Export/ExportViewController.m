//
//  ExportViewController.m
//  Daily Expense Manager
//
//  Created by Appbulous on 25/11/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import "ExportViewController.h"
#import "Transactions.h"
#import "TransactionHandler.h"
#import "Transfer.h"
#import "TransferHandler.h"
#import "ReminderHandler.h"
#import "Reminder.h"
#import "Budget.h"
#import "BudgetHandler.h"
#import "CategoryList.h"
#import "CategoryList.h"
#import "Paymentmode.h"
#import "PaymentmodeHandler.h"
#import "UserInfoHandler.h"
#import "UserInfo.h"
#import "CustomizeExportViewController.h"
#import "UIAlertView+Block.h"
#import "VSGGoogleServiceDrive.h"
#import "GoogleDriveViewController.h"
#import "EmailViewController.h"
//#import "MBProgressHUD.h"

// Constants used for OAuth 2.0 authorization.
//static NSString *const kKeychainItemName = @"iOSDriveSample: Google Drive";
static NSString *const kKeychainItemName = @"PdfReaderRes";//@"PdfReaderRes";
static NSString *const kClientId =@"1009544359695-vfq6m7hltvudgj5ek5l5grcvt62hatoo.apps.googleusercontent.com";//@"102673127935-4c68qg4u5vbldb9vjs46ongsgkslcmk2.apps.googleusercontent.com";*/
static NSString *const kClientSecret =@"UTj3KeexhlkJD58AwwdLX0kQ";//@"CAOBkGq9lFmFKxT_tvDCj4sg";



@interface ExportViewController ()
{
    NSMutableArray *item;
    NSMutableDictionary *dict;
    NSMutableArray *currentRow;
    NSMutableArray *fieldNames;
    NSString *currentFilePath;
    //MBProgressHUD *  progressHUD;
}

@end


@implementation ExportViewController
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    currentFilePath=[[NSString alloc] init];
    [Utility setFontFamily:Embrima forView:self.view andSubViews:YES];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    tapRecognizer.numberOfTapsRequired = 1;
    self.tapView.userInteractionEnabled=YES;
    [self.tapView addGestureRecognizer:tapRecognizer];
    [self.lblTitle setFont:[UIFont fontWithName:Ebrima_Bold size:16.0f]];
    [self.tableView setScrollEnabled:NO];
    item=[[NSMutableArray alloc] initWithObjects:NSLocalizedString(@"Detailed", nil),NSLocalizedString(@"Summarized", nil),NSLocalizedString(@"CustomizeExport", nil),NSLocalizedString(@"cancel", nil), nil];
    CGRect frame;
    frame = self.tableView.frame;
    frame.size.height = ([item count])*44;
    self.tableView.frame = frame;
    
    frame = self.topView.frame;
    frame.size.height = self.tableView.frame.size.height+40;
    self.topView.frame = frame;
    
    CGFloat xWidth = self.topView.frame.size.width;
    CGFloat yHeight = self.topView.frame.size.height;
    CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
    [self.topView setFrame:CGRectMake(5, yOffset, xWidth, yHeight)];
    self.topView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.topView.layer.borderWidth = 1.0f;
    self.topView.clipsToBounds = TRUE;
    [self.topView didMoveToSuperview];
    fieldNames=[[NSMutableArray alloc] initWithObjects:@"type",@"token_id",@"transaction_type",@"transaction_id",@"pic", @"user_token_id",@"category",@"sub_category", @"amount",@"updation_date",@"server_updation_date", @"date",@"location", @"description", @"paymentMode",@"with_person",@"shown_on_homescreen",@"warranty",@"transaction_reference_id",@"reminder_heading",@"reminder_when_to_alert",@"reminder_time_period",@"reminder_sub_alarm",@"reminder_recurring_type",@"reminder_alarm",@"reminder_alert",@"fromaccount",@"toaccount",@"income_transaction_id",@"expense_transaction_id",@"email_id",@"address",@"password",@"hide_status",@"user_dob",@"user_name",@"fromdate",@"todate",@"transaction_inserted_from",@"class", nil];
    
}


- (IBAction)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [self.view removeFromSuperview];
}

// Do any additional setup after loading the view.

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [item count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] ;
    }
    if ([[item objectAtIndex:[indexPath row]] isEqualToString:NSLocalizedString(@"cancel", nil)])
    {
         UILabel *textLabel=[[UILabel alloc] init];
         textLabel.font=[UIFont fontWithName:Embrima size:16];
         textLabel.textColor=[UIColor darkGrayColor];
         textLabel.text = [item objectAtIndex:[indexPath row]];
        [textLabel setFrame:CGRectMake(130, 0, 150, 44)];
        [cell addSubview:textLabel];
        
    }else
    {
        cell.textLabel.font=[UIFont fontWithName:Embrima size:16];
        cell.textLabel.textColor=[UIColor darkGrayColor];
        cell.textLabel.text = [item objectAtIndex:[indexPath row]];
        UIImage *image=[UIImage imageNamed:@"black_export_icon.png"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTag:100];
        CGRect frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
        button.frame = frame;
        [button setImage:image forState:UIControlStateNormal];
        cell.accessoryView = button;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
            [self showAlertViewforRightCsv:(int)[indexPath row]];
            [self.topView removeFromSuperview];
            break;
        case 1:
            [self showAlertViewforRightCsv:(int)[indexPath row]];
            [self.topView removeFromSuperview];
            break;
        case 2:
            [self customeize];
            break;
        case 3:
            [self.view removeFromSuperview];
            break;
    }
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

-(void)customeize
{
    self.objCustomPopUpViewController =[self.storyboard instantiateViewControllerWithIdentifier:@"CustomizeExportViewController"];
    [self.view addSubview: self.objCustomPopUpViewController.view];
}


-(void)showAlertViewforRightCsv:(int)tag
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"enter_file_name", nil)  message:@"-"  delegate:self cancelButtonTitle:@"Export" otherButtonTitles:NSLocalizedString(@"cancel", nil), nil];
    [alertView setTag:tag];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    long long milliseconds = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
    NSString *strubg= [[NSNumber numberWithUnsignedLongLong:milliseconds] stringValue];
    [alertView textFieldAtIndex:0].text =[NSString stringWithFormat:@"%@%@",@"MyTransaction",strubg];
    [alertView textFieldAtIndex:0].textColor =[UIColor darkGrayColor];
    [alertView show];
    
}


-(void)rightCsvfromCoreData:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:fileName];
    currentFilePath=path;
    CHCSVWriter *csvWriter=[[CHCSVWriter alloc]initForWritingToCSVFile:path];
    for (NSString *string in fieldNames)
    {
        [csvWriter writeField:string];
    }
    [csvWriter finishLine];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.S"];
    NSArray *transactionItems=[[TransactionHandler sharedCoreDataController] getAllUserTransaction];
    for (Transactions *transaction  in transactionItems)
    {
        NSString *pic;
            if([transaction.pic length]!=0 && ![[Utility userDefaultsForKey:MAIN_TOKEN_ID ] isEqualToString:@"0"])
            {
                pic=[NSString stringWithFormat:@"%@%@",transactionPicURL,[NSString stringWithFormat:@"%@_%@",transaction.transaction_id,transaction.token_id]];
            }else
            {
                pic=@"";
            }
        NSString *transaction_type;
        if ([transaction.transaction_type intValue] ==TYPE_INCOME)
        {
            transaction_type=NSLocalizedString(@"income", nil);
        }else
        {
            transaction_type=NSLocalizedString(@"expense", nil);
        }
       
      NSArray *array =[[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"%d",TYPE_TRANSACTION],transaction.token_id,transaction_type,transaction.transaction_id,pic,transaction.user_token_id,transaction.category,transaction.sub_category,[transaction.amount stringValue],[transaction.updation_date stringValue],[transaction.server_updation_date stringValue],  [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:([[transaction.date stringValue] doubleValue] / 1000)]],transaction.location,transaction.discription, transaction.paymentMode,transaction.with_person,[transaction.show_on_homescreen stringValue] , [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:([[transaction.warranty stringValue] doubleValue] / 1000)]],transaction.transaction_reference_id,@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",transaction.transaction_inserted_from,@"-", nil];
          NSLog(@"Transactions:%lu",(unsigned long)[array count]);
        [csvWriter writeLineOfFields:array];
    }
    NSArray *transferItems=[[TransferHandler sharedCoreDataController] getAllTransfer];
    for (Transfer *transfer  in transferItems)
    {
        
        NSArray *array =[[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"%d",TYPE_TRANSFER],transfer.token_id,@"-",transfer.transaction_id,@"-",@"-",transfer.category,transfer.sub_category,[transfer.amount stringValue],[transfer.updation_date stringValue],[transfer.server_updation_date stringValue], [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:([[transfer.date stringValue] doubleValue] / 1000)]],@"-",transfer.discription, transfer.paymentMode,@"-",@"-" ,@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",transfer.fromaccount,transfer.toaccount,[transfer.income_transaction_id stringValue],transfer.expense_transaction_id,@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-", nil];
            NSLog(@"Transfer:%lu",(unsigned long)[array count]);
         [csvWriter writeLineOfFields:array];
    }
    NSArray *reminderItems=[[ReminderHandler sharedCoreDataController] getAllReminder];
    for (Reminder  *reminder  in reminderItems)
    {
         NSString *pic;
        if([reminder.pic length]!=0 && ![[Utility userDefaultsForKey:MAIN_TOKEN_ID ] isEqualToString:@"0"])
        {
            pic=[NSString stringWithFormat:@"%@%@",reminderPicURL,[NSString stringWithFormat:@"%@_%@",reminder.transaction_id,reminder.token_id]];
        }else
        {
            pic=@"";
        }
        NSArray *array =[[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"%d",TYPE_REMINDER],reminder.token_id,reminder.transaction_type,reminder.transaction_id,pic,reminder.user_token_id,reminder.category,reminder.sub_category,reminder.amount ,[reminder.updation_date stringValue],[reminder.server_updation_date stringValue], [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:([[reminder.date stringValue] doubleValue] / 1000)]],@"-",reminder.discription, reminder.paymentMode,@"-",@"-" ,@"-",@"-",reminder.reminder_heading,reminder.reminder_when_to_alert,reminder.reminder_time_period,reminder.reminder_sub_alarm,reminder.reminder_recurring_type,reminder.reminder_alarm,reminder.reminder_alert,@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-", nil];
        NSLog(@"Reminder:%lu",(unsigned long)[array count]);
        NSLog(@"%@",array);
        [csvWriter writeLineOfFields:array];
    }
    NSArray *budgettItems=[[BudgetHandler sharedCoreDataController] getAllBudget];
    for (Budget  *budget  in budgettItems)
    {
      NSArray *array=[[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"%d",TYPE_BUDGET],budget.token_id,@"-",budget.transaction_id,@"-",budget.user_token_id,budget.category,budget.sub_category,[budget.amount stringValue],[budget.updation_date stringValue],[budget.server_updation_date stringValue],@"-",@"-",budget.discription, budget.paymentMode,@"-",[budget.show_on_homescreen stringValue] ,@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:([[budget.fromdate stringValue] doubleValue] / 1000)]],[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:([[budget.todate stringValue] doubleValue] / 1000)]],@"-",@"-", nil];
        NSLog(@"Budget:%lu",(unsigned long)[array count]);
        [csvWriter writeLineOfFields:array];
    }
    NSArray *categeryItems=[[CategoryListHandler sharedCoreDataController] getAllCategory];
    for (CategoryList  *list  in categeryItems)
    {
        NSString *pic;
        if([list.category_icon length]!=0 && ![[Utility userDefaultsForKey:MAIN_TOKEN_ID ] isEqualToString:@"0"])
        {
            pic=[NSString stringWithFormat:@"%@%@",categoryPicURL,[NSString stringWithFormat:@"%@_%@",list.transaction_id,list.token_id]];
        }else
        {
            pic=@"";
        }
        NSArray *array =[[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"%d",TYPE_CATEGORY],list.token_id,@"_",list.transaction_id,pic,@"-",list.category,list.sub_category,@"-",[list.updation_date stringValue],[list.server_updation_date stringValue], @"-",@"-",@"-", @"-",@"-",@"-" ,@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",[list.hide_status stringValue],@"-",@"-",@"-",@"-",@"-",[list.class_type stringValue], nil];
        NSLog(@"CategoryList:%lu",(unsigned long)[array count]);
        [csvWriter writeLineOfFields:array];
    }
    NSArray *PaymentModeItems=[[PaymentmodeHandler sharedCoreDataController] getDefaultPaymentModeBeanList];
    for (Paymentmode  *list  in PaymentModeItems)
    {
        NSMutableArray *newarray=[[NSMutableArray alloc] init];
        [newarray addObject:[NSString stringWithFormat:@"%d",TYPE_PAYMENT]];
        [newarray addObject:list.token_id];
        [newarray addObject:@"-"];
        [newarray addObject:list.transaction_id];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:[list.updation_date stringValue]];
        [newarray addObject:[list.server_updation_date stringValue]];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:list.paymentMode];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:[list.hide_status stringValue]];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [csvWriter writeLineOfFields:newarray];
        NSLog(@"PaymentMode:%lu",(unsigned long)[newarray count]);
        NSLog(@"%@",newarray);
    }
    
    NSArray *userItems=[[UserInfoHandler sharedCoreDataController] getAllUserDetails];
    for (UserInfo  *user  in userItems)
    {
        NSMutableArray *newarray=[[NSMutableArray alloc] init];
        [newarray addObject:[NSString stringWithFormat:@"%d",USER_ACCOUNT]];
        [newarray addObject:user.token_id];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:user.user_token_id];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:[user.updation_date stringValue]];
        [newarray addObject:[user.server_updation_date stringValue]];
        [newarray addObject:@"-"];
        [newarray addObject:[user.location stringValue]];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:user.email_id];
        [newarray addObject:user.address];
        [newarray addObject:user.password];
        [newarray addObject:[user.hide_status stringValue]];
        [newarray addObject:user.user_dob];
        [newarray addObject:user.user_name];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        [newarray addObject:@"-"];
        NSLog(@"UserInfo:%lu",(unsigned long)[newarray count]);
        [csvWriter writeLineOfFields:newarray];
    }
    [csvWriter closeStream];
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//    progressHUD=nil;
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"successfully_exported_popup_text", nil) message:NSLocalizedString(@"send_mail", nil) delegate:self cancelButtonTitle:@"Now" otherButtonTitles:@"Later", nil];
    [alert setTag:10];
    [alert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Export"])
    {
        if (alertView.tag==0)
        {
//            progressHUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            progressHUD.labelText=NSLocalizedString(@"exporting_database", nil);
            UITextField *textField = [alertView textFieldAtIndex:0];
            [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(handleTimer:)
               userInfo:[NSString stringWithFormat:@"%@.csv",textField.text] repeats:NO];
        }else if (alertView.tag==1)
        {
//            progressHUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            progressHUD.labelText=NSLocalizedString(@"exporting_database", nil);
            UITextField *textField = [alertView textFieldAtIndex:0];
            [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(handleTimer:) userInfo:[NSString stringWithFormat:@"%@.xls",textField.text] repeats:NO];
        }
    }
    if([title isEqualToString:@"Now"])
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:nil      message:nil     delegate:self     cancelButtonTitle: @"Cancel"  otherButtonTitles:@"Export via Google Drive", @"Export via Email", nil];
        [message show];
    }
    if([title isEqualToString:@"Cancel"] || [title isEqualToString:@"Later"])
    {
        [self.view removeFromSuperview];
    }
    else if([title isEqualToString:@"Export via Google Drive"])
    {
        [self PermisonGogleDrive];
    }
    else if([title isEqualToString:@"Export via Email"])
    {
        [self composeMail];
    }
}


- (void)handleTimer:(NSTimer*)theTimer
{
       [self rightCsvfromCoreData:(NSString*)[theTimer userInfo]];
}

- (void)showAlert:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle: title   message: message  delegate:self cancelButtonTitle: @"OK" otherButtonTitles: nil];
    [alert show];
}


-(void)PermisonGogleDrive
{
    self.isAuth=[[NSUserDefaults standardUserDefaults] objectForKey:@"isAuth"];
    if ([[self isAuth] length]==0)
    {
        SEL finishedSelector = @selector(viewController:finishedWithAuth:error:);
        GTMOAuth2ViewControllerTouch *authViewController =[[GTMOAuth2ViewControllerTouch alloc] initWithScope:kGTLAuthScopeDrive clientID:kClientId clientSecret:kClientSecret keychainItemName:kKeychainItemName delegate:self finishedSelector:finishedSelector];
        [self presentViewController:authViewController animated:YES completion:nil];
    } else
    {
        [self isAuthorizedWithAuthentication:[[VSGGoogleServiceDrive sharedService] authorizer]];
    }
}


-(void)sendToGogleDrive
{
    NSData *fileData = [NSData dataWithContentsOfFile:currentFilePath];
    NSArray *filepart = [currentFilePath componentsSeparatedByString:@"/"];
    NSString *filename = [filepart lastObject];
    NSString *extension = [[[filepart lastObject] componentsSeparatedByString:@"."] lastObject];
    GTLDriveFile *file = [GTLDriveFile object];
    file.title = filename;
    file.descriptionProperty = NSLocalizedString(@"Daily_Expense_Manager_Backup", nil);
    NSString *mimeType;
    if ([extension isEqualToString:@"jpg"])
    {
        mimeType = @"image/jpeg";
    } else if ([extension isEqualToString:@"xls"])
    {
        mimeType = @"application/vnd.ms-excel";;
    } else if ([extension isEqualToString:@"doc"])
    {
        mimeType = @"application/msword";
    } else if ([extension isEqualToString:@"ppt"])
    {
        mimeType = @"application/vnd.ms-powerpoint";
    } else if ([extension isEqualToString:@"csv"])
    {
        mimeType =@"text/csv";
    } else if ([extension isEqualToString:@"pdf"])
    {
        mimeType = @"application/pdf";
    }
    file.mimeType = mimeType;
    
    GTLUploadParameters *uploadParameters = [GTLUploadParameters uploadParametersWithData:fileData MIMEType:file.mimeType];
    GTLQueryDrive *query = [GTLQueryDrive queryForFilesInsertWithObject:file  uploadParameters:uploadParameters];
    UIAlertView *waitIndicator = [self showWaitIndicator:@"Uploading to Google Drive"];
    [self.driveService executeQuery:query completionHandler:^(GTLServiceTicket *ticket,   GTLDriveFile *insertedFile, NSError *error)
     {
         [waitIndicator dismissWithClickedButtonIndex:0 animated:YES];
         if (error == nil)
         {
              NSLog(@"File ID: %@", insertedFile.identifier);
             [self showAlert:@"Google Drive" message:@"File saved!"];
             [self.view removeFromSuperview];
         }
         else
         {
              NSLog(@"An error occurred: %@", error);
             [self showAlert:@"Google Drive" message:@"Sorry, an error occurred!"];
             [self.view removeFromSuperview];
         }
     }];
}



- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController finishedWithAuth:(GTMOAuth2Authentication *)auth  error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (error == nil)
    {
        _isAuth=@"101";
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
     [self sendToGogleDrive];
}



-(void)composeMail
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        // We must always check whether the current device is configured for sending emails
        if ([mailClass canSendMail])
        {
            EmailViewController* picker = [[EmailViewController alloc] init];
            NSArray *toRecipents = [NSArray arrayWithObject:@"rewachandan05@gmail.com"];
            [picker setToRecipients:toRecipents];
            [picker setSubject:NSLocalizedString(@"Daily_Expense_Manager_Backup", nil)];
            NSData *fileData = [NSData dataWithContentsOfFile:currentFilePath];
            NSArray *filepart = [currentFilePath componentsSeparatedByString:@"/"];
            NSString *filename = [filepart lastObject];
            NSString *extension = [[[filepart lastObject] componentsSeparatedByString:@"."] lastObject];
            NSString *mimeType;
            if ([extension isEqualToString:@"xls"])
            {
                mimeType = @"application/vnd.ms-excel";;
            } else if ([extension isEqualToString:@"csv"])
            {
                mimeType =@"text/csv";
            }
            [picker addAttachmentData:fileData mimeType:mimeType fileName:filename];
           [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:picker  animated:YES  completion:nil];
        }
        else
        {
            UIAlertView *newAlertView=[[UIAlertView alloc]initWithTitle:@"" message:@"Email is not configured. Go to iPad settings> mail contacts, calendars > add account." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [newAlertView show];
        }
    }
}


// Helper for showing a wait indicator in a popup
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



@end
