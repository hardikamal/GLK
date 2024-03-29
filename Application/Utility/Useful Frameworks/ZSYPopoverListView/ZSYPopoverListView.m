//
//  ZSYPopoverListView.m
//  MyCustomTableViewForSelected
//
//  Created by Zhu Shouyu on 6/2/13.
//  Copyright (c) 2013 zhu shouyu. All rights reserved.
//

#import "ZSYPopoverListView.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

static const CGFloat ZSYCustomButtonHeight = 40;

static const char * const kZSYPopoverListButtonClickForCancel = "kZSYPopoverListButtonClickForCancel";

static const char * const kZSYPopoverListButtonClickForDone = "kZSYPopoverListButtonClickForDone";

@interface ZSYPopoverListView ()
@property (nonatomic, retain) UITableView *mainPopoverListView;                 //主的选择列表视图
@property (nonatomic, retain) UIButton *doneButton;                             //确定选择按钮
@property (nonatomic, retain) UIButton *cancelButton;                           //取消选择按钮
@property (nonatomic, retain) UIControl *controlForDismiss;
@property (nonatomic) BOOL chek;  //没有按钮的时候，才会使用这个
//初始化界面 
- (void)initTheInterface;

//动画进入
- (void)animatedIn;

//动画消失
- (void)animatedOut;

//展示界面
- (void)show;

//消失界面
- (void)dismiss;
@end

@implementation ZSYPopoverListView
@synthesize datasource = _datasource;
@synthesize delegate = _delegate;
@synthesize mainPopoverListView = _mainPopoverListView;
@synthesize doneButton = _doneButton;
@synthesize cancelButton = _cancelButton;
@synthesize titleName = _titleName;
@synthesize controlForDismiss = _controlForDismiss;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initTheInterface];
    }
    return self;
}

- (void)initTheInterface
{
    [Utility setFontFamily:Embrima forView:self andSubViews:YES];
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 05.0f;
    self.clipsToBounds = TRUE;
    _titleName = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleName.font = [UIFont fontWithName:Ebrima_Bold size:16.0f];
    self.titleName.backgroundColor = [UIColor colorWithRed:86./255. green:212./255. blue:187./255. alpha:1.0f];
    _chek=YES;
    self.titleName.textAlignment = NSTextAlignmentCenter;
    self.titleName.textColor = [UIColor whiteColor];
    CGFloat xWidth = self.bounds.size.width;
    self.titleName.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleName.frame = CGRectMake(0, 0, xWidth, 42.0f);
    self.imageView=[[UIImageView alloc] initWithFrame: CGRectMake(10, 10, 26.0f, 26.0f)];
    [self addSubview:self.titleName];
    [self addSubview:self.imageView];
    CGRect tableFrame = CGRectMake(0, 42.0f, xWidth, self.bounds.size.height-32.0f);
    _mainPopoverListView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    self.mainPopoverListView.dataSource = self;
    self.mainPopoverListView.delegate = self;
    [self addSubview:self.mainPopoverListView];
}

- (void)refreshTheUserInterface
{
  
    if (self.cancelButton || self.doneButton)
    {
        self.mainPopoverListView.frame = CGRectMake(0, 42.0f, self.mainPopoverListView.frame.size.width, self.mainPopoverListView.frame.size.height - ZSYCustomButtonHeight);
        
    }
    if (self.doneButton && nil == self.cancelButton)
    {
        self.doneButton.frame = CGRectMake(0, self.bounds.size.height - ZSYCustomButtonHeight, self.bounds.size.width, ZSYCustomButtonHeight);

    }
    else if (nil == self.doneButton && self.cancelButton)
    {
        self.cancelButton.frame = CGRectMake(0, self.bounds.size.height - ZSYCustomButtonHeight, self.bounds.size.width, ZSYCustomButtonHeight);
    }
    else if (self.doneButton && self.cancelButton)
    {
        self.doneButton.frame = CGRectMake(0, self.bounds.size.height - ZSYCustomButtonHeight, self.bounds.size.width / 2.0f, ZSYCustomButtonHeight);
        self.cancelButton.frame = CGRectMake(self.bounds.size.width / 2.0f, self.bounds.size.height - ZSYCustomButtonHeight, self.bounds.size.width / 2.0f, ZSYCustomButtonHeight);
    }
    _controlForDismiss = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _controlForDismiss.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];
    [_controlForDismiss addTarget:self action:@selector(touchForDismissSelf:) forControlEvents:UIControlEventTouchUpInside];
}

- (NSIndexPath *)indexPathForSelectedRow
{
    return [self.mainPopoverListView indexPathForSelectedRow];
}
#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [tableView setScrollEnabled:NO];
    return [self.items count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] ;
    }
    if ([[self.items objectAtIndex:[indexPath row]] isEqualToString:self.type])
    {
        self.chek=YES;
    }
    if ([[self.items objectAtIndex:[indexPath row]] isEqualToString:self.type])
    {
        cell.imageView.image = [UIImage imageNamed:@"radial_button_active.png"];
        self.chek=NO;
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"radial_button.png"];
    }
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 1.0, cell.contentView.frame.size.width, 1)];
    cell.textLabel.font=[UIFont fontWithName:Embrima size:16];
    separator.backgroundColor = [UIColor darkTextColor];
    [cell.contentView addSubview:separator];
    cell.textLabel.text = [self.items objectAtIndex:[indexPath row]];
    return cell;
}



#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"radial_button.png"];
    self.chek=NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     self.selectedIndexPath = indexPath;
     self.type=[self.items objectAtIndex:[indexPath row]];
     UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
     cell.imageView.image = [UIImage imageNamed:@"radial_button_active.png"];
     [tableView reloadData];
}

#pragma mark - Animated Mthod
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
        if (finished) {
            if (self.controlForDismiss)
            {
                [self.controlForDismiss removeFromSuperview];
            }
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - show or hide self
- (void)show
{
    [self refreshTheUserInterface];
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    if (self.controlForDismiss)
    [keywindow addSubview:self.controlForDismiss];
    [keywindow addSubview:self];
    self.center = CGPointMake(keywindow.bounds.size.width/2.0f, keywindow.bounds.size.height/2.0f);
    [self animatedIn];
}

- (void)dismiss
{
    [self animatedOut];
}

#pragma mark - Reuse Cycle
- (id)dequeueReusablePopoverCellWithIdentifier:(NSString *)identifier
{
    return [self.mainPopoverListView dequeueReusableCellWithIdentifier:identifier];
}

- (UITableViewCell *)popoverCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.mainPopoverListView cellForRowAtIndexPath:indexPath];
}

+ (UIImage *)normalButtonBackgroundImage
{
	const size_t locationCount = 4;
	CGFloat opacity = 1.0;
    CGFloat locations[locationCount] = { 0.0, 0.5, 0.5 + 0.0001, 1.0 };
    CGFloat components[locationCount * 4] = {
		179/255.0, 185/255.0, 199/255.0, opacity,
		121/255.0, 132/255.0, 156/255.0, opacity,
		87/255.0, 100/255.0, 130/255.0, opacity,
		108/255.0, 120/255.0, 146/255.0, opacity,
	};
	return [self glassButtonBackgroundImageWithGradientLocations:locations
													  components:components
												   locationCount:locationCount];
}

+ (UIImage *)cancelButtonBackgroundImage
{
	const size_t locationCount = 4;
	CGFloat opacity = 1.0;
    CGFloat locations[locationCount] = { 0.0, 0.5, 0.5 + 0.0001, 1.0 };
    CGFloat components[locationCount * 4] = {
		164/255.0, 169/255.0, 184/255.0, opacity,
		77/255.0, 87/255.0, 115/255.0, opacity,
		51/255.0, 63/255.0, 95/255.0, opacity,
		78/255.0, 88/255.0, 116/255.0, opacity,
	};
	return [self glassButtonBackgroundImageWithGradientLocations:locations
													  components:components
												   locationCount:locationCount];
}

+ (UIImage *)glassButtonBackgroundImageWithGradientLocations:(CGFloat *)locations
												  components:(CGFloat *)components
											   locationCount:(NSInteger)locationCount
{
	const CGFloat lineWidth = 1;
	const CGFloat cornerRadius = 4;
	UIColor *strokeColor = [UIColor colorWithRed:1/255.0 green:11/255.0 blue:39/255.0 alpha:1.0];
	
	CGRect rect = CGRectMake(0, 0, cornerRadius * 2 + 1, ZSYCustomButtonHeight);
    
	BOOL opaque = NO;
    UIGraphicsBeginImageContextWithOptions(rect.size, opaque, [[UIScreen mainScreen] scale]);
    
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, locationCount);
	
	CGRect strokeRect = CGRectInset(rect, lineWidth * 0.5, lineWidth * 0.5);
	UIBezierPath *strokePath = [UIBezierPath bezierPathWithRoundedRect:strokeRect cornerRadius:cornerRadius];
	strokePath.lineWidth = lineWidth;
	[strokeColor setStroke];
	[strokePath stroke];
	
	CGRect fillRect = CGRectInset(rect, lineWidth, lineWidth);
	UIBezierPath *fillPath = [UIBezierPath bezierPathWithRoundedRect:fillRect cornerRadius:cornerRadius];
	[fillPath addClip];
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
	CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
	CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
	
	CGGradientRelease(gradient);
	CGColorSpaceRelease(colorSpace);
	
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
	CGFloat capHeight = floorf(rect.size.height * 0.5);
	return [image resizableImageWithCapInsets:UIEdgeInsetsMake(capHeight, cornerRadius, capHeight, cornerRadius)];
}

#pragma mark - Button Method
- (void)setCancelButtonTitle:(NSString *)aTitle block:(ZSYPopoverListViewButtonBlock)block
{
    if (nil == _cancelButton)
    {
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cancelButton setBackgroundColor:[UIColor whiteColor]];
        [self.cancelButton.titleLabel setFont:[UIFont fontWithName:Embrima size:16]];
        [self.cancelButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(buttonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cancelButton];
    }
    [self.cancelButton setTitle:aTitle forState:UIControlStateNormal];
   // objc_setAssociatedObject(self.cancelButton, kZSYPopoverListButtonClickForCancel, [block copy], OBJC_ASSOCIATION_RETAIN);
}

- (void)setDoneButtonWithTitle:(NSString *)aTitle block:(ZSYPopoverListViewButtonBlock)block
{
    if (nil == _doneButton)
    {
         self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.doneButton setBackgroundColor:[UIColor whiteColor]];
        [self.cancelButton.titleLabel setFont:[UIFont fontWithName:Embrima size:16]];
        [self.doneButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.doneButton addTarget:self action:@selector(buttonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.doneButton];
        UILabel *lable=[[UILabel alloc] initWithFrame:CGRectMake(140, self.frame.size.height-30, 1, 20)];
        [lable setBackgroundColor:[UIColor darkGrayColor]];
        [self addSubview:lable];
    }
    [self.doneButton setTitle:aTitle forState:UIControlStateNormal];
    //objc_setAssociatedObject(self.doneButton, kZSYPopoverListButtonClickForDone, [block copy], OBJC_ASSOCIATION_RETAIN);
}
#pragma mark - UIButton Clicke Method
- (void)buttonWasPressed:(id)sender
{
   
    NSMutableDictionary *bookListing = [[NSMutableDictionary alloc] init];
    [bookListing setObject:self.type  forKey:@"object"];
    [bookListing setObject:_titleName.text forKey:@"title"];
     NSLog(@"bookListing:%@",bookListing);
     NSString * noticationName =@"ZSYPopListView";
    [[NSNotificationCenter defaultCenter] postNotificationName:noticationName   object:nil userInfo:bookListing];
    
     [self animatedOut];
}

- (void)touchForDismissSelf:(id)sender
{
    [self animatedOut];


}
@end
