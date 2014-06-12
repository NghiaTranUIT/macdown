//
//  NSString+Lookup.m
//  MacDown
//
//  Created by Tzu-ping Chung  on 11/06/2014.
//  Copyright (c) 2014 Tzu-ping Chung . All rights reserved.
//

#import "NSString+Lookup.h"
#import "MPUtilities.h"


@implementation NSString (Lookup)

- (NSInteger)locationOfFirstNewlineBefore:(NSUInteger)location
{
    NSUInteger length = self.length;
    if (location > length)
        location = length;
    NSInteger p = location - 1;
    while (p >= 0 && !MPCharacterIsNewline([self characterAtIndex:p]))
        p--;
    return p;
}

- (NSUInteger)locationOfFirstNewlineAfter:(NSUInteger)location
{
    NSUInteger length = self.length;
    if (location >= length)
        return length;
    NSInteger p = location + 1;
    while (p < length && !MPCharacterIsNewline([self characterAtIndex:p]))
        p++;
    return p;
}

- (NSUInteger)locationOfFirstNonWhitespaceCharacterInLineBefore:(NSUInteger)loc
{
    NSInteger p = [self locationOfFirstNewlineBefore:loc] + 1;
    NSUInteger length = self.length;
    if (loc > length)
        loc = length;
    while (p < loc && MPCharacterIsWhitespace([self characterAtIndex:p]))
        p++;
    return p;
}

- (NSString *)titleString
{
    NSString *pattern = @"\\s+(\\S.*)$";

    // Try to find the highest ranked title.
    for (NSUInteger i = 0; i < 6; i++)
    {
        pattern = [@"#" stringByAppendingString:pattern];
        NSString *p = [NSString stringWithFormat:@"%@%@", @"^", pattern];
        NSRegularExpressionOptions opt = NSRegularExpressionAnchorsMatchLines;
        NSRegularExpression *regex =
            [[NSRegularExpression alloc] initWithPattern:p options:opt
                                                   error:NULL];
        NSTextCheckingResult *result =
            [regex firstMatchInString:self options:0
                                range:NSMakeRange(0, self.length)];
        if (result)
        {
            NSString *title = [self substringWithRange:[result rangeAtIndex:1]];
            return title;
        }
    }
    return nil;
}

@end