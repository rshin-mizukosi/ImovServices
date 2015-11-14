//
//  DetalheViewController.h
//  ImovServices
//
//  Created by Renan Shin Mizukosi on 10/5/15.
//  Copyright © 2015 Renan Shin Mizukosi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "Imovel.h"
#import "Proprietario.h"

@interface DetalheViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate> {
    NSMutableArray *titleSections, *camposVisaoGeral, *camposCaractAdic, *valoresVisaoGeral, *valoresCaractAdic;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *mapa;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *fotos;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *favorites;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnEmail;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *telefonar;

@property (nonatomic, retain) Imovel *imovel;

- (NSString *)convertePrecoToStringWith:(double)preco;
- (void)initializeVariables;
- (void)setDetails;
- (void)enviarEmail;

@end
