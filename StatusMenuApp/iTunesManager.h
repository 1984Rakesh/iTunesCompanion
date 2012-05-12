//
//  iTunesManager.h
//  StatusMenuApp
//
//  Created by Rakesh Patole on 28/04/12.
//

#import <Foundation/Foundation.h>
#import "iTunes.h"

#define kITunesDidChangeState           @"kITunesDidChangeState"
#define kiTunesDidChangePlayerPosition  @"kiTunesDidChangePlayerPosition"


@interface iTunesManager : NSObject {
    NSTimer *playerPositionTimer;    
    
    iTunesApplication *itunesApplication;
}

+ (iTunesManager *) sharedManager;
+ (void) startListeningToEventsFromItunes;
+ (void) stopListeningToEventsFromItunes;

- (iTunesEPlS) playerState;
- (iTunesTrack *) currentTrack;

- (void) playpauseTrack;
- (void) nextTrack;
- (void) backTrack;


@end

/**************************************************************************************************/

//typedef enum _iTunesState {
//    kStoped,
//    kPause,
//    kPlaying
//} iTunesState;

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

