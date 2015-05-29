//
//  Jumper.m
//  Jumper
//
//  Created by Deszip on 09.01.14.
//  Copyright (c) 2014 Alterplay. All rights reserved.
//

#import "Jumper.h"

static Jumper *sharedPlugin;

@interface Jumper()

@property (nonatomic, strong) NSBundle *bundle;

- (void)goUp;
- (void)goDown;

@end

@implementation Jumper

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[self alloc] initWithBundle:plugin];
        });
    }
}

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init]) {
        self.bundle = plugin;
        
        dispatch_async(dispatch_get_main_queue(), ^{
        NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
            if (menuItem) {
                [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
                
                NSString *moveUpTitle = [NSString stringWithFormat:@"%i lines up", kMovementStep];
                NSMenuItem *upActionMenuItem = [[NSMenuItem alloc] initWithTitle:moveUpTitle action:@selector(goUp) keyEquivalent:@""];
                unichar upArrowKey = NSUpArrowFunctionKey;
                [upActionMenuItem setKeyEquivalent:[NSString stringWithCharacters:&upArrowKey length:1]];
                [upActionMenuItem setKeyEquivalentModifierMask:kModifierKey];
                [upActionMenuItem setTarget:self];
                [[menuItem submenu] addItem:upActionMenuItem];

                NSString *moveDownTitle = [NSString stringWithFormat:@"%i lines down", kMovementStep];
                NSMenuItem *downActionMenuItem = [[NSMenuItem alloc] initWithTitle:moveDownTitle action:@selector(goDown) keyEquivalent:@""];
                unichar downArrowKey = NSDownArrowFunctionKey;
                [downActionMenuItem setKeyEquivalent:[NSString stringWithCharacters:&downArrowKey length:1]];
                [downActionMenuItem setKeyEquivalentModifierMask:kModifierKey];
                [downActionMenuItem setTarget:self];
                [[menuItem submenu] addItem:downActionMenuItem];
            }
        });
    }

    return self;
}

- (void)goUp
{
    for (NSUInteger i = 0; i < kMovementStep; i++) {
        [[[[NSApplication sharedApplication] keyWindow] firstResponder] moveUp:self];
    }
}

- (void)goDown
{
    for (NSUInteger i = 0; i < kMovementStep; i++) {
        [[[[NSApplication sharedApplication] keyWindow] firstResponder] moveDown:self];
    }
}

@end