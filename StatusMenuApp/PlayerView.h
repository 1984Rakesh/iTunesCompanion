//
//  PlayerControllerView.h
//  StatusMenuApp
//
//  Created by Rakesh Patole on 29/04/12.
//

#import <Cocoa/Cocoa.h>
#import "iTunesManager.h"

@interface PlayerView : NSView {
    IBOutlet NSImageView *artWork;
    IBOutlet NSTextField *trackName;
    IBOutlet NSTextField *trackArtist;
    IBOutlet NSButton *playPauseButton;
}

- (void) setPlayerState:(iTunesEPlS)state forTrack:(iTunesTrack *)trackInfo;
- (void) setPlayerPosition:(NSUInteger)newPosition;

@end
