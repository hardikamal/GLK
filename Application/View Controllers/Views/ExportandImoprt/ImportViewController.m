//
//  ImportViewController.m
//  Daily Expense Manager
//
//  Created by Appbulous on 25/11/14.
//  Copyright (c) 914 Jyoti Kumar. All rights reserved.
//

#import "ImportViewController.h"
#import "CustomizeExportViewController.h"
//#import "MBProgressHUD.h"
#import "HelpViewController.h"
#import "ImportHelper.h"


@interface ImportViewController ()
{
   // MBProgressHUD *  progressHUD;
    NSMutableArray *item;
    NSMutableDictionary *dict;
    NSMutableArray *currentRow;
}
@end


@implementation ImportViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    [Utility setFontFamily:Embrima forView:self.view andSubViews:YES];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    tapRecognizer.numberOfTapsRequired = 1;
     self.tapView.userInteractionEnabled=YES;
    [self.lblImport setFont:[UIFont fontWithName:Ebrima_Bold size:16.0f]];
    [self.tapView addGestureRecognizer:tapRecognizer];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    CGFloat xWidth = self.topView.frame.size.width;
    CGFloat yHeight = self.topView.frame.size.height;
    CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
    [self.topView setFrame:CGRectMake(5, yOffset, xWidth, yHeight)];
    
    [self.topView didMoveToSuperview];
    if ([self.mainTitle isEqualToString:NSLocalizedString(@"viewReports", nil)])
    {
        [self.lblImport setText:self.mainTitle];
        [self.imgTitle setImage:[UIImage imageNamed:@"white_viewreport_icon.png"]];
        [self getAllXlsFileForImport];
    }else
    {
        [self getAllCsvFileForImport];

    }
}




-(void)getAllXlsFileForImport
{
    
    item=[[NSMutableArray alloc] init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentDirectory error:nil];
    
    for (NSString *tString in dirContents)
    {
        if ([tString hasSuffix:@".xls"])
        {
            [item addObject:tString];
        }
    }
     [self updateTopView];
}





-(void)getAllCsvFileForImport
{
    
    item=[[NSMutableArray alloc] init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentDirectory error:nil];
    
    for (NSString *tString in dirContents)
    {
        if ([tString hasSuffix:@".csv"])
        {
            [item addObject:tString];
        }
    }
    [self updateTopView];
}



-(void)updateTopView
{
    if ([item count]==0)
    {
        UILabel *fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 300, 40)];
        fromLabel.text =NSLocalizedString(@"no_files_found", nil);
        fromLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
        fromLabel.backgroundColor = [UIColor clearColor];
        fromLabel.textColor = [UIColor darkGrayColor];
        fromLabel.textAlignment = NSTextAlignmentLeft;
        [fromLabel setFont:[UIFont fontWithName:Embrima size:20.0f]];
        [self.topView addSubview:fromLabel];
        [self.tableView setHidden:YES];
    }else
    {
        CGFloat xWidth = self.topView.bounds.size.width;
        CGFloat yHeight = [item count]*55+80;
        if (yHeight>self.view.frame.size.height-100)
        {
            yHeight=self.view.frame.size.height-100;
            [self.tableView setFrame:CGRectMake(0, self.tableView.frame.origin.y, xWidth, yHeight-80)];
        }else
             [self.tableView setFrame:CGRectMake(0, self.tableView.frame.origin.y, xWidth, yHeight-40)];
        CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
        [self.topView setFrame:CGRectMake(5, yOffset, xWidth, yHeight)];
   
        [self.btnCancel setFrame:CGRectMake(self.btnCancel.frame.origin.x, yHeight-40, xWidth, self.btnCancel.frame.size.height)];
        if (yHeight<self.view.frame.size.height-100)
        {
            self.tableView.scrollEnabled = FALSE;
        }
        [self.tableView reloadData];
    }

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    cell.textLabel.font=[UIFont fontWithName:Embrima size:12];
    cell.textLabel.textColor=[UIColor darkGrayColor];
    cell.textLabel.text = [item objectAtIndex:[indexPath row]];
    UIImage *image=[UIImage imageNamed:@"black_export_icon.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTag:100];
    CGRect frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    button.frame = frame;
    [button setImage:image forState:UIControlStateNormal];
    cell.accessoryView = button;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *csvPath = [docsPath stringByAppendingPathComponent:[item objectAtIndex:[indexPath row]]];
    if ([self.mainTitle isEqualToString:NSLocalizedString(@"viewReports", nil)])
    {
        [self handleXlsURL:csvPath];
    }else
    {
        [self.topView removeFromSuperview];
//        progressHUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        progressHUD.detailsLabelText=NSLocalizedString(@"importfile", nil);
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(handleTimer:)  userInfo:csvPath repeats:NO];
    }
}

-(void) handleXlsURL:(NSString *)url
{
    NSString * noticationName =@"ImportViewController";
    NSMutableDictionary *bookListing = [[NSMutableDictionary alloc] init];
    NSString *ppt = [[NSBundle mainBundle] pathForResource:@"cab" ofType:@"xls"];
    [bookListing setValue:ppt forKey:@"urlpath"];
    [[NSNotificationCenter defaultCenter] postNotificationName:noticationName object:nil userInfo:bookListing];
    [self.view removeFromSuperview];
}

- (void)handleTimer:(NSTimer*)theTimer
{
    [self loadData:(NSString*)[theTimer userInfo]];
}


-(void) handleOpenURL:(NSURL *)url
{
    NSString *fileString = [url absoluteString];
    NSArray *filepart = [fileString componentsSeparatedByString:@"/"];
    NSString *filename = [filepart lastObject];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* inboxPath = [documentsDirectory stringByAppendingPathComponent:@"Inbox"];
    NSString *csvPath = [inboxPath stringByAppendingPathComponent:filename];
    [self loadData:[csvPath stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
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
               // [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
               // progressHUD=nil;
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:NSLocalizedString(@"data_not_imported_because_ofaccountmismatch", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
                [self animatedOut];
            }else
            {
                [[ImportHelper sharedCoreDataController] ExportNewfile:currentRow];
               // [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
               // progressHUD=nil;
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Success" message:NSLocalizedString(@"data_imported_successfully", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
                [self animatedOut];
            }
        }
        
    }
}



//-(void)ExportOldFiel
//{
//    for(int i=1;i<[currentRow count];i++)
//    {
//       
//        if ([NSLocalizedString(@"income", nil) isEqualToString:[[currentRow objectAtIndex:i] valueForKey:[NSString stringWithFormat:@"8"]]] || [NSLocalizedString(@"expense", nil) isEqualToString:[[currentRow objectAtIndex:i] valueForKey:[NSString stringWithFormat:@"8"]]])
//        {
//            [self importAllOldTransactions:[currentRow objectAtIndex:i]];
//            
//        }  if ([NSLocalizedString(@"category", nil) isEqualToString:[[currentRow objectAtIndex:i] valueForKey:[NSString stringWithFormat:@"8"]]])
//        {
//            [self importAllCategories:[currentRow objectAtIndex:i]];
//            addMillies=0;
//            
//        }   if ([NSLocalizedString(@"paymentMode", nil) isEqualToString:[[currentRow objectAtIndex:i] valueForKey:[NSString stringWithFormat:@"8"]]])
//        {
//            [self importAllPaymentModes:[currentRow objectAtIndex:i]];
//            addMillies=0;;
//        }
//    }
//}



//-(void)importAllOldTransactions:(NSDictionary *)dic
//{
//    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
//    [dictionary setObject:[Utility userDefaultsForKey:MAIN_TOKEN_ID] forKey:@"token_id"];
//    [dictionary setObject:[dic valueForKey:[NSString stringWithFormat:@"4"]] forKey:@"category"];
//    [dictionary setObject:@"" forKey:@"sub_category"];
//  
//    if ([NSLocalizedString(@"income", nil) isEqualToString:[dic valueForKey:[NSString stringWithFormat:@"8"]]])
//    {
//          [dictionary setObject:[NSNumber numberWithInt:TYPE_INCOME] forKey:@"transaction_type"];
//    }else
//          [dictionary setObject:[NSNumber numberWithInt:TYPE_EXPENSE] forKey:@"transaction_type"];
//
//    
//    [dictionary setObject:[Utility userDefaultsForKey:CURRENT_TOKEN_ID] forKey:@"user_token_id"];
//    
//    [dictionary setObject:[NSNumber numberWithDouble:[[dic valueForKey:[NSString stringWithFormat:@"8"]] doubleValue]] forKey:@"amount"];;
//    
//    [dictionary setObject:[dic valueForKey:[NSString stringWithFormat:@"7"]] forKey:@"paymentMode"];
//    
//    NSString *string=[dic valueForKey:[NSString stringWithFormat:@"7"]];
//   
//     NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    if ([[string componentsSeparatedByString:@"-"] count]!=0)
//    {
//        [formatter setDateFormat:@"MM-dd-yyyy"];
//    }else
//    {
//        [formatter setDateFormat:@"MM/dd/yyyy"];
//    }
//    
//    NSNumberFormatter * formate = [[NSNumberFormatter alloc] init];
//    [formate setNumberStyle:NSNumberFormatterDecimalStyle];
//    NSDate *date=[formatter dateFromString:[dic valueForKey:[NSString stringWithFormat:@"11"]]];
//    long long milliseconds = (long long)([date timeIntervalSince1970] * 1000.0);
//    [dictionary setObject: [NSNumber numberWithUnsignedLongLong:milliseconds] forKey:@"date"];
//    [dictionary setObject:[NSNumber numberWithInt:0] forKey:@"server_updation_date"];
//    addMillies=addMillies+1;
//    [dictionary setObject:[NSNumber numberWithLongLong:[[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date] longLongValue] + addMillies] forKey:@"updation_date"];
//    [dictionary setObject:[[NSNumber numberWithLongLong:[[Utility getGMT_MillisFromYYYY_MM_DD_HH_SS_Date] longLongValue] + addMillies] stringValue] forKey:@"transaction_id"];
//    [dictionary setObject:[dic valueForKey:[NSString stringWithFormat:@"5"]] forKey:@"discription"];
//    [dictionary setObject:[NSNumber numberWithInteger:[[dic valueForKey:[NSString stringWithFormat:@"10"]] integerValue]] forKey:@"hide_status"];
//    [dictionary setObject:@"" forKey:@"pic"];
//    [dictionary setObject:@"" forKey:@"location"];
//    [dictionary setObject:@"" forKey:@"with_person"];
//    [dictionary setObject:[dic valueForKey:[NSString stringWithFormat:@"%d",transactionreference_id]] forKey:@"transaction_reference_id"];
//    [dictionary setObject:[NSNumber numberWithInteger:0] forKey:@"show_on_homescreen"];
//    [dictionary setObject:@"" forKey:@"transaction_inserted_from"];
//    [dictionary setObject:@"" forKey:@"warranty"];
//    [[TransactionHandler sharedCoreDataController] insertDataIntoTransactionTableFromEmport:dictionary];
//}








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


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)btnCancelClick:(id)sender
{
    [self.view removeFromSuperview];
}


@end
