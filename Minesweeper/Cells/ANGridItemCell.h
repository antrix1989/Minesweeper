//
//  ANGridItemCell.h
//  Minesweeper
//
//  Created by Sergey Demchenko on 1/11/14.
//  Copyright (c) 2014 antrix1989@gmail.com. All rights reserved.
//

@class ANGridItem;

/**
 Represents cell which shows text value of the grid item.
 */
@interface ANGridItemCell : UICollectionViewCell

/**
 Value of the cell.
 */
@property (strong, nonatomic) ANGridItem *gridItem;

/**
 Show or hides value of the grid item.
 @param show Boolean value that indicates show or hide value.
 */
- (void)showValue:(BOOL)show;

@end
