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
    }
    return self;
}

- (IBAction)playButtonAction:(id)sender {
    [[iTunesManager sharedManager] playpauseTrack];
}

- (IBAction)nextTrackButtonAction:(id)sender {
    [[iTunesManager sharedManager] nextTrack];
}

- (IBAction)backTrackButtonAction:(id)sender {
    [[iTunesManager sharedManager] backTrack];
}

- (IBAction)openiTunesButtonAction:(id)sender {
    [[iTunesManager sharedManager] openiTunes];
}

- (IBAction)changePlayerPositionAction:(id)sender {
    [[iTunesManager sharedManager] setPlayerPosition:[sender intValue]];
    [(PlayerView *)[self view] setPlayerPosition:[[iTunesManager sharedManager] playerPosition]];
}

#pragma mark - 
#pragma mark Notification Handler
- (void) itunesDidChangeStateNotification:(NSNotification *)notification {   
    iTunesEPlS state = [[iTunesManager sharedManager] playerState];
    iTunesTrack *currentTrack = [[iTunesManager sharedManager] currentTrack];
    
    [(PlayerView *)self.view setPlayerState:state
                                   forTrack:currentTrack];
    
    iTunesArtwork *artWorkImage = [[currentTrack artworks] objectAtIndex:0];
    
    if( state == iTunesEPlSPlaying ){
        [GrowlApplicationBridge notifyWithTitle:[currentTrack name]
                                    description:[currentTrack album]
                               notificationName:@"testGrowlNotification"
                                       iconData:[artWorkImage rawData]
                                       priority:0
                                       isSticky:NO
                                   clickContext:@"launchNotifyClick"];        
    }
}

- (void) itunesDidChangePlayerPositionNotification:(NSNotification *)notification {
    [(PlayerView *)[self view] setPlayerPosition:[[iTunesManager sharedManager] playerPosition]];
}

@end