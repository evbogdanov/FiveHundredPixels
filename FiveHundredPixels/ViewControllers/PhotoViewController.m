//
//  PhotoViewController.m
//  FiveHundredPixels
//
//  Created by Ev Bogdanov on 22/04/2017.
//  Copyright © 2017 Ev Bogdanov. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UINavigationItem *nameTitle;

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.photo.bigImageURL]]];

    self.nameTitle.title = self.photo.name;
}

@end
