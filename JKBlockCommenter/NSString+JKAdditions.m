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
    
    NSRegularExpression *expression = [[NSRegularExpression alloc] initWithPattern:@"^\\s*" options:0 error:NULL];
    NSRange range = [expression rangeOfFirstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
    NSString *leadingSpaces = [self substringWithRange:range];
    leadingSpaces = leadingSpaces.length ? leadingSpaces : @"";
    
    expression = [[NSRegularExpression alloc] initWithPattern:@"\\s*$" options:0 error:NULL];
    range = [expression rangeOfFirstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
    NSString *trailingSpaces = [self substringWithRange:range];
    trailingSpaces = trailingSpaces.length ? trailingSpaces : @"";
    NSString *trimmedString = [self jk_trimmedString];

    return [NSString stringWithFormat:@"%@/*%@*/%@",leadingSpaces,trimmedString,trailingSpaces];
}

- (NSString *)jk_commentRemovedString{
    NSString *trimmedString = [self jk_trimmedString];
    if ([trimmedString jk_isAcomment]) {
        NSRegularExpression *expression = [[NSRegularExpression alloc] initWithPattern:@"^\\s*" options:0 error:NULL];
        NSRange range = [expression rangeOfFirstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
        NSString *leadingSpaces = [self substringWithRange:range];
        leadingSpaces = leadingSpaces.length ? leadingSpaces : @"";
        
        expression = [[NSRegularExpression alloc] initWithPattern:@"\\s*$" options:0 error:NULL];
        range = [expression rangeOfFirstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
        NSString *trailingSpaces = [self substringWithRange:range];
        trailingSpaces = trailingSpaces.length ? trailingSpaces : @"";
        NSString *trimmedString = [self jk_trimmedString];
        NSString *uncommentedCode = [trimmedString substringWithRange:NSMakeRange(2, trimmedString.length - 4)];
        return [NSString stringWithFormat:@"%@%@%@",leadingSpaces,uncommentedCode,trailingSpaces];
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
