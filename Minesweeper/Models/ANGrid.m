//
//  ANGrid.m
//  Minesweeper
//
//  Created by Sergey Demchenko on 1/10/14.
//  Copyright (c) 2014 antrix1989@gmail.com. All rights reserved.
//

#import "ANGrid.h"
#import "ANGridItemNumber.h"

@interface ANGrid ()

@property (strong, nonatomic) NSMutableArray *selectedIndexes;

@end

@implementation ANGrid

#pragma mark - NSObject

- (id)initWithRowsCount:(NSInteger)rowsCount andSectionsCount:(NSInteger)sectionsCount
{
    self = [super init];
    
    if (self) {
        _rowsCount = rowsCount;
        _sectionsCount = sectionsCount;
        
        NSInteger totalCount = _rowsCount * _sectionsCount;
        
        _items = [[NSMutableArray alloc] initWithCapacity:totalCount];
        
        for (NSInteger i = 0; i < totalCount; i++) {
            [_items addObject:[ANGridItemNumber new]];
        }
        
        self.selectedIndexes = [NSMutableArray new];
    }
    
    return self;
}

- (NSString *)description
{
    NSString *result = [NSString stringWithFormat:@"<%@: %p>\n", self.class, self];
    
    for (NSInteger rowIndex = 0; rowIndex < self.rowsCount; rowIndex++) {
        NSString *rowString = @"|";
        for (NSInteger sectionIndex = 0; sectionIndex < self.sectionsCount; sectionIndex++) {
            
            ANGridItem *gridItem = [self gridItemAtIndexPath:[NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex]];
            
            rowString = [rowString stringByAppendingString:[NSString stringWithFormat:@" %@ ", gridItem]];
            
        }
        rowString = [rowString stringByAppendingString:@"|\n"];
        
        result = [result stringByAppendingString:rowString];
    }
    
    return result;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _rowsCount = [aDecoder decodeIntForKey:@"rowsCount"];
        _sectionsCount = [aDecoder decodeIntForKey:@"sectionsCount"];
        _items = [aDecoder decodeObjectForKey:@"items"];
        _selectedIndexes = [aDecoder decodeObjectForKey:@"selectedIndexes"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:self.rowsCount forKey:@"rowsCount"];
    [aCoder encodeInt:self.sectionsCount forKey:@"sectionsCount"];
    [aCoder encodeObject:self.items forKey:@"items"];
    [aCoder encodeObject:self.selectedIndexes forKey:@"selectedIndexes"];
}

#pragma mark - Public

- (ANGridItem *)gridItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = self.sectionsCount * indexPath.row + indexPath.section;
    
    return [self.items objectAtIndex:index];
}

- (NSIndexPath *)indexPathOfGridItem:(ANGridItem *)gridItem
{
    NSUInteger index = [self.items indexOfObject:gridItem];
    
    NSInteger row = index / self.sectionsCount;
    NSInteger section = index % self.sectionsCount;
    
    return [NSIndexPath indexPathForRow:row inSection:section];
}

- (void)setGridItem:(ANGridItem *)gridItem atIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = self.sectionsCount * indexPath.row + indexPath.section;
    
    [_items replaceObjectAtIndex:index withObject:gridItem];
}

- (NSArray *)adjacentGridItemsForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *result = [NSMutableArray new];
    
    for (NSIndexPath *adjacentItemIndexPath in [self adjacentIndexesForItemAtIndexPath:indexPath]) {
        [result addObject:[self gridItemAtIndexPath:adjacentItemIndexPath]];
    }
    
    return result;
}

- (NSArray *)adjacentIndexesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *result = [NSMutableArray new];
    
    if (indexPath.section > 0) {
        // Get left item.
        NSIndexPath *itemIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - 1];
        [result addObject:itemIndexPath];
    }
    
    if (indexPath.section < self.sectionsCount - 1) {
        // Get right item.
        NSIndexPath *itemIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section + 1];
        [result addObject:itemIndexPath];
    }
    
    if (indexPath.row > 0) {
        // Get top item.
        NSIndexPath *itemIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
        [result addObject:itemIndexPath];
    }
    
    if (indexPath.row < self.rowsCount - 1) {
        // Get bottom item.
        NSIndexPath *itemIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
        [result addObject:itemIndexPath];
    }
    
    if (indexPath.section > 0 && indexPath.row > 0) {
        // Get top left item.
        NSIndexPath *itemIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section - 1];
        [result addObject:itemIndexPath];
    }
    
    if (indexPath.section < self.sectionsCount - 1 && indexPath.row > 0) {
        // Get top right item.
        NSIndexPath *itemIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section + 1];
        [result addObject:itemIndexPath];
    }
    
    if (indexPath.section > 0 && indexPath.row < self.rowsCount - 1) {
        // Get bottom left item.
        NSIndexPath *itemIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section - 1];
        [result addObject:itemIndexPath];
    }
    
    if (indexPath.section < self.sectionsCount - 1 && indexPath.row < self.rowsCount - 1) {
        // Get bottom right item.
        NSIndexPath *itemIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section + 1];
        [result addObject:itemIndexPath];
    }
    
    return result;
}

- (void)selectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.selectedIndexes addObject:indexPath];
}

- (BOOL)isItemAtIndexPathSelected:(NSIndexPath *)indexPath
{
    return [self.selectedIndexes containsObject:indexPath];
}

- (BOOL)save;
{
    return [NSKeyedArchiver archiveRootObject:self toFile:[self archivePath]];
}

- (BOOL)load
{
    ANGrid *loadedGrid = [NSKeyedUnarchiver unarchiveObjectWithFile:[self archivePath]];
    
    self.selectedIndexes = loadedGrid.selectedIndexes;
    _rowsCount = loadedGrid.rowsCount;
    _sectionsCount = loadedGrid.sectionsCount;
    _items = loadedGrid.items;
    
    return loadedGrid != nil;
}

#pragma mark - Private

- (NSString *)archivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"grid.archive"];
}

@end
