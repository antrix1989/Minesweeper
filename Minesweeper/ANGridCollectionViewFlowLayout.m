//
//  ANGreedCollectionViewFlowLayout.m
//  Minesweeper
//
//  Created by Sergey Demchenko on 2/13/14.
//  Copyright (c) 2014 antrix1989@gmail.com. All rights reserved.
//

#import "ANGridCollectionViewFlowLayout.h"

@implementation ANGridCollectionViewFlowLayout

- (CGSize)collectionViewContentSize
{
    CGFloat width = [self.collectionView numberOfSections] * self.itemSize.width + ([self.collectionView numberOfSections] - 1) * self.spacing;
    CGFloat height = [self.collectionView numberOfItemsInSection:0] * self.itemSize.height + ([self.collectionView numberOfItemsInSection:0] - 1) * self.spacing;
    return CGSizeMake(width, height);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributesInRect = [NSMutableArray new];
    for (int sectionIndex = 0; sectionIndex < [self.collectionView numberOfSections]; sectionIndex++) {
        for (int itemInSectionIndex = 0; itemInSectionIndex < [self.collectionView numberOfItemsInSection:sectionIndex]; itemInSectionIndex++)
        [attributesInRect addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:itemInSectionIndex inSection:sectionIndex]]];
    }
    return attributesInRect;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    // If there is free space - increase width to max integer possible value and center grid inside collection view.
    NSUInteger size = (self.collectionView.frame.size.width - [self.collectionView numberOfSections] * self.spacing) / [self.collectionView numberOfSections];
    
    CGFloat widthOffset = 0;
    
    if (size < self.itemSize.width) {
        size = self.itemSize.width;
    } else {
        widthOffset = (self.collectionView.frame.size.width - (size * [self.collectionView numberOfSections] + [self.collectionView numberOfSections] * self.spacing)) / 2.0;
    }
    
    attributes.frame = CGRectMake(size * indexPath.section + self.spacing * indexPath.section + widthOffset,
                                  size * indexPath.item + self.spacing * indexPath.item,
                                  size,
                                  size);
    
    return attributes;
}


@end
