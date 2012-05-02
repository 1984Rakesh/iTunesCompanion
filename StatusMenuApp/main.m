//
//  main.m
//  StatusMenuApp
//
//  Created by Rakesh on 26/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AppleScriptObjC/AppleScriptObjC.h>

int main(int argc, char *argv[])
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    [[NSBundle mainBundle] loadAppleScriptObjectiveCScripts];
    [pool release];
    return NSApplicationMain(argc, (const char **)argv);
}
