//
//  OrdenacaoTableViewController.h
//  ImovServices
//
//  Created by Renan Shin Mizukosi on 10/19/15.
//  Copyright © 2015 Renan Shin Mizukosi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrdenacaoTableViewControllerDelegate <NSObject>

- (void)setOrdenacao:(NSInteger)order;

@end

@interface OrdenacaoTableViewController : UITableViewController

@property (nonatomic)id<OrdenacaoTableViewControllerDelegate> delegate;

@end
