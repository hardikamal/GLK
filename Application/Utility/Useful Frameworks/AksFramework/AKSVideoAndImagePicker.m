//
//  Last Updated by Alok on 25/09/14.
//  Copyright (c) 2015 Aryansbtloe. All rights reserved.
//

#import "AKSVideoAndImagePicker.h"
#import <QuartzCore/QuartzCore.h>
#import "NSObject+PE.h"
#import <AVFoundation/AVFoundation.h>

static AKSVideoAndImagePicker *aKSVideoAndImagePicker_ = nil;

@implementation AKSVideoAndImagePicker

@synthesize operationFinishedBlockAKSVIPicker;
@synthesize imagePickerController;
@synthesize lastVideoPath;
@synthesize popover;
@synthesize compression;

+ (AKSVideoAndImagePicker *)sharedAKSVideoAndImagePicker {
    TCSTART
    
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        if (aKSVideoAndImagePicker_ == nil) {
            aKSVideoAndImagePicker_ = [[AKSVideoAndImagePicker alloc]init];
        }
    });
    return aKSVideoAndImagePicker_;
    
    TCEND
}

+ (void)needImage:(BOOL)imageNeeded needVideo:(BOOL)videoNeeded FromLibrary:(BOOL)fromLibrary compress:(BOOL)compress allowEditing:(BOOL)editing from:(UIViewController *)viewController didFinished:(AKSVideoAndImagePickerOperationFinishedBlock)operationFinishedBlock {
    TCSTART
    
    if ((fromLibrary == NO) && (IS_CAMERA_AVAILABLE == NO)) {
        [CommonFunctions showNotificationInViewController:viewController withTitle:nil withMessage:@"Camera not available" withType:TSMessageNotificationTypeError withDuration:MIN_DUR];
        return;
    }
    
    [AKSVideoAndImagePicker sharedAKSVideoAndImagePicker];
    
    aKSVideoAndImagePicker_.operationFinishedBlockAKSVIPicker = operationFinishedBlock;
    aKSVideoAndImagePicker_.imagePickerController                      = [[UIImagePickerController alloc]init];
    aKSVideoAndImagePicker_.imagePickerController.videoQuality         = UIImagePickerControllerQualityTypeHigh;
    aKSVideoAndImagePicker_.imagePickerController.videoMaximumDuration = 90;
    aKSVideoAndImagePicker_.imagePickerController.delegate             = aKSVideoAndImagePicker_;
    aKSVideoAndImagePicker_.imagePickerController.allowsEditing        = editing;
    aKSVideoAndImagePicker_.compression = compress;
    
    if (fromLibrary) aKSVideoAndImagePicker_.imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    else aKSVideoAndImagePicker_.imagePickerController.sourceType           = UIImagePickerControllerSourceTypeCamera;
    
    NSMutableArray *mediaType = [[NSMutableArray alloc]init];
    if (videoNeeded) [mediaType addObject:@"public.movie"];
    if (imageNeeded) [mediaType addObject:@"public.image"];
    
    aKSVideoAndImagePicker_.imagePickerController.mediaTypes = mediaType;
    
    [viewController presentViewController:aKSVideoAndImagePicker_.imagePickerController animated:YES completion:nil];
    TCEND
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    TCSTART dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.05 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [AKSVideoAndImagePicker didFinishPickingMediaWithInfo:info];
    });
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    imagePickerController = nil;
    
    TCEND
}

+ (void)didFinishPickingMediaWithInfo:(NSDictionary *)info {
    TCSTART
    
    NSString *mediaType = [info objectForKey:@"UIImagePickerControllerMediaType"];
    
    if ([mediaType isEqualToString:@"public.movie"]) {
        [AKSVideoAndImagePicker showActivityIndicatorWithText:@"Processing"];
        [AKSVideoAndImagePicker saveVideoInDocumentsTemporarily:info];
        [AKSVideoAndImagePicker reformatVideoAndCompressIfRequired];
    }
    else if ([mediaType isEqualToString:@"public.image"]) {
        [AKSVideoAndImagePicker showActivityIndicatorWithText:@"processing"];
        
        UIImage *image = info[UIImagePickerControllerEditedImage];
        if (!image) {
            image = info[UIImagePickerControllerOriginalImage];
        }
        if (aKSVideoAndImagePicker_.compression) {
            image = [AKSMethods compressThisImage:image];
        }
        if (image) {
            NSString *pathToUnupdatedDirectory = [AKSVideoAndImagePicker getFilePathToSaveUnUpdatedImage];
            [UIImageJPEGRepresentation(image, 0.5) writeToFile:pathToUnupdatedDirectory atomically:YES];
            aKSVideoAndImagePicker_.operationFinishedBlockAKSVIPicker(pathToUnupdatedDirectory, [pathToUnupdatedDirectory lastPathComponent], @"image");
        }
        aKSVideoAndImagePicker_.operationFinishedBlockAKSVIPicker = nil;
        [AKSVideoAndImagePicker removeActivityIndicator];
    }
    
    TCEND
}

+ (void)reformatVideoAndCompressIfRequired {
    aKSVideoAndImagePicker_.lastVideoPath = [AKSVideoAndImagePicker getFilePathToSaveUnUpdatedVideo];
    if (aKSVideoAndImagePicker_.compression) {
        [AKSVideoAndImagePicker videoProcessingOperationWithInputURL:[NSURL fileURLWithPath:[AKSVideoAndImagePicker getTemporaryFilePathToSaveVideo]] outputURL:[NSURL fileURLWithPath:aKSVideoAndImagePicker_.lastVideoPath] handler: ^(AVAssetExportSession *exportSession) {
            [aKSVideoAndImagePicker_ performSelectorOnMainThread:@selector(operationSuccessfull) withObject:nil waitUntilDone:NO];
        }];
    }
    else {
        NSError *error;
        [FCFileManager copyItemAtPath:[AKSVideoAndImagePicker getTemporaryFilePathToSaveVideo] toPath:aKSVideoAndImagePicker_.lastVideoPath error:&error];
        [AKSMethods showMessage:[error description]];
        [AKSVideoAndImagePicker removeActivityIndicator];
        aKSVideoAndImagePicker_.operationFinishedBlockAKSVIPicker(aKSVideoAndImagePicker_.lastVideoPath, [aKSVideoAndImagePicker_.lastVideoPath lastPathComponent], @"video");
        aKSVideoAndImagePicker_.operationFinishedBlockAKSVIPicker = nil;
    }
}

+ (void)videoProcessingOperationWithInputURL:(NSURL *)inputURL outputURL:(NSURL *)outputURL handler:(void (^)(AVAssetExportSession *))handler {
    [[NSFileManager defaultManager] removeItemAtURL:outputURL error:nil];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    
    NSString *presetName = nil;
    if (aKSVideoAndImagePicker_.compression) {
        presetName = AVAssetExportPresetLowQuality;
    }
    else {
        presetName = AVAssetExportPresetHighestQuality;
    }
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:presetName];
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    exportSession.shouldOptimizeForNetworkUse = aKSVideoAndImagePicker_.compression;
    [exportSession exportAsynchronouslyWithCompletionHandler: ^(void) {
        handler(exportSession);
    }];
}

- (void)operationSuccessfull {
    [AKSVideoAndImagePicker removeActivityIndicator];
    aKSVideoAndImagePicker_.operationFinishedBlockAKSVIPicker(aKSVideoAndImagePicker_.lastVideoPath, [aKSVideoAndImagePicker_.lastVideoPath lastPathComponent], @"video");
    aKSVideoAndImagePicker_.operationFinishedBlockAKSVIPicker = nil;
}

+ (void)saveVideoInDocumentsTemporarily:(NSDictionary *)info {
    [[[NSData alloc] initWithContentsOfURL:info[UIImagePickerControllerMediaURL]] writeToFile:[[NSMutableString alloc] initWithString:[AKSVideoAndImagePicker getTemporaryFilePathToSaveVideo]] atomically:YES];
}

+ (NSString *)getTemporaryFilePathToSaveVideo {
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"capturedvideo.MOV"];
}

+ (NSString *)getFilePathToSaveUnUpdatedVideo {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directory = [paths objectAtIndex:0];
    for (int i = 0; TRUE; i++) {
        if (![[NSFileManager defaultManager]fileExistsAtPath:[NSString stringWithFormat:@"%@/Video%d.mp4", directory, i]]) return [NSString stringWithFormat:@"%@/Video%d.mp4", directory, i];
    }
}

+ (NSString *)getFilePathToSaveUnUpdatedImage {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directory = [paths objectAtIndex:0];
    for (int i = 0; TRUE; i++) {
        if (![[NSFileManager defaultManager]fileExistsAtPath:[NSString stringWithFormat:@"%@/Image%d.jpg", directory, i]]) return [NSString stringWithFormat:@"%@/Image%d.jpg", directory, i];
    }
}

+ (void)showActivityIndicatorWithText:(NSString *)text {
    [AKSVideoAndImagePicker removeActivityIndicator];
    [CommonFunctions showActivityIndicatorWithText:text];
}

+ (void)removeActivityIndicator {
    [CommonFunctions removeActivityIndicator];
}

@end
