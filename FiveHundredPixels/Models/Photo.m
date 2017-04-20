//
//  Photo.m
//  FiveHundredPixels
//
//  Created by Ev Bogdanov on 20/04/2017.
//  Copyright © 2017 Ev Bogdanov. All rights reserved.
//

#import "Photo.h"

@implementation Photo

- (instancetype)initWithName:(NSString *)name
               smallImageURL:(NSString *)smallImageURL
                 bigImageURL:(NSString *)bigImageURL {
    self = [super init];
    if (self) {
        _name = name;
        _smallImageURL = smallImageURL;
        _bigImageURL = bigImageURL;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Photo with name: '%@' and big image: %@", self.name, self.bigImageURL];
}

@end
