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
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation PhotosViewController


#pragma mark - Setters and getters

- (void)setPhotos:(NSArray *)photos {
    _photos = photos;
    [self.tableView reloadData];
}

- (UIActivityIndicatorView *)activityIndicatorView {
    if (!_activityIndicatorView)
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

    return _activityIndicatorView;
}


#pragma mark - Show/hide activity indicator

- (void)showActivityIndicator {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.activityIndicatorView startAnimating];
}

- (void)hideActivityIndicator {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.activityIndicatorView stopAnimating];
}


#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.searchBar.delegate = self;

    self.tableView.backgroundView = self.activityIndicatorView;
}


#pragma mark - Default photo image

- (UIImage *)defaultPhotoImage {
    static UIImage *image = nil;

    if (!image)
        image = [UIImage imageNamed:@"photo"];

    return image;
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
    cell.imageView.image = [self defaultPhotoImage];

    // Readme:
    // http://stackoverflow.com/questions/16663618/async-image-loading-from-url-inside-a-uitableview-cell-image-changes-to-wrong
    dispatch_queue_t requestQueue = dispatch_queue_create("500px photo request", NULL);
    dispatch_async(requestQueue, ^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photo.smallImageURL]]];
        if (!image)
            return;

        dispatch_async(dispatch_get_main_queue(), ^{
            UITableViewCell *updatedCell = [tableView cellForRowAtIndexPath:indexPath];
            if (updatedCell)
                updatedCell.imageView.image = image;
        });
    });

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Will be nil on iPhone.
    id detail = self.splitViewController.viewControllers[1];

    if ([detail isKindOfClass:[UINavigationController class]]) {
        detail = [((UINavigationController *)detail).viewControllers firstObject];
    }

    if ([detail isKindOfClass:[PhotoViewController class]]) {
        PhotoViewController *photoVC = (PhotoViewController *)detail;
        photoVC.photo = self.photos[indexPath.row];
    }
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
    // Clear everything
    self.photos = nil;
    searchBar.text = nil;

    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    // Not interested in previous photos
    self.photos = nil;
    [self showActivityIndicator];

    [self hideKeyboardAndKeepCancelButtonEnabled:searchBar];

    [[PhotoManager sharedManager] searchPhotosByTerm:searchBar.text withCallback:^(NSArray *photos) {
        [self hideActivityIndicator];
        self.photos = photos;
    }];
}

- (void)hideKeyboardAndKeepCancelButtonEnabled:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    for (UIView *view in searchBar.subviews) {
        for (id subview in view.subviews) {
            if ( [subview isKindOfClass:[UIButton class]] ) {
                [subview setEnabled:YES];
                return;
            }
        }
    }
}

@end
