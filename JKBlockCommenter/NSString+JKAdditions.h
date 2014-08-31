//
//  NSString+JKAdditions.h
//  JKBlockCommenter
//
//  Created by Johnykutty on 31/08/14.
//  Copyright (c) 2014 Johnykutty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JKAdditions)

- (NSString *)jk_commentedString;
- (NSString *)jk_commentremovedString;
- (BOOL)jk_isAcomment;
@end
