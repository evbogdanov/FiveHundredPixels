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

@interface PhotosViewController ()

@end

@implementation PhotosViewController

- (void)setPhotos:(NSArray *)photos {
    _photos = photos;
    // [self.tableView reloadData];

    for (Photo *photo in _photos) {
        NSLog(@"%@", photo);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[PhotoManager sharedManager] searchPhotosByTerm:@"apple"
                                        withCallback:^(NSArray *photos) {
        self.photos = photos;
    }];
}

@end
