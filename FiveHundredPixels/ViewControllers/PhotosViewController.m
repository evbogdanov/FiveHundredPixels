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

@end

@implementation PhotosViewController

- (void)setPhotos:(NSArray *)photos {
    _photos = photos;
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[PhotoManager sharedManager] searchPhotosByTerm:@"apple"
                                        withCallback:^(NSArray *photos) {
        self.photos = photos;
    }];
}

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Show photo"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Photo *photo = self.photos[indexPath.row];
        PhotoViewController *photoVC = (PhotoViewController *)segue.destinationViewController;
        photoVC.photo = photo;
    }
}

@end
