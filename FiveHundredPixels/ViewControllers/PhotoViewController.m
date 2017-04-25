//
//  PhotoViewController.m
//  FiveHundredPixels
//
//  Created by Ev Bogdanov on 22/04/2017.
//  Copyright © 2017 Ev Bogdanov. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController ()

@property (weak, nonatomic) IBOutlet UINavigationItem *nameTitle;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UIImage *image; // Image is not really a property.
                                              // Since I never use its instance
                                              // variable, I don't @synthesize it.

@end

@implementation PhotoViewController


#pragma mark - Getters and setters

- (void)setPhoto:(Photo *)photo {
    _photo = photo;
    [self downloadImage];
}

- (void)setScrollView:(UIScrollView *)scrollView {
    _scrollView = scrollView;
    _scrollView.minimumZoomScale = 0.2;
    _scrollView.maximumZoomScale = 2.0;
    _scrollView.delegate = self;
    [self maybeSetScrollViewContentSize];
}

- (UIImageView *)imageView {
    if (!_imageView)
        _imageView = [[UIImageView alloc] init];

    return _imageView;
}

- (UIImage *)image {
    return self.imageView.image;
}

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
    [self.imageView sizeToFit];
    [self maybeSetScrollViewContentSize];
    [self.activityIndicatorView stopAnimating];
}


#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameTitle.title = self.photo.name;
    [self.scrollView addSubview:self.imageView];
}


#pragma mark - Zooming

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}


#pragma mark - Helpers

- (void)maybeSetScrollViewContentSize {
    // How it works:
    // https://www.youtube.com/watch?v=LdTEO7mKaMk&t=47m30s
    self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
}

- (void)downloadImage {
    self.image = nil;

    if (!self.photo)
        return;

    [self.activityIndicatorView startAnimating];

    // 'Old' URL to download. Might be different when downloading is finished.
    NSString *URLString = self.photo.bigImageURL;

    dispatch_queue_t downloadQueue = dispatch_queue_create("500px download image", NULL);
    dispatch_async(downloadQueue, ^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:URLString]]];

        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.photo && [URLString isEqualToString:self.photo.bigImageURL]) {
                // Set image only if it matches the 'old' photo.
                self.image = image;
            }
        });
    });
}

@end
