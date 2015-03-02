//
//  Utility.h
//  Tettra
//
//  Created by Harish Kumar Yadav on 25/03/14.
//  Copyright (c) 2014 Ajay Jha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/utsname.h>

#define kCMNavBarNotificationHeight    44.0f
#define kCMNavBarNotificationIPadWidth 480.0f
#define RADIANS(deg) ((deg) * M_PI / 180.0f)

@interface Utility : NSObject

+(BOOL) isValidEmail:(NSString *)emailString Strict:(BOOL)strictFilter;

+(BOOL)isInternetAvailable;
+(void)showInternetNotAvailabelAlert;
+(BOOL)isPasswordValid:(UITextField *)textField;
+(NSString*)generateGUID;
+(NSString*)machineName;
+(UIView*)addBottomBorderLine:(UITextField*)_txtField;
+(UIView*)addImageonTextField:(UIImage*)image :(UITextField*)_txtField;
+ (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
+(NSNumber*) getGMT_MillisFromYYYY_MM_DD_HH_SS_Date:(NSString*)dateStr;
+(NSNumber*) getGMT_MillisFromYYYY_MM_DD_HH_SS_Date;
+ (UIImage*)appLogoImage;
+(void)saveToUserDefaults:(id)value withKey:(NSString*)key;
+(NSString*)userDefaultsForKey:(NSString*)key;
+(void)removeFromUserDefaultsWithKey:(NSString*)key;

//+ (NSString*)displayStringForKey:(NSString*)key;
//+ (BOOL)imageExist:(NSString*)imageName;

+ (void) showAlertViewWithTag:(NSInteger)tag title:(NSString*)title message:(NSString*)msg delegate:(id)delegate
            cancelButtonTitle:(NSString*)CbtnTitle otherButtonTitles:(NSString*)otherBtnTitles;
+ (NSString *)getCurrentLanguage;
+(UIImage *)normalizedImage:(UIImage *)image;
+(CGSize )labelStr:(NSString *)aString lineLength:(CGFloat)aLength FontSize:(CGFloat)fontSize;
+(NSString*)stringByAddingSpace:(NSString*)stringToAddSpace spaceCount:(NSInteger)spaceCount atIndex:(NSInteger)index;
+(NSString*)stringByTrimingWhiteSpace:(NSString*)myText;
+(NSString *)modifyDate:(NSString *)aDate fromFormat:(NSString *)fromFormat toFormat:(NSString *)toFormat;

+(NSURL*) findUrlPath:(NSString*)aUrl;
+(NSString *)setDatesAgo:(NSString *)aDate;
+(NSString *)setDatesAgoExtended:(NSString *)aDate;
+(NSString *)setDateAndTime :(NSString *)aDate;
+(NSData*) getArchievedDataFromDic:(NSDictionary*)dic;
+(NSDictionary*) getDicFromArchievedData:(NSData*)data;
+(NSData*) getArchievedDataFromArray:(NSArray *)array;
+(NSArray*) getArrayFromArchievedData:(NSData*)data;

+(NSString *)myNumberFormatter:(NSString*)aNumber;
+(NSString*)uniqueIDForDevice;

+(void) flipWithinThreeDStlyeWithInView:(UIView *)rotateIn andRotateOut:(UIView *)rotateOut;
+(UIImage *)scaleImage:(UIImage *)image1 toSize:(CGSize)newSize;
+(UIImage *)resizeImage:(UIImage *)orginalImage resizeSize:(CGSize)size;

+(NSString *)countStr:(NSString*)countStr countLabelName:(NSString*)countLabelName;
+(float )heightLabel:(NSString *)labelStr lineWidth:(CGFloat)aWidth fontSize:(CGFloat)fontSize;
+(float )heightLabel:(NSString *)labelStr lineWidth:(CGFloat)aWidth fontName:(NSString*)fontName fontSize:(CGFloat)fontSize;
+(NSDateComponents *)getTimeDifference:(NSDate*)newDate;
+(NSDateComponents *)getAges:(NSDate*)dobDate;
+(void)setFontFamily:(NSString*)fontFamily forView:(UIView*)view andSubViews:(BOOL)isSubViews;
+(BOOL)initReminder:(NSDictionary*)dictionary;
+(void)showAlertWithMassager:(UIView*)view :(NSString*)string;
@end
