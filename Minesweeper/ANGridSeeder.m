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

const NSUInteger kMinesCount = 8;

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

- (void)seedGrid:(ANGrid *)grid
{
    [self seedMines:grid];
    [self seedNumbers:grid];
}

#pragma mark - Private

- (void)seedMines:(ANGrid *)grid
{
    NSMutableArray *mineIndexes = [NSMutableArray new];
    
    while (mineIndexes.count < kMinesCount) {
        NSNumber *randomIndex = [NSNumber numberWithInt:arc4random_uniform(grid.items.count)];
        
        BOOL randomIndexAlreadyExists = CFArrayContainsValue ((__bridge CFArrayRef)mineIndexes, CFRangeMake(0, mineIndexes.count), (CFNumberRef)randomIndex);
        
        if (randomIndexAlreadyExists) {
            continue;
        }
        
        [mineIndexes addObject:randomIndex];
    }
    
    for (NSNumber *mineIndex in mineIndexes) {
        [grid.items replaceObjectAtIndex:[mineIndex intValue] withObject:[ANGridItemMine new]];
    }
}

- (void)seedNumbers:(ANGrid *)grid
{
    for (NSInteger rowIndex = 0; rowIndex < grid.rowsCount; rowIndex++) {
        for (NSInteger sectionIndex = 0; sectionIndex < grid.sectionsCount; sectionIndex++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
            
            ANGridItem *gridItem = [grid gridItemAtIndexPath:indexPath];
            
            if ([gridItem isKindOfClass:[ANGridItemNumber class]]) {
                NSArray *adjacentItems = [grid adjacentGridItemsForItemAtIndexPath:indexPath];
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
