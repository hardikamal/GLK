//
//  NSLayoutConstraint+Helper.h
//
//  Created by Jonas Treub on 15/08/14.
//  Copyright (c) 2015 JonasTreub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSLayoutConstraint (Helper)

#pragma mark - fixed size
+ (NSLayoutConstraint *)constraintWidthOfView:(UIView *)view width:(CGFloat)width;
+ (NSLayoutConstraint *)constraintHeightOfView:(UIView *)view height:(CGFloat)height;

#pragma mark - relative size
+ (NSLayoutConstraint *)constraintWidthOfView:(UIView *)view withView:(UIView *)viewTwo;
+ (NSLayoutConstraint *)constraintHeightOfView:(UIView *)view withView:(UIView *)viewTwo;

+ (NSLayoutConstraint *)constraintWidthOfView:(UIView *)view withView:(UIView *)viewTwo ratio:(CGFloat)ratio;
+ (NSLayoutConstraint *)constraintHeightOfView:(UIView *)view withView:(UIView *)viewTwo ratio:(CGFloat)ratio;

#pragma mark - center
+ (NSLayoutConstraint *)constraintCenterXOfView:(UIView *)view withView:(UIView *)viewTwo;
+ (NSLayoutConstraint *)constraintCenterYOfView:(UIView *)view withView:(UIView *)viewTwo;

#pragma mark - center with offset
+ (NSLayoutConstraint *)constraintCenterXOfView:(UIView *)view withView:(UIView *)viewTwo offset:(CGFloat)offset;
+ (NSLayoutConstraint *)constraintCenterYOfView:(UIView *)view withView:(UIView *)viewTwo offset:(CGFloat)offset;

#pragma mark - center with ratio
// ratio goes from 0 = left/top up to 2 = right/bottom
+ (NSLayoutConstraint *)constraintCenterXView:(UIView *)view withView:(UIView *)viewTwo ratio:(CGFloat)ratio;
+ (NSLayoutConstraint *)constraintCenterYView:(UIView *)view withView:(UIView *)viewTwo ratio:(CGFloat)ratio;

#pragma mark - position
+ (NSLayoutConstraint *)constraintTopOfView:(UIView *)view withView:(UIView *)viewTwo;
+ (NSLayoutConstraint *)constraintBottomOfView:(UIView *)view withView:(UIView *)viewTwo;
+ (NSLayoutConstraint *)constraintLeftOfView:(UIView *)view withView:(UIView *)viewTwo;
+ (NSLayoutConstraint *)constraintRightOfView:(UIView *)view withView:(UIView *)viewTwo;

#pragma mark - position with margin
+ (NSLayoutConstraint *)constraintTopOfView:(UIView *)view withOuterView:(UIView *)viewTwo margin:(CGFloat)margin;
+ (NSLayoutConstraint *)constraintBottomOfView:(UIView *)view withOuterView:(UIView *)viewTwo margin:(CGFloat)margin;
+ (NSLayoutConstraint *)constraintLeftOfView:(UIView *)view withOuterView:(UIView *)viewTwo margin:(CGFloat)margin;
+ (NSLayoutConstraint *)constraintRightOfView:(UIView *)view withOuterView:(UIView *)viewTwo margin:(CGFloat)margin;

+ (NSLayoutConstraint *)constraintTopOfView:(UIView *)view withBottomOfView:(UIView *)viewTwo margin:(CGFloat)margin;
+ (NSLayoutConstraint *)constraintBottomOfView:(UIView *)view withTopOfView:(UIView *)viewTwo margin:(CGFloat)margin;
+ (NSLayoutConstraint *)constraintLeftOfView:(UIView *)view withRightOfView:(UIView *)viewTwo margin:(CGFloat)margin;
+ (NSLayoutConstraint *)constraintRightOfView:(UIView *)view withLeftOfView:(UIView *)viewTwo margin:(CGFloat)margin;


@end
