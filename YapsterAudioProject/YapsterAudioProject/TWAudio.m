//
//  TWAudio.m
//  YapsterAudioProject
//
//  Created by thomas wheeler on 2/16/15.
//  Copyright (c) 2015 thomas wheeler. All rights reserved.
//

#import "TWAudio.h"
#import <AWSiOSSDKv2/S3.h>


@interface TWAudio ()
@property NSString * key;
@property NSString * bucketName;

@property NSMutableData * mp3Data;

@property NSURL * purl;

@property NSURLConnection * conn;

@property NSUInteger expectedContentLength;
@end

@implementation TWAudio{
	BOOL firstBytesLoaded;
	BOOL allBytesLoaded;
}

-(instancetype) initWithKey:(NSString *)key bucketName:(NSString *)bucketName {
	self = [super init];
	if(self){
		self.key = key;
		self.bucketName = bucketName;
		
		self.mp3Data = [[NSMutableData alloc] init];
		firstBytesLoaded = NO;
		allBytesLoaded = NO;
		
		dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			[self loadPresignedURL];
		});
	}
	return self;
}

-(NSString*) getKey {
	return _key;
}

-(NSData*) songData {
	return self.mp3Data;
}

-(BOOL) isReady {
	return firstBytesLoaded;
}

-(void) loadPresignedURL {
	AWSS3GetPreSignedURLRequest *getPreSignedURLRequest = [AWSS3GetPreSignedURLRequest new];
	getPreSignedURLRequest.bucket = self.bucketName;
	getPreSignedURLRequest.key = self.key;
	getPreSignedURLRequest.HTTPMethod = AWSHTTPMethodGET;
	getPreSignedURLRequest.expires = [NSDate dateWithTimeIntervalSinceNow:3600];
	
	[[[AWSS3PreSignedURLBuilder defaultS3PreSignedURLBuilder] getPreSignedURL:getPreSignedURLRequest]
	 continueWithBlock:^id(BFTask *task) {
		 
		 if (task.error) {
			 NSLog(@"Error: %@",task.error);
		 } else {
			 self.purl = (NSURL*)task.result;
			 [self loadFirstBytes];
		 }
		 
		 return nil;
	 }];
}

-(void) loadFirstBytes {
	if(!firstBytesLoaded){
		NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL: self.purl];
		
		NSString *byteRange = [NSString stringWithFormat:@"bytes=0-%d",PREVIEW_BYTES];
		//NSLog(@"%@",byteRange);
		[req setValue:byteRange	forHTTPHeaderField:@"Range"];
		
		[NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
			if(connectionError){
				NSLog(@"%@",connectionError);
			}
			if(data){
				[self.mp3Data appendData:data];
				firstBytesLoaded = YES;
			
				if(self.delegate){
					[self.delegate readyToPlay: self];
				}
				
				NSString * str = [(NSHTTPURLResponse *)response allHeaderFields][@"Content-Range"];
				
				NSString *pattern = @"(\\d+)-(\\d+)/(\\d+)";
				NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
				NSTextCheckingResult *result = [expression firstMatchInString:str options:0 range:NSMakeRange(0,str.length)];
				self.expectedContentLength = [[str substringWithRange:[result rangeAtIndex:3]] integerValue];
			}
		}];
	}else{
		if(self.delegate){
			[self.delegate readyToPlay: self];
		}
	}
}

-(void) loadRestOfSong {
	if(!allBytesLoaded) {
		
		NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL: self.purl];
		
		NSString *byteRange = [NSString stringWithFormat:@"bytes=%d-",PREVIEW_BYTES+1];
		[req setValue:byteRange	forHTTPHeaderField:@"Range"];
		
		//self.conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
		//[self.conn start];
		
		[NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
			if(connectionError){
				NSLog(@"%@",connectionError);
			}
			if(data){
				[self.mp3Data appendData:data];
				allBytesLoaded = YES;
				NSLog(@"last %lu bytes downloaded", [data length]);
			}
		}];
	}
}

-(void) unloadRestOfSong {
	if(allBytesLoaded){
		NSRange r = {0,PREVIEW_BYTES+1};
		self.mp3Data = [[self.mp3Data subdataWithRange:r] mutableCopy];
		allBytesLoaded = NO;
	}
}

@end
