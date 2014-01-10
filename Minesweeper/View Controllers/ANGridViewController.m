//
//  ANGridViewController.m
//  Minesweeper
//
//  Created by Sergey Demchenko on 1/10/14.
//  Copyright (c) 2014 antrix1989@gmail.com. All rights reserved.
//

#import "ANGridViewController.h"
#import "ANGrid.h"
#import "ANGridSeeder.h"
#import "ANGridItemCell.h"
#import "ANGridItem.h"
#import "ANGridItemMine.h"

const NSUInteger kGridRowsCount = 8;
const NSUInteger kGridSectionsCount = 8;
const NSUInteger kGridCellsSeparatorWidht = 1;

static NSString *kGridItemCell = @"ANGridItemCell";

@interface ANGridViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *gridCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *showMinesButton;

@property (strong, nonatomic) ANGrid *grid;
@property (strong, nonatomic) NSMutableArray *selectedIndexes;
@property (assign, nonatomic) BOOL showMines;

- (IBAction)onShowMinesButtonTapped:(id)sender;

@end

@implementation ANGridViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.showMines = NO;
    
    self.selectedIndexes = [NSMutableArray new];
    
    [self.gridCollectionView registerNib:[UINib nibWithNibName:kGridItemCell bundle:nil] forCellWithReuseIdentifier:kGridItemCell];
    
    self.grid = [[ANGrid alloc] initWithRowsCount:kGridRowsCount andSectionsCount:kGridSectionsCount];
    
    NSLog(@"%@", self.grid);
    
    [[ANGridSeeder sharedInstance] seedGrid:self.grid];
    
    NSLog(@"%@", self.grid);
    
    [self.gridCollectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.grid.sectionsCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.grid.rowsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ANGridItemCell *gridItemCell = (ANGridItemCell *)[self.gridCollectionView dequeueReusableCellWithReuseIdentifier:kGridItemCell forIndexPath:indexPath];
    
    gridItemCell.gridItem = [self.grid gridItemAtIndexPath:indexPath];
    
    BOOL showValue = [self.selectedIndexes containsObject:indexPath];
    
    if ([gridItemCell.gridItem isKindOfClass:ANGridItemMine.class]) {
        [gridItemCell showValue:self.showMines];
    } else {
        [gridItemCell showValue:showValue];
    }
    
    return gridItemCell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.selectedIndexes addObject:indexPath];
    
    ANGridItemCell *gridItemCell = (ANGridItemCell *)[self.gridCollectionView cellForItemAtIndexPath:indexPath];
    [gridItemCell showValue:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger countOfSectionSepartors = kGridCellsSeparatorWidht * self.grid.sectionsCount - 1;
    
    CGFloat totalWidthSpaceForCells = self.gridCollectionView.frame.size.width - countOfSectionSepartors;
    
    CGFloat widthSpaceForCell = totalWidthSpaceForCells / self.grid.sectionsCount;
    
    return CGSizeMake(widthSpaceForCell, widthSpaceForCell);
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // Top, left, bottom, right.
    return UIEdgeInsetsMake(kGridCellsSeparatorWidht, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

#pragma mark - IBAction

- (IBAction)onShowMinesButtonTapped:(id)sender
{
    self.showMines = !self.showMines;
    
    [self.gridCollectionView reloadData];
}

#pragma mark - Private

- (void)setShowMines:(BOOL)showMines
{
    _showMines = showMines;
    
    NSString *title = showMines ? @"Hide Mines" : @"Show Mines";
    
    [self.showMinesButton setTitle:title forState:UIControlStateNormal];
}
@end
