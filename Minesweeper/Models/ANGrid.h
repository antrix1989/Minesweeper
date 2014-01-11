//
//  ANGrid.h
//  Minesweeper
//
//  Created by Sergey Demchenko on 1/10/14.
//  Copyright (c) 2014 antrix1989@gmail.com. All rights reserved.
//

@class ANGridItem;

/**
 Represents a grid model that holds all grid items.
 */
@interface ANGrid : NSObject

/**
 Array of grid items.
 */
@property (strong, nonatomic) NSMutableArray *items;

/**
 Count of the secions in the grid.
 */
@property(assign, nonatomic, readonly) NSInteger sectionsCount;

/**
 Count of the rows in the grid.
 */
@property(assign, nonatomic, readonly) NSInteger rowsCount;

/**
 Initialize a grid with specified size. By default items are ANGridItemNumber with 0 value.
 @param rowsCount Height of the grid.
 @param sectionsCount Width of the grid.
 @return ANGrid object.
 */
- (id)initWithRowsCount:(NSInteger)rowsCount andSectionsCount:(NSInteger)sectionsCount;

/**
 Returns grid item at index path.
 @return ANGridItem at specified index path.
 */
- (ANGridItem *)gridItemAtIndexPath:(NSIndexPath *)indexPath;

/**
 Sets grid item at index path.
 @param gridItem New gridItem object.
 @param indexPath Path where object should be replaced.
 */
- (void)setGridItem:(ANGridItem *)gridItem atIndexPath:(NSIndexPath *)indexPath;

/**
 Returns adjacent (including diagonals) grid items for item at index path.
 @param indexPath Path of the item.
 @return NSArray of the adjacent ANGridItem.
 */
- (NSArray *)adjacentGridItemsForItemAtIndexPath:(NSIndexPath *)indexPath;

/**
 Returns adjacent (including diagonals) indexes for item at index path.
 @param indexPath Path of the item.
 @return NSArray of the adjacent indexes.
 */
- (NSArray *)adjacentIndexesForItemAtIndexPath:(NSIndexPath *)indexPath;

@end
