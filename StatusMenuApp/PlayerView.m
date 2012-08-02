//
//  PlayerControllerView.m
//  StatusMenuApp
//
//  Created by Rakesh Patole on 29/04/12.
//

#import "PlayerView.h"

@interface PlayerView()

- (NSImage *) placeHolderArtWork;
- (void) setTime:(NSInteger)time toLable:(NSTextField *)textField;

@end

@implementation PlayerView

#define TIME_DISPLAY_FORMAT @"%d:%02d"

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
        else {
            if( state == iTunesEPlSPaused ) {
                [playPauseButton setTitle:@"Play"];
            }
        }       
    }
    else {
        if( state == iTunesEPlSStopped ){
            [playPauseButton setTitle:@"Play"];
            [playerProgress setDoubleValue:0];
            [playerProgress setMaxValue:0];
            [playerProgress setMinValue:0];
            
            [timeRemaining setStringValue:@""];
            [timeElapsed setStringValue:@""];
        }
    }
}

- (void) setPlayerPosition:(NSUInteger)newPosition {
    NSLog(@"New Position :: %lu",newPosition);
    [playerProgress setDoubleValue:newPosition];
    
    NSInteger duration = newPosition - [playerProgress maxValue];
    
    [self setTime:newPosition toLable:timeElapsed];
    [self setTime:duration toLable:timeRemaining];
}

#pragma mark -
#pragma mark Private
- (void) setTime:(NSInteger)time toLable:(NSTextField *)textField {
    NSInteger minsRemaining = time / 60;
    NSInteger secReamining = abs(time % 60);
    [textField setStringValue:[NSString stringWithFormat:TIME_DISPLAY_FORMAT,(int)minsRemaining,(int)secReamining]];
}

- (NSImage *) placeHolderArtWork {
    if( placeHolderArtWork == nil ){
        
    }
    return placeHolderArtWork;
}

@end
