//
//  PhotoViewController.m
//  FiveHundredPixels
//
//  Created by Ev Bogdanov on 22/04/2017.
//  Copyright © 2017 Ev Bogdanov. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController ()

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
    self.title = photo.name;
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
    self.scrollView.zoomScale = 1.0;
    self.imageView.image = image;
    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [self maybeSetScrollViewContentSize];
    [self.activityIndicatorView stopAnimating];
}


#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
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


#pragma mark - iPad portrait mode and master view

- (void)showLeftBarButtonItem {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Photos"
                                                             style:self.splitViewController.displayModeButtonItem.style
                                                            target:self.splitViewController.displayModeButtonItem.target
                                                            action:self.splitViewController.displayModeButtonItem.action];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.splitViewController.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if (self.splitViewController.displayMode == UISplitViewControllerDisplayModePrimaryHidden) {
        [self showLeftBarButtonItem];
    }
}

-(void)splitViewController:(UISplitViewController *)svc
   willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode {
    if (displayMode == UISplitViewControllerDisplayModePrimaryHidden) {
        [self showLeftBarButtonItem];
    }
    else {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

@end
