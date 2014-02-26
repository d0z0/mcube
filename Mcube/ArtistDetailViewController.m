//
//  ArtistDetailViewController.m
//  Mcube
//
//  Created by Schubert Cardozo on 12/02/14.
//  Copyright (c) 2014 Schubert Cardozo. All rights reserved.
//

#import "ArtistDetailViewController.h"

@interface ArtistDetailViewController ()

@end

@implementation ArtistDetailViewController

@synthesize artistObject;
@synthesize logoImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        sectionedReleases = @[@"A Darkness Descends",
                              @"Beyond the Darkness",
                              @"The Return to Darkness"];
    }
    return self;
}

- (UIImage *)convertImageToGrayScale:(UIImage *)image
{
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // Grayscale color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Create bitmap content with current image size and grayscale colorspace
    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    
    // Draw image into current context, with specified rectangle
    // using previously defined context (with grayscale colorspace)
    CGContextDrawImage(context, imageRect, [image CGImage]);
    
    // Create bitmap image info from pixel data in current context
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    // Create a new UIImage object
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    // Release colorspace, context and bitmap information
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);
    
    // Return the new grayscale image
    return newImage;
}

- (void)loadView
{
    [super loadView];
    [self customizeHeader];
    
    
    UIView *objView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - 64.0f)];
    self.view = objView;
    
    CGFloat topSection = 150.0f;
    CGFloat pagerSection = 25.0f;
    CGFloat bottomSection = objView.frame.size.height - topSection - pagerSection;
    
    UIImageView *watermarkImageView = [[UIImageView alloc] initWithFrame:objView.frame];
    watermarkImageView.image = logoImage;
    watermarkImageView.alpha = 0.5f;
    watermarkImageView.contentMode = UIViewContentModeScaleAspectFit;
    [watermarkImageView setBackgroundColor:[UIColor blackColor]];
    watermarkImageView.layer.masksToBounds = YES;
    watermarkImageView.clipsToBounds = YES;
    [objView addSubview:watermarkImageView];
    
    UIView *maskView = [[UIView alloc] initWithFrame:objView.frame];
    [maskView setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.75f]];
    [objView addSubview:maskView];

    CGRect topPaneFrame = CGRectMake(0.0f, 0.0f, 160.0f, topSection);
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(topPaneFrame.origin.x + 15.0f, topPaneFrame.origin.y + 15.0f, topPaneFrame.size.width - 15.0f, topPaneFrame.size.height - 30.0f)];
    logoImageView.image = logoImage;
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [logoImageView setBackgroundColor:[UIColor blackColor]];
    
    logoImageView.layer.masksToBounds = YES;
    logoImageView.clipsToBounds = YES;
    logoImageView.layer.borderWidth = 1.0f;
    logoImageView.layer.cornerRadius = 5.0f;
    logoImageView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    [objView addSubview:logoImageView];

    topPaneFrame.origin.x += 160.0f;
    
    UIScrollView *bandStatsView = [[UIScrollView alloc] initWithFrame:CGRectMake(topPaneFrame.origin.x + 15.0f, topPaneFrame.origin.y + 15.0f, topPaneFrame.size.width - 30.0f, topPaneFrame.size.height - 30.0f)];
    [bandStatsView setBackgroundColor:[UIColor clearColor]];
    
    CGRect labelFrame = CGRectMake(0.0f, 0.0f, bandStatsView.frame.size.width, bandStatsView.frame.size.height/7.0f);
    
    // genres
    UILabel *genreLabel = [[UILabel alloc] initWithFrame:labelFrame];
    genreLabel.text = artistObject[@"genres"];
    [genreLabel setTextColor:[UIColor whiteColor]];
    [genreLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:11.0f]];
    [bandStatsView addSubview:genreLabel];
    labelFrame.origin.y += labelFrame.size.height;
    
    //formed
    UILabel *yearLabel = [[UILabel alloc] initWithFrame:labelFrame];
    yearLabel.text = [NSString stringWithFormat:@"Formed in %@", artistObject[@"year"]];
    [yearLabel setTextColor:[UIColor whiteColor]];
    [yearLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:11.0f]];
    [bandStatsView addSubview:yearLabel];
    labelFrame.origin.y += labelFrame.size.height;
    
    // location
    UILabel *locationLabel = [[UILabel alloc] initWithFrame:labelFrame];
    locationLabel.text = artistObject[@"location"];
    [locationLabel setTextColor:[UIColor whiteColor]];
    [locationLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:11.0f]];
    [bandStatsView addSubview:locationLabel];
    labelFrame.origin.y += labelFrame.size.height;
    
    // country
    UILabel *countryLabel = [[UILabel alloc] initWithFrame:labelFrame];
    countryLabel.text = artistObject[@"country"];
    [countryLabel setTextColor:[UIColor whiteColor]];
    [countryLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:11.0f]];
    [bandStatsView addSubview:countryLabel];
    labelFrame.origin.y += labelFrame.size.height;

    labelFrame.origin.y += labelFrame.size.height;

    // members
    for(NSArray *member in artistObject[@"members"])
    {
        UILabel *memberLabel = [[UILabel alloc] initWithFrame:labelFrame];
        memberLabel.text = [member objectAtIndex:0];
        [memberLabel setTextColor:[UIColor whiteColor]];
        [memberLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:11.0f]];
        [bandStatsView addSubview:memberLabel];
        labelFrame.origin.y += labelFrame.size.height;
        
        UILabel *memberRoleLabel = [[UILabel alloc] initWithFrame:labelFrame];
        memberRoleLabel.text = [member objectAtIndex:1];
        [memberRoleLabel setTextColor:[UIColor grayColor]];
        [memberRoleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.0f]];
        [bandStatsView addSubview:memberRoleLabel];
        labelFrame.origin.y += labelFrame.size.height;
    }
    
    [bandStatsView setContentSize:CGSizeMake(bandStatsView.frame.size.width, labelFrame.origin.y)];
    
    [objView addSubview:bandStatsView];
    
    CGRect pagerFrame = CGRectMake(15.0f, topSection, 320.0f - 30.0f, pagerSection);
    
    UISegmentedControl *pagerControl = [[UISegmentedControl alloc] initWithItems:@[@"Sounds", @"Videos", @"Discography", @"Info"]];
    
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [pagerControl setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];
    [pagerControl setTintColor:[UIColor grayColor]];
    
    pagerControl.frame = pagerFrame;
    [objView addSubview:pagerControl];
    
    CGRect bottomPaneFrame = CGRectMake(0.0f, topSection + pagerSection + 15.0f, 320.0f, bottomSection - 15.0f);

    UITableView *releasesTableView = [[UITableView alloc] initWithFrame:bottomPaneFrame];
    releasesTableView.delegate = self;
    releasesTableView.dataSource = self;
    releasesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [releasesTableView setBackgroundColor:[UIColor clearColor]];
    
//    [bandScrollView addSubview:releasesTableView];

    [objView addSubview:releasesTableView];
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return [[[artistObject objectForKey:@"albums"] objectAtIndex:section] objectAtIndex:0];
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(5.0f, 0.0f, 320.0f, 20.0f)];
    headerView.backgroundColor = [UIColor darkGrayColor];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 0.0f, 245.0f, 20.0f)];
    nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.text = [[[artistObject objectForKey:@"albums"] objectAtIndex:section] objectAtIndex:0];

    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(260.0f, 0.0f, 45.0f, 20.0f)];
    typeLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:11.0f];
    typeLabel.textAlignment = NSTextAlignmentRight;
    //typeLabel.backgroundColor = [UIColor blackColor];
    typeLabel.textColor = [UIColor whiteColor];
    typeLabel.text = [[[artistObject objectForKey:@"albums"] objectAtIndex:section] objectAtIndex:2];

    [headerView addSubview:nameLabel];
    [headerView addSubview:typeLabel];

    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.backgroundColor = [UIColor clearColor];
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 0.0f, 290.0f, 30.0f)];
    textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0f];
    textLabel.textColor = [UIColor whiteColor];
    //[cell.contentView setBackgroundColor:[UIColor colorWithWhite:0.5f alpha:0.25f]];
    textLabel.text = [[[artistObject objectForKey:@"tracks"] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [cell.contentView addSubview:textLabel];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[artistObject objectForKey:@"albums"] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[artistObject objectForKey:@"tracks"] objectAtIndex:section] count];
}

- (void)customizeHeader
{
    self.title = self.artistObject[@"name"];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:nil];
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
