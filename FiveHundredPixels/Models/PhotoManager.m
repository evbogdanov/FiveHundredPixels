//
//  PhotoManager.m
//  FiveHundredPixels
//
//  Created by Ev Bogdanov on 20/04/2017.
//  Copyright © 2017 Ev Bogdanov. All rights reserved.
//

#import "PhotoManager.h"
#import "Photo.h"

#define FHP_SEARCH_URL @"https://api.500px.com/v1/photos/search"
#define FHP_SMALL_IMAGE_SIZE 200
#define FHP_BIG_IMAGE_SIZE 1080
#define FHP_JSON_KEY_PHOTOS @"photos"
#define FHP_JSON_KEY_PHOTO_NAME @"name"
#define FHP_JSON_KEY_PHOTO_URLS @"image_url"

@implementation PhotoManager

- (instancetype)init {
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

- (void)searchPhotosByTerm:(NSString *)term
              withCallback:(void(^)(NSArray *))callback {
    NSString *URLString = [NSString stringWithFormat:@"%@?consumer_key=%@&term=%@&sort=rating&image_size[]=%i&image_size[]=%i",
                     FHP_SEARCH_URL, self.consumerKey, [self encodeURIComponent:term], FHP_SMALL_IMAGE_SIZE, FHP_BIG_IMAGE_SIZE];

    NSURL *URL = [NSURL URLWithString:URLString];

    // Don't block the main thread when requesting photos from 500px.
    dispatch_queue_t requestQueue = dispatch_queue_create("500px request", NULL);
    dispatch_async(requestQueue, ^{
        NSData *JSONReply = [NSData dataWithContentsOfURL:URL];

        NSDictionary *reply = [NSJSONSerialization JSONObjectWithData:JSONReply
                                                              options:0
                                                                error:NULL];

        NSMutableArray *photos = [NSMutableArray array];
        for (NSDictionary *photoDict in reply[FHP_JSON_KEY_PHOTOS]) {
            NSArray *imageURLs = photoDict[FHP_JSON_KEY_PHOTO_URLS];
            Photo *photo = [[Photo alloc] initWithName:photoDict[FHP_JSON_KEY_PHOTO_NAME]
                                         smallImageURL:imageURLs[0]
                                           bigImageURL:imageURLs[1]];
            [photos addObject:photo];
        }

        // Photos mess with UI, so I have to run my callback on the main thread.
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(photos);
        });
    });
}

- (NSString *)encodeURIComponent:(NSString *)string {
    return [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
}

@end
