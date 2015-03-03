//
//  ContentGenerator.m
//  YapsterAudioProject
//
//  Created by thomas wheeler on 2/9/15.
//  Copyright (c) 2015 thomas wheeler. All rights reserved.
//

#import "ContentGenerator.h"
#import "Yap.h"

@implementation ContentGenerator

+(NSArray*) generateAmountOfRandomContents:(NSInteger)amount {
	NSArray* imageURL = @[@"misc/twins1.jpg", @"misc/twins2.jpg", @"misc/twins3.jpg",
							 @"misc/twins4.jpg",@"misc/webcoverpicture1.jpg", @"misc/webcoverpicture2.jpg", @"misc/webcoverpicture3.jpg", @"misc/webcoverpicture4.jpg"];
	NSArray* mp3URL = @[@"misc/ashlee_1.mp3" , @"misc/gurkaran_1.mp3" ];
	
	NSMutableArray* output = [[NSMutableArray alloc] init];
	
	for(int i = 0; i < amount; i++){
		Yap *d = [[Yap alloc] initWithImageKey:imageURL[arc4random()%imageURL.count] mp3Key:mp3URL[arc4random()%mp3URL.count]];
		[output addObject:d];
	
	}
	
	return output;
}

@end
