//
//  PhotosViewController.m
//  FiveHundredPixels
//
//  Created by Ev Bogdanov on 19/04/2017.
//  Copyright © 2017 Ev Bogdanov. All rights reserved.
//

#import "PhotosViewController.h"
#import "PhotoManager.h"

@interface PhotosViewController ()

@end

@implementation PhotosViewController

//- (void)setPhotos:(NSArray *)photos {
//    _photos = photos;
//    [self.tableView reloadData];
//}

- (void)viewDidLoad {
    [super viewDidLoad];

    PhotoManager *manager = [PhotoManager sharedManager];
    NSLog(@"consumer key is '%@'", manager.consumerKey);
}

@end
