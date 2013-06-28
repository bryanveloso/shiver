//
//  HeaderView.m
//  Shiver
//
//  Created by Bryan Veloso on 6/19/13.
//  Copyright (c) 2013 Revyver, Inc. All rights reserved.
//

#import "HeaderView.h"

#import "NSColor+Hex.h"


@implementation HeaderView

- (void)drawRect:(NSRect)dirtyRect
{
    // Abstracted attributes.
    NSRect frame = dirtyRect;

    // Declare our colors first.
    NSColor *topColor = [NSColor colorWithHex:@"#F4F4F5"];
    NSColor *bottomColor = [NSColor colorWithHex:@"#CDCED4"];
    NSColor *highlightColor = [NSColor colorWithHex:@"#FFF"];
    NSColor *shadowColor = [NSColor colorWithHex:@"9A9B9F"];

    // We're only drawing the left side of the two-tone header.
    NSRect rect = NSMakeRect(0, 0, NSWidth(frame), NSHeight(frame));
    NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:topColor endingColor:bottomColor];
    [gradient drawInRect:rect angle:-90];

    // Draw boxes for the highlight and shadow too.
    NSRect highlightRect = NSMakeRect(0, NSHeight(frame) - 1, NSWidth(frame), 1);
    [highlightColor setFill];
    NSRectFill(highlightRect);

    NSRect shadowRect = NSMakeRect(0, 1, NSWidth(frame), 1);
    [shadowColor setFill];
    NSRectFill(shadowRect);

    [super drawRect:dirtyRect];
}

@end
