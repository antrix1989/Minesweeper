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
#import "ANGridItemNumber.h"
#import "ANGridValidator.h"
#import "ANGridCollectionViewFlowLayout.h"

const NSUInteger kGridCellsSeparatorWidht = 1;
const NSUInteger kGridCellSize = 30;

static NSString *kGridItemCell = @"ANGridItemCell";

typedef NS_ENUM(NSInteger, ANGameState)
{
    ANGameStateUnknown,
    ANGameStatePlaying,
    ANGameStateEnd
};

@interface ANGridViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *gridCollectionView;
@property (weak, nonatomic) IBOutlet ANGridCollectionViewFlowLayout *gridCollectionViewFlowLayout;
@property (weak, nonatomic) IBOutlet UIButton *showMinesButton;
@property (weak, nonatomic) IBOutlet UISlider *sizeSlider;
@property (weak, nonatomic) IBOutlet UISlider *minesSlider;
@property (weak, nonatomic) IBOutlet UILabel *gridSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *minesCountLabel;

@property (strong, nonatomic) ANGrid *grid;
@property (assign, nonatomic) BOOL showMines;
@property (assign, nonatomic) ANGameState state;

- (IBAction)onShowMinesButtonTapped:(id)sender;
- (IBAction)onValidateButtonTapped:(id)sender;
- (IBAction)onNewGameButtonTapped:(id)sender;
- (IBAction)onSaveButtonTapped:(id)sender;
- (IBAction)onLoadButtonTapped:(id)sender;
- (IBAction)onSizeScrub:(id)sender;
- (IBAction)onMinesCountScrub:(id)sender;

@end

@implementation ANGridViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.gridCollectionView registerNib:[UINib nibWithNibName:kGridItemCell bundle:nil] forCellWithReuseIdentifier:kGridItemCell];

    self.gridCollectionViewFlowLayout.spacing = kGridCellsSeparatorWidht;
    self.gridCollectionViewFlowLayout.itemSize = CGSizeMake(kGridCellSize, kGridCellSize);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self startNewGame];
    
    [self updateUi];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Are you ready?" delegate:nil cancelButtonTitle:@"Start" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.grid.columnsCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.grid.rowsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ANGridItemCell *gridItemCell = (ANGridItemCell *)[self.gridCollectionView dequeueReusableCellWithReuseIdentifier:kGridItemCell forIndexPath:indexPath];
    
    NSIndexPath *gridIndexPath = [NSIndexPath indexPathForGridRow:indexPath.item inGridColumn:indexPath.section];
    
    gridItemCell.gridItem = [self.grid gridItemAtIndexPath:gridIndexPath];
    
    BOOL showValue = [self.grid isItemAtIndexPathSelected:gridIndexPath];
    
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
    if (self.state != ANGameStatePlaying) {
        return;
    }
    
    [self selectItemAtIndexPath:indexPath];
    
    ANGridItemCell *gridItemCell = (ANGridItemCell *)[self.gridCollectionView cellForItemAtIndexPath:indexPath];
    [gridItemCell showValue:YES];
    
    if ([gridItemCell.gridItem isKindOfClass:ANGridItemMine.class]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Game Over" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        self.state = ANGameStateEnd;
    }
}

#pragma mark - IBAction

- (IBAction)onShowMinesButtonTapped:(id)sender
{
    self.showMines = !self.showMines;
    
    [self.gridCollectionView reloadData];
}

- (IBAction)onValidateButtonTapped:(id)sender
{
    if ([[ANGridValidator sharedInstance] isGridContainsUnselecteNumberItems:self.grid]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Game Over" message:@"Not all cells with numbers were clicked." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Congratulation" message:@"You win!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    self.state = ANGameStateEnd;
}

- (IBAction)onNewGameButtonTapped:(id)sender
{
    [self startNewGame];
}

- (IBAction)onSaveButtonTapped:(id)sender
{
    if (self.state != ANGameStatePlaying) {
        return;
    }
    
    [self.grid save];
}

- (IBAction)onLoadButtonTapped:(id)sender
{
    [self.grid load];
    
    self.state = ANGameStatePlaying;
    
    [self.gridCollectionView reloadData];
}

- (IBAction)onSizeScrub:(id)sender
{
    [self updateUi];
}

- (IBAction)onMinesCountScrub:(id)sender
{
    [self updateUi];
}

#pragma mark - Private

- (void)setShowMines:(BOOL)showMines
{
    _showMines = showMines;
    
    NSString *title = showMines ? @"Hide Mines" : @"Show Mines";
    
    [self.showMinesButton setTitle:title forState:UIControlStateNormal];
}

- (void)selectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *gridIndexPath = [NSIndexPath indexPathForGridRow:indexPath.item inGridColumn:indexPath.section];
    [self.grid selectItemAtIndexPath:gridIndexPath];
    
    ANGridItemCell *gridItemCell = (ANGridItemCell *)[self.gridCollectionView cellForItemAtIndexPath:indexPath];
    [gridItemCell showValue:YES];
    
    if ([gridItemCell.gridItem isKindOfClass:ANGridItemNumber.class]) {
        ANGridItemNumber *gridItemNumber = (ANGridItemNumber *)gridItemCell.gridItem;
        
        if (gridItemNumber.number == 0) {
            // Select every cell around it.
            for (NSIndexPath *adjancedIndexPath in [self.grid adjacentIndexesForItemAtIndexPath:gridIndexPath]) {
                // If this cell wasn't already selected - select it.
                if (![self.grid isItemAtIndexPathSelected:adjancedIndexPath]) {
                    [self selectItemAtIndexPath:adjancedIndexPath];
                }
            }
        }
    }
}

- (void)startNewGame
{
    self.showMines = NO;
    
    self.grid = [[ANGrid alloc] initWithColumnsCount:[self gridSizeValue] andRowsCount:[self gridSizeValue]];
    
    [[ANGridSeeder sharedInstance] seedGrid:self.grid withMinesCount:[self minesCountValue]];
    
    NSLog(@"%@", self.grid);
    
    [self.gridCollectionView reloadData];
    
    self.state = ANGameStatePlaying;
}

- (void)updateUi
{
    self.gridSizeLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[self gridSizeValue]];
    self.minesCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[self minesCountValue]];
}

- (NSUInteger)gridSizeValue
{
    return (int)self.sizeSlider.value;
}

- (NSUInteger)minesCountValue
{
    return (int)self.minesSlider.value;
}

@end
