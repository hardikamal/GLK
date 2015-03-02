//
//  Last Updated by Alok on 19/02/14.
//  Copyright (c) 2015 Aryansbtloe. All rights reserved.
//

#import "LocationRepresentingCell.h"

@implementation LocationRepresentingCell

@synthesize name;
@synthesize isConfigured;

- (void)awakeFromNib {
	[self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	[self others];
}

- (void)others {
	if (isConfigured == NO) {
		isConfigured = YES;
		[self setBackgroundColor:[UIColor clearColor]];
		[name setBackgroundColor:[UIColor clearColor]];
	}
}

+ (float)getRequiredHeight {
	return 40;
}

@end
