//
//  DownloadTableViewController.m
//  YapsterAudioProject
//
//  Created by thomas wheeler on 2/5/15.
//  Copyright (c) 2015 thomas wheeler. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "DownloadTableViewController.h"
#import "DownloadTableViewCell.h"
#import "ContentGenerator.h"
#import "AudioProjectObject.h"

#import <AWSiOSSDKv2/AWSCore.h>
#import <AWSCognitoSync/Cognito.h>

#import <AWSiOSSDKv2/S3.h>

#import "TWAPViewController.h"


@implementation DownloadTableViewController{
	NSArray *contents;
	DownloadTableViewCell * playingCell;
}

-(void) viewDidLoad {
	[super viewDidLoad];
	
	contents = self.delegate.contents; //[ContentGenerator generateAmountOfRandomContents:20];
	
	/*for(NSDictionary* d in contents){
		NSLog(@"%@ %@",d[@"image"], d[@"mp3"]);
	}*/
	[self.tableView setDelegate:self];
	[self.tableView setDataSource:self];
	
	[self.tableView reloadData];
	
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return contents.count;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	AudioProjectObject * object = contents[indexPath.row];
	DownloadTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DownloadCell" forIndexPath: indexPath];
	
	//NSLog(@"yo");
	cell.nameLabel.text = object.imageKey;
	cell.smallLabel.text = [object.audioDownloader getKey];
	
	cell.progressView.progress = 0.0f;
	
	cell.mp3DownloadProgress.progress = 0.0f;
	cell.mp3DownloadProgress.hidden = YES;
	
	cell.pImageView.hidden = NO;
	cell.pImageView.image = nil;
	//cell.pImageView.backgroundColor = [UIColor blackColor];
	cell.pImageView.clipsToBounds = YES;
	cell.pImageView.contentMode = UIViewContentModeScaleAspectFill;
	
	cell.songDownloadActivity.hidesWhenStopped = YES;
	
	if(![object.audioDownloader isReady]){
		object.audioDownloader.delegate = self;
		[cell.songDownloadActivity startAnimating];
	} else {
		[cell.songDownloadActivity stopAnimating];
		cell.songDownloadActivity.hidden = YES;
	}
	
	if([object imageFileIsDownloaded]){
		cell.pImageView.image = [[UIImage alloc] initWithContentsOfFile:object.downloadedImageFile];
	}else{
		cell.songDownloadActivity.hidden = NO;
		[cell.songDownloadActivity startAnimating];
		
		object.updateProgress = ^(int64_t a, int64_t b, int64_t c){
			dispatch_async(dispatch_get_main_queue(), ^{
				cell.progressView.progress = (float)b/(float)c;
			});
		};
		object.imageDownloadCompletionHandler = ^(){
			[tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
		};
	}
	
	return cell;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	AudioProjectObject * object = contents[indexPath.row];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	//deselect previous cell dealloc its audio
	/*if(playingCell){
		playingCell.mp3DownloadProgress.hidden = YES;
		playingCell.playingAudio = NO;
		NSIndexPath * p = [tableView indexPathForCell:playingCell];
		//[tableView reloadRowsAtIndexPaths:@[p] withRowAnimation:UITableViewRowAnimationAutomatic];
		TWAudio *oldAudio = ((AudioProjectObject*)contents[p.row]).audioDownloader;
		[oldAudio unloadRestOfSong];
	}*/
	
	if ([object.audioDownloader isReady]){
		
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			[object.audioDownloader loadRestOfSong];
		});
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
									@"Main" bundle:[NSBundle mainBundle]];
		
		TWAPViewController *myController = (TWAPViewController*)[storyboard instantiateViewControllerWithIdentifier:@"TWAPID"];
		myController.audioObject = object;
		[self.navigationController pushViewController:myController animated:YES];
		/*self.player = [[AVAudioPlayer alloc] initWithData:[object.audioDownloader songData] error:nil];
		
		playingCell = ((DownloadTableViewCell*)[tableView cellForRowAtIndexPath:indexPath]);
		playingCell.playingAudio = YES;
		[tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
		
		NSLog(@"%ld",(long)self.player.duration);
		self.player.delegate = self;
		[self.player play];*/
		
	}
	
	// move to a different screen instead
}

-(void) readyToPlay:(TWAudio *)twa {
	
	for (AudioProjectObject * apo in contents){
		if ([apo.audioDownloader isEqual:twa]){
			NSInteger index = [contents indexOfObject:apo];
			NSIndexPath *indexP = [NSIndexPath indexPathForRow:index inSection:0];
			dispatch_async(dispatch_get_main_queue(), ^{
				[self.tableView reloadRowsAtIndexPaths:@[indexP] withRowAnimation:UITableViewRowAnimationAutomatic];
			});
			NSLog(@"row %ld is ready to play", index);
		}
	}
}

-(void) audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
	NSLog(@"%@", error);
}

-(void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
	NSLog(@"did finish playing %f", player.currentTime);
}
/*
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSMutableDictionary * object = contents[indexPath.row];
	DownloadTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DownloadCell" forIndexPath: indexPath];
	
	//NSLog(@"yo");
	cell.nameLabel.text = object[@"image"];
	cell.smallLabel.text = object[@"mp3"];
	
	cell.progressView.progress = 0.0f;
	
	cell.mp3DownloadProgress.progress = 0.0f;
	
	cell.pImageView.hidden = NO;
	cell.pImageView.image = nil;
	//cell.pImageView.backgroundColor = [UIColor blackColor];
	cell.pImageView.clipsToBounds = YES;
	cell.pImageView.contentMode = UIViewContentModeScaleAspectFill;
	
	if([[NSFileManager defaultManager] fileExistsAtPath:object[@"fileondevice"]]){
		cell.pImageView.image = [UIImage imageWithContentsOfFile:object[@"fileondevice"]];
		cell.progressView.hidden = YES;
	}else {
		cell.progressView.hidden = NO;
		
		
		// Construct the NSURL for the download location.
		NSString *downloadingFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%i.jpg",arc4random()]];
		NSURL *downloadingFileURL = [NSURL fileURLWithPath:downloadingFilePath];
		
		object[@"fileondevice"] = downloadingFilePath;
		
		// Construct the download request.
		AWSS3TransferManagerDownloadRequest *downloadRequest = [AWSS3TransferManagerDownloadRequest new];
		
		downloadRequest.bucket = @"yapster";
		downloadRequest.key = object[@"image"];
		downloadRequest.downloadingFileURL = downloadingFileURL;
		downloadRequest.downloadProgress = ^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite){
			dispatch_async(dispatch_get_main_queue(), ^{
				cell.progressView.progress = (float) totalBytesWritten / (float) totalBytesExpectedToWrite;
			});
		};
		
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
				//File downloaded successfully.
				//cell.pImageView.image = [UIImage imageWithContentsOfFile:downloadingFilePath];
				
				//cell.progressView.progress = 1.0f;
				//cell.progressView.hidden = YES;
				
				[tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
			}
			return nil;
		}];
	}
	
	return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSMutableDictionary * object = contents[indexPath.row];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	AWSS3GetPreSignedURLRequest *getPreSignedURLRequest = [AWSS3GetPreSignedURLRequest new];
	getPreSignedURLRequest.bucket = @"yapster";
	getPreSignedURLRequest.key = object[@"mp3"];
	getPreSignedURLRequest.HTTPMethod = AWSHTTPMethodGET;
	getPreSignedURLRequest.expires = [NSDate dateWithTimeIntervalSinceNow:3600];
	
	NSLog(@"sending request for presigned url");
	
	[[[AWSS3PreSignedURLBuilder defaultS3PreSignedURLBuilder] getPreSignedURL:getPreSignedURLRequest]
	 continueWithBlock:^id(BFTask *task) {
		 
		 if (task.error) {
			 NSLog(@"Error: %@",task.error);
		 } else {
			 
			 NSURL *presignedURL = task.result;
			 NSLog(@"download presignedURL is: \n%@", presignedURL);
			 
			 //NSURLRequest *request = [NSURLRequest requestWithURL:presignedURL];
			 //[[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
			 object[@"presignedURL"] = presignedURL;
			 
			 NSString * purl = presignedURL.description;
			 [purl writeToFile:[NSTemporaryDirectory() stringByAppendingString:@"temp.m3u"] atomically:YES encoding:NSStringEncodingConversionAllowLossy error:nil];
			 
			 self.player = [[AVPlayer alloc] initWithURL: presignedURL];
			 
			 [self.player addObserver:self forKeyPath:@"status" options:0 context:nil];
			 
			 [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
			 //[self.player play];
		 }
		 return nil;
	 }];

	
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	
	if (object == self.player && [keyPath isEqualToString:@"status"]) {
		if (self.player.status == AVPlayerStatusFailed) {
			NSLog(@"AVPlayer Failed");
			
		} else if (self.player.status == AVPlayerStatusReadyToPlay) {
			NSLog(@"AVPlayerStatusReadyToPlay");
			[self.player play];
			
			
		} else if (self.player.status == AVPlayerItemStatusUnknown) {
			NSLog(@"AVPlayer Unknown");
			
		}
	}
}*/

@end