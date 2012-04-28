//
//  iTunesManager.m
//  StatusMenuApp
//
//  Created by Rakesh Patole on 28/04/12.
//  Copyright (c) 2012 Diaspark. All rights reserved.
//

#import "iTunesManager.h"

@implementation iTunesManager

static iTunesManager *sharedManager;

- (iTunesManager *) sharedManager {
    @synchronized(sharedManager) {
        if( sharedManager == nil ){
            sharedManager = [[iTunesManager alloc] init];
        }
    }
    return sharedManager;
}

@end
