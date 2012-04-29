//
//  AppDelegate.m
//  StatusMenuApp
//
//  Created by Rakesh on 26/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate

@synthesize window = _window;

- (void) awakeFromNib {
    [super awakeFromNib];
    
    statusMenuItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusMenuItem retain];
    
    [statusMenuItem setTitle:@"Hello Status"];
    [statusMenuItem setMenu:statusMenu];
    
    [[statusMenu itemAtIndex:0] setView:[playerViewController view]];
    
    
}
	
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}


@end
