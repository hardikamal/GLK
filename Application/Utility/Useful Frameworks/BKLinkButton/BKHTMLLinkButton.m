//
//  BKHTMLLinkButton.m
//  BKHTMLLinkButton
//
//  Created by boreal-kiss.com on 10/04/20.
//  Copyright 2010 boreal-kiss.com. All rights reserved.
//

#import "BKHTMLLinkButton.h"

//Private
static const NSUInteger DefaultNormalColor = 0x336699;
static const NSUInteger DefaultHighlightedColor = 0xFFFFFF;
static NSString *const DefaultFontName = @"Helvetica-Bold";
static const CGFloat DefaultFontSize = 15.0;

//Private
@interface BKHTMLLinkButton ()
- (void)_initIvars;
- (void)_updateControl;
- (void)_touchUpInside;
- (CGPoint)_startPointWithRectSize:(CGSize)rectSize titleSize:(CGSize)titleSize;
- (UIColor *)_colorFromHex:(NSUInteger)color24;
@end

@implementation BKHTMLLinkButton
@synthesize buttonTitle = _buttonTitle;
@synthesize url = _url;
@synthesize normalColor = _normalColor;
@synthesize highlightedColor = _highlightedColor;
@synthesize textDecorated = _textDecorated;
@synthesize x = _x;
@synthesize y = _y;
@synthesize width = _width;
@synthesize height = _height;

+ (id)buttonWithTitle:(NSString *)aTitle url:(NSString *)urlString {
	return [[[self class] alloc] initWithTitle:aTitle url:urlString];
}

//The designated initializer.
- (id)initWithTitle:(NSString *)aTitle url:(NSString *)urlString {
	if (self = [super init]) {
		self.buttonTitle = aTitle;
		self.url = urlString;
		self.normalColor = [self _colorFromHex:DefaultNormalColor];
		self.highlightedColor = [self _colorFromHex:DefaultHighlightedColor];
		self.font = [UIFont fontWithName:DefaultFontName size:DefaultFontSize];
		[self _initIvars];
	}
	return self;
}

//Override
- (void)awakeFromNib {
	self.buttonTitle = self.currentTitle;
	self.normalColor = [self titleColorForState:UIControlStateNormal];
	self.highlightedColor = [self titleColorForState:UIControlStateHighlighted];
	[self _initIvars];
}

//Override
- (void)drawRect:(CGRect)rect {
	if (_textDecorated) {
		CGSize rectSize = rect.size;
		CGSize titleSize = [_buttonTitle sizeWithFont:self.titleLabel.font];
		CGPoint startP = [self _startPointWithRectSize:rectSize titleSize:titleSize];
		CGPoint endP = CGPointMake(startP.x + titleSize.width, startP.y);
		CGContextRef context = UIGraphicsGetCurrentContext();
		CGContextSetStrokeColorWithColor(context, self.currentTitleColor.CGColor);
		CGContextMoveToPoint(context, startP.x, startP.y);
		CGContextAddLineToPoint(context, endP.x, endP.y);
		CGContextStrokePath(context);
	}
}

#pragma mark -
#pragma mark Private

- (void)_initIvars {
	_x = self.frame.origin.x;
	_y = self.frame.origin.y;
	_width = self.frame.size.width;
	_height = self.frame.size.height;
	_textDecorated = YES;
	[self _updateControl];
}

- (void)_updateControl {
	[self addTarget:self action:@selector(_touchUpInside) forControlEvents:UIControlEventTouchUpInside];
	[self addTarget:self action:@selector(setNeedsDisplay) forControlEvents:UIControlEventAllTouchEvents];
}

- (void)_touchUpInside {
	if (_url) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:_url]];
	}
	[self setNeedsDisplay];
}

- (CGPoint)_startPointWithRectSize:(CGSize)rectSize titleSize:(CGSize)titleSize {
	CGFloat startX, startY, descender;

	switch (self.contentHorizontalAlignment) {
		case UIControlContentHorizontalAlignmentCenter:
			startX = (rectSize.width - titleSize.width) / 2.0;
			break;

		case UIControlContentHorizontalAlignmentLeft:
			startX = 0.0;
			break;

		case UIControlContentHorizontalAlignmentRight:
			startX = rectSize.width - titleSize.width;
			break;

		default:
			break;
	}

	descender = self.titleLabel.font.descender + 2;
	startY = (rectSize.height + titleSize.height) / 2.0 + descender;

	return CGPointMake(startX, startY);
}

//Utility
- (UIColor *)_colorFromHex:(NSUInteger)color24 {
	CGFloat r = (color24 >> 16) / 255.0f;
	CGFloat g = (color24 >> 8 & 0xFF) / 255.0f;
	CGFloat b = (color24 & 0xFF) / 255.0f;
	return [UIColor colorWithRed:r green:g blue:b alpha:1.0f];
}

@end
