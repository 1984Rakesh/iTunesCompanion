//
//  PlayerViewController.h
//  StatusMenuApp
//
//  Created by Rakesh Patole on 29/04/12.
//  Copyright (c) 2012 Diaspark. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Growl/Growl.h>

#import "PlayerView.h"
#import "iTunesManager.h"

@interface PlayerViewController : NSViewController<GrowlApplicationBridgeDelegate> {
    
}


- (IBAction)playButtonAction:(id)sender;
- (IBAction)pauseButtonAction:(id)sender;

@end
