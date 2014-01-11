//
//  ANGridValidator.h
//  Minesweeper
//
//  Created by Sergey Demchenko on 1/11/14.
//  Copyright (c) 2014 antrix1989@gmail.com. All rights reserved.
//

@class ANGrid;

/**
 Manager that checks are all cells not containing mines have been tapped on a grid.
 */
@interface ANGridValidator : NSObject

/**
 Returns the ANGridValidator sharedInstance.
 @return ANGridValidator Shared Instance Singleton.
 */
+ (instancetype)sharedInstance;

/**
 Checks if grid contains unselected number items.
 @param grid which will be validated.
 @return YES if grid contains unselected items, otherwise NO. 
 */
- (BOOL)isGridContainsUnselecteNumberItems:(ANGrid *)grid;

@end
