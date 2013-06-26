//
//  StreamViewController.h
//  Shiver
//
//  Created by Bryan Veloso on 6/8/13.
//  Copyright (c) 2013 Revyver, Inc. All rights reserved.
//

#import "JAListView.h"

#import <Cocoa/Cocoa.h>

@interface StreamListViewController : NSViewController <NSUserNotificationCenterDelegate, JAListViewDataSource, JAListViewDelegate>

@property (nonatomic, strong, readonly) NSArray *streamArray;

- (id)initWithUser:(User *)user;

@end
