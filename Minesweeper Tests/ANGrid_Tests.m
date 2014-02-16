//
//  Minesweeper_Tests.m
//  Minesweeper Tests
//
//  Created by Sergey Demchenko on 2/16/14.
//  Copyright (c) 2014 antrix1989@gmail.com. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "ANGrid.h"
#import "ANGridItemNumber.h"

@interface ANGrid_Tests : XCTestCase

@property (nonatomic) ANGrid *grid;

@end

@implementation ANGrid_Tests

- (void)setUp
{
    [super setUp];
    
    self.grid = [[ANGrid alloc] initWithColumnsCount:4 andRowsCount:7];
}

- (void)tearDown
{
    self.grid = nil;
    
    [super tearDown];
}

- (void)test_initWithColumnsCountAndRowsCount_creates_valid_grid_items_count
{
    XCTAssertEqual(28ul, self.grid.items.count);
}

- (void)test_initWithColumnsCountAndRowsCount_fills_grid_with_ANGridItemNumber_by_default
{
    for (id gridItem in self.grid.items) {
        XCTAssertEqual(ANGridItemNumber.class, [gridItem class]);
    }
}

- (void)test_initWithColumnsCountAndRowsCount_fills_grid_with_zero_ANGridItemNumber_by_default
{
    for (ANGridItemNumber *gridItem in self.grid.items) {
        XCTAssertEqual(0ul, gridItem.number);
    }
}

- (void)test_columnsCount_returns_valid_count
{
    XCTAssertEqual(4l, self.grid.columnsCount);
}

- (void)test_rowsCount_returns_valid_count
{
    XCTAssertEqual(7l, self.grid.rowsCount);
}

- (void)test_setGridItemAtIndexPath_sets_value_at_expected_position
{
    self.grid = [[ANGrid alloc] initWithColumnsCount:4 andRowsCount:4];
    
    ANGridItemNumber *number = [[ANGridItemNumber alloc] initWithNumber:7];
    NSIndexPath *gridIndexPath = [NSIndexPath indexPathForGridRow:2 inGridColumn:1];
    
    [self.grid setGridItem:number atIndexPath:gridIndexPath];
    
    XCTAssertEqualObjects(number, [self.grid.items objectAtIndex:9]); // position = 2 * 4 + 1
}

@end
