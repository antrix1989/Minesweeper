//
//  ANGridSeeder.h
//  Minesweeper
//
//  Created by Sergey Demchenko on 1/10/14.
//  Copyright (c) 2014 antrix1989@gmail.com. All rights reserved.
//

@class ANGrid;

/**
 Represents a manager that is resposible for seeding grid with mines and numbers.
 */
@interface ANGridSeeder : NSObject

/**
 Returns the ANGridSeeder sharedInstance.
 @return ANGridSeeder Shared Instance Singleton.
 */
+ (instancetype)sharedInstance;

/**
 Seeds grid with mines (ANGridItemMine) and numbers (ANGridItemNumber).
 @param grid which will be seeded.
 */
- (void)seedGrid:(ANGrid *)grid;

@end
