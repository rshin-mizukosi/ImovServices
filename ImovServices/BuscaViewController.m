//
//  BuscaViewController.m
//  ImovServices
//
//  Created by Renan Shin Mizukosi on 9/28/15.
//  Copyright © 2015 Renan Shin Mizukosi. All rights reserved.
//

#import "BuscaViewController.h"

@interface BuscaViewController () <MBProgressHUDDelegate> {
    MBProgressHUD *hud;
}

@end

@implementation BuscaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    imoveisArray = [[NSMutableArray alloc] init];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    
    if(revealViewController) {
        [self.menuBar setTarget:self.revealViewController];
        [self.menuBar setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    [self showAlertaReferencia];
    
    self.filtro.target = self;
    self.filtro.action = @selector(buttonFiltro:);
    
    self.viewLoaded = NO;
}

- (void)buttonFiltro:(id)sender {
    [self performSegueWithIdentifier:@"filtroSegue" sender:sender];
}

- (void)showAlertaReferencia {
    UIAlertController *alertLocal = [UIAlertController alertControllerWithTitle:@"Referência" message:@"Digite um endereço de referência" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *txt = alertLocal.textFields.firstObject;
        self.referencia = txt.text;
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alertLocal dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertLocal addAction:ok];
    [alertLocal addAction:cancel];
    
    [alertLocal addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"CEP, endereço, bairro, cidade, estado";
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.returnKeyType = UIReturnKeyDone;
    }];
    
    [self presentViewController:alertLocal animated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    if(!self.viewLoaded) {
        self.viewLoaded = YES;
        
        [self loadImoveisWithURL:@"http://www.shintechnology.esy.es/imovservices/webservices/buscar_imoveis.php"];
    }
}

- (void)loadImoveisWithURL:(NSString *)strURL {
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
    hud.labelText = @"Loading";
    hud.userInteractionEnabled = NO;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //[self.navigationController.navigationBar setUserInteractionEnabled:NO];
        [self.myTableView setUserInteractionEnabled:NO];
        [self listarImoveisWithURL:strURL];
        
        dispatch_async(dispatch_get_main_queue(),^{
            [hud hide:true];
            //[self.navigationController.navigationBar setUserInteractionEnabled:YES];
            [self.myTableView setUserInteractionEnabled:YES];
            
            NSString *strResultado = nil;
            
            if([imoveisArray count] > 1)
                strResultado = @"imóveis encontrados";
            else
                strResultado = @"imóvel encontrado";
            
            self.resultado.text = [[NSString alloc] initWithFormat:@"%d %@", (int)[imoveisArray count], strResultado];
            
            [self.myTableView reloadData];
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)listarImoveisWithURL:(NSString *)strUrl {
    //transformando a string em uma url
    //NSURL *url = [NSURL URLWithString:strUrl];
    NSURL *url = [NSURL URLWithString:strUrl];
    
    //criando o NSData e fazendo um request
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    //transformando o NSDATA para NSDICTIONARY o NSJSONSerialization faz o Parser do JSON
    NSError *error;
    json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    NSDictionary *imoveis = [json objectForKey:@"data"];
    Imovel *i = nil;
    
    [imoveisArray removeAllObjects];
    
    for(NSDictionary *temp in imoveis) {
        i = [[Imovel alloc] init];
        
        [i setIdImov:[[temp objectForKey:@"ID_IMOVEL"] intValue]];
        [i setEndereco:[temp objectForKey:@"ATTR_ENDERECO1"]];
        [i setBairro:[temp objectForKey:@"ATTR_ENDERECO3"]];
        [i setCep:[temp objectForKey:@"CEP"]];
        [i setCidade:[temp objectForKey:@"CIDADE"]];
        [i setUf:[temp objectForKey:@"UF"]];
        [i setPreco:[[temp objectForKey:@"VALOR_PROPOSTO"] doubleValue]];
        [i setArea:[[temp objectForKey:@"METRAGEM"] doubleValue]];
        
        [i setQtdQuarto:[[temp objectForKey:@"QUARTO"] intValue]];
        [i setQtdSuite:[[temp objectForKey:@"SUITE"] intValue]];
        [i setQtdBanheiro:[[temp objectForKey:@"BANHEIRO"] intValue]];
        [i setQtdDispensa:[[temp objectForKey:@"DISPENSA"] intValue]];
        
        [i setTemQuintal:[[temp objectForKey:@"QUINTAL"] boolValue]];
        [i setTemVaranda:[[temp objectForKey:@"VARANDA"] boolValue]];
        [i setTemSalaoJogos:[[temp objectForKey:@"SALAO_JOGOS"] boolValue]];
        [i setTemSalaoFesta:[[temp objectForKey:@"SALAO_FESTA"] boolValue]];
        [i setTemChurraqueira:[[temp objectForKey:@"CHURRASQUEIRA"] boolValue]];
        [i setTemPiscina:[[temp objectForKey:@"PISCINA"] boolValue]];
        [i setTemVarandaGourmet:[[temp objectForKey:@"VARANDA_GOURMET"] boolValue]];
        
        i.fotos = [[NSMutableArray alloc] init];
        
        [i.fotos addObject:[self convertURLFotoToImageWithUrlFoto:[temp objectForKey:@"FOTO_1"]]];
        
        [i.fotos addObject:[self convertURLFotoToImageWithUrlFoto:[temp objectForKey:@"FOTO_2"]]];
        
        [i.fotos addObject:[self convertURLFotoToImageWithUrlFoto:[temp objectForKey:@"FOTO_3"]]];
        
        [imoveisArray addObject:i];
    }
}

- (UIImage *)convertURLFotoToImageWithUrlFoto:(NSString *)urlFoto {
    NSData *dataImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlFoto]];
    return [UIImage imageWithData:dataImage];
}

- (void)filtrarImoveisWithURL:(NSString *)strURL {
    NSLog(@"%@", strURL);
    
    [self loadImoveisWithURL:strURL];
}

- (NSDictionary *)getJson {
    return json;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [imoveisArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    Imovel *i = [imoveisArray objectAtIndex:indexPath.row];
    
    cell.endereco.text = [i endereco];
    cell.bairro.text = [NSString stringWithFormat:@"%@, %@ - %@", [i bairro], [i cidade], [i uf]];
    
    cell.quarto.text = [NSString stringWithFormat:@"%d quarto(s)", [i qtdQuarto]];
    cell.suite.text = [NSString stringWithFormat:@"%d suite(s)", [i qtdSuite]];
    cell.banheiro.text = [NSString stringWithFormat:@"%d banheiro(s)", [i qtdBanheiro]];
    cell.preco.text = [self convertePrecoToStringWith:[i preco]];
    cell.area.text = [NSString stringWithFormat:@"%.2fm²", [i area]];
    
    cell.imagem.image = [i.fotos firstObject];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"detalheSegue" sender:nil];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)convertePrecoToStringWith:(double)preco {
    NSNumber *amount = [NSNumber numberWithDouble:preco];
    NSLocale *brazil = [[NSLocale alloc] initWithLocaleIdentifier:@"pt_BR"];
    NSNumberFormatter *currencyStyle = [[NSNumberFormatter alloc] init];
    [currencyStyle setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [currencyStyle setNumberStyle:NSNumberFormatterCurrencyStyle];
    [currencyStyle setLocale:brazil];
    return [currencyStyle stringFromNumber:amount];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detalheSegue"]) {
        Imovel *i = [imoveisArray objectAtIndex:[[self.myTableView indexPathForSelectedRow] row]];
        DetalheViewController *vc = segue.destinationViewController;
        
        vc.imovel = i;
    }
    else if([segue.identifier isEqualToString:@"filtroSegue"]) {
        FiltroTableViewController *vc = segue.destinationViewController;
        vc.delegate = self;
    }
}

@end
