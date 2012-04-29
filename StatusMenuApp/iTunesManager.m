//
//  iTunesManager.m
//  StatusMenuApp
//
//  Created by Rakesh Patole on 28/04/12.
//  Copyright (c) 2012 Diaspark. All rights reserved.
//

#import "iTunesManager.h"

@interface iTunesManager(Private)

- (void) initAppleScripts;
- (void) registerForDistributedNotificationFromiTunes;
- (void) deregisterForDistributedNotificationFromiTunes;
- (TrackInformation *) executeAppleScript:(NSAppleScript *)script error:(NSError **)error;
- (TrackInformation *) newTrackInformationWithEventDescription:(NSAppleEventDescriptor *)eventDescriptor;
- (void) updateTrackInfo:(NSNotification *)notification;

@end

@implementation iTunesManager

static iTunesManager *sharedManager;

+ (iTunesManager *) sharedManager {
    @synchronized(sharedManager) {
        if( sharedManager == nil ){
            sharedManager = [[iTunesManager alloc] init];
        }
    }
    return sharedManager;
}

- (id) init {
    self = [super init];
    if( self != nil ){
        [self initAppleScripts];
        [self registerForDistributedNotificationFromiTunes];
    }
    return self;
}

- (TrackInformation *) play:(NSError **)error {
    return [self executeAppleScript:iTunesPlayScript
                              error:error];
}

- (TrackInformation *) pause:(NSError **)error {
    return [self executeAppleScript:iTunesPauseScript
                              error:error];
}

#pragma mark -
#pragma mark Private
- (void) registerForDistributedNotificationFromiTunes {
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self 
                                                        selector:@selector(updateTrackInfo:) 
                                                            name:@"com.apple.iTunes.playerInfo" 
                                                          object:nil];
}

- (void) deregisterForDistributedNotificationFromiTunes {
    [[NSDistributedNotificationCenter defaultCenter] removeObserver:self];
}

- (void) initAppleScripts {
    iTunesPlayScript = [[NSAppleScript alloc] initWithSource:@"tell application \"iTunes\"\nplay\nend tell"];
    iTunesPauseScript = [[NSAppleScript alloc] initWithSource:@"tell application \"iTunes\"\npause\nend tell"]; 
}

- (TrackInformation *) executeAppleScript:(NSAppleScript *)script error:(NSError **)error {
    NSDictionary *dict = nil;
    NSAppleEventDescriptor *eventDescriptor = [script executeAndReturnError:&dict];
    return [self newTrackInformationWithEventDescription:eventDescriptor];
}

- (TrackInformation *) newTrackInformationWithEventDescription:(NSAppleEventDescriptor *)eventDescriptor {
    return nil;
}

- (void) updateTrackInfo:(NSNotification *)notification {
    id object = [notification userInfo];
    NSLog(@"%@",object);
}

- (void) dealloc {
    [self deregisterForDistributedNotificationFromiTunes];
    
    [super dealloc];
}

@end
