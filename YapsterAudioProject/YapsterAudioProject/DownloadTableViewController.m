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
#import "Yap.h"

#import <AWSiOSSDKv2/AWSCore.h>
#import <AWSCognitoSync/Cognito.h>

#import <AWSiOSSDKv2/S3.h>

#import "PlayingYapViewController.h"


@implementation DownloadTableViewController{
	NSArray *contents;
	NSIndexPath *pathOfPlayingCell;
}

-(void) viewDidLoad {
	[super viewDidLoad];
	
	contents = self.delegate.contents; //[ContentGenerator generateAmountOfRandomContents:20];
	
	[self.tableView setDelegate:self];
	[self.tableView setDataSource:self];
	
	[self.tableView reloadData];
	
	self.player = [[AVQueuePlayer alloc] init];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return contents.count;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	Yap * object = contents[indexPath.row];
	DownloadTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DownloadCell" forIndexPath: indexPath];
	
	//NSLog(@"yo");
	cell.nameLabel.text = object.imageKey;
	cell.smallLabel.text = object.mp3Key;
	
	cell.progressView.progress = 0.0f;
	
	cell.mp3DownloadProgress.progress = 0.0f;
	cell.mp3DownloadProgress.hidden = YES;
	
	cell.pImageView.hidden = NO;
	cell.pImageView.image = nil;
	//cell.pImageView.backgroundColor = [UIColor blackColor];
	cell.pImageView.clipsToBounds = YES;
	cell.pImageView.contentMode = UIViewContentModeScaleAspectFill;
	
	cell.songDownloadActivity.hidesWhenStopped = YES;
	//[cell.songDownloadActivity stopAnimating];
	
	if(object.purl){
		[cell.songDownloadActivity stopAnimating];
		cell.songDownloadActivity.hidden = YES;
	} else {
		[cell.songDownloadActivity startAnimating];
		object.purlDownloadCompletionHandler = ^(){
			dispatch_async(dispatch_get_main_queue(), ^{
				[tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
			});
		};
	}
	
	if([object imageFileIsDownloaded]){
		cell.pImageView.image = [[UIImage alloc] initWithContentsOfFile:object.downloadedImageFile];
	}else{
		object.updateImageDownloadProgress = ^(int64_t a, int64_t b, int64_t c){
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
	Yap * object = contents[indexPath.row];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	
	if (object.purl){
		
		if(![indexPath isEqual: pathOfPlayingCell]){
			[self.player insertItem: [AVPlayerItem playerItemWithURL:object.purl] afterItem:nil];
			if(self.player.items.count > 1)
				[self.player advanceToNextItem];
			[self.player play];
			[self.player addObserver:self forKeyPath:@"status" options:0 context:nil];
		}
		
		
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
									@"Main" bundle:[NSBundle mainBundle]];
		
		PlayingYapViewController *myController = (PlayingYapViewController*)[storyboard instantiateViewControllerWithIdentifier:@"TWAPID"];
		myController.delegate = self;
		[self.navigationController pushViewController:myController animated:YES];
		
	}
	
	// move to a different screen instead
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	
	if (object == self.player&& [keyPath isEqualToString:@"status"]) {
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

- (void)playerItemDidReachEnd:(NSNotification *)notification {
	
	//  code here to play next sound file
	
}

@end