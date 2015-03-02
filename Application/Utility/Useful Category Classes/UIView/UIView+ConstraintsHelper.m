//
//  UIView+ConstraintsHelper.m
//
//  Created by Jonas Treub on 15/08/14.
//  Copyright (c) 2015 JonasTreub. All rights reserved.
//

#import "UIView+ConstraintsHelper.h"

@implementation UIView (ConstraintsHelper)

#pragma mark - fixed size

- (void)constraintWidth:(CGFloat)width height:(CGFloat)height
{
    [self constraintWidth:width];
    [self constraintHeight:height];
}

- (void)constraintWidth:(CGFloat)width
{
    UIView *superview = self.superview;
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1
                                                                  constant:width]];
}

- (void)constraintHeight:(CGFloat)height
{
    UIView *superview = self.superview;
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1
                                                                  constant:height]];
}

#pragma mark - relative size

- (void)constraintWidthAndHeightWithView:(UIView *)view
{
    [self constraintWidthWithView:view];
    [self constraintHeightWithView:view];
}

- (void)constraintWidthWithView:(UIView *)viewTwo
{
    [self constraintWidthWithView:viewTwo ratio:1];
}

- (void)constraintHeightWithView:(UIView *)viewTwo
{
    [self constraintHeightWithView:viewTwo ratio:1];
}

- (void)constraintWidthAndHeight
{
    [self constraintWidthAndHeightWithView:self.superview];
}

- (void)constraintWidth
{
    [self constraintWidthWithView:self.superview];
}

- (void)constraintHeight
{
    [self constraintHeightWithView:self.superview];
}

- (void)constraintWidthWithView:(UIView *)viewTwo ratio:(CGFloat)ratio
{
    UIView *superview = self.superview;
    
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:viewTwo
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:ratio
                                                                  constant:0]];
}

- (void)constraintHeightWithView:(UIView *)viewTwo ratio:(CGFloat)ratio
{
    UIView *superview = self.superview;
    
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:viewTwo
                                                                 attribute:NSLayoutAttributeHeight
                                                                multiplier:ratio
                                                                  constant:0]];
}

- (void)constraintWidthWithRatio:(CGFloat)ratio
{
    [self constraintWidthWithView:self.superview ratio:ratio];
}

- (void)constraintHeightWithRatio:(CGFloat)ratio
{
    [self constraintHeightWithView:self.superview ratio:ratio];
}

#pragma mark - center

- (void)constraintCenterWithView:(UIView *)viewTwo
{
    [self constraintCenterXWithView:viewTwo];
    [self constraintCenterYWithView:viewTwo];
}

- (void)constraintCenterXWithView:(UIView *)viewTwo
{
    [self constraintCenterXWithView:viewTwo offset:0];
}

- (void)constraintCenterYWithView:(UIView *)viewTwo
{
    [self constraintCenterYWithView:viewTwo offset:0];
}

- (void)constraintCenter
{
    [self constraintCenterWithView:self.superview];
}

- (void)constraintCenterX
{
    [self constraintCenterXWithView:self.superview];
}

- (void)constraintCenterY
{
    [self constraintCenterYWithView:self.superview];
}

#pragma mark - center with offset

- (void)constraintCenterXWithView:(UIView *)viewTwo offset:(CGFloat)offset
{
    UIView *superview = self.superview;
    
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:viewTwo
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1
                                                                  constant:offset]];
}


- (void)constraintCenterYWithView:(UIView *)viewTwo offset:(CGFloat)offset
{
    UIView *superview = self.superview;
    
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:viewTwo
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1
                                                                  constant:offset]];
}

- (void)constraintCenterXWithOffset:(CGFloat)offset
{
    [self constraintCenterXWithView:self.superview offset:offset];
}

- (void)constraintCenterYWithOffset:(CGFloat)offset
{
    [self constraintCenterYWithView:self.superview offset:offset];
}

#pragma mark - center with ratio

- (void)constraintCenterXWithView:(UIView *)viewTwo ratio:(CGFloat)ratio
{
    UIView *superview = self.superview;
    
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:viewTwo
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:ratio
                                                                  constant:0]];
}

- (void)constraintCenterYWithView:(UIView *)viewTwo ratio:(CGFloat)ratio
{
    UIView *superview = self.superview;
    
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:viewTwo
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:ratio
                                                                  constant:0]];
}

- (void)constraintCenterXWithRatio:(CGFloat)ratio
{
    [self constraintCenterXWithView:self.superview ratio:ratio];
}

- (void)constraintCenterYWithRatio:(CGFloat)ratio
{
    [self constraintCenterYWithView:self.superview ratio:ratio];
}

#pragma mark - position

- (void)constraintTopLeftWithView:(UIView *)viewTwo
{
    [self constraintTopWithView:viewTwo];
    [self constraintLeftWithView:viewTwo];
}

- (void)constraintTopRightWithView:(UIView *)viewTwo
{
    [self constraintTopWithView:viewTwo];
    [self constraintRightWithView:viewTwo];
}

- (void)constraintBottomLeftWithView:(UIView *)viewTwo
{
    [self constraintBottomWithView:viewTwo];
    [self constraintLeftWithView:viewTwo];
}

- (void)constraintBottomRightWithView:(UIView *)viewTwo
{
    [self constraintBottomWithView:viewTwo];
    [self constraintRightWithView:viewTwo];
}

- (void)constraintTopLeft
{
    [self constraintTopLeftWithView:self.superview];
}

- (void)constraintTopRight
{
    [self constraintTopRightWithView:self.superview];
}

- (void)constraintBottomLeft
{
    [self constraintBottomLeftWithView:self.superview];
}

- (void)constraintBottomRight
{
    [self constraintBottomRightWithView:self.superview];
}

- (void)constraintTopWithView:(UIView *)viewTwo
{
    [self constraintTopWithOuterView:viewTwo margin:0];
}

- (void)constraintBottomWithView:(UIView *)viewTwo
{
    [self constraintBottomWithOuterView:viewTwo margin:0];
}

- (void)constraintLeftWithView:(UIView *)viewTwo
{
    [self constraintLeftWithOuterView:viewTwo margin:0];
}

- (void)constraintRightWithView:(UIView *)viewTwo
{
    [self constraintRightWithOuterView:viewTwo margin:0];
}

- (void)constraintTop
{
    [self constraintTopWithView:self.superview];
}

- (void)constraintBottom
{
    [self constraintBottomWithView:self.superview];
}

- (void)constraintLeft
{
    [self constraintLeftWithView:self.superview];
}

- (void)constraintRight
{
    [self constraintRightWithView:self.superview];
}

#pragma mark - position with margin

- (void)constraintTopWithOuterView:(UIView *)outerView margin:(CGFloat)margin
{
    UIView *superview = self.superview;
    
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:outerView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1
                                                                  constant:margin]];
}

- (void)constraintBottomWithOuterView:(UIView *)outerView margin:(CGFloat)margin
{
    UIView *superview = self.superview;
    
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:outerView
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1
                                                                  constant:margin]];
}

- (void)constraintLeftWithOuterView:(UIView *)outerView margin:(CGFloat)margin
{
    UIView *superview = self.superview;
    
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:outerView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1
                                                                  constant:margin]];
}

- (void)constraintRightWithOuterView:(UIView *)outerView margin:(CGFloat)margin
{
    UIView *superview = self.superview;
    
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:outerView
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1
                                                                  constant:margin]];
}

- (void)constraintTopWithMargin:(CGFloat)margin
{
    [self constraintTopWithOuterView:self.superview margin:margin];
}

- (void)constraintBottomWithMargin:(CGFloat)margin
{
    [self constraintBottomWithOuterView:self.superview margin:margin];
}

- (void)constraintLeftWithMargin:(CGFloat)margin
{
    [self constraintLeftWithOuterView:self.superview margin:margin];
}

- (void)constraintRightWithMargin:(CGFloat)margin
{
    [self constraintRightWithOuterView:self.superview margin:margin];
}

- (void)constraintTopWithBottomOfView:(UIView *)viewTwo margin:(CGFloat)margin
{
    UIView *superview = self.superview;
    
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:viewTwo
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1
                                                                  constant:margin]];
}

- (void)constraintBottomWithTopOfView:(UIView *)viewTwo margin:(CGFloat)margin
{
    UIView *superview = self.superview;
    
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:viewTwo
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1
                                                                  constant:margin]];
}

- (void)constraintLeftWithRightOfView:(UIView *)viewTwo margin:(CGFloat)margin
{
    UIView *superview = self.superview;
    
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:viewTwo
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1
                                                                  constant:margin]];
}

- (void)constraintRightWithLeftOfView:(UIView *)viewTwo margin:(CGFloat)margin
{
    UIView *superview = self.superview;
    
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:viewTwo
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1
                                                                  constant:margin]];
}

@end
