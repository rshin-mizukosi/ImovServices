//
//  EnderecoTableViewController.h
//  ImovServices
//
//  Created by Renan Shin Mizukosi on 10/30/15.
//  Copyright © 2015 Renan Shin Mizukosi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EnderecoTableViewControllerDelegate <NSObject>

- (void)setEnderecoWithString:(NSString *)endereco;

@end

@interface EnderecoTableViewController : UITableViewController <UISearchResultsUpdating>

@property (nonatomic) id<EnderecoTableViewControllerDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *cidades, *cidadesFiltrado;
@property (nonatomic, retain) NSMutableArray *estados, *estadosFiltrado;
@property (nonatomic, retain) UISearchController *resultSearchController;

- (void)initializeArrays;
- (void)setParametersSearchBar;

@end
