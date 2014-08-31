//
//  JKBlockCommenter.m
//  JKBlockCommenter
//
//  Created by Johnykutty on 29/08/14.
//    Copyright (c) 2014 Johnykutty. All rights reserved.
//

#import "JKBlockCommenter.h"

static JKBlockCommenter *sharedPlugin;

@interface JKBlockCommenter()
@property (nonatomic, strong) NSTextView *activeTextView;
@property (nonatomic, strong) NSBundle *bundle;
@end

@implementation JKBlockCommenter

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
        
        NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"File"];
        if (menuItem) {
            [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
            NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"Do Action" action:@selector(doMenuAction) keyEquivalent:@""];
            [actionMenuItem setTarget:self];
            [[menuItem submenu] addItem:actionMenuItem];
        }
    }
    return self;
}

// Sample Action, for menu item:
- (void)doMenuAction
{
    NSMutableString *fullString = [[self.activeTextView string] mutableCopy];
    NSRange selectedRange = [self.activeTextView selectedRange];
    NSString *selectedString = [fullString substringWithRange:selectedRange];
    
    NSString *stringToReplace = [NSString stringWithFormat:@"/* %@ */",selectedString];
    [fullString replaceCharactersInRange:selectedRange withString:stringToReplace];
    
    [self.activeTextView  setString:fullString];

}

- (NSTextView *)activeTextView{
    if (!_activeTextView) {
        NSResponder *firstResponder = [[NSApp keyWindow] firstResponder];
		if ([firstResponder isKindOfClass:NSClassFromString(@"DVTSourceTextView")] && [firstResponder isKindOfClass:[NSTextView class]]) {
			_activeTextView = (NSTextView *)firstResponder;
		}
    }
    return _activeTextView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
