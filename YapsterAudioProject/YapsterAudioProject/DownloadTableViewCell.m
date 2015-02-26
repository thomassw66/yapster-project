//
//  DownloadTableViewCell.m
//  YapsterAudioProject
//
//  Created by thomas wheeler on 2/5/15.
//  Copyright (c) 2015 thomas wheeler. All rights reserved.
//

#import "DownloadTableViewCell.h"

@implementation DownloadTableViewCell

-(UIImageView*) pImageView {
	if(_pImageView == nil){
		_pImageView = [[UIImageView alloc] initWithFrame: CGRectMake(8, 0, 68, 84)];
		[self.viewForBaselineLayout addSubview:_pImageView];
	}
	return _pImageView;
}



@end
