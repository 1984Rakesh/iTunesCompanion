//
//  AppDelegate.m
//  StatusMenuApp
//
//  Created by Rakesh on 26/04/12.
//

#import "AppDelegate.h"

@interface AppDelegate()

- (void) statusItemClicked:(id)sender;

@end


@implementation AppDelegate

@synthesize window = _window;

- (void) awakeFromNib {
    [super awakeFromNib];
    
    statusMenuItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusMenuItem retain]; 
    
//    [[statusMenuItem view] addSubview:statusBarView];
    [statusMenuItem setTitle:@"iTunes Helper"];
    
    NSView *view = [playerViewController view];
    [[menu itemAtIndex:0] setView:view];
    [statusMenuItem setTarget:self];
    [statusMenuItem setAction:@selector(statusItemClicked:)];
}

- (void) applicationDidFinishLaunching:(NSNotification *)notification {
    [iTunesManager startListeningToEventsFromItunes];
}

- (void) applicationWillTerminate:(NSNotification *)notification {
    [iTunesManager stopListeningToEventsFromItunes];
}

#pragma mark - 
#pragma mark Private
- (void) statusItemClicked:(id)sender {
     [statusMenuItem popUpStatusItemMenu:menu];
}

@end
