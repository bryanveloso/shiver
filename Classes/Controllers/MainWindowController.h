//
//  MainWindowController.h
//  Shiver
//
//  Created by Bryan Veloso on 2/7/14.
//  Copyright (c) 2014 Revyver, Inc. All rights reserved.
//


#import "SHWindowController.h"
#import "WindowViewModel.h"

@class StreamListViewController;
@class StreamViewerViewController;

@interface MainWindowController : SHWindowController <NSWindowDelegate>

@property (nonatomic, strong) StreamListViewController *sidebarController;
@property (nonatomic, strong) StreamViewerViewController *viewerController;
@property (nonatomic, strong, readonly) WindowViewModel *viewModel;

@property (weak) IBOutlet NSTextField *gameLabel;
@property (weak) IBOutlet NSTextField *viewersLabel;
@property (weak) IBOutlet NSView *titleView;
@property (weak) IBOutlet NSView *viewer;

@end
