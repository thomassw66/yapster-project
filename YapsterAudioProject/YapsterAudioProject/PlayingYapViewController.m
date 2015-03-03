//
//  TWAPViewController.m
//  YapsterAudioProject
//
//  Created by thomas wheeler on 2/25/15.
//  Copyright (c) 2015 thomas wheeler. All rights reserved.
//

#import "PlayingYapViewController.h"

@implementation PlayingYapViewController{
	BOOL isPlaying;
}

-(void) viewDidLoad {
	[super viewDidLoad];
	
	self.slider.minimumValue = 0.0;
	self.slider.maximumValue = CMTimeGetSeconds(self.delegate.player.currentItem.asset.duration);
	
	[NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
}

- (void)updateTime:(NSTimer *)timer {
	float time = CMTimeGetSeconds(self.delegate.player.currentTime);
	float duration = CMTimeGetSeconds(self.delegate.player.currentItem.asset.duration);

	self.slider.value = time;
	self.timeLabel.text = [NSString stringWithFormat:@"%d:%02d",(int)time/60, (int) time % 60];
	int secondsLeft = duration - time;
	self.durationLeftLabel.text = [NSString stringWithFormat:@"-%d:%02d", secondsLeft/60, secondsLeft%60];
	
	if(self.delegate.player.rate > 0 && !self.delegate.player.error) {
		if(![self.button.titleLabel.text isEqualToString:@"Pause"]){
			
			[self.button setTitle: @"Pause" forState: UIControlStateNormal];
		}
	}else{
		if(![self.button.titleLabel.text isEqualToString:@"Play"]){
			
			[self.button setTitle: @"Play" forState: UIControlStateNormal];
		}
	}
}

- (IBAction)buttonPausePlayPressed:(id)sender {
	if(self.delegate.player.rate > 0 && !self.delegate.player.error) {
		
		[(UIButton*) sender setTitle: @"Play" forState: UIControlStateNormal];
		[self.delegate.player pause];
		
	} else {
		[(UIButton*) sender setTitle: @"Pause" forState: UIControlStateNormal];
		[self.delegate.player play];
	}
}

- (IBAction)sliderValueChanged:(id)sender {
	[self.delegate.player seekToTime: CMTimeMake(self.slider.value * 100, 100)];
	[self.delegate.player play];
	isPlaying = YES;
}
@end
