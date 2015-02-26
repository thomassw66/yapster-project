//
//  AudioProjectObject.m
//  YapsterAudioProject
//
//  Created by thomas wheeler on 2/10/15.
//  Copyright (c) 2015 thomas wheeler. All rights reserved.
//

#import "AudioProjectObject.h"
#import <AWSiOSSDKv2/S3.h>

@interface AudioProjectObject()

@property (strong, nonatomic) NSURLConnection* downloadConnection;

@end

@implementation AudioProjectObject{
	BOOL downloadedImage;
	BOOL imageIsDownloading;
}
-(instancetype) initWithImageKey: (NSString*) imageKey mp3Key:(NSString*) mp3Key{
	self = [super init];
	if(self){
		self.imageKey = imageKey;
		self.audioDownloader = [[TWAudio alloc] initWithKey:mp3Key bucketName:@"yapster"];
		
		downloadedImage = NO;
		imageIsDownloading = NO;
		
		[self loadImage];
		//[self loadPresignedURL];
	}
	return self;
}

-(NSString*) downloadedImageFile{
	if(!_downloadedImageFile){
		_downloadedImageFile = [NSString stringWithFormat:@"%@%@%@",NSTemporaryDirectory(), [[NSProcessInfo processInfo] globallyUniqueString], @".mp3"];
	}
	return _downloadedImageFile;
}

-(BOOL) imageFileIsDownloaded{
	return downloadedImage;
}

-(void) loadImage {
	
	AWSS3TransferManagerDownloadRequest *downloadRequest = [AWSS3TransferManagerDownloadRequest new];
	
	downloadRequest.bucket = @"yapster";
	downloadRequest.key = self.imageKey;
	downloadRequest.downloadingFileURL = [NSURL URLWithString: self.downloadedImageFile];
	downloadRequest.downloadProgress = ^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite){
			if(self.updateProgress){
				self.updateProgress(bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
			}
	};
	
	imageIsDownloading = YES;
	
	AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
	[[transferManager download:downloadRequest]
		continueWithExecutor:[BFExecutor mainThreadExecutor]
		withBlock:^id(BFTask *task) {
			if (task.error){
				if ([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain]) {
					switch (task.error.code) {
						case AWSS3TransferManagerErrorCancelled:
						case AWSS3TransferManagerErrorPaused:
							break;
							
						default:
							NSLog(@"Error: %@", task.error);
							break;
					}
				} else {
					// Unknown error.
					NSLog(@"Error: %@", task.error);
				}
			}
			
			if (task.result) {
				downloadedImage = YES;
				imageIsDownloading = NO;
				if(self.imageDownloadCompletionHandler){
					self.imageDownloadCompletionHandler();
				}
			}
			return nil;
		}];
}

@end
