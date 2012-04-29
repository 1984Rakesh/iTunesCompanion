//
//  iTunesManager.h
//  StatusMenuApp
//
//  Created by Rakesh Patole on 28/04/12.
//  Copyright (c) 2012 Diaspark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrackInformation  : NSObject {
}

@end

@interface iTunesManager : NSObject {
    NSAppleScript *iTunesPlayScript;
    NSAppleScript *iTunesPauseScript;
}

+ (iTunesManager *) sharedManager;

- (TrackInformation *) play:(NSError **)error;
- (TrackInformation *) pause:(NSError **)error;

@end
