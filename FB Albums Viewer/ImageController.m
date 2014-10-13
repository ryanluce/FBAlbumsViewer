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

//Singleton of sorts
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

//Load an image either from local cache(preferred) or from network
- (void)loadImageWithURL:(NSString *)imageURL andCompletionBlock:(void (^)(UIImage *image))completionBlock
{
    if([_imagesCache objectForKey:imageURL])
    {
        completionBlock([_imagesCache objectForKey:imageURL]);
        return;
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,  0);
    //throw the data being loaded onto a different thread
    dispatch_async(queue, ^{
        NSURL *URL = [NSURL URLWithString:imageURL];
        NSData *imageData = [NSData dataWithContentsOfURL:URL];
        UIImage *imageToUse = [UIImage imageWithData:imageData];
        //back on main thread to ensure ui updates happen as they should
        dispatch_sync(dispatch_get_main_queue(), ^{
            if(!imageToUse) return;
            
            [_imagesCache setObject:imageToUse
                            forKey:imageURL];
            completionBlock(imageToUse);
        });
    });
    
}



@end
