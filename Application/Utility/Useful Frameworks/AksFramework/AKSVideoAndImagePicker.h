//
//  Last Updated by Alok on 25/09/14.
//  Copyright (c) 2015 Aryansbtloe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^AKSVideoAndImagePickerOperationFinishedBlock)(NSString *filePath, NSString *fileName, NSString *fileType);

@interface AKSVideoAndImagePicker : NSObject {
    UIImagePickerController *imagePickerController;
    UIPopoverController *popover;
    NSString *lastVideoPath;
}

@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UIPopoverController *popover;
@property (nonatomic, strong) NSString *lastVideoPath;
@property (nonatomic, readwrite) BOOL compression;
@property (nonatomic, copy) AKSVideoAndImagePickerOperationFinishedBlock operationFinishedBlockAKSVIPicker;

+ (void)needImage:(BOOL)imageNeeded needVideo:(BOOL)videoNeeded FromLibrary:(BOOL)fromLibrary compress:(BOOL)compress allowEditing:(BOOL)editing from:(UIViewController *)viewController didFinished:(AKSVideoAndImagePickerOperationFinishedBlock)operationFinishedBlock;

@end
