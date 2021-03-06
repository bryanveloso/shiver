//
//  MainWindowController.m
//  Shiver
//
//  Created by Bryan Veloso on 2/7/14.
//  Copyright (c) 2014 Revyver, Inc. All rights reserved.
//

#import "INAppStoreWindow.h"
#import "StreamListViewController.h"
#import "StreamListViewModel.h"
#import "StreamViewModel.h"
#import "StreamViewerViewController.h"
#import "TitleView.h"
#import "UserViewModel.h"

#import "MainWindowController.h"

@interface MainWindowController () {
    IBOutlet NSView *_loginView;
    IBOutlet NSView *_masterView;
    IBOutlet NSView *_sidebarView;
    IBOutlet NSView *_userView;
}

@property (nonatomic, strong) NSView *errorView;
@property (nonatomic, strong) NSString *username;

@property (weak) IBOutlet NSImageView *avatar;
@property (weak) IBOutlet NSTextField *usernameLabel;
@property (weak) IBOutlet NSButton *loginButton;

@end

@implementation MainWindowController

@dynamic viewModel;

- (void)windowDidLoad
{
    [super windowDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestToOpenWindow:) name:RequestToOpenWindowNotification object:nil];

    [self initializeViewControllers];
    [self initializeInterface];
}

- (void)initializeViewControllers
{
    self.listViewModel = [[StreamListViewModel alloc] init];
    self.sidebarController = [[StreamListViewController alloc] initWithViewModel:self.listViewModel nibName:@"StreamListView" bundle:nil];
    [self.sidebarController.view setFrame:_sidebarView.bounds];
    [_sidebarView addSubview:self.sidebarController.view];

    StreamViewModel *streamViewModel = [[StreamViewModel alloc] init];
    self.viewerController = [[StreamViewerViewController alloc] initWithViewModel:streamViewModel nibName:@"StreamViewer" bundle:nil];
    [self setViewerController:self.viewerController];
    [self.viewerController.view setFrame:_viewer.bounds];
    [_viewer addSubview:self.viewerController.view];
}

- (void)initializeInterface
{
	INAppStoreWindow *window = (INAppStoreWindow *)[self window];
    [window setTitleBarHeight:38.0];
    [window setTrafficLightButtonsLeftMargin:12.0];
    [window setShowsBaselineSeparator:NO];

	NSView *titleBarView = window.titleBarView;
    [self.titleView setFrame:titleBarView.bounds];
    [self.titleView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    [titleBarView addSubview:self.titleView];
    [self.titleView addSubview:_loginView];
    [self.titleView setWantsLayer:YES];

    [[RACObserve(self, viewModel.isLoggedIn)
        deliverOn:[RACScheduler mainThreadScheduler]]
        subscribeNext:^(NSNumber *loggedIn) {
            BOOL isLoggedIn = [loggedIn boolValue];
            if (isLoggedIn) {
                [[self.titleView animator] replaceSubview:_loginView with:_userView];
            } else {
                if ([_userView superview] != nil) {
                    [[self.titleView animator] replaceSubview:_userView with:_loginView];
                }
            }
        }];

    [[self.usernameLabel cell] setBackgroundStyle:NSBackgroundStyleRaised];
    RAC(self, usernameLabel.stringValue, @"") = RACObserve(self, viewModel.name);
    RAC(self, avatar.image, nil) = [RACObserve(self, viewModel.logoImageURL)
        map:^id(NSURL *url) {
            return [[NSImage alloc] initWithContentsOfURL:url];
        }];
}

#pragma mark - Notification Observers

- (void)requestToOpenWindow:(NSNotification *)notification
{
    [NSApp activateIgnoringOtherApps:YES];
    [self.window makeKeyAndOrderFront:self];
}

#pragma mark - Interface Builder Actions

- (IBAction)login:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:RequestToOpenPreferencesNotification object:self userInfo:nil];
}

#pragma - NSWindowDelegate Methods

- (BOOL)windowShouldClose:(id)sender
{
    [self.window orderOut:self];
    return NO;
}

- (void)windowDidBecomeKey:(NSNotification *)notification
{
    DDLogVerbose(@"Displaying main window.");
}

- (void)windowDidResignKey:(NSNotification *)notification
{
    DDLogVerbose(@"Hiding main window.");
}

- (void)windowWillClose:(NSNotification *)notification
{
    DDLogVerbose(@"Closing main window.");
}

@end
