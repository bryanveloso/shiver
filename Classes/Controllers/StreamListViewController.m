//
//  StreamViewController.m
//  Shiver
//
//  Created by Bryan Veloso on 6/8/13.
//  Copyright (c) 2013 Revyver, Inc. All rights reserved.
//

#import "StreamListViewController.h"

#import "Channel.h"
#import "NSColor+Hex.h"
#import "OAuthViewController.h"
#import "PXListViewDelegate.h"
#import "PXListView.h"
#import "Stream.h"
#import "StreamListViewCell.h"
#import "WindowController.h"

@interface StreamListViewController () {
@private
    dispatch_source_t _timer;
}

- (NSSet *)compareExistingStreamList:(NSArray *)existingArray withNewList:(NSArray *)newArray;
- (void)sendNewStreamNotificationToUser:(NSSet *)newSet;
@end

@implementation StreamListViewController

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestStreamListRefresh:) name:RequestToUpdateStreamNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDisconnectedAccount:) name:UserDidDisconnectAccountNotification object:nil];

    NSUserNotificationCenter *center = [NSUserNotificationCenter defaultUserNotificationCenter];
    [center setDelegate:self];

    [self.listView setCellSpacing:0];
    [self.listView setAllowsEmptySelection:YES];
    [self.listView setAllowsMultipleSelection:YES];
    [self loadStreamList];
    [self startTimerForLoadingStreamList];
}

#pragma mark - Data Source Methods

- (void)startTimerForLoadingStreamList
{
    // Schedule a timer to run `loadStreamList` every 5 minutes (300 seconds).
    // Keep a strong reference to _timer in ARC.
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 300.0 * NSEC_PER_SEC, 1.0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{ [self loadStreamList]; });
    dispatch_resume(_timer);
}

- (void)loadStreamList
{
    [Stream streamListWithBlock:^(NSArray *streams, NSError *error) {
        if (error) { NSLog(@"%@", [error localizedDescription]); }

        // If we've fetched streams before, compared the existing list to the
        // newly fetched one to check for any new broadcasts. If so, send those
        // streams to the notification center.
        if (self.streamArray != nil) {
            NSSet *newBroadcasts = [self compareExistingStreamList:self.streamArray withNewList:streams];
            [self sendNewStreamNotificationToUser:newBroadcasts];
        }

        self.streamArray = streams;

        // Reload the listView and send a notification that the list was
        // reloaded so other parts of the application can update their UIs.
        [self.listView reloadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:StreamListWasUpdatedNotification object:self userInfo:nil];
    }];
}

- (NSSet *)compareExistingStreamList:(NSArray *)existingArray withNewList:(NSArray *)newArray
{
    // Take the `_id` value of each stream in the existing array subtract those
    // that exist in the recently fetched array. Notifications will be sent for
    // the results.
    NSSet *existingStreamSet = [NSSet setWithArray:existingArray];
    NSSet *existingStreamSetIDs = [existingStreamSet valueForKey:@"_id"];
    NSSet *newStreamSet = [NSSet setWithArray:newArray];
    NSSet *xorSet = [newStreamSet filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"NOT _id IN %@", existingStreamSetIDs]];
    return xorSet;
}

#pragma mark - NSUserNotificationCenter Methods

- (void)sendNewStreamNotificationToUser:(NSSet *)newSet
{
    NSUserNotificationCenter *center = [NSUserNotificationCenter defaultUserNotificationCenter];
    for (Stream *stream in newSet) {
        NSUserNotification *notification = [[NSUserNotification alloc] init];
        [notification setTitle:[NSString stringWithFormat:@"%@ is now live!", stream.channel.displayName]];
        [notification setSubtitle:[NSString stringWithFormat:@"%@", stream.game]];
        [notification setInformativeText:stream.channel.status];
        [notification setSoundName:NSUserNotificationDefaultSoundName];
        [notification setUserInfo:@{ @"URL": [stream.channel.url absoluteString] }];

        // Beam it up, Scotty!
        [center deliverNotification:notification];
    }
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification
{
    return YES;
}

- (void)userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *)notification {
    if ([notification activationType] == NSUserNotificationActivationTypeContentsClicked) {
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[notification userInfo][@"URL"]]];
    }
}

#pragma mark - ListView Methods

- (PXListViewCell *)listView:(PXListView *)aListView cellForRow:(NSUInteger)row
{
    StreamListViewCell *cell = (StreamListViewCell *)[aListView dequeueCellWithReusableIdentifier:@"Cell"];
    if (!cell) {
        cell = [StreamListViewCell cellLoadedFromNibNamed:@"StreamListViewCell" bundle:nil reusableIdentifier:@"Cell"];
    }

    // Set up our new cell.
    Stream *stream = [self.streamArray objectAtIndex:row];
    [cell setStream:stream];

    [[cell streamPreview] setImage:[[NSImage alloc] initWithContentsOfURL:stream.previewImageURL]];
    [[cell streamLogo] setImage:[[NSImage alloc] initWithContentsOfURL:stream.channel.logoImageURL]];

    NSMutableAttributedString *attrStreamTitle = [[NSMutableAttributedString alloc] initWithString:stream.channel.status];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    [style setMaximumLineHeight:14];
    [attrStreamTitle addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, [attrStreamTitle length])];
    [[cell streamTitleLabel] setAttributedStringValue:attrStreamTitle];

    [[cell streamUserLabel] setStringValue:stream.channel.displayName];
    [[cell streamUserLabel] setTextColor:[NSColor colorWithHex:@"#4A4A4A"]];

    [[cell streamGameLabel] setStringValue:stream.game];
    [[cell streamGameLabel] setTextColor:[NSColor colorWithHex:@"#9D9D9E"]];

    [[cell streamViewerCountLabel] setStringValue:[NSString stringWithFormat:@"%@", stream.viewers]];

    return cell;
}

- (CGFloat)listView:(PXListView *)aListView heightOfRow:(NSUInteger)row
{
    return 115;
}

- (NSUInteger)numberOfRowsInListView:(PXListView *)aListView
{
    return [self.streamArray count];
}

#pragma mark Notification Observers

- (void)requestStreamListRefresh:(NSNotification *)notification
{
    WindowController *object = [notification object];
    if ([object isKindOfClass:[WindowController class]]) {
        [self loadStreamList];
    }
}

- (void)userDisconnectedAccount:(NSNotification *)notification
{
    OAuthViewController *object = [notification object];
    if ([object isKindOfClass:[OAuthViewController class]]) {
        // Ah, don't forget we have a timer. We should stop it.
        dispatch_source_cancel(_timer);
    }
}

@end
