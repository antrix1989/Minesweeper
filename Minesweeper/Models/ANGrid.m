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

- (id)initWithColumnsCount:(NSInteger)columnsCount andRowsCount:(NSInteger)rowsCount
{
    self = [super init];
    
    if (self) {
        _rowsCount = rowsCount;
        _columnsCount = columnsCount;
        
        NSInteger totalCount = _rowsCount * _columnsCount;
        
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
        for (NSInteger columnIndex = 0; columnIndex < self.columnsCount; columnIndex++) {
            
            ANGridItem *gridItem = [self gridItemAtIndexPath:[NSIndexPath indexPathForGridRow:rowIndex inGridColumn:columnIndex]];
            
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
        _columnsCount = [aDecoder decodeIntForKey:@"sectionsCount"];
        _items = [aDecoder decodeObjectForKey:@"items"];
        _selectedIndexes = [aDecoder decodeObjectForKey:@"selectedIndexes"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:(int)self.rowsCount forKey:@"rowsCount"];
    [aCoder encodeInt:(int)self.columnsCount forKey:@"sectionsCount"];
    [aCoder encodeObject:self.items forKey:@"items"];
    [aCoder encodeObject:self.selectedIndexes forKey:@"selectedIndexes"];
}

#pragma mark - Public

- (ANGridItem *)gridItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = self.columnsCount * indexPath.gridRow + indexPath.gridColumn;
    
    return [self.items objectAtIndex:index];
}

- (NSIndexPath *)indexPathOfGridItem:(ANGridItem *)gridItem
{
    NSUInteger index = [self.items indexOfObject:gridItem];
    
    NSInteger row = index / self.columnsCount;
    NSInteger column = index % self.columnsCount;
    
    return [NSIndexPath indexPathForGridRow:row inGridColumn:column];
}

- (void)setGridItem:(ANGridItem *)gridItem atIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = self.columnsCount * indexPath.gridRow + indexPath.gridColumn;
    
    [self.items replaceObjectAtIndex:index withObject:gridItem];
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
    
    if (indexPath.gridColumn > 0) {
        // Get left item.
        NSIndexPath *itemIndexPath = [NSIndexPath indexPathForGridRow:indexPath.gridRow inGridColumn:indexPath.gridColumn - 1];
        [result addObject:itemIndexPath];
    }
    
    if (indexPath.gridColumn < self.columnsCount - 1) {
        // Get right item.
        NSIndexPath *itemIndexPath = [NSIndexPath indexPathForGridRow:indexPath.gridRow inGridColumn:indexPath.gridColumn + 1];
        [result addObject:itemIndexPath];
    }
    
    if (indexPath.gridRow > 0) {
        // Get top item.
        NSIndexPath *itemIndexPath = [NSIndexPath indexPathForGridRow:indexPath.gridRow - 1 inGridColumn:indexPath.gridColumn];
        [result addObject:itemIndexPath];
    }
    
    if (indexPath.gridRow < self.rowsCount - 1) {
        // Get bottom item.
        NSIndexPath *itemIndexPath = [NSIndexPath indexPathForGridRow:indexPath.gridRow + 1 inGridColumn:indexPath.gridColumn];
        [result addObject:itemIndexPath];
    }
    
    if (indexPath.gridColumn > 0 && indexPath.gridRow > 0) {
        // Get top left item.
        NSIndexPath *itemIndexPath = [NSIndexPath indexPathForGridRow:indexPath.gridRow - 1 inGridColumn:indexPath.gridColumn - 1];
        [result addObject:itemIndexPath];
    }
    
    if (indexPath.gridColumn < self.columnsCount - 1 && indexPath.gridRow > 0) {
        // Get top right item.
        NSIndexPath *itemIndexPath = [NSIndexPath indexPathForGridRow:indexPath.gridRow - 1 inGridColumn:indexPath.gridColumn + 1];
        [result addObject:itemIndexPath];
    }
    
    if (indexPath.gridColumn > 0 && indexPath.gridRow < self.rowsCount - 1) {
        // Get bottom left item.
        NSIndexPath *itemIndexPath = [NSIndexPath indexPathForGridRow:indexPath.gridRow + 1 inGridColumn:indexPath.gridColumn - 1];
        [result addObject:itemIndexPath];
    }
    
    if (indexPath.gridColumn < self.columnsCount - 1 && indexPath.gridRow < self.rowsCount - 1) {
        // Get bottom right item.
        NSIndexPath *itemIndexPath = [NSIndexPath indexPathForGridRow:indexPath.gridRow + 1 inGridColumn:indexPath.gridColumn + 1];
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
    _columnsCount = loadedGrid.columnsCount;
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

#pragma mark - NSIndexPath (ANGrid)

@implementation NSIndexPath (ANGrid)

#pragma mark - Public

+ (NSIndexPath *)indexPathForGridRow:(NSInteger)gridRow inGridColumn:(NSInteger)gridColumn
{
    NSUInteger indexes[] = {gridColumn, gridRow};
    
    return [NSIndexPath indexPathWithIndexes:indexes length:(sizeof(indexes) / sizeof(NSUInteger))];
}

- (NSInteger)gridColumn
{
    return [self indexAtPosition:0];
}

- (NSInteger)gridRow
{
    return [self indexAtPosition:1];
}

@end
