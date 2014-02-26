//
//  ArtistListViewController.m
//  Mcube
//
//  Created by Schubert Cardozo on 08/02/14.
//  Copyright (c) 2014 Schubert Cardozo. All rights reserved.
//

#import "ArtistListViewController.h"
#import "ArtistDetailViewController.h"
#import <Parse/Parse.h>

@interface ArtistListViewController ()

@end

@implementation ArtistListViewController
- (void)loadView
{
    [super loadView];
    
    //[PFQuery clearAllCachedResults];
    
    imagesCache = [[NSMutableDictionary alloc ] init];
    
    PFQuery *artistListQuery = [PFQuery queryWithClassName:@"Artist"];
    artistListQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
    [artistListQuery setLimit:1000];
    NSLog(@"CACHE->%@", ([artistListQuery hasCachedResult] ? @"yes" : @"no"));
    [artistListQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error)
        {
            artistObjects = objects;
            [artistTableView reloadData];
            // stop spinner
        }
    }];
    
    artistTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    [artistTableView setBackgroundColor:[UIColor blackColor]];
    artistTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    artistTableView.delegate = self;
    artistTableView.dataSource = self;
    
    [self.view addSubview:artistTableView];
    
    [self customize];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *artistObject = [artistObjects objectAtIndex:indexPath.row];
    ArtistDetailViewController *artistDetailViewController = [[ArtistDetailViewController alloc] init];
    artistDetailViewController.artistObject = artistObject;
    artistDetailViewController.logoImage = [imagesCache objectForKey:[artistObject objectId]];
    [artistDetailViewController.view setBackgroundColor:[UIColor blackColor]];
    [self.navigationController pushViewController:artistDetailViewController animated:YES];
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
    
    PFObject *data = [artistObjects objectAtIndex:indexPath.row];
    
//    NSLog(@"index.row->%d", indexPath.row);
//    NSLog(@"data->%@", data);
    
    // elemets in content view
    UIImageView *logoImageView;
    UILabel *artistTitleLabel;
    UILabel *artistLocation;
    UILabel *artistGenre;
    UIImageView *imageMaskView;
    
    if(cell == nil)
    {
        // instantiate new cell and set common stuff
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kArtistCellIdentifier];
        
        // imageview
        logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, kArtistPhotoWidth - 20.0f, kArtistCellHeight - 20.0f)];
        logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        [logoImageView setBackgroundColor:[UIColor blackColor]];
        logoImageView.tag = 1;
        logoImageView.layer.masksToBounds = YES;
        logoImageView.clipsToBounds = YES;
        logoImageView.layer.borderWidth = 1.0f;
        logoImageView.layer.borderColor = [UIColor grayColor].CGColor;
        
        logoImageView.layer.cornerRadius = 5.0f;
        [cell.contentView addSubview:logoImageView];
        
        CGRect labelRect = CGRectMake(kArtistPhotoWidth, 0.0f, 320.0f - kArtistPhotoWidth- 20.0f - 10.0f, (kArtistCellHeight - 20.0f) *1/3);
        
        // titleView
        labelRect.origin.y += 10.0f;
        artistTitleLabel = [[UILabel alloc] initWithFrame:labelRect];
        artistTitleLabel.tag = 2;
        [artistTitleLabel setTextColor:[UIColor whiteColor]];
        [artistTitleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13.0f]];
        [cell.contentView addSubview:artistTitleLabel];
        

        // locationView
        labelRect.origin.y += labelRect.size.height;
        artistLocation = [[UILabel alloc] initWithFrame:labelRect];
        artistLocation.tag = 3;
        [artistLocation setTextColor:[UIColor lightTextColor]];
        [artistLocation setFont:[UIFont fontWithName:@"HelveticaNeue" size:10.0f]];
        [cell.contentView addSubview:artistLocation];

        // genreView
        labelRect.origin.y += labelRect.size.height;
        artistGenre = [[UILabel alloc] initWithFrame:labelRect];
        [artistGenre setTextColor:[UIColor lightTextColor]];
        artistGenre.tag = 4;
        [artistGenre setFont:[UIFont fontWithName:@"HelveticaNeue" size:10.0f]];

        [cell.contentView addSubview:artistGenre];


        imageMaskView = [[UIImageView alloc] initWithFrame:logoImageView.frame];
        imageMaskView.tag = 5;
        imageMaskView.layer.masksToBounds = YES;
        imageMaskView.clipsToBounds = YES;
        imageMaskView.layer.cornerRadius = logoImageView.layer.cornerRadius;
        imageMaskView.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.5f];
        [cell.contentView addSubview:imageMaskView];

        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else
    {
//        NSLog(@"reuse -> %@", [artistObjects objectAtIndex:indexPath.row][@"name"]);
        // get individual views of cell using tag
        logoImageView = (UIImageView *)[cell.contentView viewWithTag:1];
        logoImageView.image = nil;
        artistTitleLabel = (UILabel *)[cell.contentView viewWithTag:2];
        artistLocation = (UILabel *)[cell.contentView viewWithTag:3];
        artistGenre = (UILabel *)[cell.contentView viewWithTag:4];
        imageMaskView = (UIImageView *)[cell.contentView viewWithTag:5];
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.tag = indexPath.row;
    
    // only change what is different for each cell
    artistTitleLabel.text = data[@"name"];
    artistLocation.text = data[@"location"];
    artistGenre.text = data[@"genres"];
    
    if (data[@"logo_image_url"] != nil  && ![data[@"logo_image_url"] isEqual:[NSNull null]])
    {
        //  pass through cache
        if([imagesCache objectForKey:[data objectId]] != nil)
        {
            // cache hit
            logoImageView.image = [imagesCache objectForKey:[data objectId]];
        }
        else
        {
            // cache miss
            PFFile *logoImage = data[@"logo_image_file"];
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0ul);
            dispatch_async(queue, ^(void){
                // lazy load
                NSData *imageData;
                imageData = [logoImage getData];
                UIImage *cacheImage = [UIImage imageWithData:imageData];
                
                // update UI from the thread main
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (cell.tag == indexPath.row)
                    {
                        if(cacheImage)
                            [imagesCache setValue:cacheImage forKey:[data objectId]];
                        logoImageView.image = cacheImage;
                    }
                });
            });
        }
    }
    
    return cell;
}

- (void)customize
{
    //[self.navigationController.navigationBar setTintColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
    //self.view.backgroundColor = [UIColor whiteColor];
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
