//
//  Last Updated by Alok on 19/02/14.
//  Copyright (c) 2015 Aryansbtloe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationRepresentingCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *name;
@property (nonatomic, readwrite) BOOL isConfigured;

+ (float)getRequiredHeight;

@end
