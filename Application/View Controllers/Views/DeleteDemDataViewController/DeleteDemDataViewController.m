
//
//  DeleteDemDataViewController.m
//  Daily Expense Manager
//
//  Created by Appbulous on 27/10/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import "DeleteDemDataViewController.h"

#import "TransactionHandler.h"
#import "BudgetHandler.h"
#import "ReminderHandler.h"
#import "TransferHandler.h"
#import "UserInfoHandler.h"
#import "UIAlertView+Block.h"
#import "HomeHelper.h"
@interface DeleteDemDataViewController ()

@end

@implementation DeleteDemDataViewController

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
    [Utility setFontFamily:Embrima forView:self.view andSubViews:YES];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    tapRecognizer.numberOfTapsRequired = 1;
    self.tapView.userInteractionEnabled=YES;
    [self.tapView addGestureRecognizer:tapRecognizer];
    [Utility setFontFamily:Embrima forView:self.view andSubViews:YES];
	// Do any additional setup after loading the view.
}

- (IBAction)handleSingleTap:(UITapGestureRecognizer *)sender
{
    
    [self.view removeFromSuperview];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnIncomClick:(UIButton*)sender
{
    UIImage *secondImage = [UIImage imageNamed:@"check_box_actives.png"];
    NSData *imgData1 = UIImagePNGRepresentation(sender.imageView.image);
    NSData *imgData2 = UIImagePNGRepresentation(secondImage);
    BOOL isCompare =  [imgData1 isEqual:imgData2];
    if(isCompare)
    {
        [sender setImage:[UIImage imageNamed:@"check_boxs.png"] forState:UIControlStateNormal];
    }else
        [sender setImage:[UIImage imageNamed:@"check_box_actives.png"] forState:UIControlStateNormal];
}


- (IBAction)btnReminderClick:(UIButton*)sender
{
    UIImage *secondImage = [UIImage imageNamed:@"check_box_actives.png"];
    NSData *imgData1 = UIImagePNGRepresentation(sender.imageView.image);
    NSData *imgData2 = UIImagePNGRepresentation(secondImage);
    BOOL isCompare =  [imgData1 isEqual:imgData2];
    if(isCompare)
    {
        [sender setImage:[UIImage imageNamed:@"check_boxs.png"] forState:UIControlStateNormal];
    }else
        [sender setImage:[UIImage imageNamed:@"check_box_actives.png"] forState:UIControlStateNormal];
}



- (IBAction)btnBudgetClick:(UIButton*)sender
{
    UIImage *secondImage = [UIImage imageNamed:@"check_box_actives.png"];
    NSData *imgData1 = UIImagePNGRepresentation(sender.imageView.image);
    NSData *imgData2 = UIImagePNGRepresentation(secondImage);
    BOOL isCompare =  [imgData1 isEqual:imgData2];
    if(isCompare)
    {
        [sender setImage:[UIImage imageNamed:@"check_boxs.png"] forState:UIControlStateNormal];
    }else
        [sender setImage:[UIImage imageNamed:@"check_box_actives.png"] forState:UIControlStateNormal];
}



- (IBAction)btnTransferClick:(UIButton*)sender
{
    
    UIImage *secondImage = [UIImage imageNamed:@"check_box_actives.png"];
    NSData *imgData1 = UIImagePNGRepresentation(sender.imageView.image);
    NSData *imgData2 = UIImagePNGRepresentation(secondImage);
    BOOL isCompare =  [imgData1 isEqual:imgData2];
    if(isCompare)
    {
        [sender setImage:[UIImage imageNamed:@"check_boxs.png"] forState:UIControlStateNormal];
    }else
        [sender setImage:[UIImage imageNamed:@"check_box_actives.png"] forState:UIControlStateNormal];

}

- (IBAction)btnWarrantiesClick:(UIButton*)sender
{
    
    UIImage *secondImage = [UIImage imageNamed:@"check_box_actives.png"];
    NSData *imgData1 = UIImagePNGRepresentation(sender.imageView.image);
    NSData *imgData2 = UIImagePNGRepresentation(secondImage);
    BOOL isCompare =  [imgData1 isEqual:imgData2];
    if(isCompare)
    {
        [sender setImage:[UIImage imageNamed:@"check_boxs.png"] forState:UIControlStateNormal];
    }else
        [sender setImage:[UIImage imageNamed:@"check_box_actives.png"] forState:UIControlStateNormal];
}

- (IBAction)btnExpenseClick:(UIButton*)sender
{
    
    UIImage *secondImage = [UIImage imageNamed:@"check_box_actives.png"];
    NSData *imgData1 = UIImagePNGRepresentation(sender.imageView.image);
    NSData *imgData2 = UIImagePNGRepresentation(secondImage);
    BOOL isCompare =  [imgData1 isEqual:imgData2];
    if(isCompare)
    {
        [sender setImage:[UIImage imageNamed:@"check_boxs.png"] forState:UIControlStateNormal];
    }else
        [sender setImage:[UIImage imageNamed:@"check_box_actives.png"] forState:UIControlStateNormal];
    
}


-(void)deleteItem
{
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Alert" message:NSLocalizedString(@"areyousuretodelete", nil) delegate:self cancelButtonTitle:@"Continue"  otherButtonTitles: nil];
    [alert addButtonWithTitle:@"Cancel"];
    [alert show];
}




- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        UIImage *secondImage = [UIImage imageNamed:@"check_box_actives.png"];
        NSData *imgData1 = UIImagePNGRepresentation(self.btnIncom.imageView.image);
        NSData *imgData2 = UIImagePNGRepresentation(secondImage);
        BOOL isCompare =  [imgData1 isEqual:imgData2];
        if(isCompare)
        {
            NSArray *array=[[TransactionHandler sharedCoreDataController] getAllUserTransactionWithType:[NSString stringWithFormat:@"%i",TYPE_INCOME]];
            for (int i=0; i<[array count]; i++)
            {
                [[TransactionHandler sharedCoreDataController] deleteTransaction:[array objectAtIndex:i]];
            }
        }
        
        imgData1 = UIImagePNGRepresentation(self.btnExpense.imageView.image);
        isCompare =  [imgData1 isEqual:imgData2];
        if(isCompare)
        {
            NSArray *array=[[TransactionHandler sharedCoreDataController] getAllUserTransactionWithType:[NSString stringWithFormat:@"%i",TYPE_EXPENSE]];
            for (int i=0; i<[array count]; i++)
            {
                [[TransactionHandler sharedCoreDataController] deleteTransaction:[array objectAtIndex:i]];
            }
        }
        imgData1 = UIImagePNGRepresentation(self.btnBudgets.imageView.image);
        isCompare =  [imgData1 isEqual:imgData2];
        if(isCompare)
        {
            NSArray *array=[[BudgetHandler sharedCoreDataController] getAllBudget];
            for (int i=0; i<[array count]; i++)
            {
                [[BudgetHandler sharedCoreDataController] deleteBudget:[array objectAtIndex:i]];
            }
        }
        imgData1 = UIImagePNGRepresentation(self.btnReminder.imageView.image);
        isCompare =  [imgData1 isEqual:imgData2];
        if(isCompare)
        {   NSArray *array=[[ReminderHandler sharedCoreDataController] getAllReminder];
            for (int i=0; i<[array count]; i++)
            {
                [[ReminderHandler sharedCoreDataController] deleteReminder:[array objectAtIndex:i]];
            }
        }
        imgData1 = UIImagePNGRepresentation(self.btnTransfer.imageView.image);
        isCompare =  [imgData1 isEqual:imgData2];
        if(isCompare)
        {
            NSArray *array=[[TransferHandler sharedCoreDataController] getAllTransfer];
            for (int i=0; i<[array count]; i++)
            {
                [[TransferHandler sharedCoreDataController] deleteTransefer:[array objectAtIndex:i]];
            }
        }
        imgData1 = UIImagePNGRepresentation(self.btnWarranties.imageView.image);
        isCompare =  [imgData1 isEqual:imgData2];
        if(isCompare)
        {
            NSArray *array=[[TransactionHandler sharedCoreDataController] getAllWarranrtyList];
            for (int i=0; i<[array count]; i++)
            {
                [[TransactionHandler sharedCoreDataController] deleteTransaction:[array objectAtIndex:i]];
            }
        }
        
        if([[NSUserDefaults standardUserDefaults] boolForKey:UPDATION_ON_SERVER_TIME] && [Utility isInternetAvailable])
        {
            [[HomeHelper sharedCoreDataController] upgradeBackendDataOnServer];
        }
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}


- (IBAction)btnDeleteClick:(id)sender
{
    NSString *string=NSLocalizedString(@"areyousuretodelete", nil);
    UIImage *secondImage = [UIImage imageNamed:@"check_box_actives.png"];
    NSData *imgData1 = UIImagePNGRepresentation(self.btnIncom.imageView.image);
    NSData *imgData2 = UIImagePNGRepresentation(secondImage);
    BOOL isCompare =  [imgData1 isEqual:imgData2];
    if(isCompare)
    {
        string=[NSString stringWithFormat:@"%@ ,%@",string,NSLocalizedString(@"income", nil)];
    }
    
    imgData1 = UIImagePNGRepresentation(self.btnExpense.imageView.image);
    isCompare =  [imgData1 isEqual:imgData2];
    if(isCompare)
    {
        string=[NSString stringWithFormat:@"%@ ,%@",string,NSLocalizedString(@"expense", nil)];

    }
    imgData1 = UIImagePNGRepresentation(self.btnBudgets.imageView.image);
    isCompare =  [imgData1 isEqual:imgData2];
    if(isCompare)
    {
      string=[NSString stringWithFormat:@"%@ ,%@",string,NSLocalizedString(@"budget", nil)];
        
    }
    imgData1 = UIImagePNGRepresentation(self.btnReminder.imageView.image);
    isCompare =  [imgData1 isEqual:imgData2];
    if(isCompare)
    {
         string=[NSString stringWithFormat:@"%@ ,%@",string,NSLocalizedString(@"reminder", nil)];
        
    }
    imgData1 = UIImagePNGRepresentation(self.btnTransfer.imageView.image);
    isCompare =  [imgData1 isEqual:imgData2];
    if(isCompare)
    {
        string=[NSString stringWithFormat:@"%@ ,%@",string,NSLocalizedString(@"transferTransaction", nil)];
    }
    imgData1 = UIImagePNGRepresentation(self.btnWarranties.imageView.image);
    isCompare =  [imgData1 isEqual:imgData2];
    if(isCompare)
    {
       string=[NSString stringWithFormat:@"%@ ,%@",string,NSLocalizedString(@"warrantiesTransaction", nil)];
    }
    if (![string isEqualToString:NSLocalizedString(@"areyousuretodelete", nil)])
    {
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"%@ ",string] delegate:self cancelButtonTitle:@"Continue"  otherButtonTitles: nil];
        [alert addButtonWithTitle:@"Cancel"];
        [alert show];
    }
}



- (IBAction)btnCancleClick:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];

}


@end
