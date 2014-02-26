//
//  ArtistDetailViewController.h
//  Mcube
//
//  Created by Schubert Cardozo on 12/02/14.
//  Copyright (c) 2014 Schubert Cardozo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ArtistDetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *sectionedReleases;
}
@property (nonatomic, strong) PFObject *artistObject;
@property (nonatomic, strong) UIImage *logoImage;
@end
