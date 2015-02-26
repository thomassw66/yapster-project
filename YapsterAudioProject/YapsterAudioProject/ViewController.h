//
//  ViewController.h
//  YapsterAudioProject
//
//  Created by thomas wheeler on 2/3/15.
//  Copyright (c) 2015 thomas wheeler. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AWSiOSSDKv2/AWSCore.h>
#import <AWSiOSSDKv2/S3.h>
#import "TWAudio.h"
#import "DownloadTableViewController.h"

@interface ViewController : UIViewController <NSURLConnectionDataDelegate,TWADelegate,DTVCDelegate>

@property NSArray *contents;

@end

