//
//  AlbumModel.h
//  FB Albums Viewer
//
//  Created by Ryan Luce on 10/12/14.
//  Copyright (c) 2014 Ryan Luce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlbumModel : NSObject

@property (nonatomic, strong) NSString *albumName;
@property (nonatomic, strong) NSNumber *albumId;
@property (nonatomic, strong) NSNumber *imageCount;
@property (nonatomic, readonly) NSString *albumImageURL;

@end
