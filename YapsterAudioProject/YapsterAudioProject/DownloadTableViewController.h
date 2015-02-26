//
//  DownloadTableViewController.h
//  YapsterAudioProject
//
//  Created by thomas wheeler on 2/5/15.
//  Copyright (c) 2015 thomas wheeler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "TWAudio.h"

@protocol DTVCDelegate;

@interface DownloadTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate,TWADelegate,AVAudioPlayerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
//@property (strong, nonatomic) AVPlayer * player;
@property (strong, nonatomic) AVAudioPlayer * player;

@property id <DTVCDelegate> delegate;

@end


@protocol DTVCDelegate <NSObject>
@property NSArray * contents;
@end