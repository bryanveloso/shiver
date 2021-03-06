//
//  Preferences.h
//  Shiver
//
//  Created by Bryan Veloso on 6/29/13.
//  Copyright (c) 2013 Revyver, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Preferences : NSObject

@property (nonatomic, assign) NSNumber *iconVisibility;
@property (nonatomic, assign) NSNumber *iconAction;
@property (nonatomic, assign) BOOL autoStartEnabled;
@property (nonatomic, assign) BOOL notificationsEnabled;
@property (nonatomic, assign) BOOL streamCountEnabled;
@property (nonatomic, assign) BOOL backgroundSoundEnabled;
@property (nonatomic, assign) NSNumber *streamListRefreshTime;

+ (Preferences *)sharedPreferences;
- (void)setupDefaults;

@end
