//
//  ImageController.m
//  FB Albums Viewer
//
//  Created by Ryan Luce on 10/12/14.
//  Copyright (c) 2014 Ryan Luce. All rights reserved.
//

#import "ImageController.h"

@interface ImageController()
{
    //Cache images so they don't get reloaded from network resources
    NSCache *_imagesCache;
}
@end

@implementation ImageController

+ (instancetype)sharedImageController
{
    static ImageController *sharedImageController;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedImageController = [[self alloc] init];
    });
    return sharedImageController;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        _imagesCache = [[NSCache alloc] init];
    }
    return self;
}


- (void)loadImageWithURL:(NSString *)imageURL andCompletionBlock:(void (^)(UIImage *image))completionBlock
{
    if([_imagesCache objectForKey:imageURL])
    {
        completionBlock([_imagesCache objectForKey:imageURL]);
        return;
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,  0);
    
    dispatch_async(queue, ^{
        NSURL *URL = [NSURL URLWithString:imageURL];
        NSData *imageData = [NSData dataWithContentsOfURL:URL];
        UIImage *imageToUse = [UIImage imageWithData:imageData];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [_imagesCache setObject:imageToUse
                            forKey:imageURL];
            completionBlock(imageToUse);
        });
    });
    
}



@end
