//
//  InteresseViewController.h
//  ImovServices
//
//  Created by Renan Shin Mizukosi on 11/3/15.
//  Copyright © 2015 Renan Shin Mizukosi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTableViewCell.h"
#import "ImovelDoc.h"
#import "Imovel.h"
#import "Tarefa.h"
#import "SWRevealViewController.h"
#import "MBProgressHUD.h"
#import "TarefasTableViewController.h"

@interface InteresseViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuBar;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) NSMutableArray *imoveis;
@property (nonatomic, retain) NSMutableArray *listaDocs;
@property (nonatomic, retain) NSDictionary *json;
@property (nonatomic) BOOL viewLoaded;

- (void)setJsonContent;
- (void)listaImoveisInteresse;
- (UIImage *)convertURLFotoToImageWithUrlFoto:(NSString *)urlFoto;
- (NSString *)convertePrecoToStringWith:(double)preco;
- (void)exibirAvisoWithTitle:(NSString *)title andMessage:(NSString *)message;
- (void)exibirLoading;

@end
