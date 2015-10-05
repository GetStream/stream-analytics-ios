//
//  ListTableViewController.m
//  Basic
//
//  Created by Alexander van der Werff on 05/10/15.
//  Copyright © 2015 Stream. All rights reserved.
//

#import "ListTableViewController.h"
#import "DetailViewController.h"

@interface ListTableViewController ()

@end

@implementation ListTableViewController {
    NSIndexPath *selectedPath;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedPath = indexPath;
    [self performSegueWithIdentifier:@"Engage" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DetailViewController *detailVC = (DetailViewController *)[segue destinationViewController];
    detailVC.someId = [NSString stringWithFormat:@"id_%ld", (long)selectedPath.row];
}

@end
