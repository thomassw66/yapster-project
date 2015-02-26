//
//  TWImage.h
//  YapsterAudioProject
//
//  Created by thomas wheeler on 2/17/15.
//  Copyright (c) 2015 thomas wheeler. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TWIDelegate <NSObject>

-(void) updateProgressBytesWritten:(NSUInteger) bw totalBytesWritten: (NSUInteger) tbw totalBytesExpectedToWrite: (NSUInteger) tbew;

@end

@interface TWImage : NSObject

-(instancetype) initWithKey: (NSString*) key bucketName: (NSString*) name;


@end
