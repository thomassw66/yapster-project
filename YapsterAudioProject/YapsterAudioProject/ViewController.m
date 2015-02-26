//
//  ViewController.m
//  YapsterAudioProject
//
//  Created by thomas wheeler on 2/3/15.
//  Copyright (c) 2015 thomas wheeler. All rights reserved.
//

#import "ViewController.h"

#import <AWSiOSSDKv2/AWSCore.h>
#import <AWSCognitoSync/Cognito.h>

#import <AWSiOSSDKv2/S3.h>

#import <AVFoundation/AVFoundation.h>
#import "ContentGenerator.h"

@interface ViewController ()

//- (IBAction)musicButtonPressed:(id)sender;
//- (IBAction)buttonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) AVQueuePlayer * player;
@property (strong, nonatomic) AVAudioPlayer *player2;
@property AVPlayer * player3;
@property TWAudio * audioClient;
@end

@implementation ViewController{
	NSUInteger totalBytes;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	/*
	NSError * sessionError = nil;
	//[[AVAudioSession sharedInstance] setDelegate:self];
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
	UInt32 doChangeDefaultRoute = 1;
	AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(doChangeDefaultRoute), &doChangeDefaultRoute);
	*/
	//[self presignedURL];
	//self.audioClient = [[TWAudio alloc] initWithKey:@"misc/ashlee_1.mp3" bucketName:@"yapster"];
	//self.audioClient.delegate = self;
	self.contents = [ContentGenerator generateAmountOfRandomContents:20];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
	((DownloadTableViewController*)segue.destinationViewController).delegate = self;
	
}
/*
- (IBAction)buttonPressed:(id)sender {
	
	
	// Construct the NSURL for the download location.
	NSString *downloadingFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"downloaded-twins2.jpg"];
	//NSString *downloadingFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"downloaded-misc/ashlee_1.mp3"];
	NSURL *downloadingFileURL = [NSURL fileURLWithPath:downloadingFilePath];
	
	// Construct the download request.
	AWSS3TransferManagerDownloadRequest *downloadRequest = [AWSS3TransferManagerDownloadRequest new];
	
	downloadRequest.bucket = @"yapster";
	downloadRequest.key = @"misc/twins2.jpg";
	//downloadRequest.key = @"misc/ashlee_1.mp3";
	downloadRequest.downloadingFileURL = downloadingFileURL;
	
	AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
	
	// Download the file.
	[[transferManager download:downloadRequest]
	 continueWithExecutor:[BFExecutor mainThreadExecutor]
	 withBlock:^id(BFTask *task) {
		 
		 NSLog(@"hello");
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
			 AWSS3TransferManagerDownloadOutput *downloadOutput = task.result;
			 //File downloaded successfully.
			 self.imageView.contentMode = UIViewContentModeScaleAspectFit;
			 self.imageView.image = [UIImage imageWithContentsOfFile:downloadingFilePath];
			 
			 
			 NSLog(@"downloaded");
		 }
		 return nil;
	 }];
	/*AWSCognito *syncClient = [AWSCognito defaultCognito];
	AWSCognitoDataset *dataset = [syncClient openOrCreateDataset:@"myDataset"];
	[dataset setString:@"myValue" forKey:@"myKey"];
	[dataset synchronize];
	
}

-(IBAction)musicButtonPressed:(id)sender{
	// Construct the NSURL for the download location.
	//NSString *downloadingFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"downloaded-twins2.jpg"];
	NSString *downloadingFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"downloaded-ashlee_1.mp3"];
	NSURL *downloadingFileURL = [NSURL fileURLWithPath:downloadingFilePath];
	
	// Construct the download request.
	AWSS3TransferManagerDownloadRequest *downloadRequest = [AWSS3TransferManagerDownloadRequest new];
	
	downloadRequest.bucket = @"yapster";
	//downloadRequest.key = @"misc/twins2.jpg";
	downloadRequest.key = @"misc/ashlee_1.mp3";
	downloadRequest.downloadingFileURL = downloadingFileURL;
	//downloadRequest.range
	
	AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
	
	// Download the file.
	[[transferManager download:downloadRequest]
	 continueWithExecutor:[BFExecutor mainThreadExecutor]
	 withBlock:^id(BFTask *task) {
		 
		 NSLog(@"hello");
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
			 AWSS3TransferManagerDownloadOutput *downloadOutput = task.result;
			 //File downloaded successfully.
			 //self.imageView.contentMode = UIViewContentModeScaleAspectFit;
			 //self.imageView.image = [UIImage imageWithContentsOfFile:downloadingFilePath];
			 NSArray *queue = @[
								[AVPlayerItem playerItemWithURL:downloadingFileURL],
								//[AVPlayerItem playerItemWithURL: [[NSBundle mainBundle] URLForResource:@"IronBacon" withExtension:@"mp3"]]
								 ];
			 self.player = [[AVQueuePlayer alloc] initWithItems:queue];
			 self.player.actionAtItemEnd = AVPlayerActionAtItemEndAdvance;
			 [self.player play];
			 
			 NSLog(@"downloaded");
		 }
		 return nil;
	 }];
}*/
/*
-(void) presignedURL {
	AWSS3GetPreSignedURLRequest *getPreSignedURLRequest = [AWSS3GetPreSignedURLRequest new];
	getPreSignedURLRequest.bucket = @"yapster";
	getPreSignedURLRequest.key = @"misc/ashlee_1.mp3";
	getPreSignedURLRequest.HTTPMethod = AWSHTTPMethodGET;
	getPreSignedURLRequest.expires = [NSDate dateWithTimeIntervalSinceNow:3600];
	
	[[[AWSS3PreSignedURLBuilder defaultS3PreSignedURLBuilder] getPreSignedURL:getPreSignedURLRequest]
	 continueWithBlock:^id(BFTask *task) {
		 
		 if (task.error) {
			 NSLog(@"Error: %@",task.error);
		 } else {
			 
			 NSString*str = @"https://s3-us-west-2.amazonaws.com/thomasyapsterinternproject/Music/Music/Katy+Perry/5.+Firework.mp3?X-Amz-Date=20150212T172405Z&X-Amz-Expires=300&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Signature=86e8fd30bd8cba1d201561c81ef747fbd0c55213cac0913e9ad9cd2cd6f69613&X-Amz-Credential=ASIAJRLEEFE5E3OI5YQQ/20150212/us-west-2/s3/aws4_request&X-Amz-SignedHeaders=Host&x-amz-security-token=AQoDYXdzEKn//////////wEakAL1EgFKJ3H/CGv81W1QZjaY2bXsBzMmo0ZYwkvnxZZUnrMWQ/ilCnT5oH87RteIVckHhofks2BpCFzYnlAjmtqCWw8LjRUWjnnrfC9%2BHTf9u%2BH71Pwd/g2ByW2iWNVGakPGfykxKsfMjL%2BXDXCYKeLvApItL6abtunFT2MzSOng/NjT2f2cke3mIprid0rSee5kByF0RN8tb9Om0Cr2Lgn5I%2BspWWPzSmOeKXe9bZVYNpPLbg/0lcDiciUrps7PS2WArSm2zUE93mS1V23xHxDH1Ob4xFKCSG0MzFCIv4s4JMyQ2uwmPzIfRPKLQglfQc3cyDBFGiETkjFGknn7Rpn9SXt9LETYotAHdbFBVg2cBiDajvOmBQ%3D%3D";
			 NSURL *presignedURL = [NSURL URLWithString:str];//task.result;//
			 NSLog(@"download presignedURL is: \n%@", presignedURL);
			 
			 totalBytes = 0;
			 
			 NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:presignedURL];
			 NSString *range = [NSString stringWithFormat:@"bytes=0-%d", 1300000];
			 [request setValue:range forHTTPHeaderField:@"Range"];
			 //NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
			 NSLog(@"sending request...");
			 [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * response, NSData* data, NSError*err){
				 
				 //				start, length
				 NSRange range = {0, [data length]};
				 NSMutableData *mData = [[data subdataWithRange:range] mutableCopy];
				 
				 
				 
				 NSLog(@"recieved response! expected length %lld",[response expectedContentLength]);
				 NSLog(@"%@", [(NSHTTPURLResponse*)response allHeaderFields][@"Content-Range"]);
				 
				 self.player2 = [[AVAudioPlayer alloc] initWithData:mData error:nil];
				 
				 [self.player2 addObserver:self forKeyPath:@"status" options:0 context:nil];
				 [self.player2 play];
				 
				 
				 NSRange range2 = {[data length]/4, [data length] - [data length]/4};
				 NSData * d= [data subdataWithRange:range2];
				 //[mData appendData:d];
				 
			 }];
			 //6322976 6282976
			 
			 //self.player2 = [[AVAudioPlayer alloc] initWithContentsOfURL:presignedURL error:nil];
			 //[self.player2 prepareToPlay];
			 //[self.player2 play];
		 }
		 return nil;
	 }];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	
	if (object == self.player && [keyPath isEqualToString:@"status"]) {
		NSLog(@"wussup");
		if (self.player.status == AVPlayerStatusFailed) {
			NSLog(@"AVPlayer Failed");
			
		} else if (self.player.status == AVPlayerStatusReadyToPlay) {
			NSLog(@"AVPlayerStatusReadyToPlay");
			[self.player play];
			
			
		} else if (self.player.status == AVPlayerItemStatusUnknown) {
			NSLog(@"AVPlayer Unknown");
			
		}
	}
}
- (void)connection:(NSURLConnection *)connection
	didReceiveData:(NSData *)data{
	totalBytes += [data length];
	
	NSLog(@"%lu bytes recieved", (unsigned long)totalBytes);
	//self.player2 = [[AVAudioPlayer alloc] initWithData:data error:nil];
	//[self.player2 prepareToPlay];
	//[self.player2 play];
	
	//NSLog(@"played somethin");
	
}*/
-(void) readyToPlay {
	NSLog(@"ready to play");
	
	NSData* d = [self.audioClient songData];
	self.player2 = [[AVAudioPlayer alloc] initWithData:d error:nil];
	[self.player2 play];
	
	[self.audioClient loadRestOfSong];
}
@end
