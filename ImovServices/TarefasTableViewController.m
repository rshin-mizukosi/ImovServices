//
//  TarefasTableViewController.m
//  ImovServices
//
//  Created by Renan Shin Mizukosi on 9/25/15.
//  Copyright © 2015 Renan Shin Mizukosi. All rights reserved.
//

#import "TarefasTableViewController.h"
#import "SWRevealViewController.h"
#import "DocumentoViewController.h"
#import "MBProgressHUD.h"
#import "Tarefa.h"
#import "Autenticado.h"

@interface TarefasTableViewController () <MBProgressHUDDelegate> {
    MBProgressHUD *hud;
}

@end

@implementation TarefasTableViewController
@synthesize tarefas, tarefasFeitas, tarefasNaoFeitas;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeCampos];
    [self alocaTarefasInSections];
    [self implementaRefreshControl];
}

- (void)alocaTarefasInSections {
    for(int i=0; i<tarefas.count; i++) {
        Tarefa *t = [tarefas objectAtIndex:i];
        
        if([t.strImage isKindOfClass:[NSString class]])
            [tarefasFeitas addObject:t];
        else
            [tarefasNaoFeitas addObject:t];
    }
}

- (void)implementaRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor greenColor];
    self.refreshControl.tintColor = [UIColor blackColor];
    [self.refreshControl addTarget:self action:@selector(atualizaDocumentos) forControlEvents:UIControlEventValueChanged];
}

- (void)atualizaDocumentos {
    if(self.tarefasFeitas.count > 0 || self.tarefasNaoFeitas.count > 0) {
        [self.myTableView beginUpdates];
        [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
        [self.myTableView endUpdates];
    }
    
    if(self.refreshControl) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributeTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributeTitle;
        
        [self.refreshControl endRefreshing];
    }
}

- (void)initializeCampos {
    Autenticado *autenticado = [[Autenticado alloc] init];
    
    // Se tipo de usuário for imobiliária, habilita os botões de adicionar e editar título dos docs.
    // Se for usuário comum, bloqueia estes botões
    if([autenticado isImobiliaria]) {
        self.addBar.target = self;
        self.addBar.action = @selector(buttonAdd:);
        self.addBar.enabled = YES;
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
        self.editBar.enabled = YES;
    }
    else {
        self.addBar.enabled = NO;
        self.editBar.enabled = NO;
    }
    
    //tarefas = [[NSMutableArray alloc] init];
    tarefasFeitas = [[NSMutableArray alloc] init];
    tarefasNaoFeitas = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAlertaAdd {
    UIAlertController *alertaAdd = [UIAlertController alertControllerWithTitle:@"Tarefa" message:@"Digite o nome da tarefa" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *add = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *txtTarefa = alertaAdd.textFields.firstObject;
        [self addTarefaWith:txtTarefa.text];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alertaAdd dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertaAdd addAction:add];
    [alertaAdd addAction:cancel];
    
    [alertaAdd addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Nome da tarefa";
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.returnKeyType = UIReturnKeyDone;
    }];
    
    [self presentViewController:alertaAdd animated:YES completion:nil];
}

- (void)addTarefaWith:(NSString *)nomeTarefa {
    Tarefa *tarefa = [[Tarefa alloc] init];
    [tarefa setTitulo:nomeTarefa];
    //[tarefa setDetalhe:[NSString stringWithFormat:@"Adicionada em: %@", [self getCurrentDate]]];
    
    [self.tarefasNaoFeitas insertObject:tarefa atIndex:0];
    
    NSIndexPath *indexPath = [[NSIndexPath alloc] init];
    indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.myTableView beginUpdates];
    [self.myTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.myTableView endUpdates];
}

- (void)moveTarefaToRealizadasWithIndexPath:(NSIndexPath *)indexPath {
    Tarefa *tarefa = [[Tarefa alloc] init];
    tarefa = [self.tarefasNaoFeitas objectAtIndex:indexPath.row];
    //[tarefa setDetalhe:[NSString stringWithFormat:@"Alterada em: %@", [self getCurrentDate]]];
    
    [self.tarefasNaoFeitas removeObjectAtIndex:indexPath.row];
    [self.tarefasFeitas insertObject:tarefa atIndex:0];
    
    NSIndexPath *auxIndexPath = [[NSIndexPath alloc] init];
    auxIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    
    [self.myTableView beginUpdates];
    [self.myTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.myTableView insertRowsAtIndexPaths:@[auxIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.myTableView endUpdates];
}

- (void)setJson {
    
}

- (NSDictionary *)getJson {
    return json;
}

- (void)buttonAdd:(id)sender {
    [self showAlertaAdd];
}

#pragma mark - Table view data source

/*
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 3;
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberRows = 0;
    
    switch (section) {
        case 0:
            numberRows = [self.tarefasNaoFeitas count];
            break;
        case 1:
            numberRows = [self.tarefasFeitas count];
            break;
        default:
            break;
    }
        
    return numberRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = nil;
    NSMutableArray *aux = nil;
    
    if(indexPath.section == 0) {
        aux = [self.tarefasNaoFeitas mutableCopy];
        cellID = @"cellNaoFeitas";
    }
    else {
        aux = [self.tarefasFeitas mutableCopy];
        cellID = @"cellFeitas";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    
    Tarefa *tarefa = [[Tarefa alloc] init];
    tarefa = [aux objectAtIndex:indexPath.row];
    
    cell.textLabel.text = tarefa.titulo;
    //cell.detailTextLabel.text = tarefa.detalhe;
    
    if(indexPath.section == 1)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    // Configure the cell...
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0)
        return @"Sem anexo (doc)";
    else
        return @"Com anexo (doc)";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"tarefaSegue" sender:nil];
    [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)getCurrentDate {
    NSDate *hoje = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy hh:mm:ss"];
    NSString *dateString = [dateFormat stringFromDate:hoje];
    
    return dateString;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    Autenticado *autenticado = [[Autenticado alloc] init];
    
    if([autenticado isImobiliaria])
        return YES;
    
    return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        if(indexPath.section == 0) {
            [self.tarefasNaoFeitas removeObjectAtIndex:indexPath.row];
            
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (void)saveTarefa:(Tarefa *)tarefa {
    [self.myTableView reloadData];
    
    if(self.myIndexPath.section == 0)
        [self moveTarefaToRealizadasWithIndexPath:self.myIndexPath];
    
    /*NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    
    if(self.myIndexPath.section == 0)
        [self moveTarefaToRealizadasWithIndexPath:self.myIndexPath];
    else
        [self.tarefasFeitas replaceObjectAtIndex:indexPath.row withObject:tarefa];*/
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"tarefaSegue"]) {
        self.myIndexPath = [[NSIndexPath alloc] init];
        
        self.myIndexPath = [self.myTableView indexPathForSelectedRow];
        DocumentoViewController *vc = segue.destinationViewController;
        vc.delegate = self;
        
        if(self.myIndexPath.section == 0)
            vc.tarefa = [self.tarefasNaoFeitas objectAtIndex:self.myIndexPath.row];
        else
            vc.tarefa = [self.tarefasFeitas objectAtIndex:self.myIndexPath.row];
    }
}

@end
