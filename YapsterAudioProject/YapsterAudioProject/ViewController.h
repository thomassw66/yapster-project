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

#import "DownloadTableViewController.h"

@interface ViewController : UIViewController <NSURLConnectionDataDelegate,DTVCDelegate>

@property NSArray *contents;
@property (strong, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBOutlet UILabel *errorLabel;

@end

