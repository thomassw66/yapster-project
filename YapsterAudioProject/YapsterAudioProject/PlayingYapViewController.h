//
//  TWAPViewController.h
//  YapsterAudioProject
//
//  Created by thomas wheeler on 2/25/15.
//  Copyright (c) 2015 thomas wheeler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Yap.h"

@protocol PlayingYapDelegate;

@interface PlayingYapViewController : UIViewController

@property id <PlayingYapDelegate> delegate;

@property (strong, nonatomic) IBOutlet UISlider *slider;
- (IBAction)buttonPausePlayPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *durationLeftLabel;
- (IBAction)sliderValueChanged:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *button;

@end

@protocol PlayingYapDelegate <NSObject>

@property AVPlayer * player;

@end