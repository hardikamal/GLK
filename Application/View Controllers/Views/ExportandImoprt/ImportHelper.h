//
//  ImportHelper.h
//  Daily Expense Manager
//
//  Created by Appbulous on 12/02/15.
//  Copyright (c) 2015 Chandan Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImportHelper : NSObject
+(ImportHelper *)sharedCoreDataController;
-(void)ExportNewfile:(NSArray*)currentRow;
-(int)getChangeTokenIdOrNot:(NSString *)csvTokenId;
@end
