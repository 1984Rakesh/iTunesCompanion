//
//  PlayerViewController.m
//  StatusMenuApp
//
//  Created by Rakesh Patole on 29/04/12.
//

#import "PlayerViewController.h"

@interface PlayerViewController(Private)

- (void) itunesDidChangeStateNotification:(NSNotification *)notification;
- (void) itunesDidChangePlayerPositionNotification:(NSNotification *)notification;

@end

@implementation PlayerViewController

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if( self != nil ){
        [GrowlApplicationBridge setGrowlDelegate:self];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(itunesDidChangeStateNotification:)
                                                     name:kITunesDidChangeState
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(itunesDidChangePlayerPositionNotification:)
                                                     name:kiTunesDidChangePlayerPosition
                                                   object:nil];
        
        iTunesEPlS state = [[iTunesManager sharedManager] playerState];
        iTunesTrack *currentTrack = [[iTunesManager sharedManager] currentTrack];
        [(PlayerView *)self.view setPlayerState:state
                                       forTrack:currentTrack];
    }
    return self;
}

- (IBAction)playButtonAction:(id)sender {
    [[iTunesManager sharedManager] playpauseTrack];
}

- (IBAction)pauseButtonAction:(id)sender {
    [[iTunesManager sharedManager] playpauseTrack];
}

- (IBAction)nextTrackButtonAction:(id)sender {
    [[iTunesManager sharedManager] nextTrack];
}

- (IBAction)backTrackButtonAction:(id)sender {
    [[iTunesManager sharedManager] backTrack];
}

#pragma mark - 
#pragma mark Notification Handler
- (void) itunesDidChangeStateNotification:(NSNotification *)notification {   
    iTunesEPlS state = [[iTunesManager sharedManager] playerState];
    iTunesTrack *currentTrack = [[iTunesManager sharedManager] currentTrack];
    
    [(PlayerView *)self.view setPlayerState:state
                                   forTrack:currentTrack];
    
    if( state == iTunesEPlSPlaying ){
        [GrowlApplicationBridge notifyWithTitle:@"Application Launched" 
                                    description:@"The app launched successfully and displayed this notification"
                               notificationName:@"testGrowlNotification"
                                       iconData:nil
                                       priority:0
                                       isSticky:NO
                                   clickContext:@"launchNotifyClick"];        
    }
}

- (void) itunesDidChangePlayerPositionNotification:(NSNotification *)notification {
    NSNumber *playerPosition = [notification object];
    [(PlayerView *)[self view] setPlayerPosition:[playerPosition intValue]];
}

@end