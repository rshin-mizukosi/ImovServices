//
//  FiltroTableViewController.h
//  ImovServices
//
//  Created by Renan Shin Mizukosi on 9/28/15.
//  Copyright © 2015 Renan Shin Mizukosi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnderecoTableViewController.h"
#import "PrecoTableViewController.h"
#import "AreaTableViewController.h"
#import "OrdenacaoTableViewController.h"
#import "Filtro.h"

@protocol FiltroTableViewControllerDelegate <NSObject>

- (void)filtrarImoveisWithURL:(NSString *)strURL;

@end

@interface FiltroTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, EnderecoTableViewControllerDelegate, PrecoTableViewControllerDelegate, AreaTableViewControllerDelegate, OrdenacaoTableViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *tipoOperacao;
@property (weak, nonatomic) IBOutlet UISegmentedControl *qtdQuartos;
@property (weak, nonatomic) IBOutlet UISegmentedControl *qtdSuites;
@property (weak, nonatomic) IBOutlet UISegmentedControl *qtdBanheiros;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *fechar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *aplicar;
@property (nonatomic, retain) Filtro *filtro;

@property (nonatomic)id<FiltroTableViewControllerDelegate> delegate;

- (NSString *)convertePrecoToStringWithPreco:(double)preco;
- (void)initializeCampos;

@end
