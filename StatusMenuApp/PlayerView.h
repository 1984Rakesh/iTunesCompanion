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
    IBOutlet NSSlider *playerProgress;
    IBOutlet NSTextField *timeElapsed;
    IBOutlet NSTextField *timeRemaining;
    
    NSImage *placeHolderArtWork;
}

- (void) setPlayerState:(iTunesEPlS)state forTrack:(iTunesTrack *)trackInfo;
- (void) setPlayerPosition:(NSUInteger)newPosition;

@end
