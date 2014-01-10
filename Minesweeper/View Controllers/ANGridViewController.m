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

const NSUInteger kGridRowsCount = 8;
const NSUInteger kGridSectionsCount = 8;

@interface ANGridViewController ()

@property (strong, nonatomic) ANGrid *grid;

@end

@implementation ANGridViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.grid = [[ANGrid alloc] initWithRowsCount:kGridRowsCount andSectionsCount:kGridSectionsCount];
    
    NSLog(@"%@", self.grid);
    
    [[ANGridSeeder sharedInstance] seedGrid:self.grid];
    
    NSLog(@"%@", self.grid);
}

@end
