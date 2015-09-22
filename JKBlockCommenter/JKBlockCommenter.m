//
//  JKBlockCommenter.m
//  JKBlockCommenter
//
//  Created by Johnykutty on 29/08/14.
//    Copyright (c) 2014 Johnykutty. All rights reserved.
//

#import "JKBlockCommenter.h"
#import "NSString+JKAdditions.h"

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
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didApplicationFinishLaunchingNotification:)
                                                     name:NSApplicationDidFinishLaunchingNotification
                                                   object:nil];
    }
    return self;
}

- (void)didApplicationFinishLaunchingNotification:(NSNotification*)noti
{
    [self createMenu];
}

- (void)createMenu
{
    //removeObserver
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];
    
    NSMenuItem *editMenu = [[NSApp mainMenu] itemWithTitle:@"Edit"];
    if (editMenu) {
        NSString *menuTitle = @"Comment Selection With /* ... */";
        
        //Check whether already exists
        if ([[editMenu submenu] itemWithTitle:menuTitle]) {
            //no need to create again
            return;
        }
        [[editMenu submenu] addItem:[NSMenuItem separatorItem]];
        NSMenuItem *commentMenuItem = [[NSMenuItem alloc] initWithTitle:menuTitle action:@selector(commentOrUncomment) keyEquivalent:@"/"];
        [commentMenuItem setKeyEquivalentModifierMask:NSCommandKeyMask | NSAlternateKeyMask];
        [commentMenuItem setTarget:self];
        [[editMenu submenu] addItem:commentMenuItem];
    }
}

- (void) commentOrUncomment
{
    NSRange selectedRange = [self.activeTextView selectedRange];
    if (!selectedRange.length) {
        return;
    }
    NSMutableString *fullString = [[self.activeTextView string] mutableCopy];
    NSString *selectedString = [fullString substringWithRange:selectedRange];
    
    NSString *stringToReplace = [selectedString jk_isAcomment] ? [selectedString jk_commentRemovedString] : [selectedString jk_commentedString];
    
    if ([self.activeTextView shouldChangeTextInRange:selectedRange replacementString:stringToReplace]){
        [[self.activeTextView textStorage] beginEditing];
        [[self.activeTextView  textStorage] replaceCharactersInRange:selectedRange withString:stringToReplace];
        [[self.activeTextView textStorage] endEditing];
        [self.activeTextView didChangeText];
    }
}

- (NSTextView *)activeTextView{
    NSResponder *firstResponder = [[NSApp keyWindow] firstResponder];
    if ([firstResponder isKindOfClass:NSClassFromString(@"DVTSourceTextView")] && [firstResponder isKindOfClass:[NSTextView class]]) {
        _activeTextView = (NSTextView *)firstResponder;
    }
    return _activeTextView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
