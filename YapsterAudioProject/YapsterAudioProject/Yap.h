//
//  AudioProjectObject.h
//  YapsterAudioProject
//
//  Created by thomas wheeler on 2/10/15.
//  Copyright (c) 2015 thomas wheeler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVPlayerItem.h>

@interface Yap : NSObject <NSURLConnectionDataDelegate>


//@property TWAudio * audioDownloader;
@property NSString* mp3Key;
@property NSURL* purl;
@property (copy) void (^purlDownloadCompletionHandler)();

-(instancetype) initWithImageKey: (NSString*) imageKey mp3Key:(NSString*) mp3Key;
//-(instancetype) initWithJSONObject: (NSDictionary*) obj;

//set of functions to handle the image download and progress
@property (copy) void (^updateImageDownloadProgress)(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite);
@property (copy) void (^imageDownloadCompletionHandler)();

-(BOOL) imageFileIsDownloaded;

@property (atomic,strong) NSString * imageKey;
@property (nonatomic,strong) NSString *downloadedImageFile;

@end
