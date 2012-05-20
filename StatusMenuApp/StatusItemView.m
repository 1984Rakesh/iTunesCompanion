//
//  StatusItemView.m
//  StatusMenuApp
//
//  Created by Rakesh Patole on 20/05/12.
//  Copyright (c) 2012 Diaspark. All rights reserved.
//

#import "StatusItemView.h"

@implementation StatusItemView

- (void)drawRect:(NSRect)dirtyRect
{
    CGRect rect = CGRectInset(dirtyRect, 2, 2);
    [[NSColor selectedMenuItemColor] set];
    NSRectFill(rect); 
}

@end
