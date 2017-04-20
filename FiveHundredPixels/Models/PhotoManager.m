//
//  PhotoManager.m
//  FiveHundredPixels
//
//  Created by Ev Bogdanov on 20/04/2017.
//  Copyright © 2017 Ev Bogdanov. All rights reserved.
//

#import "PhotoManager.h"

@implementation PhotoManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *secretsPath = [[NSBundle mainBundle] pathForResource:@"Secrets" ofType:@"plist"];
        NSDictionary *secrets = [[NSDictionary alloc] initWithContentsOfFile:secretsPath];
        _consumerKey = secrets[@"Consumer key"];
    }
    return self;
}

+ (PhotoManager *)sharedManager {
    static PhotoManager *singleton = nil;

    static dispatch_once_t oncePredicate;

    dispatch_once(&oncePredicate, ^{
        singleton = [[PhotoManager alloc] init];
    });

    return singleton;
}

@end
