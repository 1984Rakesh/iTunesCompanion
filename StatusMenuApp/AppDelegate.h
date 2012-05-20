//
//  AppDelegate.h
//  StatusMenuApp
//
//  Created by Rakesh on 26/04/12.
//

#import <Cocoa/Cocoa.h>
#import "PlayerViewController.h"
#import "StatusItemView.h"

@interface AppDelegate : NSObject <NSApplicationDelegate,NSMenuDelegate> {
    NSStatusItem *statusMenuItem;
    IBOutlet PlayerViewController *playerViewController;
    IBOutlet NSPopover *playerViewPopOver;
    IBOutlet StatusItemView *statusMenuItemView;
    IBOutlet NSMenu *menu;
}

@property (assign) IBOutlet NSWindow *window;



@end
