//
//  THPinViewController.m
//  THPinViewController
//
//  Created by Thomas Heß on 11.4.14.
//  Copyright (c) 2014 Thomas Heß. All rights reserved.
//

#import "THPinViewController.h"
#import "THPinView.h"
#import "UIImage+ImageEffects.h"

@interface THPinViewController () <THPinViewDelegate>

@property (nonatomic, strong) THPinView *pinView;
@property (nonatomic, strong) UIView *blurView;
@property (nonatomic, assign) NSArray *blurViewContraints;

@end

@implementation THPinViewController

- (instancetype)initWithDelegate:(id<THPinViewControllerDelegate>)delegate
{
    self = [super init];
    if (self) {
        _delegate = delegate;
        _backgroundColor = [UIColor whiteColor];
        _translucentBackground = NO;
       // _promptTitle = NSLocalizedStringFromTable(@"prompt_title", @"THPinViewController", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.translucentBackground)
    {
        self.view.backgroundColor = [UIColor clearColor];
        [self addBlurView];
    } else
    {
        self.view.backgroundColor = self.backgroundColor;
    }
    
    self.pinView = [[THPinView alloc] initWithDelegate:self];
    self.pinView.backgroundColor = self.view.backgroundColor;
    self.pinView.promptTitle = self.promptTitle;
   
    self.pinView.promptColor = self.promptColor;
    self.pinView.hideLetters = self.hideLetters;
    self.pinView.disableCancel = self.disableCancel;
    self.pinView.translatesAutoresizingMaskIntoConstraints = NO;
   
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 66)];
    UILabel *fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 15, 250, 40)];
    [fromLabel setText:@"Daily Expense Manager"];
    fromLabel.font = [UIFont fontWithName:Ebrima_Bold size:18.0f];
    fromLabel.backgroundColor = [UIColor clearColor];
    fromLabel.textColor = [UIColor whiteColor];
    [v addSubview:fromLabel];
    
    [v setBackgroundColor:[UIColor colorWithRed:13/255.0f green:198/255.0f blue:170/255.0f alpha:1.0f]];
    [self.view addSubview:v];
    [self.view addSubview:self.pinView];
    // center pin view
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pinView attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0f constant:0.0f]];
    CGFloat pinViewYOffset = 0.0f;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        pinViewYOffset = -9.0f;
    } else {
        BOOL isFourInchScreen = (fabs(CGRectGetHeight([[UIScreen mainScreen] bounds]) - 568.0f) < DBL_EPSILON);
        if (isFourInchScreen)
        {
            pinViewYOffset = 25.5f;
        } else
        {
            pinViewYOffset = 18.5f;
        }
    }
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pinView attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0f constant:pinViewYOffset]];
}

#pragma mark - Properties

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    if ([self.backgroundColor isEqual:backgroundColor])
    {
        return;
    }
    _backgroundColor = backgroundColor;
    if (! self.translucentBackground)
    {
        self.view.backgroundColor = self.backgroundColor;
        self.pinView.backgroundColor = self.backgroundColor;
    }
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)setTranslucentBackground:(BOOL)translucentBackground
{
    if (self.translucentBackground == translucentBackground)
    {
        return;
    }
    _translucentBackground = translucentBackground;
    if (self.translucentBackground)
    {
        UIColor *darkBlueColor = [UIColor colorWithRed:13/255.0f green:198/255.0f blue:170/255.0f alpha:.30f];
        self.view.backgroundColor =darkBlueColor;
        self.pinView.backgroundColor = [UIColor clearColor];
        [self addBlurView];
    } else
    {
        self.view.backgroundColor = self.backgroundColor;
        self.pinView.backgroundColor = self.backgroundColor;
        [self removeBlurView];
    }
}


- (void)setPromptTitle:(NSString *)promptTitle
{
    if ([self.promptTitle isEqualToString:promptTitle])
    {
        return;
    }
    _promptTitle = [promptTitle copy];
    self.pinView.promptTitle = self.promptTitle;
}

- (void)setPromptColor:(UIColor *)promptColor
{
    if ([self.promptColor isEqual:promptColor])
    {
        return;
    }
    _promptColor = promptColor;
    self.pinView.promptColor = self.promptColor;
}

- (void)setHideLetters:(BOOL)hideLetters
{
    if (self.hideLetters == hideLetters)
    {
        return;
    }
    _hideLetters = hideLetters;
    self.pinView.hideLetters = self.hideLetters;
}

- (void)setDisableCancel:(BOOL)disableCancel
{
    if (self.disableCancel == disableCancel)
    {
        return;
    }
    _disableCancel = disableCancel;
    self.pinView.disableCancel = self.disableCancel;
}

#pragma mark - Blur

- (void)addBlurView
{
    self.blurView = [[UIImageView alloc] initWithImage:[self blurredContentImage]];
    self.blurView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view insertSubview:self.blurView belowSubview:self.pinView];
    NSDictionary *views = @{ @"blurView" : self.blurView };
    NSMutableArray *constraints =
    [NSMutableArray arrayWithArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[blurView]|"
                                                                           options:0 metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[blurView]|"
                                                                             options:0 metrics:nil views:views]];
    self.blurViewContraints = constraints;
    [self.view addConstraints:self.blurViewContraints];
}

- (void)removeBlurView
{
    [self.blurView removeFromSuperview];
    self.blurView = nil;
    [self.view removeConstraints:self.blurViewContraints];
    self.blurViewContraints = nil;
}

- (UIImage*)blurredContentImage
{
    UIView *contentView = [[[UIApplication sharedApplication] keyWindow] viewWithTag:THPinViewControllerContentViewTag];
    if (! contentView)
    {
        return nil;
    }
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [contentView drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image applyBlurWithRadius:20.0f tintColor:[UIColor colorWithWhite:1.0f alpha:0.25f]
                saturationDeltaFactor:1.8f maskImage:nil];
}

#pragma mark - THPinViewDelegate

- (NSUInteger)pinLengthForPinView:(THPinView *)pinView
{
    NSUInteger pinLength = [self.delegate pinLengthForPinViewController:self];
    NSAssert(pinLength > 0, @"PIN length must be greater than 0");
    return MAX(pinLength, (NSUInteger)1);
}

- (BOOL)pinView:(THPinView *)pinView isPinValid:(NSString *)pin
{
    return [self.delegate pinViewController:self isPinValid:pin];
}

- (void)cancelButtonTappedInPinView:(THPinView *)pinView
{
    if ([self.delegate respondsToSelector:@selector(pinViewControllerWillDismissAfterPinEntryWasCancelled:)]) {
        [self.delegate pinViewControllerWillDismissAfterPinEntryWasCancelled:self];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(pinViewControllerDidDismissAfterPinEntryWasCancelled:)]) {
            [self.delegate pinViewControllerDidDismissAfterPinEntryWasCancelled:self];
        }
    }];
}

- (void)correctPinWasEnteredInPinView:(THPinView *)pinView
{
    if ([self.delegate respondsToSelector:@selector(pinViewControllerWillDismissAfterPinEntryWasSuccessful:)])
    {
        [self.delegate pinViewControllerWillDismissAfterPinEntryWasSuccessful:self];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(pinViewControllerDidDismissAfterPinEntryWasSuccessful:)]) {
            [self.delegate pinViewControllerDidDismissAfterPinEntryWasSuccessful:self];
        }
    }];
}

- (void)incorrectPinWasEnteredInPinView:(THPinView *)pinView
{
    if ([self.delegate userCanRetryInPinViewController:self])
    {
        if ([self.delegate respondsToSelector:@selector(incorrectPinEnteredInPinViewController:)])
        {
            [self.delegate incorrectPinEnteredInPinViewController:self];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(pinViewControllerWillDismissAfterPinEntryWasUnsuccessful:)]) {
            [self.delegate pinViewControllerWillDismissAfterPinEntryWasUnsuccessful:self];
        }
        [self dismissViewControllerAnimated:YES completion:^{
            if ([self.delegate respondsToSelector:@selector(pinViewControllerDidDismissAfterPinEntryWasUnsuccessful:)]) {
                [self.delegate pinViewControllerDidDismissAfterPinEntryWasUnsuccessful:self];
            }
        }];
    }
}

@end
