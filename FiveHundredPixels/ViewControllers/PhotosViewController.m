//
//  PhotosViewController.m
//  FiveHundredPixels
//
//  Created by Ev Bogdanov on 19/04/2017.
//  Copyright © 2017 Ev Bogdanov. All rights reserved.
//

#import "PhotosViewController.h"
#import "PhotoManager.h"
#import "Photo.h"
#import "PhotoViewController.h"

@interface PhotosViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation PhotosViewController


#pragma mark - Setters and getters

- (void)setPhotos:(NSArray *)photos {
    _photos = photos;
    [self.tableView reloadData];
}


#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.delegate = self;
}


#pragma mark - Table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.photos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Photo cell"
                                                            forIndexPath:indexPath];
    Photo *photo = self.photos[indexPath.row];
    cell.textLabel.text = photo.name;
    cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photo.smallImageURL]]];
    return cell;
}


#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Show photo"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Photo *photo = self.photos[indexPath.row];
        PhotoViewController *photoVC = (PhotoViewController *)segue.destinationViewController;
        photoVC.photo = photo;
    }
}


#pragma mark - Search bar

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    [[PhotoManager sharedManager] searchPhotosByTerm:searchBar.text withCallback:^(NSArray *photos) {
        self.photos = photos;
    }];
}

@end
