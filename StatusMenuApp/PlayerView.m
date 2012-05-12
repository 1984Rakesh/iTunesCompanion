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
        
        if( state == iTunesEPlSPlaying ) [playPauseButton setTitle:@"Pause"];
        if( state == iTunesEPlSPaused ) [playPauseButton setTitle:@"Play"];
    }
    else {
        if( state == iTunesEPlSStopped ){
            [playPauseButton setTitle:@"Play"];
        }
    }
}

- (void) setPlayerPosition:(NSUInteger)newPosition {
    
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
