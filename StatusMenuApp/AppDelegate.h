//
//  AppDelegate.h
//  StatusMenuApp
//
//  Created by Rakesh on 26/04/12.
//

#import <Cocoa/Cocoa.h>
#import "PlayerViewController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    IBOutlet NSMenu *statusMenu;
    NSStatusItem *statusMenuItem;
    IBOutlet PlayerViewController *playerViewController;
}

@property (assign) IBOutlet NSWindow *window;



@end
