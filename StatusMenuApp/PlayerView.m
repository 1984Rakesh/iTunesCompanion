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

@end

@implementation PlayerView

- (void) setPlayerState:(iTunesState)state forTrack:(TrackInformation *)trackInfo {
    if( state == kPlaying || state == kPause ){
        
    }
    else {
        if( state == kStoped ){
            
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

@end
