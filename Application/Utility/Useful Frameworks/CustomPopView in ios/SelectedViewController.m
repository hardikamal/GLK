//
//  SelectedViewController.m
//  Daily Expense Manager
//
//  Created by Appbulous on 24/09/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import "SelectedViewController.h"
#import "UIAlertView+Block.h"
@interface SelectedViewController ()

@end

@implementation SelectedViewController

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
    [self.lblTitile setFont:[UIFont fontWithName:Ebrima_Bold size:16.0f]];
    [self.lblTitile setText:self.titleString];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    tapRecognizer.numberOfTapsRequired = 1;
    self.tapView.userInteractionEnabled=YES;
    [self.tapView addGestureRecognizer:tapRecognizer];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    CGFloat xWidth = self.popUpView.frame.size.width;
    CGFloat yHeight = self.popUpView.frame.size.height;
    CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
    [self.popUpView setFrame:CGRectMake(5, yOffset, xWidth, yHeight)];
    [self.popUpView didMoveToSuperview];
    
	// Do any additional setup after loading the view.
}

- (IBAction)handleSingleTap:(UITapGestureRecognizer *)sender
{
        [self animatedOut];
    
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
// Do any additional setup after loading the view.


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.item count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] ;
    }
    cell.textLabel.font=[UIFont fontWithName:Embrima size:16];
    cell.textLabel.textColor=[UIColor darkGrayColor];
    NSMutableDictionary *item = [self.item objectAtIndex:[indexPath row]];
    cell.textLabel.text = [item objectForKey:@"text"];
    NSString * checked = [item objectForKey:@"checked"];
    UIImage *image;
    if ([checked isEqualToString:@"YES" ])
    {
        image=[UIImage   imageNamed:@"check_box_actives.png"] ;
        [self chekSelectButton];
    }else
    {
        image= [UIImage imageNamed:@"check_boxs.png"];
        [self.btnSelect setImage:image forState:UIControlStateNormal];
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTag:100];
    CGRect frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    button.frame = frame;
    [button setImage:image forState:UIControlStateNormal];
    cell.accessoryView = button;
    return cell;
}

-(void)chekSelectButton
{
    for (NSDictionary *item in self.item)
    {
         NSString * checked = [item objectForKey:@"checked"];
        if ([checked isEqualToString:@"NO" ])
        {
            return;
            
        }
    }
    [self.btnSelect setImage:[UIImage imageNamed:@"check_box_actives.png"] forState:UIControlStateNormal];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *item = [self.item objectAtIndex:[indexPath row]];
    NSString * checked = [item objectForKey:@"checked"];
    if ([checked isEqualToString:@"YES" ])
    {
         [item setObject:@"NO" forKey:@"checked"];
    }else
    {
        [item setObject:@"YES" forKey:@"checked"];
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (IBAction)btnSelectClicked:(UIButton*)sender
{
    UIImage *secondImage = [UIImage imageNamed:@"check_box_actives.png"];
    NSData *imgData1 = UIImagePNGRepresentation(sender.imageView.image);
    NSData *imgData2 = UIImagePNGRepresentation(secondImage);
    BOOL isCompare =  [imgData1 isEqual:imgData2];
    if(isCompare)
    {
        for (NSMutableDictionary *item in self.item)
        {
            [item setObject:@"NO" forKey:@"checked"];
        }
        [self.btnSelect setImage:[UIImage imageNamed:@"check_boxs.png"] forState:UIControlStateNormal];
        [self.tableView reloadData];
    }else
    {
        for (NSMutableDictionary *item in self.item)
        {
            [item setObject:@"YES" forKey:@"checked"];
        }
        [self.btnSelect setImage:[UIImage imageNamed:@"check_box_actives.png"] forState:UIControlStateNormal];
        [self.tableView reloadData];
    }
}

- (IBAction)okbtnClick:(id)sender
{
    if (![self.item count]==0)
    {
    NSMutableArray *array=[[NSMutableArray alloc] init];
    for (NSMutableDictionary *item in self.item)
    {
        NSString * checked = [item objectForKey:@"checked"];
        if ([checked isEqualToString:@"YES" ])
        {
            [array addObject:[item objectForKey:@"text"]];
        }
    }
    NSString * noticationName =@"SelectedViewController";
    NSMutableDictionary *bookListing = [[NSMutableDictionary alloc] init];
    [bookListing setValue:array forKey:@"object"];
    if (self.chekPaymentorCategery)
    {
        [bookListing setValue:@"YES" forKey:@"chek"];
    }else
    {
        [bookListing setValue:@"NO" forKey:@"chek"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:noticationName
                                                        object:nil userInfo:bookListing];
    }else
    {
        if (self.chekPaymentorCategery)
        {
            [Utility showAlertWithMassager:self.navigationController.view :@"Selected atleast One Categery"];
        }else
        {
            [Utility showAlertWithMassager:self.navigationController.view :@"Selected atleast One PaymentMode"];
        }
    }
}

- (IBAction)CanclebtnClick:(id)sender
{
    if (![self.item count]==0)
    {
    NSString * noticationName =@"SelectedViewController";
    
        NSMutableArray *array=[[NSMutableArray alloc] init];
        for (NSMutableDictionary *item in self.item)
        {
                [array addObject:[item objectForKey:@"text"]];
        }
       
    NSMutableDictionary *bookListing = [[NSMutableDictionary alloc] init];
    [bookListing setValue:array forKey:@"object"];
        
    if (self.chekPaymentorCategery)
    {
        [bookListing setValue:@"YES" forKey:@"chek"];
    }else
    {
        [bookListing setValue:@"NO" forKey:@"chek"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:noticationName object:nil userInfo:bookListing];
    }else
    {
        if (self.chekPaymentorCategery)
        {
             [Utility showAlertWithMassager:self.navigationController.view :@"Selected atleast One Categery"];
        }else
        {
             [Utility showAlertWithMassager:self.navigationController.view :@"Selected atleast One PaymentMode"];
        }
    }
}

@end
