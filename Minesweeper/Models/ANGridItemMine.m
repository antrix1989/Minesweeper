//
//  ANGridItemMine.m
//  Minesweeper
//
//  Created by Sergey Demchenko on 1/10/14.
//  Copyright (c) 2014 antrix1989@gmail.com. All rights reserved.
//

#import "ANGridItemMine.h"

@implementation ANGridItemMine

#pragma mark - NSObject

- (NSString *)description
{
    return @"M";
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
}

@end
