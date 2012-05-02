//
//  iTunesManager.h
//  StatusMenuApp
//
//  Created by Rakesh Patole on 28/04/12.
//

#import <Foundation/Foundation.h>
#import "TrackInformation.h"
#import "AStoObjC.h"

typedef enum _iTunesState {
    kStoped,
    kPause,
    kPlaying
} iTunesState;

#define kITunesDidChangeState           @"kITunesDidChangeState"
#define kiTunesDidChangePlayerPosition  @"kiTunesDidChangePlayerPosition"


@interface iTunesManager : NSObject {
    TrackInformation *currentPlayingTrack;
    iTunesState playerState;
    NSTimer *playerPositionTimer;    
    
    AStoObjC *convertor;
    Class iTunes;
    
@private
    NSAppleScript *iTunesPlayScript;
    NSAppleScript *iTunesPauseScript;
    NSAppleScript *iTunesNextTrackScript;
    NSAppleScript *iTunesBackTrackScript;
    NSAppleScript *iTunesCurrentTrackProgressScript;
    NSAppleScript *iTunesCurrentTrackArtworkScript;
    NSAppleScript *iTunesCurrentTrackInfoScript;
    NSAppleScript *iTunesPlayerStatusScript;
}

+ (iTunesManager *) sharedManager;
+ (void) startListeningToEventsFromItunes;
+ (void) stopListeningToEventsFromItunes;

- (iTunesState) playerState;
- (TrackInformation *) currentTrack;

- (BOOL) play:(NSError **)error;
- (BOOL) pause:(NSError **)error;
- (BOOL) nextTrack:(NSError **)error;
- (BOOL) backTrack:(NSError **)error;
- (BOOL) changePlayerPosition:(NSError **)error;

@end

