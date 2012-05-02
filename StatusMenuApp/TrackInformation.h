//
//  TrackInformation.h
//  StatusMenuApp
//
//  Created by Rakesh Patole on 30/04/12.
//  Copyright (c) 2012 Diaspark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrackInformation : NSObject {
    NSDictionary *trackInfo;
    NSImage *artWork;
}
@property (nonatomic, retain) NSImage *artWork;

- (id) initWithInfo:(NSDictionary *)info;

@end
