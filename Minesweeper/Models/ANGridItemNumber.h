//
//  ANGridItemNumber.h
//  Minesweeper
//
//  Created by Sergey Demchenko on 1/10/14.
//  Copyright (c) 2014 antrix1989@gmail.com. All rights reserved.
//

#import "ANGridItem.h"

/**
 Represents a grid item model that holds the number of adjacent (including diagonals) ANGridItemMine models.
 */
@interface ANGridItemNumber : ANGridItem

/**
 Nubmber of this grid item.
 */
@property (assign, nonatomic) NSUInteger number;

/**
 Initialize a ANGridItemNumber with specified number.
 @param number Nubmber of this grid item.
 @return ANGridItemNumber object.
 */
- (id)initWithNumber:(NSUInteger)number;

@end
