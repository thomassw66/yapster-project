//
//  DownloadTableViewCell.h
//  YapsterAudioProject
//
//  Created by thomas wheeler on 2/5/15.
//  Copyright (c) 2015 thomas wheeler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioProjectObject.h"

@interface DownloadTableViewCell : UITableViewCell 

//@property (strong, nonatomic) IBOutlet UIImageView *pImageView;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *smallLabel;
@property (strong, nonatomic) IBOutlet UIProgressView *mp3DownloadProgress;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *songDownloadActivity;
@property (strong, nonatomic) UIImageView * pImageView;

@property BOOL playingAudio;

@end
