//
//  UIView+All Subview.m
//
//  Created by Alok
//  Copyright (c) 2013 okolodev.org. All rights reserved.
//

#import "UIView+All Subview.h"

@implementation UIView (viewRecursion)

- (NSMutableArray *)allSubViews {
	NSMutableArray *arr = [[NSMutableArray alloc] init];
	[arr addObject:self];
	for (UIView *subview in self.subviews) {
		[arr addObjectsFromArray:(NSArray *)[subview allSubViews]];
	}
	return arr;
}

@end
