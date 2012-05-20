//
//  iTunesManager.m
//  StatusMenuApp
//
//  Created by Rakesh Patole on 28/04/12.
//

#import "iTunesManager.h"
#import "iTunes.h"

@interface iTunesManager(Private)

- (iTunesApplication *) itunesApplication;

- (void) registerForDistributedNotificationFromiTunes;
- (void) deregisterForDistributedNotificationFromiTunes;
- (void) iTunesDistributedNotificationHandler:(NSNotification *)notification;

- (void) startTimer;
- (void) pauseTimer;
- (void) stopTimer;
- (void) updateTimer;

- (void) initState;

@end

@interface iTunesManager(State)

- (void) setState:(iTunesEPlS)state;
- (SEL) selForState:(iTunesEPlS)state; 
- (void) playing;
- (void) stopped;
- (void) paused;

+ (NSDictionary *)stateMethods;

@end

@implementation iTunesManager

#define PLAYER_POSITION_UPDATE_TIME_INTERVAL            1.0f //sec

static NSDictionary *stateMethods;
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
        [self performSelector:@selector(initState)
                   withObject:nil
                   afterDelay:0.5f];
    }
    return self;
}

- (iTunesApplication *) itunesApplication {
    if( itunesApplication == nil ){
        itunesApplication = [[SBApplication applicationWithBundleIdentifier:iTunes_BundleIdentifier] retain];
    }
    return itunesApplication;
}

- (iTunesEPlS) playerState {
    iTunesEPlS playerState = iTunesEPlSStopped;
    if( [[self itunesApplication] isRunning] == YES ) {
        playerState = [[self itunesApplication] playerState];
    }
    return playerState;
}

- (iTunesTrack *) currentTrack {
    iTunesTrack *currentTrack = nil;
    if( [[self itunesApplication] isRunning] == YES ){
        currentTrack = [[self itunesApplication] currentTrack];
    }
    return currentTrack;
}

- (NSUInteger) playerPosition {
    NSUInteger playerPosition = 0;
    if([[self itunesApplication] isRunning] == YES ){
        playerPosition = [[self itunesApplication] playerPosition];
    }
    return playerPosition;
}

- (void) openiTunes {
    [[[self itunesApplication] browserWindows] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSLog(@"%@",obj);
        Class iTunesBrowserWindowClass = NSClassFromString(@"ITunesBrowserWindow");
        if( [obj isKindOfClass:iTunesBrowserWindowClass] == YES ){
            [(iTunesBrowserWindow *)obj open];
            [(iTunesBrowserWindow *)obj reveal];
            *stop = YES;
        }
    }];
    
    if( [[self itunesApplication] isRunning] == YES ){
        [[self currentTrack] reveal];
    }
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

- (void) setPlayerPosition:(NSInteger)newPosition {
    [[self itunesApplication] setPlayerPosition:newPosition];
    
}

#pragma mark -
#pragma mark Private
- (void) initState {
    [self setState:[[self itunesApplication] playerState]];
}

- (void) startTimer {
    if( playerPositionTimer == nil ){
//        playerPositionTimer = [NSTimer timerWithTimeInterval:

        playerPositionTimer = [NSTimer timerWithTimeInterval:PLAYER_POSITION_UPDATE_TIME_INTERVAL
                                                      target:self
                                                    selector:@selector(updateTimer)
                                                    userInfo:nil
                                                     repeats:YES];
        [playerPositionTimer retain];
        [[NSRunLoop mainRunLoop] addTimer:playerPositionTimer forMode:NSRunLoopCommonModes];
        [playerPositionTimer fire];
    }
}

- (void) pauseTimer {
    [self stopTimer];
}

- (void) resumeTimer {
    [self startTimer];
}

- (void) stopTimer {
    if( playerPositionTimer != nil ){
        if( [playerPositionTimer isValid] == YES ){
            [playerPositionTimer invalidate];
        }
        FREE_NSOBJ(playerPositionTimer);
    }
}

- (void) updateTimer {
    [[NSNotificationCenter defaultCenter] postNotificationName:kiTunesDidChangePlayerPosition
                                                        object:nil];
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
    
    FREE_NSOBJ(itunesApplication);
    FREE_NSOBJ(playerPositionTimer);
    
    [super dealloc];
}

@end

@implementation iTunesManager(State)

- (void) setState:(iTunesEPlS)state {
//    NSString *stateMethod = [[self stateMethodsArray] objectAtIndex:state];
//    [self performSelector:NSSelectorFromString(stateMethod)];
    SEL stateMethos = [self selForState:state];
    if( stateMethods != nil ){
        [self performSelector:stateMethos];
        [[NSNotificationCenter defaultCenter] postNotificationName:kITunesDidChangeState
                                                            object:nil];
    }
}

- (SEL) selForState:(iTunesEPlS)state {
    SEL stateMethod = nil;
    NSString * stateMethodStr = [[[self class] stateMethods] objectForKey:[NSString stringWithFormat:@"%c",state]];
    stateMethod = NSSelectorFromString(stateMethodStr);
    return stateMethod;
}

+ (NSDictionary *)stateMethods {
    if( stateMethods == nil ){
        NSArray * objects = [NSArray arrayWithObjects:NSStringFromSelector(@selector(playing)),
                             NSStringFromSelector(@selector(stopped)),
                             NSStringFromSelector(@selector(paused)),nil];
        NSArray * keys = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%c",iTunesEPlSPlaying],
                          [NSString stringWithFormat:@"%c",iTunesEPlSStopped],
                          [NSString stringWithFormat:@"%c",iTunesEPlSPaused],
                          nil];
        stateMethods = [[NSDictionary alloc] initWithObjects:objects
                                                     forKeys:keys];
    }
    return stateMethods;
}



- (void) playing {
    [self startTimer];
}

- (void) stopped {
    [self stopTimer];
}

- (void) paused {
    [self pauseTimer];
}

@end

/**************************************************************************************************/
//- (BOOL) executeAppleScript:(NSAppleScript *)script error:(NSError **)error {
//    NSDictionary *dict = nil;
//    [script executeAndReturnError:&dict];
//    NSLog(@"Dict :: %@",dict);
//    if( dict != nil ){
//        [self initError:error fromInfoDict:dict];
//    }
//    return (*error == nil);
//}
//
//- (void) initError:(NSError **)erro fromInfoDict:(NSDictionary *)dict {
//    
//}
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

//- (NSArray *) stateStringsArray {
//    return nil;// [NSArray arrayWithObjects:@"Stopped",@"Paused",@"Playing",nil];
//}
//
//- (NSArray *) stateMethodsArray {
////    enum iTunesEPlS {
////        iTunesEPlSStopped = 'kPSS',
////        iTunesEPlSPlaying = 'kPSP',
////        iTunesEPlSPaused = 'kPSp',
////        iTunesEPlSFastForwarding = 'kPSF',
////        iTunesEPlSRewinding = 'kPSR'
////    };
//    return [NSArray arrayWithObjects:@"stopped",@"playing",@"paused",nil];
//}


/**************************************************************************************************/