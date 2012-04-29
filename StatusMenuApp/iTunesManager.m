//
//  iTunesManager.m
//  StatusMenuApp
//
//  Created by Rakesh Patole on 28/04/12.
//

#import "iTunesManager.h"

@interface iTunesManager(Private)

- (void) initAppleScripts;
- (void) registerForDistributedNotificationFromiTunes;
- (void) deregisterForDistributedNotificationFromiTunes;
- (TrackInformation *) executeAppleScript:(NSAppleScript *)script error:(NSError **)error;
- (TrackInformation *) newTrackInformationWithEventDescription:(NSAppleEventDescriptor *)eventDescriptor;
- (void) initError:(NSError **)erro fromInfoDict:(NSDictionary *)dict;
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
    
    TrackInformation *trackInfo = nil;
    
    if( dict != nil ){
        [self initError:error fromInfoDict:dict];
    }
    else {
        trackInfo = [self newTrackInformationWithEventDescription:eventDescriptor];
    }
    
    return trackInfo;
}

- (TrackInformation *) newTrackInformationWithEventDescription:(NSAppleEventDescriptor *)eventDescriptor {
    return nil;
}

- (void) initError:(NSError **)erro fromInfoDict:(NSDictionary *)dict {
    
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
