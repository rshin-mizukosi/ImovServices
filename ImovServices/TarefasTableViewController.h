//
//  TarefasTableViewController.h
//  ImovServices
//
//  Created by Renan Shin Mizukosi on 9/25/15.
//  Copyright © 2015 Renan Shin Mizukosi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DocumentoViewController.h"

@interface TarefasTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, DocumentoViewControllerDelegate> {
    NSDictionary *json;
}

@property (strong, nonatomic) NSMutableArray *tarefas, *tarefasFeitas, *tarefasNaoFeitas;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editBar;

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) NSIndexPath *myIndexPath;

- (void)alocaTarefasInSections;
- (void)setJson;
- (NSDictionary *)getJson;
- (NSString *)getCurrentDate;
- (void)showAlertaAdd;
- (void)addTarefaWith:(NSString *)nomeTarefa;
- (void)moveTarefaToRealizadasWithIndexPath:(NSIndexPath *)indexPath;
- (void)initializeCampos;
- (void)implementaRefreshControl;

@end
