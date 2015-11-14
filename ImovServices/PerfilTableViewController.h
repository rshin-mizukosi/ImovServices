//
//  PerfilTableViewController.h
//  ImovServices
//
//  Created by Renan Shin Mizukosi on 10/27/15.
//  Copyright © 2015 Renan Shin Mizukosi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PerfilTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuBar;

- (void)setPerfil;
- (void)setDetailsRowForIndexPath:(NSIndexPath *)indexPath;
- (void)avisoLogout;

@end
