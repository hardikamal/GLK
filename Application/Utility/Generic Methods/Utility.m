//
//  Utility.m
//  Tettra
//
//  Created by Harish Kumar Yadav on 25/03/14.
//  Copyright (c) 2014 Ajay Jha. All rights reserved.
//
#import "Reachability.h"
//#import "MBProgressHUD.h"
#import "Utility.h"

@implementation Utility

+(BOOL) isValidEmail:(NSString *)emailString Strict:(BOOL)strictFilter
{
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    
    NSString *emailRegex = strictFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:emailString];
}


+(BOOL)isInternetAvailable
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    if(networkStatus == NotReachable)
        return NO;
    else
        return YES;
    
    return YES;

        
}

+(void)showInternetNotAvailabelAlert
{
    UIAlertView *alertForInternet = [[UIAlertView alloc]initWithTitle:@"No Internet Connection!" message:@"Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alertForInternet show];
}




+(BOOL)isPasswordValid:(UITextField *)txtPassword
{
  
    if([txtPassword.text length] >= 6)
    {
        BOOL isNumeric = [txtPassword.text rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location != NSNotFound;
        NSCharacterSet *alphanumericSet = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"];
        BOOL charcater=[txtPassword.text rangeOfCharacterFromSet:alphanumericSet].location != NSNotFound;

        if(isNumeric && charcater)
        {
            return YES;
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:@"Please Ensure that you have at least one Character, one Digit " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return NO;
        }
   }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:@"Please Ensure that you have at least six character" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    return NO;
}

+(NSString *)machineName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

+(void)showAlertWithMassager:(UIView*)view :(NSString*)string
{
    //UIWindow *tempKeyboardWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
//    [CommonFunctions showHUDInfoMessageWithText:string forDuration:MIN_DUR onView:view];
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:tempKeyboardWindow animated:YES];
//    // Configure for text only and offset down
//    hud.mode = MBProgressHUDModeText;
//    hud.detailsLabelText = string;
//    hud.margin = 10.f;
//    hud.yOffset = 150.f;
//   // hud.removeFromSuperViewOnHide = YES;
//    [hud hide:YES afterDelay:2];
    [CommonFunctions showToastMessageWithMessage:string];
}

+(NSString *)generateGUID
{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return (__bridge NSString *) uuidStr;
}

+(UIView*)addBottomBorderLine:(UITextField*)_txtField
{
    UIView *bottomBorder = [[UIView alloc]
                            initWithFrame:CGRectMake(_txtField.frame.origin.x-100,_txtField.frame.size.height-10, _txtField.frame.size.width+30,1.0f)];
    
    bottomBorder.backgroundColor = [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1.0f];
    return bottomBorder;
}


+(UIView*)addImageonTextField:(UIImage*)image :(UITextField*)_txtField
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, _txtField.frame.size.height/2)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, _txtField.frame.size.height/2, _txtField.frame.size.height/3)];
    imageView.image =image;
    [view addSubview:imageView];
    return view;
}

+ (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    if (image ==nil)
    {
        newImage=[UIImage imageNamed:@"circle.png"];
    }
    UIGraphicsEndImageContext();
    
    return newImage;
}

+(NSNumber*) getGMT_MillisFromYYYY_MM_DD_HH_SS_Date:(NSString*)dateStr
{
      NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    if ([[dateStr componentsSeparatedByString:@" "] count]==3)
    {
        [dateFormat setDateFormat:@"dd/MM/yyyy hh:mm:ss a"];
    }else
         [dateFormat setDateFormat:@"dd/MM/yyyy"];
    
    NSDate *date = [dateFormat dateFromString:dateStr];
    long long milliseconds = (long long)([date timeIntervalSince1970] * 1000.0);
    return [NSNumber numberWithUnsignedLongLong:milliseconds];
}

+(NSNumber*) getGMT_MillisFromYYYY_MM_DD_HH_SS_Date
{
    NSDate *date = [NSDate date];
    long long milliseconds = (long long)([date timeIntervalSince1970] * 1000.0);
    return [NSNumber numberWithUnsignedLongLong:milliseconds];
}

+ (UIImage*)appLogoImage
{
    return [UIImage imageNamed:@"appLogo.png"];
}


+(void)saveToUserDefaults:(id)value withKey:(NSString*)key
{

	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	if (standardUserDefaults)
    {
		[standardUserDefaults setObject:value forKey:key];
		[standardUserDefaults synchronize];
	}
}

+(NSString*)userDefaultsForKey:(NSString*)key
{
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	NSString *val = nil;
	
	if (standardUserDefaults)
		val = [standardUserDefaults objectForKey:key];
	
	return val;
}
+(void)removeFromUserDefaultsWithKey:(NSString*)key
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    [standardUserDefaults removeObjectForKey:key];
    [standardUserDefaults synchronize];
}

#pragma mark - getCurrentLanguage

+ (NSString *)getCurrentLanguage
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
	return [languages objectAtIndex:0];
}
////----- show a alert massage
#pragma mark - show a alert massage

+ (void) showAlertViewWithTag:(NSInteger)tag title:(NSString*)title message:(NSString*)msg delegate:(id)delegate
            cancelButtonTitle:(NSString*)CbtnTitle otherButtonTitles:(NSString*)otherBtnTitles
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:delegate
										  cancelButtonTitle:CbtnTitle otherButtonTitles:otherBtnTitles, nil];
    alert.tag = tag;
	[alert show];
}


#pragma mark - Global Label Size

+(CGSize )labelStr:(NSString *)aString lineLength:(CGFloat)aLength FontSize:(CGFloat)fontSize
{
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:aString attributes:@
                                          {
                                          NSFontAttributeName: [UIFont systemFontOfSize:fontSize]
                                          }];
    
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){aLength, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    
    CGSize result = CGSizeMake(ceilf(rect.size.width), ceilf(rect.size.height));
    return result;
}

+(float )heightLabel:(NSString *)labelStr lineWidth:(CGFloat)aWidth fontSize:(CGFloat)fontSize
{
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:labelStr attributes:@
                                          {
                                          NSFontAttributeName: [UIFont systemFontOfSize:fontSize]
                                          }];
    
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){aWidth, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    return ceilf(rect.size.height);
}

+(float )heightLabel:(NSString *)labelStr lineWidth:(CGFloat)aWidth fontName:(NSString*)fontName fontSize:(CGFloat)fontSize
{
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:labelStr attributes:@
                                          {
                                          NSFontAttributeName:[UIFont fontWithName:Embrima size:fontSize]
                                          }];
    
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){aWidth, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    
    return ceilf(rect.size.height);
}

#pragma mark - String By Adding Space

+(NSString*)stringByAddingSpace:(NSString*)stringToAddSpace spaceCount:(NSInteger)spaceCount atIndex:(NSInteger)index
{
    NSString *result = [NSString stringWithFormat:@"%@%@",[@" " stringByPaddingToLength:spaceCount withString:@" " startingAtIndex:0],stringToAddSpace];
    return result;
}

#pragma mark - String By Triming Space

+(NSString*)stringByTrimingWhiteSpace:(NSString*)myText
{
    NSString *trimmedText = [myText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return trimmedText;
}

#pragma mark - Modify Date Format

+(NSString *)modifyDate:(NSString *)aDate fromFormat:(NSString *)fromFormat toFormat:(NSString *)toFormat
{
    //Date
    NSDateFormatter *formator=[[NSDateFormatter alloc]init];
    [formator setDateFormat:fromFormat];
    NSDate *dt=[formator dateFromString:aDate];
    [formator setDateFormat:toFormat];//@"MMMM d, YYYY"]
    NSString *modifiedDate=[formator stringFromDate:dt];
    return modifiedDate;
}

#pragma mark - Set Date And Time

+(NSString *)setDatesAgo:(NSString *)aDate
{
    NSDateFormatter *format=[[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [format setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    NSDate* date1 = [format dateFromString:aDate];
    NSDate* date2=[NSDate date];
    NSTimeInterval distanceBetweenDates = [date2 timeIntervalSinceDate:date1];
    NSInteger days=distanceBetweenDates/(60*60*24);
    NSInteger hoursBetweenDates = distanceBetweenDates/(60*60);
    NSInteger minbetweendates=distanceBetweenDates/60;
    
    NSString *str=@"";
    
    if(hoursBetweenDates>24)
    {
        if(days>1)
            str=[NSString stringWithFormat:@"%li days ago",(long)days];
        else
            str=[NSString stringWithFormat:@"%li day ago",(long)days];
    }
    else if(hoursBetweenDates>0)
    {
        if(hoursBetweenDates>1)
            str=[NSString stringWithFormat:@"%li hrs ago",(long)hoursBetweenDates];
        else
            str=[NSString stringWithFormat:@"%li hr ago",(long)hoursBetweenDates];
    }
    else
    {
        if(minbetweendates>1)
            str=[NSString stringWithFormat:@"%li mins ago",(long)minbetweendates];
        else
            str=[NSString stringWithFormat:@"%li min ago",(long)minbetweendates];
    }
    return str;
}

+(NSString *)setDatesAgoExtended:(NSString *)aDate
{
    //    NSDateFormatter *format=[[NSDateFormatter alloc]init];
    //    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    [format setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    //
    //    NSDate* date1 = [format dateFromString:aDate];
    ////    NSString *finalStr=[date1 myDateTimeAgo];
    NSString *finalStr=@"test";
    return finalStr;
}

+(NSString *)setDateAndTime :(NSString *)aDate
{
    NSDateFormatter *format=[[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [format setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate* date1 = [format dateFromString:aDate];
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"dd/MM/yy| hh:mm a"];
    NSString *finalDate=[df stringFromDate:date1];
    //    NSLog(@"finalDate:--->%@",finalDate);
    return finalDate;
}

#pragma mark - NSKeyedArchiver

+(NSData*) getArchievedDataFromDic:(NSDictionary*)dic
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
    return data;
}
+(NSDictionary*) getDicFromArchievedData:(NSData*)data
{
    NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return dic;
}

+(NSData*) getArchievedDataFromArray:(NSArray *)array
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
    return data;
}

+(NSArray*) getArrayFromArchievedData:(NSData*)data
{
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return array;
}

#pragma mark - For Incomplete URL path

+(NSURL*) findUrlPath:(NSString*)aUrl
{
    BOOL results = [[aUrl lowercaseString] hasPrefix:@"http://"] || [[aUrl lowercaseString] hasPrefix:@"https://"];
    NSURL *urlAddress = nil;
    
    if (results)
    {
        urlAddress = [NSURL URLWithString:aUrl];
    }
    else
    {
        //        NSString *resultUrl = [NSString stringWithFormat:@"%@%@",BaseUrl,aUrl];
        //        urlAddress = [NSURL URLWithString: resultUrl];
    }
    return urlAddress;
}

#pragma mark - For Decimal Number Formating

+(NSString *)myNumberFormatter:(NSString*)aNumber
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setGroupingSize:3];
    [formatter setSecondaryGroupingSize:2];
    [formatter setGroupingSeparator:@","];
    NSNumber *numberFromString = [formatter numberFromString:aNumber];
    NSString *finalValue = [formatter stringFromNumber:numberFromString];
    return finalValue;
}

#pragma mark - uniqueIDForDevice

+(NSString*)uniqueIDForDevice
{
    NSString* uniqueIdentifier = nil;
    if( [UIDevice instancesRespondToSelector:@selector(identifierForVendor)] )
    { // >=iOS 7
        uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    } else { //<=iOS6, Use UDID of Device
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        //uniqueIdentifier = ( NSString*)CFUUIDCreateString(NULL, uuid);- for non- ARC
        uniqueIdentifier = ( NSString*)CFBridgingRelease(CFUUIDCreateString(NULL, uuid));// for ARC
        CFRelease(uuid);
    }
    return uniqueIdentifier;
}

#pragma mark - flipWithinThreeDStlyeWithInView

+(void) flipWithinThreeDStlyeWithInView:(UIView *)rotateIn andRotateOut:(UIView *)rotateOut
{
    
    rotateIn.layer.anchorPointZ = 11.547f;
    rotateIn.layer.doubleSided = NO;
    rotateIn.layer.zPosition = 2;
    
    CATransform3D viewInStartTransform = CATransform3DMakeRotation(RADIANS(120), 1.0, 0.0, 0.0);
    viewInStartTransform.m34 = -1.0 / 200.0;
    
    rotateOut.layer.anchorPointZ = 11.547f;
    rotateOut.layer.doubleSided = NO;
    rotateOut.layer.zPosition = 2;
    
    CATransform3D viewOutEndTransform = CATransform3DMakeRotation(RADIANS(-120), 1.0, 0.0, 0.0);
    viewOutEndTransform.m34 = -1.0 / 200.0;
    rotateIn.layer.transform = viewInStartTransform;
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         rotateIn.layer.transform = CATransform3DIdentity;
                         rotateOut.layer.transform = viewOutEndTransform;
                     }
                     completion:^(BOOL finished)
     {
         
     }];
}

#pragma mark - Resize Image

+(UIImage *)resizeImage:(UIImage *)orginalImage resizeSize:(CGSize)size
{
	CGFloat actualHeight = orginalImage.size.height;
	CGFloat actualWidth = orginalImage.size.width;
	if(actualWidth <= size.width && actualHeight<=size.height)
	{
		return orginalImage;
	}
	float oldRatio = actualWidth/actualHeight;
	float newRatio = size.width/size.height;
	if(oldRatio < newRatio)
	{
		oldRatio = size.height/actualHeight;
		actualWidth = oldRatio * actualWidth;
		actualHeight = size.height;
	}
	else
	{
		oldRatio = size.width/actualWidth;
		actualHeight = oldRatio * actualHeight;
		actualWidth = size.width;
	}
	CGRect rect = CGRectMake(0.0,0.0,actualWidth,actualHeight);
	UIGraphicsBeginImageContext(rect.size);
	[orginalImage drawInRect:rect];
	orginalImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return orginalImage;
}

+(UIImage *)scaleImage:(UIImage *)image1 toSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image1 drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+(UIImage *)normalizedImage:(UIImage *)image {
    if (image.imageOrientation == UIImageOrientationUp) return image;
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    [image drawInRect:(CGRect){0, 0, image.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}

#pragma mark - Count String

+(NSString *)countStr:(NSString*)countStr countLabelName:(NSString*)countLabelName
{
    //    NSNull *nullValue = [NSNull null];
    //    NSArray *arrayWithNull = @[nullValue];
    //    NSLog(@"arrayWithNull: %@", arrayWithNull);
    //    // Output: "arrayWithNull: (<null>)"
    
    NSString *finalStr=nil;
    if ((countStr == (NSString *) [NSNull null]) || (countStr.length == 0))
    {
        finalStr=[NSString stringWithFormat:@"0 %@",countLabelName];
    }
    else
    {
        int countInt=[countStr intValue];
        if(countInt==1 || countInt==0)
            finalStr=[NSString stringWithFormat:@"%d %@",countInt,countLabelName];
        else
            finalStr=[NSString stringWithFormat:@"%d %@s",countInt,countLabelName];
    }
    return finalStr;
}

#pragma mark - Time Difference

+(NSDateComponents *)getTimeDifference:(NSDate*)newDate
{
    NSDate *currentDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DATEFORMATTER2];
    
    NSString* currentDateStr=[dateFormatter stringFromDate:currentDate];
    NSString* newDateStr=[dateFormatter stringFromDate:newDate];
    
    currentDate=[dateFormatter dateFromString:currentDateStr];
    newDate=[dateFormatter dateFromString:newDateStr];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSCalederUnit
                                               fromDate:currentDate
                                                 toDate:newDate //EventDate
                                                options:0];
    
    return components;
}

#pragma mark - Get Age

+(NSDateComponents *)getAges:(NSDate*)dobDate
{
    NSDate *currentDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DATEFORMATTER2];
    
    NSString* currentDateStr=[dateFormatter stringFromDate:currentDate];
    NSString* newDateStr=[dateFormatter stringFromDate:dobDate];
    
    currentDate=[dateFormatter dateFromString:currentDateStr];
    dobDate=[dateFormatter dateFromString:newDateStr];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSCalederUnit
                                               fromDate:dobDate
                                                 toDate:currentDate
                                                options:0];
    
    
    return components;
}


+(void)setFontFamily:(NSString*)fontFamily forView:(UIView*)view andSubViews:(BOOL)isSubViews
{
    if ([view isKindOfClass:[UILabel class]])
    {
        UILabel *lbl = (UILabel *)view;
        [lbl setFont:[UIFont fontWithName:fontFamily size:[[lbl font] pointSize]]];
    }
    
    if (isSubViews)
    {
        for (UIView *sview in view.subviews)
        {
            [self setFontFamily:fontFamily forView:sview andSubViews:YES];
        }
    }
}





@end
