//
//  ArtistListViewController.h
//  Mcube
//
//  Created by Schubert Cardozo on 08/02/14.
//  Copyright (c) 2014 Schubert Cardozo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kArtistCellIdentifier @"artistCell"
#define kArtistCellHeight 70.0f
#define kArtistPhotoWidth 70.0f

@interface ArtistListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *artistTableView;
    NSArray *artistObjects;
    NSMutableDictionary *imagesCache;

}

@end
