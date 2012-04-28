//
//  AppDelegate.h
//  StatusMenuApp
//
//  Created by Rakesh on 26/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Growl/Growl.h>

@interface AppDelegate : NSObject <NSApplicationDelegate,GrowlApplicationBridgeDelegate> {
    IBOutlet NSMenu *statusMenu;
    NSStatusItem *statusMenuItem;
    IBOutlet NSView *customMenuItemView;
    NSAppleScript *iTunesPlayScript;
    NSAppleScript *iTunesPauseScript;
}

@property (assign) IBOutlet NSWindow *window;

- (IBAction)playButtonAction:(id)sender;
- (IBAction)pauseButtonAction:(id)sender;

@end
