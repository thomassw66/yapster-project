//
//  TWAPViewController.h
//  YapsterAudioProject
//
//  Created by thomas wheeler on 2/25/15.
//  Copyright (c) 2015 thomas wheeler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AudioProjectObject.h"

@interface TWAPViewController : UIViewController

@property AVAudioPlayer * player;
@property AudioProjectObject * audioObject;

@property (strong, nonatomic) IBOutlet UISlider *slider;
- (IBAction)buttonPausePlayPressed:(id)sender;

@end

