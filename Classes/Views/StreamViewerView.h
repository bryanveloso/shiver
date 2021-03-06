//
//  StreamViewerView.h
//  Shiver
//
//  Created by Bryan Veloso on 2/21/14.
//  Copyright (c) 2014 Revyver, Inc. All rights reserved.
//

#import "RBLView.h"

@interface StreamViewerView : RBLView

@property (weak) IBOutlet NSButton *followButton;
@property (weak) IBOutlet NSButton *profileButton;
@property (weak) IBOutlet NSButton *reloadButton;
@property (weak) IBOutlet NSButton *playPauseButton;
@property (weak) IBOutlet NSButton *muteButton;
@property (weak) IBOutlet NSImageView *logo;
@property (weak) IBOutlet NSTextField *broadcastLabel;
@property (weak) IBOutlet NSTextField *liveSinceLabel;
@property (weak) IBOutlet NSTextField *statusLabel;
@property (weak) IBOutlet NSSlider *volumeSlider;

- (NSAttributedString *)attributedStatusWithString:(NSString *)string;

@end
