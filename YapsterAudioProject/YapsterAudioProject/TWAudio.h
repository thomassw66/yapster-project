//
//  TWAudio.h
//  YapsterAudioProject
//
//  Created by thomas wheeler on 2/16/15.
//  Copyright (c) 2015 thomas wheeler. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PREVIEW_BYTES 500000

@protocol TWADelegate;


@interface TWAudio : NSObject 

@property id <TWADelegate> delegate;

-(instancetype) initWithKey: (NSString*) key bucketName: (NSString*) name;
-(NSData*) songData;
-(BOOL) isReady;

-(void) loadFirstBytes;
-(void) loadRestOfSong;

-(NSString*) getKey;

-(void) unloadRestOfSong;

@end


@protocol TWADelegate <NSObject>

-(void) readyToPlay: (TWAudio*)twa;

@end