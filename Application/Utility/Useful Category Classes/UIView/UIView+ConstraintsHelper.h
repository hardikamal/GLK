//
//  UIView+ConstraintsHelper.h
//
//  Created by Jonas Treub on 15/08/14.
//  Copyright (c) 2015 JonasTreub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ConstraintsHelper)

#pragma mark - fixed size
- (void)constraintWidth:(CGFloat)width height:(CGFloat)height;
- (void)constraintWidth:(CGFloat)width;
- (void)constraintHeight:(CGFloat)height;

#pragma mark - relative size
- (void)constraintWidthAndHeightWithView:(UIView *)view;
- (void)constraintWidthWithView:(UIView *)viewTwo;
- (void)constraintHeightWithView:(UIView *)viewTwo;

- (void)constraintWidthAndHeight;
- (void)constraintWidth;
- (void)constraintHeight;

- (void)constraintWidthWithView:(UIView *)viewTwo ratio:(CGFloat)ratio;
- (void)constraintHeightWithView:(UIView *)viewTwo ratio:(CGFloat)ratio;

- (void)constraintWidthWithRatio:(CGFloat)ratio;
- (void)constraintHeightWithRatio:(CGFloat)ratio;

#pragma mark - center
- (void)constraintCenterWithView:(UIView *)viewTwo;
- (void)constraintCenterXWithView:(UIView *)viewTwo;
- (void)constraintCenterYWithView:(UIView *)viewTwo;

- (void)constraintCenter;
- (void)constraintCenterX;
- (void)constraintCenterY;

#pragma mark - center with offset
- (void)constraintCenterXWithView:(UIView *)viewTwo offset:(CGFloat)offset;
- (void)constraintCenterYWithView:(UIView *)viewTwo offset:(CGFloat)offset;

- (void)constraintCenterXWithOffset:(CGFloat)offset;
- (void)constraintCenterYWithOffset:(CGFloat)offset;

#pragma mark - center with ratio
// ratio goes from 0 = left/top up to 2 = right/bottom
- (void)constraintCenterXWithView:(UIView *)viewTwo ratio:(CGFloat)ratio;
- (void)constraintCenterYWithView:(UIView *)viewTwo ratio:(CGFloat)ratio;

- (void)constraintCenterXWithRatio:(CGFloat)ratio;
- (void)constraintCenterYWithRatio:(CGFloat)ratio;

#pragma mark - position
- (void)constraintTopLeftWithView:(UIView *)viewTwo;
- (void)constraintTopRightWithView:(UIView *)viewTwo;
- (void)constraintBottomLeftWithView:(UIView *)viewTwo;
- (void)constraintBottomRightWithView:(UIView *)viewTwo;

- (void)constraintTopLeft;
- (void)constraintTopRight;
- (void)constraintBottomLeft;
- (void)constraintBottomRight;

- (void)constraintTopWithView:(UIView *)viewTwo;
- (void)constraintBottomWithView:(UIView *)viewTwo;
- (void)constraintLeftWithView:(UIView *)viewTwo;
- (void)constraintRightWithView:(UIView *)viewTwo;

- (void)constraintTop;
- (void)constraintBottom;
- (void)constraintLeft;
- (void)constraintRight;

#pragma mark - position with margin
- (void)constraintTopWithOuterView:(UIView *)viewTwo margin:(CGFloat)margin;
- (void)constraintBottomWithOuterView:(UIView *)viewTwo margin:(CGFloat)margin;
- (void)constraintLeftWithOuterView:(UIView *)viewTwo margin:(CGFloat)margin;
- (void)constraintRightWithOuterView:(UIView *)viewTwo margin:(CGFloat)margin;

- (void)constraintTopWithMargin:(CGFloat)margin;
- (void)constraintBottomWithMargin:(CGFloat)margin;
- (void)constraintLeftWithMargin:(CGFloat)margin;
- (void)constraintRightWithMargin:(CGFloat)margin;

- (void)constraintTopWithBottomOfView:(UIView *)viewTwo margin:(CGFloat)margin;
- (void)constraintBottomWithTopOfView:(UIView *)viewTwo margin:(CGFloat)margin;
- (void)constraintLeftWithRightOfView:(UIView *)viewTwo margin:(CGFloat)margin;
- (void)constraintRightWithLeftOfView:(UIView *)viewTwo margin:(CGFloat)margin;

@end
