//
//  PlayerControllerView.h
//  StatusMenuApp
//
//  Created by Rakesh Patole on 29/04/12.
//

#import <Cocoa/Cocoa.h>
#import "iTunesManager.h"

@interface PlayerView : NSView {
    NSImageView *artWork;
}

- (void) setPlayerState:(iTunesState)state forTrack:(TrackInformation *)trackInfo;
- (void) setPlayerPosition:(NSUInteger)newPosition;

@end
