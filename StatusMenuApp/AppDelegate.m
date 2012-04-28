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
    
    [[statusMenu itemAtIndex:0] setView:customMenuItemView];
    
    [GrowlApplicationBridge setGrowlDelegate:self]; // Setting a Growl delegate is unnecessary unless you need click callbacks. 
}
	
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self 
                                                        selector:@selector(updateTrackInfo:) 
                                                            name:@"com.apple.iTunes.playerInfo" 
                                                          object:nil];
    iTunesPlayScript = [[NSAppleScript alloc] initWithSource:@"tell application \"iTunes\"\nplay\nend tell"];
    iTunesPauseScript = [[NSAppleScript alloc] initWithSource:@"tell application \"iTunes\"\npause\nend tell"]; 
}

- (void) updateTrackInfo:(NSNotification *)notification {
    id object = [notification userInfo];
    NSLog(@"%@",object);
    [GrowlApplicationBridge notifyWithTitle:@"Application Launched"
                                description:@"The app launched successfully and displayed this notification"
                           notificationName:@"testGrowlNotification"
                                   iconData:nil
                                   priority:-2 
                                   isSticky:NO 
                               clickContext:@"launchNotifyClick"];
}

- (IBAction)playButtonAction:(id)sender {
    NSDictionary *dict = nil;
    NSAppleEventDescriptor *eventDescriptor = [iTunesPlayScript executeAndReturnError:&dict];
    NSLog(@"Dict :: %@, eventDescriptor :: %@",dict,eventDescriptor);
}

- (IBAction)pauseButtonAction:(id)sender {
    NSDictionary *dict = nil;
    NSAppleEventDescriptor *eventDescriptor = [iTunesPauseScript executeAndReturnError:&dict];
    NSLog(@"Dict :: %@, eventDescriptor :: %@",dict,eventDescriptor);
}


@end
