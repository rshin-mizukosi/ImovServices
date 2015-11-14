//
//  FiltroTableViewController.m
//  ImovServices
//
//  Created by Renan Shin Mizukosi on 9/28/15.
//  Copyright © 2015 Renan Shin Mizukosi. All rights reserved.
//

#import "FiltroTableViewController.h"
#import "MBProgressHUD.h"

@interface FiltroTableViewController () <MBProgressHUDDelegate> {
    MBProgressHUD *hud;
}

@end

@implementation FiltroTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeCampos];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)convertePrecoToStringWithPreco:(double)preco {
    NSNumber *amount = [NSNumber numberWithDouble:preco];
    NSLocale *brazil = [[NSLocale alloc] initWithLocaleIdentifier:@"pt_BR"];
    NSNumberFormatter *currencyStyle = [[NSNumberFormatter alloc] init];
    [currencyStyle setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [currencyStyle setNumberStyle:NSNumberFormatterCurrencyStyle];
    [currencyStyle setLocale:brazil];
    return [currencyStyle stringFromNumber:amount];
}

- (void)initializeCampos {
    self.tipoOperacao.selectedSegmentIndex = -1;
    self.qtdQuartos.selectedSegmentIndex = -1;
    self.qtdSuites.selectedSegmentIndex = -1;
    self.qtdBanheiros.selectedSegmentIndex = -1;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    cell.detailTextLabel.text = @"";
    
    indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    cell.detailTextLabel.text = @"Todos";
    
    indexPath = [NSIndexPath indexPathForRow:2 inSection:1];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    cell.detailTextLabel.text = @"Todos";
    
    indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    cell.detailTextLabel.text = @"Nenhum";
    
    self.filtro = [[Filtro alloc] init];
    
    self.fechar.target = self;
    self.fechar.action = @selector(fecharAction:);
    
    self.aplicar.target = self;
    self.aplicar.action = @selector(aplicarAction:);
}

/*
- (void)initializeSearchController {
    self.searchResultController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchResultController.searchResultsUpdater = self;
    self.searchResultController.delegate = self;
    self.searchResultController.searchBar.delegate = self;
    self.searchResultController.dimsBackgroundDuringPresentation = NO;
    [self.searchResultController.searchBar sizeToFit];
    
    [self.tableView setTableHeaderView:self.searchResultController.searchBar];
    self.definesPresentationContext = YES;
}
*/

- (void)fecharAction:(id)sender {
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)aplicarAction:(id)sender {
    if(self.qtdQuartos.selectedSegmentIndex == -1)
        [self.filtro setQtdQuartos:0];
    else
        [self.filtro setQtdQuartos:(int)self.qtdQuartos.selectedSegmentIndex+1];
    
    if(self.qtdSuites.selectedSegmentIndex == -1)
        [self.filtro setQtdSuites:0];
    else
        [self.filtro setQtdSuites:(int)self.qtdSuites.selectedSegmentIndex+1];
    
    if(self.qtdBanheiros.selectedSegmentIndex == -1)
        [self.filtro setQtdBanheiros:0];
    else
        [self.filtro setQtdBanheiros:(int)self.qtdBanheiros.selectedSegmentIndex+1];
    
    NSMutableArray *params = [[NSMutableArray alloc] init];
    
    if([self.filtro.endereco isKindOfClass:[NSString class]])
        [params addObject:[NSString stringWithFormat:@"endereco=%@", self.filtro.endereco]];
    
    if(self.filtro.minPreco > 0)
        [params addObject:[NSString stringWithFormat:@"min_preco=%.2f", self.filtro.minPreco]];
    
    if(self.filtro.maxPreco > 0)
        [params addObject:[NSString stringWithFormat:@"max_preco=%.2f", self.filtro.maxPreco]];
    
    if(self.filtro.minArea > 0)
        [params addObject:[NSString stringWithFormat:@"min_area=%d", self.filtro.minArea]];
    
    if(self.filtro.maxArea > 0)
        [params addObject:[NSString stringWithFormat:@"max_area=%d", self.filtro.maxArea]];
    
    if(self.filtro.qtdQuartos > 0)
        [params addObject:[NSString stringWithFormat:@"qtd_quarto=%d", self.filtro.qtdQuartos]];
    
    if(self.filtro.qtdSuites > 0)
        [params addObject:[NSString stringWithFormat:@"qtd_suite=%d", self.filtro.qtdSuites]];
    
    if(self.filtro.qtdBanheiros > 0)
        [params addObject:[NSString stringWithFormat:@"qtd_banheiro=%d", self.filtro.qtdBanheiros]];
    
    if([self.filtro.ordenacao isKindOfClass:[NSString class]])
        [params addObject:[NSString stringWithFormat:@"order=%@&tipo_order=%@", self.filtro.ordenacao, self.filtro.tipo_ordenacao]];
    
    NSString *stringURL = @"http://www.shintechnology.esy.es/imovservices/webservices/buscar_imoveis.php";
    
    if(params.count > 0)
        stringURL = [stringURL stringByAppendingString:@"?"];
    
    for(int i=0; i<params.count; i++) {
        stringURL = [stringURL stringByAppendingString:[params objectAtIndex:i]];
        
        if(i+1 < params.count)
            stringURL = [stringURL stringByAppendingString:@"&"];
    }
    
    [self.delegate filtrarImoveisWithURL:stringURL];
    
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setEnderecoWithString:(NSString *)endereco {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    cell.detailTextLabel.text = endereco;
    
    [self.filtro setEndereco:endereco];
}

- (void)setFaixaPrecoWithMinPreco:(double)minPreco andMaxPreco:(double)maxPreco {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *detalhe = nil;
    
    if(minPreco == 0)
        detalhe = [NSString stringWithFormat:@"Até %@", [self convertePrecoToStringWithPreco:maxPreco]];
    else if(maxPreco == 0)
        detalhe = [NSString stringWithFormat:@"A partir de %@", [self convertePrecoToStringWithPreco:minPreco]];
    else
        detalhe = [NSString stringWithFormat:@"De %@ até %@", [self convertePrecoToStringWithPreco:minPreco], [self convertePrecoToStringWithPreco:maxPreco]];
    
    cell.detailTextLabel.text = detalhe;
    
    [self.filtro setMinPreco:minPreco];
    [self.filtro setMaxPreco:maxPreco];
}

- (void)setFaixaAreaWithMinArea:(int)minArea andMaxArea:(int)maxArea {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:1];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *detalhe = nil;
    
    if(minArea == 0)
        detalhe = [NSString stringWithFormat:@"Até %dm²", maxArea];
    else if(maxArea == 0)
        detalhe = [NSString stringWithFormat:@"A partir de %dm²", minArea];
    else
        detalhe = [NSString stringWithFormat:@"De %dm² até %dm²", minArea, maxArea];
    
    cell.detailTextLabel.text = detalhe;
    
    [self.filtro setMinArea:minArea];
    [self.filtro setMaxArea:maxArea];
}

- (void)setOrdenacao:(NSInteger)order {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *detalhe = nil;
    
    if(order == 0) {
        [self.filtro setOrdenacao:@""];
        detalhe = @"Nenhum";
    }
    else if(order == 1) {
        [self.filtro setOrdenacao:@"VALOR_PROPOSTO"];
        [self.filtro setTipo_ordenacao:@"ASC"];
        detalhe = @"Menor preço";
    }
    else {
        [self.filtro setOrdenacao:@"VALOR_PROPOSTO"];
        [self.filtro setTipo_ordenacao:@"DESC"];
        detalhe = @"Maior preço";
    }
    
    cell.detailTextLabel.text = detalhe;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    /*if(self.searchResultController.active)
        return 1;
    */
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    /*if(self.searchResultController.active)
        return [searchResults count];
    */
    
    if(section == 1)
        return 6;
    
    return 1;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    
    if(indexPath.section == 0)
        cell.textLabel.text = [secao1 objectAtIndex:indexPath.row];
    else
        cell.textLabel.text = [secao2 objectAtIndex:indexPath.row];
    
    // Configure the cell...
    
    return cell;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *segue = nil;
    
    if(indexPath.section == 1) {
        if(indexPath.row == 0)
            segue = @"enderecoSegue";
        if(indexPath.row == 1)
            segue = @"precoSegue";
        else if(indexPath.row == 2)
            segue = @"areaSegue";
    }
    else if(indexPath.section == 2)
        segue = @"ordenacaoSegue";
    else if(indexPath.section == 3)
        [self initializeCampos];
    
    if(segue != nil)
        [self performSegueWithIdentifier:segue sender:nil];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [searchResults removeAllObjects];
    
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"endereco CONTAINS[cd] %@", searchController.searchBar.text];
    
    NSArray *result = [searchResults filteredArrayUsingPredicate:searchPredicate];
    
    searchResults = [[NSMutableArray alloc] initWithArray:result];
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
    hud.labelText = @"Loading";
    hud.userInteractionEnabled = false;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self filtrarEndereco:searchController.searchBar.text];
        
        dispatch_async(dispatch_get_main_queue(),^{
            [hud hide:true];
        });
    });
}

- (void)filtrarEndereco:(NSString *)filtro {
    
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
    if([segue.identifier isEqualToString:@"enderecoSegue"]) {
        EnderecoTableViewController *vc = segue.destinationViewController;
        vc.delegate = self;
    }
    else if([segue.identifier isEqualToString:@"precoSegue"]) {
        PrecoTableViewController *vc = segue.destinationViewController;
        vc.delegate = self;
    }
    else if([segue.identifier isEqualToString:@"areaSegue"]) {
        AreaTableViewController *vc = segue.destinationViewController;
        vc.delegate = self;
    }
    else if([segue.identifier isEqualToString:@"ordenacaoSegue"]) {
        OrdenacaoTableViewController *vc = segue.destinationViewController;
        vc.delegate = self;
    }
}

@end
