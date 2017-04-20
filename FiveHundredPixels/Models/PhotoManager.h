//
//  PhotoManager.h
//  FiveHundredPixels
//
//  Created by Ev Bogdanov on 20/04/2017.
//  Copyright © 2017 Ev Bogdanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoManager : NSObject

@property (nonatomic, strong) NSString *consumerKey;

+ (PhotoManager *)sharedManager;
- (void)searchPhotosByTerm:(NSString *)term
              withCallback:(void(^)(NSArray *photos))callback;

@end
