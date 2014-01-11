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
@interface ANGrid : NSObject <NSCoding>

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
 Returns index path of the grid item.
 @return NSIndexPath of specified grid item.
 */
- (NSIndexPath *)indexPathOfGridItem:(ANGridItem *)gridItem;

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

/**
 Selects grid item at index path.
 @param indexPath Path of the item.
 */
- (void)selectItemAtIndexPath:(NSIndexPath *)indexPath;

/**
 Checks is item at index path selected or not.
 @param indexPath Path of the item.
 @return BOOL is item selected or not.
 */
- (BOOL)isItemAtIndexPathSelected:(NSIndexPath *)indexPath;

/**
 Saves grid to file systme.
 @return BOOL YES if grid was saved, NO otherwise.
 */
- (BOOL)save;

/**
 Load grid from file systme.
 @return BOOL YES if grid was loaded, NO otherwise.
 */
- (BOOL)load;

@end
