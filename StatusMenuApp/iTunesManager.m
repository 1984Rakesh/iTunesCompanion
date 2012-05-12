//
//  iTunesManager.m
//  StatusMenuApp
//
//  Created by Rakesh Patole on 28/04/12.
//

#import "iTunesManager.h"

@interface iTunesManager(Private)

- (iTunesApplication *) itunesApplication;

- (void) registerForDistributedNotificationFromiTunes;
- (void) deregisterForDistributedNotificationFromiTunes;
- (void) iTunesDistributedNotificationHandler:(NSNotification *)notification;

- (void) startTimer;
- (void) pauseTimer;
- (void) resumeTimer;

@end

@interface iTunesManager(State)

//- (iTunesEPlS) stateFromString:(NSString *)stateString;
//- (NSString *) stringFromState:(iTunesEPlS)state;
- (void) setState:(iTunesEPlS)state;
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

- (iTunesEPlS) playerState {
    return [[self itunesApplication] playerState];
}

- (iTunesTrack *) currentTrack {
    return [[self itunesApplication] currentTrack];
}

- (void) playpauseTrack {
    [[self itunesApplication] playpause];
}

- (void) nextTrack {
    [[self itunesApplication] nextTrack];
}

- (void) backTrack {
    [[self itunesApplication] backTrack];
}

- (BOOL) changePlayerPosition:(NSError **)error {
    return NO;
}

#pragma mark -
#pragma mark Private
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

- (void) iTunesDistributedNotificationHandler:(NSNotification *)notification {
    [self setState:[self playerState]];
}

- (void) dealloc {
    [self deregisterForDistributedNotificationFromiTunes];
    
    [super dealloc];
}

@end

@implementation iTunesManager(State)

- (void) setState:(iTunesEPlS)state {
//    NSString *stateMethod = [[self stateMethodsArray] objectAtIndex:state];
//    [self performSelector:NSSelectorFromString(stateMethod)];
    [[NSNotificationCenter defaultCenter] postNotificationName:kITunesDidChangeState
                                                        object:nil];
}

- (NSArray *) stateStringsArray {
    return nil;// [NSArray arrayWithObjects:@"Stopped",@"Paused",@"Playing",nil];
}

- (NSArray *) stateMethodsArray {
//    enum iTunesEPlS {
//        iTunesEPlSStopped = 'kPSS',
//        iTunesEPlSPlaying = 'kPSP',
//        iTunesEPlSPaused = 'kPSp',
//        iTunesEPlSFastForwarding = 'kPSF',
//        iTunesEPlSRewinding = 'kPSR'
//    };
    return [NSArray arrayWithObjects:@"stopped",@"playing",@"paused",nil];
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

/**************************************************************************************************/
//- (void) initAppleScripts {
//iTunesPlayScript = [[NSAppleScript alloc] initWithSource:@"tell application \"iTunes\"\nplay\nend tell"];
//iTunesPauseScript = [[NSAppleScript alloc] initWithSource:@"tell application \"iTunes\"\npause\nend tell"]; 
//iTunesNextTrackScript = [[NSAppleScript alloc] initWithSource:@"tell application \"iTunes\"\nnext track\nend tell"]; 
//iTunesBackTrackScript = [[NSAppleScript alloc] initWithSource:@"tell application \"iTunes\"\nback track\nend tell"]; 
//
//iTunesPlayerStatusScript = [[NSAppleScript alloc] initWithSource:@"tell application \"iTunes\"\nreturn get player state\nend tell"];
//iTunesCurrentTrackInfoScript = [[NSAppleScript alloc] initWithSource:@"tell application \"iTunes\"\nreturn get current track\nend tell"];
//
//iTunesCurrentTrackArtworkScript = [[NSAppleScript alloc] initWithSource:@"tell application \"iTunes\"\nreturn get raw data of artwork 1 of current track\nend tell"];
//}

//- (NSString *) iTunesPlayerStatus {
////    NSDictionary *dict = nil;
////    NSAppleEventDescriptor *eventDescriptor = [iTunesPlayerStatusScript executeAndReturnError:&dict];
////    NSLog(@"State :: %@",[eventDescriptor stringValue]);
//return nil;
//}

//- (iTunesEPlS) stateFromString:(NSString *)stateString {
//    iTunesEPlS _playerState = (iTunesEPlS)[[self stateStringsArray] indexOfObject:stateString];
//    return _playerState;
//}
//
//- (NSString *) stringFromState:(iTunesEPlS)state {
//    NSArray *stateStringsArray = [self stateStringsArray];
//    
//    NSString *returnState = [stateStringsArray objectAtIndex:state];
//    
//    if( state <= [stateStringsArray count] && (NSInteger)state >= 0 ){
//        returnState = [stateStringsArray objectAtIndex:state];
//    }
//    
//    return returnState;
//}


/**************************************************************************************************/