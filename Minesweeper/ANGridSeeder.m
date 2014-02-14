//
//  ANGridSeeder.m
//  Minesweeper
//
//  Created by Sergey Demchenko on 1/10/14.
//  Copyright (c) 2014 antrix1989@gmail.com. All rights reserved.
//

#import "ANGridSeeder.h"
#import "ANGridItemMine.h"
#import "ANGridItemNumber.h"
#import "ANGrid.h"

@implementation ANGridSeeder

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

- (void)seedGrid:(ANGrid *)grid withMinesCount:(NSUInteger)minesCount;
{
    NSMutableArray *mineIndexes = [NSMutableArray new];
    
    while (mineIndexes.count < minesCount) {
        NSNumber *randomIndex = [NSNumber numberWithInt:arc4random_uniform((unsigned int)grid.items.count)];
        
        BOOL randomIndexAlreadyExists = [mineIndexes containsObject:randomIndex];
        
        if (randomIndexAlreadyExists) {
            continue;
        }
        
        [mineIndexes addObject:randomIndex];
    }
    
    for (NSNumber *mineIndex in mineIndexes) {
        [grid.items replaceObjectAtIndex:[mineIndex intValue] withObject:[ANGridItemMine new]];
    }

    [self seedNumbers:grid];
}

#pragma mark - Private

- (void)seedNumbers:(ANGrid *)grid
{
    for (NSInteger rowIndex = 0; rowIndex < grid.rowsCount; rowIndex++) {
        for (NSInteger columnIndex = 0; columnIndex < grid.columnsCount; columnIndex++) {
            
            NSIndexPath *gridIndexPath = [NSIndexPath indexPathForGridRow:rowIndex inGridColumn:columnIndex];
            
            ANGridItem *gridItem = [grid gridItemAtIndexPath:gridIndexPath];
            
            if ([gridItem isKindOfClass:[ANGridItemNumber class]]) {
                NSArray *adjacentItems = [grid adjacentGridItemsForItemAtIndexPath:gridIndexPath];
                NSUInteger number = 0;
                for (ANGridItem *adjacentItem in adjacentItems) {
                    if ([adjacentItem isKindOfClass:[ANGridItemMine class]]) {
                        number++;
                    }
                }
            
                ANGridItemNumber *numberItem = (ANGridItemNumber *)gridItem;
                numberItem.number = number;
            }
        }
    }
}

@end
