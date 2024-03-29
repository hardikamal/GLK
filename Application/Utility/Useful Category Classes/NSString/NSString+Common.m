#import "NSString+Common.h"


@implementation NSString (Common)

- (BOOL)isBlank {
	if ([[self stringByStrippingWhitespace] isEqualToString:@""])
		return YES;
	return NO;
}

- (BOOL)contains:(NSString *)string {
	NSRange range = [self rangeOfString:string];
	return (range.location != NSNotFound);
}

- (NSString *)stringByStrippingWhitespace {
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSArray *)splitOnChar:(char)ch {
	NSMutableArray *results = [[NSMutableArray alloc] init];
	int start = 0;
	for (int i = 0; i < [self length]; i++) {
		BOOL isAtSplitChar = [self characterAtIndex:i] == ch;
		BOOL isAtEnd = i == [self length] - 1;
        
		if (isAtSplitChar || isAtEnd) {
			//take the substring &amp; add it to the array
			NSRange range;
			range.location = start;
			range.length = i - start + 1;
            
			if (isAtSplitChar)
				range.length -= 1;
            
			[results addObject:[self substringWithRange:range]];
			start = i + 1;
		}
        
		//handle the case where the last character was the split char.  we need an empty trailing element in the array.
		if (isAtEnd && isAtSplitChar)
			[results addObject:@""];
	}
    
	return results;
}

- (NSString *)substringFrom:(NSInteger)from to:(NSInteger)to {
	NSString *rightPart = [self substringFromIndex:from];
	return [rightPart substringToIndex:to - from];
}

- (NSString *)firstName {
	NSArray *subStrings = [self componentsSeparatedByString:@" "];
	if ([subStrings count] > 0) {
		return [subStrings objectAtIndex:0];
	}
	else {
		return @"";
	}
}

- (NSString *)lastName {
	NSArray *subStrings = [self componentsSeparatedByString:@" "];
	if ([subStrings count] > 0) {
		return [subStrings objectAtIndex:([subStrings count] - 1)];
	}
	else {
		return @"";
	}
}

- (NSString *)encoded {
	return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)decoded {
	return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
