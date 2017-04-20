//
//  Photo.h
//  FiveHundredPixels
//
//  Created by Ev Bogdanov on 20/04/2017.
//  Copyright © 2017 Ev Bogdanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *smallImageURL;
@property (nonatomic, strong, readonly) NSString *bigImageURL;

- (instancetype)initWithName:(NSString *)name
               smallImageURL:(NSString *)smallImageURL
                 bigImageURL:(NSString *)bigImageURL;

@end
