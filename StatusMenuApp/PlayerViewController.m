//
//  PlayerViewController.m
//  StatusMenuApp
//
//  Created by Rakesh Patole on 29/04/12.
//  Copyright (c) 2012 Diaspark. All rights reserved.
//

#import "PlayerViewController.h"

@interface PlayerViewController(Private)

- (void) notifiyUserWithTrackInformation:(TrackInformation *)trackInfo;


@end

@implementation PlayerViewController

- (void) awakeFromNib {
    [super awakeFromNib];
    
    [GrowlApplicationBridge setGrowlDelegate:self];
}

- (IBAction)playButtonAction:(id)sender {
    NSError *error = nil;
    TrackInformation *trackInfo = [[iTunesManager sharedManager] play:&error];
    if( error == nil ){
        //Update View;
        NSLog(@"Playing %@",trackInfo);
        [self notifiyUserWithTrackInformation:trackInfo];
    }
    else {
        NSLog(@"Error :: %@",[error localizedDescription]);
    }
}

- (IBAction)pauseButtonAction:(id)sender {
    NSError *error = nil;
    TrackInformation *trackInfo = [[iTunesManager sharedManager] play:&error];
    if( error == nil ){
        //Update View;
        NSLog(@"Paused %@",trackInfo);
        [self notifiyUserWithTrackInformation:trackInfo];
    }
    else {
        NSLog(@"Error :: %@",[error localizedDescription]);
    }
}

#pragma mark -
#pragma mark Private 
- (void) notifiyUserWithTrackInformation:(TrackInformation *)trackInfo {
    
}

@end
