//
//  TitleView.h
//  Shiver
//
//  Created by Bryan Veloso on 2/21/14.
//  Copyright (c) 2014 Revyver, Inc. All rights reserved.
//

#import "RBLView.h"

@interface TitleView : RBLView

@property (nonatomic, assign) BOOL isActive;

@property (nonatomic, weak) IBOutlet NSButton *closeButton;
@property (nonatomic, weak) IBOutlet NSTextField *gameLabel;
@property (nonatomic, weak) IBOutlet NSTextField *viewersLabel;

- (NSAttributedString *)attributedStringWithName:(NSString *)name;
- (NSAttributedString *)attributedStringWithName:(NSString *)name game:(NSString *)game;
- (NSAttributedString *)attributedViewersWithNumber:(NSNumber *)number;

@end
