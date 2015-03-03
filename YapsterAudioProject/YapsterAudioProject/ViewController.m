//
//  ViewController.m
//  YapsterAudioProject
//
//  Created by thomas wheeler on 2/3/15.
//  Copyright (c) 2015 thomas wheeler. All rights reserved.
//

#import "ViewController.h"

#import <AWSiOSSDKv2/AWSCore.h>
#import <AWSCognitoSync/Cognito.h>
#import <AWSiOSSDKv2/S3.h>

#import <AVFoundation/AVFoundation.h>
#import "ContentGenerator.h"


@interface ViewController ()

@end

@implementation ViewController{
	NSUInteger totalBytes;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.contents = [ContentGenerator generateAmountOfRandomContents:5];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
	((DownloadTableViewController*)segue.destinationViewController).delegate = self;
	
}

@end
