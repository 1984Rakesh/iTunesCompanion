//
//  PlayerControllerView.m
//  StatusMenuApp
//
//  Created by Rakesh Patole on 29/04/12.
//

#import "PlayerView.h"

@interface PlayerView()

- (void) updateViewForPlayingState;
- (void) updateViewForPausedState;
- (void) updateViewForStopedState;

- (NSImage *) placeHolderArtWork;

@end

@implementation PlayerView

#define TIME_DISPLAY_FORMAT @"%d:%d"

- (void) setPlayerState:(iTunesEPlS)state forTrack:(iTunesTrack *)trackInfo {
    if( state == iTunesEPlSPlaying || state == iTunesEPlSPaused ){
        iTunesArtwork *artWorkImage = [[trackInfo artworks] objectAtIndex:0];
        NSImage *image = [artWorkImage data];
        if( [trackInfo videoKind] == iTunesEVdKNone  ){
            [artWork setImage:image];
        }
        else {
            [artWork setImage:[self placeHolderArtWork]];
        }
        
        NSString *name = [trackInfo name];
        if( name != nil ) {
            [trackName setStringValue:name];
        }
        
        NSString *album = [trackInfo album];
        if( album != nil ){
            [trackArtist setStringValue:album];
        }
        
        [playerProgress setMinValue:0];
        [playerProgress setMaxValue:[trackInfo duration]];
        
        if( state == iTunesEPlSPlaying ) {
            [playPauseButton setTitle:@"Pause"];
            
        }
        if( state == iTunesEPlSPaused ) [playPauseButton setTitle:@"Play"];
        
        
    }
    else {
        if( state == iTunesEPlSStopped ){
            [playPauseButton setTitle:@"Play"];
            [playerProgress setDoubleValue:0];
            [playerProgress setMaxValue:0];
            [playerProgress setMinValue:0];
        }
    }
}

- (void) setPlayerPosition:(NSUInteger)newPosition {
    NSLog(@"New Position :: %lu",newPosition);
    [playerProgress setDoubleValue:newPosition];
    
    NSInteger duration = [playerProgress maxValue] - newPosition;
    
    NSInteger minsElapsed = newPosition / 60;
    NSInteger secElapsed = newPosition % 60;
    
    NSInteger minsRemaining = duration / 60;
    NSInteger secReamining = duration % 60;
    
    [timeElapsed setStringValue:[NSString stringWithFormat:TIME_DISPLAY_FORMAT,minsElapsed,secElapsed]];
    [timeRemaining setStringValue:[NSString stringWithFormat:TIME_DISPLAY_FORMAT,minsRemaining,secReamining]];
}

#pragma mark -
#pragma mark Private
- (void) updateViewForPlayingState {
    
}

- (void) updateViewForPausedState {
    
}

- (void) updateViewForStopedState {
    
}

- (NSImage *) placeHolderArtWork {
    if( placeHolderArtWork == nil ){
        
    }
    return placeHolderArtWork;
}

@end
