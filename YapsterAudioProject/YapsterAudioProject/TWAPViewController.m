//
//  TWAPViewController.m
//  YapsterAudioProject
//
//  Created by thomas wheeler on 2/25/15.
//  Copyright (c) 2015 thomas wheeler. All rights reserved.
//

#import "TWAPViewController.h"

@implementation TWAPViewController{
	BOOL isPlaying;
}

-(void) viewDidLoad {
	[super viewDidLoad];
	
	isPlaying = NO;
	
	NSError * err;
	self.player = [[AVAudioPlayer alloc ] initWithData: [self.audioObject.audioDownloader songData] error:&err];
	[self.player prepareToPlay];
	
	self.slider.minimumValue = 0.0;
	self.slider.maximumValue = self.player.duration;
	
	[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
}

- (void)updateTime:(NSTimer *)timer {
	self.slider.value = self.player.currentTime;
}

- (IBAction)buttonPausePlayPressed:(id)sender {
	if(isPlaying) {
		
		[self.player pause];
		((UIButton*) sender).titleLabel.text = @"Play";
		
	} else {
		
		[self.player play];
		((UIButton*) sender).titleLabel.text = @"Pause";
		
	}
}

@end
