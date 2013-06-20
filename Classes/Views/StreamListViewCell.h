//
//  StreamListViewCell.h
//  Shiver
//
//  Created by Bryan Veloso on 6/8/13.
//  Copyright (c) 2013 Revyver, Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "Stream.h"
#import "StreamLogoImageView.h"
#import "StreamPreviewImageView.h"
#import "PXListViewCell.h"

@interface StreamListViewCell : PXListViewCell

@property (nonatomic, strong) Stream *stream;

@property (weak) IBOutlet StreamLogoImageView *streamLogo;
@property (weak) IBOutlet StreamPreviewImageView *streamPreview;

@property (weak) IBOutlet NSTextField *streamGameLabel;
@property (weak) IBOutlet NSTextField *streamUserLabel;
@property (weak) IBOutlet NSTextField *streamTitleLabel;
@property (weak) IBOutlet NSTextField *streamViewerCountLabel;
@property (weak) IBOutlet NSButton *streamRedirectButton;

- (IBAction)redirectToStream:(id)sender;
@end
