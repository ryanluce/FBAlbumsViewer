//
//  AlbumsListViewController.m
//  FB Albums Viewer
//
//  Created by Ryan Luce on 10/11/14.
//  Copyright (c) 2014 Ryan Luce. All rights reserved.
//

#import "AlbumsListViewController.h"
#import "AlbumsParallaxTableViewCell.h"
#import "AlbumModel.h"
#import "MBProgressHUD.h"
#import <FacebookSDK/FacebookSDK.h>

#define kParallaxCellIdentifier @"AlbumsParallaxTableViewCell"

@interface AlbumsListViewController () <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *_tableView;

    NSMutableArray *_dataSource;
}
@end

@implementation AlbumsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationItem setHidesBackButton:YES];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    if(!_dataSource)
        [self reloadAllData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)reloadAllData
{
    //Give the user a visual notification that the app is loading data
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.f];
    hud.labelText = @"Loading...";
    
    //load all the albums for the logged in user
    NSString *graphPath = @"/me/albums";
    [FBRequestConnection startWithGraphPath:graphPath
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        NSDictionary *resultDictionary = (NSDictionary *)result;
        NSMutableArray *facebookData = [NSMutableArray arrayWithArray:[resultDictionary objectForKey:@"data"]];
        _dataSource = [[NSMutableArray alloc] initWithCapacity:facebookData.count];
        //iterate through every album
        for(NSDictionary *tempDictionary in facebookData)
        {
            AlbumModel *temporaryAlbumModel = [[AlbumModel alloc] init];
            
            temporaryAlbumModel.albumId = [tempDictionary objectForKey:@"id"];
            temporaryAlbumModel.imageCount= [tempDictionary objectForKey:@"count"];
            temporaryAlbumModel.albumName = [tempDictionary objectForKey:@"name"];
            [_dataSource addObject:temporaryAlbumModel];
        }
        [_tableView reloadData];
        //make sure all images are pre scrolled
        [self scrollViewDidScroll:_tableView];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

#pragma mark - table view delegate/datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlbumsParallaxTableViewCell *albumsParallaxTableViewCell = [tableView dequeueReusableCellWithIdentifier:kParallaxCellIdentifier];
    
    [albumsParallaxTableViewCell updateWithAlbumModel:_dataSource[indexPath.row]];
    
    return albumsParallaxTableViewCell;
}

#pragma mark - scrollview delegate
//magic for the parallax effect
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    for(AlbumsParallaxTableViewCell *cell in _tableView.visibleCells)
    {
        //want the y value for the cell in perspective of self.view.
        CGRect frameInRect = [_tableView convertRect:cell.frame toView:self.view];
        //Want the parallax effect to end at the nav bar
        CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
        
        CGFloat cellYValue = frameInRect.origin.y - navigationBarHeight;
        CGFloat tableHeight = _tableView.frame.size.height - navigationBarHeight;
        CGFloat parallaxValue = cellYValue/tableHeight;
        [cell updateParallax:parallaxValue];

    }
}



@end
