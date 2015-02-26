//
//  AudioProjectObject.h
//  YapsterAudioProject
//
//  Created by thomas wheeler on 2/10/15.
//  Copyright (c) 2015 thomas wheeler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVPlayerItem.h>
#import "TWAudio.h"

@interface AudioProjectObject : NSObject <NSURLConnectionDataDelegate>

@property (atomic,strong) NSString * imageKey;
@property (nonatomic,strong) NSString *downloadedImageFile;
@property TWAudio * audioDownloader;

@property (copy) void (^updateProgress)(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite);
@property (copy) void (^imageDownloadCompletionHandler)();

-(instancetype) initWithImageKey: (NSString*) imageKey mp3Key:(NSString*) mp3Key;

-(BOOL) imageFileIsDownloaded;

@end
