//
//  ArtistListViewController.m
//  Mcube
//
//  Created by Schubert Cardozo on 08/02/14.
//  Copyright (c) 2014 Schubert Cardozo. All rights reserved.
//

#import "ArtistListViewController.h"
#import <Parse/Parse.h>

@interface ArtistListViewController ()

@end

@implementation ArtistListViewController
- (void)loadView
{
    [super loadView];
    
    PFQuery *artistListQuery = [PFQuery queryWithClassName:@"Artist"];
    artistListQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
    [artistListQuery setLimit:1000];
    NSLog(@"CACHE->%@", ([artistListQuery hasCachedResult] ? @"yes" : @"no"));
    [artistListQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error)
        {
            artistObjects = objects;
            [artistTableView reloadData];
        }
    }];
    
    artistTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    artistTableView.delegate = self;
    artistTableView.dataSource = self;
    
    [self.view addSubview:artistTableView];
    
    [self customize];
    
    NSArray *familyNames = [UIFont familyNames];
    
    for( NSString *familyName in familyNames ){
        //printf( "Family: %s \n", [familyName UTF8String] );
        
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
        for( NSString *fontName in fontNames ){
            //printf( "\tFont: %s \n", [fontName UTF8String] );
            
        }
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [artistObjects count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kArtistCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [artistTableView dequeueReusableCellWithIdentifier:kArtistCellIdentifier];
    
    NSDictionary *data = [artistObjects objectAtIndex:indexPath.row];
    
//    NSLog(@"index.row->%d", indexPath.row);
//    NSLog(@"data->%@", data);
    
    // elemets in content view
    UIImageView *artistPhotoView;
    UILabel *artistTitleLabel;
    UILabel *artistLocation;
    UILabel *artistGenre;
    if(cell == nil)
    {
        // instantiate new cell and set common stuff
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kArtistCellIdentifier];
        
        // imageview
        artistPhotoView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, kArtistPhotoWidth - 20.0f, kArtistCellHeight - 20.0f)];
        artistPhotoView.contentMode = UIViewContentModeScaleAspectFill;
        artistPhotoView.tag = 1;
        artistPhotoView.layer.masksToBounds = YES;
        artistPhotoView.clipsToBounds = YES;
        artistPhotoView.layer.borderWidth = 1.0f;
        artistPhotoView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        artistPhotoView.layer.cornerRadius = 5.0f;
        [cell.contentView addSubview:artistPhotoView];
        
        CGRect labelRect = CGRectMake(kArtistPhotoWidth, 0.0f, 320.0f - kArtistPhotoWidth- 20.0f - 10.0f, (kArtistCellHeight - 20.0f) *1/3);
        
        // titleView
        labelRect.origin.y += 10.0f;
        artistTitleLabel = [[UILabel alloc] initWithFrame:labelRect];
        artistTitleLabel.tag = 2;
        //[artistTitleLabel setBackgroundColor:[UIColor redColor]];
        [artistTitleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f]];
        [cell.contentView addSubview:artistTitleLabel];
        
        // genreView
        labelRect.origin.y += labelRect.size.height;
        artistGenre = [[UILabel alloc] initWithFrame:labelRect];
        artistGenre.tag = 4;
        [artistGenre setFont:[UIFont fontWithName:@"HelveticaNeue" size:10.0f]];
        [cell.contentView addSubview:artistGenre];

        // locationView
        labelRect.origin.y += labelRect.size.height;
        artistLocation = [[UILabel alloc] initWithFrame:labelRect];
        artistLocation.tag = 3;
        //[artistTitleLabel setBackgroundColor:[UIColor redColor]];
        [artistLocation setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.0f]];
        [cell.contentView addSubview:artistLocation];


        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
    }
    else
    {
        // get individual views of cell using tag
        artistPhotoView = (UIImageView *)[cell.contentView viewWithTag:1];
        artistTitleLabel = (UILabel *)[cell.contentView viewWithTag:2];
        artistLocation = (UILabel *)[cell.contentView viewWithTag:3];
        artistGenre = (UILabel *)[cell.contentView viewWithTag:4];
        
    }
    
    // only change what is different for each cell
    //artistPhotoView.image = [UIImage imageNamed:[data objectForKey:@"image"]];
    artistTitleLabel.text = data[@"name"];
    artistLocation.text = data[@"location"];
    artistGenre.text = data[@"genres"];


    
    return cell;
}

- (void)customize
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Artists";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
