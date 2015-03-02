//
//  BoderView.m
//  Daily Expense Manager
//
//  Created by Appbulous on 29/10/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import "BoderView.h"

@implementation BoderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
       
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    CGFloat borderWidth = .3f;
    self.frame = CGRectInset(self.frame, -borderWidth, -borderWidth);
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = borderWidth;
}


@end
