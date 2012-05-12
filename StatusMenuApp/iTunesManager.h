//
//  iTunesManager.h
//  StatusMenuApp
//
//  Created by Rakesh Patole on 28/04/12.
//

#import <Foundation/Foundation.h>
#import "iTunes.h"

typedef enum _iTunesState {
    kStoped,
    kPause,
    kPlaying
} iTunesState;

#define kITunesDidChangeState           @"kITunesDidChangeState"
#define kiTunesDidChangePlayerPosition  @"kiTunesDidChangePlayerPosition"


@interface iTunesManager : NSObject {
    iTunesState playerState;
    NSTimer *playerPositionTimer;    
    
    iTunesApplication *itunesApplication;
}

+ (iTunesManager *) sharedManager;
+ (void) startListeningToEventsFromItunes;
+ (void) stopListeningToEventsFromItunes;

- (iTunesState) playerState;
- (iTunesTrack *) currentTrack;

- (void) playpauseTrack;
- (void) nextTrack;
- (void) backTrack;


@end

/**************************************************************************************************/

//@private
//NSAppleScript *iTunesPlayScript;
//NSAppleScript *iTunesPauseScript;
//NSAppleScript *iTunesNextTrackScript;
//NSAppleScript *iTunesBackTrackScript;
//NSAppleScript *iTunesCurrentTrackProgressScript;
//NSAppleScript *iTunesCurrentTrackArtworkScript;
//NSAppleScript *iTunesCurrentTrackInfoScript;
//NSAppleScript *iTunesPlayerStatusScript;

/**************************************************************************************************/

