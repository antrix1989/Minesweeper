//
//  ANGridValidator.m
//  Minesweeper
//
//  Created by Sergey Demchenko on 1/11/14.
//  Copyright (c) 2014 antrix1989@gmail.com. All rights reserved.
//

#import "ANGridValidator.h"
#import "ANGrid.h"
#import "ANGridItem.h"
#import "ANGridItemNumber.h"

@implementation ANGridValidator

#pragma mark - NSObject

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

#pragma mark - Public

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[super allocWithZone:nil] init];
    });
    
    return sharedInstance;
}

- (BOOL)isGridContainsUnselecteNumberItems:(ANGrid *)grid
{
    BOOL result = NO;
    
    for (ANGridItem *item in grid.items) {
        if ([item isKindOfClass:ANGridItemNumber.class]) {
            NSIndexPath *indexPath = [grid indexPathOfGridItem:item];
            
            if (![grid isItemAtIndexPathSelected:indexPath]) {
                return YES;
            }
        }
    }
    
    return result;
}

@end
