//
//  TrackInformation.m
//  StatusMenuApp
//
//  Created by Rakesh Patole on 30/04/12.
//  Copyright (c) 2012 Diaspark. All rights reserved.
//

#import "TrackInformation.h"

@implementation TrackInformation

@synthesize artWork;

- (id) initWithInfo:(NSDictionary *)info {
    self = [super init];
    
    if( self != nil ){
        
    }
    
    return self;
}

- (NSImage *) artWork {
    return nil;
}

- (void) dealloc {
    if( artWork != nil ){
        [artWork release]; artWork = nil;
    }
    
    [super dealloc];
}

@end
