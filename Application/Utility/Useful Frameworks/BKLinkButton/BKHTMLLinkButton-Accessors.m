//
//  BKHTMLLinkButton-Accessors.m
//  BKHTMLLinkButton
//
//  Created by boreal-kiss.com on 10/04/20.
//  Copyright 2010 boreal-kiss.com. All rights reserved.
//

#import "BKHTMLLinkButton-Accessors.h"

//Private
@interface BKHTMLLinkButton ()
- (void)_updateControl;
@end

@implementation BKHTMLLinkButton (Accessors)

//Override
- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	[self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font {
	[[super titleLabel] setFont:font];
	[self setNeedsDisplay];
}

- (void)setNormalColor:(UIColor *)aColor {
	if (_normalColor != aColor) {
		_normalColor = aColor;
		[self setTitleColor:_normalColor forState:UIControlStateNormal];
	}
}

- (void)setHighlightedColor:(UIColor *)aColor {
	if (_highlightedColor != aColor) {
		_highlightedColor = aColor;
		[self setTitleColor:_highlightedColor forState:UIControlStateHighlighted];
	}
}

- (void)setButtonTitle:(NSString *)aTitle {
	if (_buttonTitle != aTitle) {
		_buttonTitle = aTitle;
		[self setTitle:_buttonTitle forState:UIControlStateNormal];
		[self setTitle:_buttonTitle forState:UIControlStateHighlighted];
	}
}

- (void)setUrl:(NSString *)urlString {
	if (_url != urlString) {
		_url = urlString;
		[self _updateControl];
	}
}

- (void)setX:(CGFloat)value {
	_x = value;
	self.frame = CGRectMake(_x, _y, _width, _height);
	[self setNeedsDisplay];
}

- (void)setY:(CGFloat)value {
	_y = value;
	self.frame = CGRectMake(_x, _y, _width, _height);
	[self setNeedsDisplay];
}

- (void)setWidth:(CGFloat)value {
	_width = value;
	self.frame = CGRectMake(_x, _y, _width, _height);
	[self setNeedsDisplay];
}

- (void)setHeight:(CGFloat)value {
	_height = value;
	self.frame = CGRectMake(_x, _y, _width, _height);
	[self setNeedsDisplay];
}

@end
