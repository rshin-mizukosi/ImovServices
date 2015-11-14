//
//  InteresseViewController.m
//  ImovServices
//
//  Created by Renan Shin Mizukosi on 11/3/15.
//  Copyright © 2015 Renan Shin Mizukosi. All rights reserved.
//

#import "InteresseViewController.h"

@interface InteresseViewController () <MBProgressHUDDelegate> {
    MBProgressHUD *hud;
}

@end

@implementation InteresseViewController
@synthesize imoveis, json, listaDocs, viewLoaded;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    
    if(revealViewController) {
        [self.menuBar setTarget:self.revealViewController];
        [self.menuBar setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    viewLoaded = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    if(!viewLoaded) {
        viewLoaded = YES;
        [self exibirLoading];
    }
}

- (void)exibirLoading {
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
    hud.labelText = @"Loading";
    hud.userInteractionEnabled = NO;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.myTableView setUserInteractionEnabled:NO];
        [self setJsonContent];
        
        dispatch_async(dispatch_get_main_queue(),^{
            [hud hide:true];
            [self.myTableView setUserInteractionEnabled:YES];
            [self listaImoveisInteresse];
        });
    });
}

- (void)setJsonContent {
    NSString *stringUrl = @"http://www.shintechnology.esy.es/imovservices/webservices/imoveis_interesse.php";
    
    //transformando a string em uma url
    NSURL *url = [NSURL URLWithString:stringUrl];
    
    //Criando uma requisição com a url informada
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //Definindo o método como Post
    [request setHTTPMethod:@"POST"];
    
    //setando uma chave para acesso aos dados
    //[request setValue:@"1234567890" forHTTPHeaderField:@"chave-api"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //Adiciona o Data no Body(Corpo) da requisição
    [request setHTTPBody:[[NSString stringWithFormat:@"email=%@&senha=%@", [defaults objectForKey:@"authEmail"], [defaults objectForKey:@"authSenha"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSError *error;
    NSURLResponse *resposta;
    //criando o NSData e fazendo um request, nesse nsdata teremos o retorno
    //que o insert ocorreu com sucesso ou não
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&resposta
                                                     error:&error];
    
    //transformando o NSDATA para NSDICTIONARY o NSJSONSerialization faz o Parser do JSON
    json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions
                                                           error:&error];
}

- (void)listaImoveisInteresse {
    if(json != nil) {
        int status = [[json objectForKey:@"status"] intValue];
        NSString *mensagem = [json objectForKey:@"mensagem"];
        NSDictionary *dicImoveis = [json objectForKey:@"data"];
        
        ImovelDoc *imovelDoc = nil;
        Imovel *imovel = nil;
        Tarefa *tarefa = nil;
        
        if(status == 200) {
            imoveis = [[NSMutableArray alloc] init];
            listaDocs = [[NSMutableArray alloc] init];
            
            for(NSDictionary *temp in dicImoveis) {
                imovel = [[Imovel alloc] init];
                imovelDoc = [[ImovelDoc alloc] init];
                
                [imovel setIdImov:[[temp objectForKey:@"ID_IMOVEL"] intValue]];
                [imovel setEndereco:[temp objectForKey:@"ATTR_ENDERECO1"]];
                [imovel setBairro:[temp objectForKey:@"ATTR_ENDERECO3"]];
                [imovel setCidade:[temp objectForKey:@"CIDADE"]];
                [imovel setUf:[temp objectForKey:@"UF"]];
                [imovel setPreco:[[temp objectForKey:@"VALOR_PROPOSTO"] doubleValue]];
                [imovel setArea:[[temp objectForKey:@"METRAGEM"] doubleValue]];
                
                [imovel setQtdQuarto:[[temp objectForKey:@"QUARTO"] intValue]];
                [imovel setQtdSuite:[[temp objectForKey:@"SUITE"] intValue]];
                [imovel setQtdBanheiro:[[temp objectForKey:@"BANHEIRO"] intValue]];
                [imovel setQtdDispensa:[[temp objectForKey:@"DISPENSA"] intValue]];
                
                tarefa = [[Tarefa alloc] init];
                [tarefa setTitulo:[temp objectForKey:@"TITULO_DOC_1"]];
                [tarefa setStrImage:[temp objectForKey:@"DOC_1"]];
                [listaDocs addObject:tarefa];
                
                tarefa = [[Tarefa alloc] init];
                [tarefa setTitulo:[temp objectForKey:@"TITULO_DOC_2"]];
                [tarefa setStrImage:[temp objectForKey:@"DOC_2"]];
                [listaDocs addObject:tarefa];
                
                tarefa = [[Tarefa alloc] init];
                [tarefa setTitulo:[temp objectForKey:@"TITULO_DOC_3"]];
                [tarefa setStrImage:[temp objectForKey:@"DOC_3"]];
                [listaDocs addObject:tarefa];
                
                tarefa = [[Tarefa alloc] init];
                [tarefa setTitulo:[temp objectForKey:@"TITULO_DOC_4"]];
                [tarefa setStrImage:[temp objectForKey:@"DOC_4"]];
                [listaDocs addObject:tarefa];
                
                tarefa = [[Tarefa alloc] init];
                [tarefa setTitulo:[temp objectForKey:@"TITULO_DOC_5"]];
                [tarefa setStrImage:[temp objectForKey:@"DOC_5"]];
                [listaDocs addObject:tarefa];
                
                tarefa = [[Tarefa alloc] init];
                [tarefa setTitulo:[temp objectForKey:@"TITULO_DOC_6"]];
                [tarefa setStrImage:[temp objectForKey:@"DOC_6"]];
                [listaDocs addObject:tarefa];
                
                imovel.fotos = [[NSMutableArray alloc] init];
                
                [imovel.fotos addObject:[self convertURLFotoToImageWithUrlFoto:[temp objectForKey:@"FOTO_1"]]];
                
                imovelDoc.imovel = [[Imovel alloc] init];
                imovelDoc.imovel = imovel;
                imovelDoc.listaDocs = [[NSMutableArray alloc] init];
                imovelDoc.listaDocs = [listaDocs mutableCopy];
                
                [imoveis addObject:imovelDoc];
            }
            
            [self.myTableView reloadData];
        }
        else
            [self exibirAvisoWithTitle:@"Atenção" andMessage:mensagem];
    }
    else
        [self exibirAvisoWithTitle:@"Atenção" andMessage:@"Erro JSON"];
}

- (void)exibirAvisoWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertController *alerta = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alerta dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alerta addAction:ok];
    [self presentViewController:alerta animated:YES completion:nil];
}

- (UIImage *)convertURLFotoToImageWithUrlFoto:(NSString *)urlFoto {
    NSData *dataImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlFoto]];
    return [UIImage imageWithData:dataImage];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [imoveis count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    // Configure the cell...
    
    ImovelDoc *imovelDoc = [imoveis objectAtIndex:indexPath.row];
    
    cell.endereco.text = [imovelDoc.imovel endereco];
    cell.bairro.text = [NSString stringWithFormat:@"%@, %@ - %@", [imovelDoc.imovel bairro], [imovelDoc.imovel cidade], [imovelDoc.imovel uf]];
    
    cell.quarto.text = [NSString stringWithFormat:@"%d quarto(s)", [imovelDoc.imovel qtdQuarto]];
    cell.suite.text = [NSString stringWithFormat:@"%d suite(s)", [imovelDoc.imovel qtdSuite]];
    cell.banheiro.text = [NSString stringWithFormat:@"%d banheiro(s)", [imovelDoc.imovel qtdBanheiro]];
    cell.preco.text = [self convertePrecoToStringWith:[imovelDoc.imovel preco]];
    cell.area.text = [NSString stringWithFormat:@"%.2fm²", [imovelDoc.imovel area]];
    
    cell.imagem.image = [imovelDoc.imovel.fotos firstObject];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"documentoSegue" sender:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"documentoSegue"]) {
        ImovelDoc *imovelDoc = [imoveis objectAtIndex:[[self.myTableView indexPathForSelectedRow] row]];
        TarefasTableViewController *vc = segue.destinationViewController;
        
        vc.tarefas = [imovelDoc.listaDocs mutableCopy];
    }
}

@end
