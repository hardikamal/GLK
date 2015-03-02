

//
//  HomeViewController.m
//  Daily Expense Manager
//
//  Created by Saurabh Singh on 25/02/15.
//  Copyright (c) 2015 Mobulous. All rights reserved.
//


#import "HomeViewController.h"
#import "UIColor+HexColor.h"
#import "VBPieChart.h"
#import "BROptionsButton.h"

@interface UILabel (Colorify)
- (void) colorSubstring: (NSString*) substring;
- (void) colorRange: (NSRange) range;
@end
@implementation UILabel (Colorify)
- (void)colorRange:(NSRange)range {
    if (![self respondsToSelector:@selector(setAttributedText:)]) {
        return;
    }
    NSMutableAttributedString *attributedText;
    if (!self.attributedText) {
        attributedText = [[NSMutableAttributedString alloc] initWithString:self.text];
    } else {
        attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    }
    [attributedText setAttributes:@{NSForegroundColorAttributeName:GREEN_COLOR} range:range];
    self.attributedText = attributedText;
}

- (void)colorSubstring:(NSString*)substring {
    NSRange range = [self.text rangeOfString:substring];
    [self colorRange:range];
}
@end
@interface HomeViewController ()
{
   }
@property (nonatomic, strong) BROptionsButton *brOptionsButton;

@property (nonatomic, retain) VBPieChart *chart;

@property (nonatomic, retain) NSArray *chartValues;
@end

@implementation HomeViewController
- (IBAction)leftNavClick:(UIBarButtonItem *)sender {
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}
-(void)drawChart
{
    if (!_chart) {
        _chart = [[VBPieChart alloc] init];
        [self.view addSubview:_chart];
    }
    [_chart setFrame:CGRectMake(165,64,150,150)];
    [_chart setEnableStrokeColor:YES];
    [_chart setHoleRadiusPrecent:0.7];
    [_chart.layer setShadowOffset:CGSizeMake(2, 2)];
    [_chart.layer setShadowRadius:3];
    [_chart.layer setShadowColor:[UIColor blackColor].CGColor];
    [_chart.layer setShadowOpacity:0.7];
    
    
    [_chart setHoleRadiusPrecent:0.3];
     [_chart setShowLabels:YES];
    NSLog(@"%@",[NSNumber numberWithInteger:[[self.expenseLabel.text substringFromIndex:2] integerValue]]);
    self.chartValues = @[
                         @{@"name":@"first", @"value":[NSNumber numberWithInteger:[[self.expenseLabel.text substringFromIndex:2] integerValue]], @"color":[UIColor redColor]},
                         @{@"name":@"second", @"value":[NSNumber numberWithInteger:[[self.balanceLabel.text substringFromIndex:2] integerValue]], @"color":GREEN_COLOR}
                         ];
    
    //[_chart setChartValues:_chartValues animation:YES];
    [_chart setChartValues:_chartValues animation:YES options:VBPieChartAnimationFanAll];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.tabBarController.tabBar setTranslucent:YES];
     [[UINavigationBar appearance] setBarTintColor:GREEN_COLOR];
    [self drawChart];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBarController.title=@"Goolak Dashboard";
    self.balanceLabel.text=@"₹ 43,000";
    self.expenseLabel.text=@"₹ 7,000";
    self.incomeLabel.text=@"₹ 50,000";
    [(UILabel*)[self.firstTimeAddView viewWithTag:1] setText:@"You have not started using Goollak, Start by adding a transaction"];
    [(UILabel*)[self.firstTimeAddView viewWithTag:1]colorSubstring:@"Goollak"];
    
   
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}






@end
