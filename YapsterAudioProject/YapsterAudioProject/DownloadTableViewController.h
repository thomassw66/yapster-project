//
//  DownloadTableViewController.h
//  YapsterAudioProject
//
//  Created by thomas wheeler on 2/5/15.
//  Copyright (c) 2015 thomas wheeler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "PlayingYapViewController.h"

@protocol DTVCDelegate;

@interface DownloadTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate,AVAudioPlayerDelegate,PlayingYapDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property id <DTVCDelegate> delegate;

@property AVQueuePlayer * player;

@end


@protocol DTVCDelegate <NSObject>
@property NSArray * contents;
@end