//
//  Jumper.m
//  Jumper
//
//  Created by Deszip on 09.01.14.
//    Copyright (c) 2014 Alterplay. All rights reserved.
//

#import "Jumper.h"

static Jumper *sharedPlugin;

@interface Jumper()

@property (nonatomic, strong) NSBundle *bundle;

@end

@implementation Jumper

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static id sharedPlugin = nil;
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
        
        NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
        if (menuItem) {
            [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
            
            NSMenuItem *upActionMenuItem = [[NSMenuItem alloc] initWithTitle:@"10 lines up" action:@selector(goUp) keyEquivalent:@""];
            unichar upArrowKey = NSUpArrowFunctionKey;
            [upActionMenuItem setKeyEquivalent:[NSString stringWithCharacters:&upArrowKey length:1]];
            [upActionMenuItem setKeyEquivalentModifierMask:NSControlKeyMask];
            [upActionMenuItem setTarget:self];
            [[menuItem submenu] addItem:upActionMenuItem];
            
            NSMenuItem *downActionMenuItem = [[NSMenuItem alloc] initWithTitle:@"10 lines down" action:@selector(goDown) keyEquivalent:@""];
            unichar downArrowKey = NSDownArrowFunctionKey;
            [downActionMenuItem setKeyEquivalent:[NSString stringWithCharacters:&downArrowKey length:1]];
            [downActionMenuItem setKeyEquivalentModifierMask:NSControlKeyMask];
            [downActionMenuItem setTarget:self];
            [[menuItem submenu] addItem:downActionMenuItem];
        }
    }

    return self;
}

- (void)goUp
{
    //NSLog(@"First responder: %@", [[[NSApplication sharedApplication] keyWindow] firstResponder]);
    
    for (NSUInteger i = 0; i < 10; i++) {
        [[[[NSApplication sharedApplication] keyWindow] firstResponder] moveUp:self];
    }
}

- (void)goDown
{
    //NSLog(@"First responder: %@", [[[NSApplication sharedApplication] keyWindow] firstResponder]);

    for (NSUInteger i = 0; i < 10; i++) {
        [[[[NSApplication sharedApplication] keyWindow] firstResponder] moveDown:self];
    }
    
}

@end