//
//  BKHTMLLinkButton.h
//  BKHTMLLinkButton
//
//  Created by boreal-kiss.com on 10/04/20.
//  Copyright 2010 boreal-kiss.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BKHTMLLinkButton : UIButton {
	NSString *_buttonTitle;
	NSString *_url;
	UIColor *_normalColor;
	UIColor *_highlightedColor;
	BOOL _textDecorated;
	CGFloat _x;
	CGFloat _y;
	CGFloat _width;
	CGFloat _height;
}
@property (nonatomic, strong) NSString *buttonTitle;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *highlightedColor;
@property (nonatomic) BOOL textDecorated;
@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

+ (id)buttonWithTitle:(NSString *)aTitle url:(NSString *)urlString;
- (id)initWithTitle:(NSString *)aTitle url:(NSString *)urlString;
@end

#import "BKHTMLLinkButton-Accessors.h"
