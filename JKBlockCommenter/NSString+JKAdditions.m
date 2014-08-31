//
//  NSString+JKAdditions.m
//  JKBlockCommenter
//
//  Created by Johnykutty on 31/08/14.
//  Copyright (c) 2014 Johnykutty. All rights reserved.
//

#import "NSString+JKAdditions.h"

@implementation NSString (JKAdditions)

- (NSString *)jk_commentedString{
    NSString *trimmedString = [self jk_trimmedString];
    return [NSString stringWithFormat:@"/* %@ */",trimmedString];
}

- (NSString *)jk_commentremovedString{
    NSString *trimmedString = [self jk_trimmedString];
    if ([trimmedString jk_isAcomment]) {
        return [trimmedString substringWithRange:NSMakeRange(2, trimmedString.length - 4)];
    }
    return self;
}

- (BOOL)jk_isAcomment{
    NSString *trimmedString = [self jk_trimmedString];
    if (self.length < 4) {
        return NO;
    }
    NSString *startString = [trimmedString substringToIndex:2];
    NSString *endString = [trimmedString substringFromIndex:trimmedString.length - 2];
    return [startString isEqualToString:@"/*"] && [endString isEqualToString:@"*/"];
}

- (NSString *)jk_trimmedString{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
@end
