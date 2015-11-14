//
//  BuscaViewController.h
//  ImovServices
//
//  Created by Renan Shin Mizukosi on 9/28/15.
//  Copyright © 2015 Renan Shin Mizukosi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FiltroTableViewController.h"
#import "MBProgressHUD.h"
#import "SWRevealViewController.h"
#import "CustomTableViewCell.h"
#import "DetalheViewController.h"
#import "Imovel.h"

@interface BuscaViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, FiltroTableViewControllerDelegate> {
    NSMutableArray *imoveisArray, *searchResults;
    NSDictionary *json;
}

@property (weak, nonatomic) IBOutlet UILabel *resultado;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *filtro;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuBar;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic) BOOL viewLoaded;
@property (nonatomic, retain) NSString *referencia;

- (void)loadImoveisWithURL:(NSString *)strURL;
- (void)showAlertaReferencia;
- (void)listarImoveisWithURL:(NSString *)strUrl;
- (NSDictionary *)getJson;
- (NSString *)convertePrecoToStringWith:(double)preco;
- (UIImage *)convertURLFotoToImageWithUrlFoto:(NSString *)urlFoto;

@end
