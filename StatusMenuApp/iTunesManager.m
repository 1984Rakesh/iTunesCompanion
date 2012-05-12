//
//  iTunesManager.m
//  StatusMenuApp
//
//  Created by Rakesh Patole on 28/04/12.
//

#import "iTunesManager.h"

@interface iTunesManager(Private)

- (iTunesApplication *) itunesApplication;

- (void) initAppleScripts;
- (BOOL) executeAppleScript:(NSAppleScript *)script error:(NSError **)error;
- (void) initError:(NSError **)erro fromInfoDict:(NSDictionary *)dict;

- (void) registerForDistributedNotificationFromiTunes;
- (void) deregisterForDistributedNotificationFromiTunes;
- (void) iTunesDistributedNotificationHandler:(NSNotification *)notification;

- (void) startTimer;
- (void) pauseTimer;
- (void) resumeTimer;

- (NSString *) iTunesPlayerStatus;

@end

@interface iTunesManager(State)

- (iTunesState) stateFromString:(NSString *)stateString;
- (NSString *) stringFromState:(iTunesState)state;
- (void) setState:(iTunesState)state;
- (NSArray *) stateStringsArray;
- (NSArray *) stateMethodsArray;
- (void) playing;
- (void) stopped;
- (void) paused;

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

+ (void) startListeningToEventsFromItunes {
    [[iTunesManager sharedManager] registerForDistributedNotificationFromiTunes];
}

+ (void) stopListeningToEventsFromItunes {
    [[iTunesManager sharedManager] deregisterForDistributedNotificationFromiTunes]; 
}

- (id) init {
    self = [super init];
    if( self != nil ){
        
        
        [self initAppleScripts];
        
        //some way so that view and controller can be notified the current state of itunes so that 
        //the view can be updated accordingly.... also the registeration of the itunes distributed 
        //notificatiom should be done at the start/lunch of the app so that services depending upon
        //this feture can work accordingly.
    }
    return self;
}

- (iTunesApplication *) itunesApplication {
    if( itunesApplication == nil ){
        itunesApplication = [[SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"] retain];
    }
    return itunesApplication;
}

- (iTunesState) playerState {
    return playerState;
}

- (iTunesTrack *) currentTrack {
    return [[self itunesApplication] currentTrack];
}

- (BOOL) play:(NSError **)error {
//    return [self executeAppleScript:iTunesPlayScript
//                              error:error];
    [itunesApplication playpause];
    return YES;
}

- (BOOL) pause:(NSError **)error {
    return [self executeAppleScript:iTunesPauseScript
                              error:error];
}

- (BOOL) nextTrack:(NSError **)error {
    return [self executeAppleScript:iTunesNextTrackScript
                              error:error];
}

- (BOOL) backTrack:(NSError **)error {
    return [self executeAppleScript:iTunesBackTrackScript
                              error:error];
}

- (BOOL) changePlayerPosition:(NSError **)error {
    return NO;
}

#pragma mark -
#pragma mark Private
- (void) initAppleScripts {
    iTunesPlayScript = [[NSAppleScript alloc] initWithSource:@"tell application \"iTunes\"\nplay\nend tell"];
    iTunesPauseScript = [[NSAppleScript alloc] initWithSource:@"tell application \"iTunes\"\npause\nend tell"]; 
    iTunesNextTrackScript = [[NSAppleScript alloc] initWithSource:@"tell application \"iTunes\"\nnext track\nend tell"]; 
    iTunesBackTrackScript = [[NSAppleScript alloc] initWithSource:@"tell application \"iTunes\"\nback track\nend tell"]; 
    
    iTunesPlayerStatusScript = [[NSAppleScript alloc] initWithSource:@"tell application \"iTunes\"\nreturn get player state\nend tell"];
    iTunesCurrentTrackInfoScript = [[NSAppleScript alloc] initWithSource:@"tell application \"iTunes\"\nreturn get current track\nend tell"];
    
    iTunesCurrentTrackArtworkScript = [[NSAppleScript alloc] initWithSource:@"tell application \"iTunes\"\nreturn get raw data of artwork 1 of current track\nend tell"];
}

- (BOOL) executeAppleScript:(NSAppleScript *)script error:(NSError **)error {
    NSDictionary *dict = nil;
    [script executeAndReturnError:&dict];
    NSLog(@"Dict :: %@",dict);
    if( dict != nil ){
        [self initError:error fromInfoDict:dict];
    }
    return (*error == nil);
}

- (void) initError:(NSError **)erro fromInfoDict:(NSDictionary *)dict {
    
}

- (void) startTimer {
    
}

- (void) pauseTimer {
        
}

- (void) resumeTimer {
    
}

- (NSString *) iTunesPlayerStatus {
    NSDictionary *dict = nil;
    NSAppleEventDescriptor *eventDescriptor = [iTunesPlayerStatusScript executeAndReturnError:&dict];
    NSLog(@"State :: %@",[eventDescriptor stringValue]);
    return nil;
}

#pragma mark - 
#pragma mark  Notifications
- (void) registerForDistributedNotificationFromiTunes {
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self 
                                                        selector:@selector(iTunesDistributedNotificationHandler:) 
                                                            name:@"com.apple.iTunes.playerInfo" 
                                                          object:nil];
}

- (void) deregisterForDistributedNotificationFromiTunes {
    [[NSDistributedNotificationCenter defaultCenter] removeObserver:self];
}


//Creating object with notification data is pretty straight forward but the same using an 
//apple script is very complicated using same set functions to set initial player set and change on 
//notification thus becomes further critical goal is to keep the interface same without different 
// set of functions to set initial state and change state later on...
- (void) iTunesDistributedNotificationHandler:(NSNotification *)notification {
    id object = [notification userInfo];
    NSLog(@"%@",object);
    NSString *state = [object objectForKey:@"Player State"];
    iTunesState newstate = [self stateFromString:state];
//    if( newstate == kPlaying || newstate == kPause ){
//        currentPlayingTrack = [self newTrackInformationWithUserInfo:object];
//        [currentPlayingTrack setArtWork:[self getArtData]];
//    }
    [self setState:newstate];
}

- (void) dealloc {
    [self deregisterForDistributedNotificationFromiTunes];
    
    [super dealloc];
}

@end

@implementation iTunesManager(State)

- (iTunesState) stateFromString:(NSString *)stateString {
    iTunesState _playerState = (iTunesState)[[self stateStringsArray] indexOfObject:stateString];
    return _playerState;
}

- (NSString *) stringFromState:(iTunesState)state {
    NSArray *stateStringsArray = [self stateStringsArray];
    
    NSString *returnState = [stateStringsArray objectAtIndex:kStoped];
    
    if( state <= [stateStringsArray count] && (NSInteger)state >= 0 ){
        returnState = [stateStringsArray objectAtIndex:state];
    }
    
    return returnState;
}

- (void) setState:(iTunesState)state {
    playerState = state;
    NSString *stateMethod = [[self stateMethodsArray] objectAtIndex:state];
    [self performSelector:NSSelectorFromString(stateMethod)];
    [[NSNotificationCenter defaultCenter] postNotificationName:kITunesDidChangeState
                                                        object:nil];
}

- (NSArray *) stateStringsArray {
    return [NSArray arrayWithObjects:@"Stopped",@"Paused",@"Playing",nil];
}

- (NSArray *) stateMethodsArray {
    return [NSArray arrayWithObjects:@"stopped",@"paused",@"playing",nil];
}

- (void) playing {
    NSLog(@"Playing");
    //create timer to check player position
}

- (void) stopped {
    NSLog(@"stopped");
    //stop timer that was checking player position
}

- (void) paused {
    //Pause timer that is checking player position
    NSLog(@"Paused");
}

@end