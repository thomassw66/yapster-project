//
//  AudioProjectObject.m
//  YapsterAudioProject
//
//  Created by thomas wheeler on 2/10/15.
//  Copyright (c) 2015 thomas wheeler. All rights reserved.
//

#import "Yap.h"
#import <AWSiOSSDKv2/S3.h>

@interface Yap()

@property (strong, nonatomic) NSURLConnection* downloadConnection;

@end

@implementation Yap{
	BOOL downloadedImage;
	BOOL imageIsDownloading;
}
-(instancetype) initWithImageKey: (NSString*) imageKey mp3Key:(NSString*) mp3Key{
	self = [super init];
	if(self){
		self.imageKey = imageKey;
		self.mp3Key = mp3Key;
		
		downloadedImage = NO;
		imageIsDownloading = NO;
		
		dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			[self loadPresignedURL];
		});
		dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			[self loadImage];
		});
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
	
	__weak Yap* weakSelf = self;
	
	AWSS3TransferManagerDownloadRequest *downloadRequest = [AWSS3TransferManagerDownloadRequest new];
	
	downloadRequest.bucket = @"yapster";
	downloadRequest.key = self.imageKey;
	downloadRequest.downloadingFileURL = [NSURL URLWithString: self.downloadedImageFile];
	downloadRequest.downloadProgress = ^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite){
			if(weakSelf.updateImageDownloadProgress){
				weakSelf.updateImageDownloadProgress(bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
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
				
				if(weakSelf.imageDownloadCompletionHandler){
					weakSelf.imageDownloadCompletionHandler();
				}
			}
			return nil;
		}];
}

-(void) loadPresignedURL {
	__weak Yap* weakSelf = self;
	
	AWSS3GetPreSignedURLRequest *getPreSignedURLRequest = [AWSS3GetPreSignedURLRequest new];
	getPreSignedURLRequest.bucket = @"yapster";
	getPreSignedURLRequest.key = self.mp3Key;
	getPreSignedURLRequest.HTTPMethod = AWSHTTPMethodGET;
	getPreSignedURLRequest.expires = [NSDate dateWithTimeIntervalSinceNow:3600];
	
	[[[AWSS3PreSignedURLBuilder defaultS3PreSignedURLBuilder] getPreSignedURL:getPreSignedURLRequest]
	 continueWithBlock:^id(BFTask *task) {
		 
		 if (task.error) {
			 NSLog(@"Error: %@",task.error);
		 } else {
			 weakSelf.purl = (NSURL*)task.result;
			 if (weakSelf.purlDownloadCompletionHandler) {
				 weakSelf.purlDownloadCompletionHandler();
			 }
		 }
		 
		 return nil;
	 }];
}
@end
