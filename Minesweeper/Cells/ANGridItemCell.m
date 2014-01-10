//
//  ANGridItemCell.m
//  Minesweeper
//
//  Created by Sergey Demchenko on 1/11/14.
//  Copyright (c) 2014 antrix1989@gmail.com. All rights reserved.
//

#import "ANGridItemCell.h"
#import "ANGridItem.h"

@interface ANGridItemCell ()

@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end

@implementation ANGridItemCell

#pragma mark - Public

- (void)setGridItem:(ANGridItem *)gridItem
{
    _gridItem = gridItem;
    
    self.valueLabel.text = _gridItem.description;
}

- (void)showValue:(BOOL)show
{
    self.valueLabel.hidden = !show;
}

@end
