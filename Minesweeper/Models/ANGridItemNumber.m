//
//  ANGridItemNumber.m
//  Minesweeper
//
//  Created by Sergey Demchenko on 1/10/14.
//  Copyright (c) 2014 antrix1989@gmail.com. All rights reserved.
//

#import "ANGridItemNumber.h"

@implementation ANGridItemNumber

#pragma mark - NSObject

- (id)init
{
    self = [super init];
    
    if (self) {
        _number = 0;
    }
    
    return self;
}

- (id)initWithNumber:(NSUInteger)number
{
    self = [self init];
    
    if (self) {
        _number = number;
    }
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%d", self.number];
}

@end
