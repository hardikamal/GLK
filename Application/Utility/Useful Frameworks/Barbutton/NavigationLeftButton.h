//
//  NavigationLeftButton.h
//  Daily Expense Manager
//
//  Created by Appbulous on 13/10/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationLeftButton : UIButton
- (void) setBackgroundColor:(UIColor *) _backgroundColor forState:(UIControlState) _state;
- (UIColor*) backgroundColorForState:(UIControlState) _state;
@end



