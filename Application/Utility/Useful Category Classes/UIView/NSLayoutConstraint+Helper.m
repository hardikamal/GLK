//
//  NSLayoutConstraint+Helper.m
//
//  Created by Jonas Treub on 15/08/14.
//  Copyright (c) 2015 JonasTreub. All rights reserved.
//

#import "NSLayoutConstraint+Helper.h"

@implementation NSLayoutConstraint (Helper)

#pragma mark - fixed size
+ (NSLayoutConstraint *)constraintWidthOfView:(UIView *)view width:(CGFloat)width
{
    NSLayoutConstraint *result = [NSLayoutConstraint constraintWithItem:view
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1
                                                               constant:width];
    return result;
}

+ (NSLayoutConstraint *)constraintHeightOfView:(UIView *)view height:(CGFloat)height
{
    NSLayoutConstraint *result = [NSLayoutConstraint constraintWithItem:view
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1
                                                               constant:height];
    return result;
}

#pragma mark - relative size
+ (NSLayoutConstraint *)constraintWidthOfView:(UIView *)view withView:(UIView *)viewTwo
{
    return [self constraintWidthOfView:view withView:viewTwo ratio:1];
}

+ (NSLayoutConstraint *)constraintHeightOfView:(UIView *)view withView:(UIView *)viewTwo
{
    return [self constraintHeightOfView:view withView:viewTwo ratio:1];
}

+ (NSLayoutConstraint *)constraintWidthOfView:(UIView *)view withView:(UIView *)viewTwo ratio:(CGFloat)ratio
{
    NSLayoutConstraint *result = [NSLayoutConstraint constraintWithItem:view
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:viewTwo
                                                              attribute:NSLayoutAttributeWidth
                                                             multiplier:ratio
                                                               constant:0];
    return result;
}

+ (NSLayoutConstraint *)constraintHeightOfView:(UIView *)view withView:(UIView *)viewTwo ratio:(CGFloat)ratio
{
    NSLayoutConstraint *result = [NSLayoutConstraint constraintWithItem:view
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:viewTwo
                                                              attribute:NSLayoutAttributeHeight
                                                             multiplier:ratio
                                                               constant:0];
    return result;
}

#pragma mark - center
+ (NSLayoutConstraint *)constraintCenterXOfView:(UIView *)view withView:(UIView *)viewTwo
{
    return [self constraintCenterXOfView:view withView:viewTwo offset:0];
}

+ (NSLayoutConstraint *)constraintCenterYOfView:(UIView *)view withView:(UIView *)viewTwo
{
    return [self constraintCenterYOfView:view withView:viewTwo offset:0];
}

#pragma mark - center with offset
+ (NSLayoutConstraint *)constraintCenterXOfView:(UIView *)view withView:(UIView *)viewTwo offset:(CGFloat)offset
{
    NSLayoutConstraint *result = [NSLayoutConstraint constraintWithItem:view
                                                              attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:viewTwo
                                                              attribute:NSLayoutAttributeCenterX
                                                             multiplier:1
                                                               constant:offset];
    return result;
}

+ (NSLayoutConstraint *)constraintCenterYOfView:(UIView *)view withView:(UIView *)viewTwo offset:(CGFloat)offset
{
    NSLayoutConstraint *result = [NSLayoutConstraint constraintWithItem:view
                                                              attribute:NSLayoutAttributeCenterY
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:viewTwo
                                                              attribute:NSLayoutAttributeCenterY
                                                             multiplier:1
                                                               constant:offset];
    return result;
}

#pragma mark - center with ratio
// ratio goes from 0 = left/top up to 2 = right/bottom
+ (NSLayoutConstraint *)constraintCenterXView:(UIView *)view withView:(UIView *)viewTwo ratio:(CGFloat)ratio
{
    NSLayoutConstraint *result = [NSLayoutConstraint constraintWithItem:view
                                                              attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:viewTwo
                                                              attribute:NSLayoutAttributeCenterX
                                                             multiplier:ratio
                                                               constant:0];
    return result;
}

+ (NSLayoutConstraint *)constraintCenterYView:(UIView *)view withView:(UIView *)viewTwo ratio:(CGFloat)ratio
{
    NSLayoutConstraint *result = [NSLayoutConstraint constraintWithItem:view
                                                              attribute:NSLayoutAttributeCenterY
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:viewTwo
                                                              attribute:NSLayoutAttributeCenterY
                                                             multiplier:ratio
                                                               constant:0];
    return result;
}

#pragma mark - position
+ (NSLayoutConstraint *)constraintTopOfView:(UIView *)view withView:(UIView *)viewTwo
{
    return [self constraintTopOfView:view withOuterView:viewTwo margin:0];
}

+ (NSLayoutConstraint *)constraintBottomOfView:(UIView *)view withView:(UIView *)viewTwo
{
    return [self constraintBottomOfView:view withOuterView:viewTwo margin:0];
}

+ (NSLayoutConstraint *)constraintLeftOfView:(UIView *)view withView:(UIView *)viewTwo
{
    return [self constraintLeftOfView:view withOuterView:viewTwo margin:0];
}

+ (NSLayoutConstraint *)constraintRightOfView:(UIView *)view withView:(UIView *)viewTwo
{
    return [self constraintRightOfView:view withOuterView:viewTwo margin:0];
}

#pragma mark - position with margin
+ (NSLayoutConstraint *)constraintTopOfView:(UIView *)view withOuterView:(UIView *)viewTwo margin:(CGFloat)margin
{
    NSLayoutConstraint *result = [NSLayoutConstraint constraintWithItem:view
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:viewTwo
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1
                                                               constant:margin];
    return result;
}

+ (NSLayoutConstraint *)constraintBottomOfView:(UIView *)view withOuterView:(UIView *)viewTwo margin:(CGFloat)margin
{
    NSLayoutConstraint *result = [NSLayoutConstraint constraintWithItem:viewTwo
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:view
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:margin];
    return result;
}

+ (NSLayoutConstraint *)constraintLeftOfView:(UIView *)view withOuterView:(UIView *)viewTwo margin:(CGFloat)margin
{
    NSLayoutConstraint *result = [NSLayoutConstraint constraintWithItem:view
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:viewTwo
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1
                                                               constant:margin];
    return result;
}

+ (NSLayoutConstraint *)constraintRightOfView:(UIView *)view withOuterView:(UIView *)viewTwo margin:(CGFloat)margin
{
    NSLayoutConstraint *result = [NSLayoutConstraint constraintWithItem:viewTwo
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:view
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1
                                                               constant:margin];
    return result;
}

+ (NSLayoutConstraint *)constraintTopOfView:(UIView *)view withBottomOfView:(UIView *)viewTwo margin:(CGFloat)margin
{
    NSLayoutConstraint *result = [NSLayoutConstraint constraintWithItem:view
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:viewTwo
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:margin];
    return result;
}

+ (NSLayoutConstraint *)constraintBottomOfView:(UIView *)view withTopOfView:(UIView *)viewTwo margin:(CGFloat)margin
{
    NSLayoutConstraint *result = [NSLayoutConstraint constraintWithItem:viewTwo
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:margin];
    return result;
}

+ (NSLayoutConstraint *)constraintLeftOfView:(UIView *)view withRightOfView:(UIView *)viewTwo margin:(CGFloat)margin
{
    NSLayoutConstraint *result = [NSLayoutConstraint constraintWithItem:view
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:viewTwo
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1
                                                               constant:margin];
    return result;
}

+ (NSLayoutConstraint *)constraintRightOfView:(UIView *)view withLeftOfView:(UIView *)viewTwo margin:(CGFloat)margin
{
    NSLayoutConstraint *result = [NSLayoutConstraint constraintWithItem:viewTwo
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:view
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1
                                                               constant:margin];
    return result;
}

@end
