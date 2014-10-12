//
//  ImageController.h
//  FB Albums Viewer
//
//  Created by Ryan Luce on 10/12/14.
//  Copyright (c) 2014 Ryan Luce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageController : NSObject

+ (instancetype)sharedImageController;

- (void)loadImageWithURL:(NSString *)imageURL andCompletionBlock:(void (^)(UIImage *image))completionBlock;


@end
