//
//  DetalheViewController.m
//  ImovServices
//
//  Created by Renan Shin Mizukosi on 10/5/15.
//  Copyright © 2015 Renan Shin Mizukosi. All rights reserved.
//

#import "DetalheViewController.h"
#import "FotosCollectionViewController.h"
#import "Favoritos.h"

@interface DetalheViewController () {
    Favoritos *favoritos;
}

@end

@implementation DetalheViewController
@synthesize imovel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initializeVariables];
    [self setDetails];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeVariables {
    titleSections = [[NSMutableArray alloc] init];
    [titleSections addObject:@"Visão geral"];
    [titleSections addObject:@"Características adicionais"];
    
    camposVisaoGeral = [[NSMutableArray alloc] init];
    camposCaractAdic = [[NSMutableArray alloc] init];
    valoresVisaoGeral = [[NSMutableArray alloc] init];
    valoresCaractAdic = [[NSMutableArray alloc] init];
    
    [camposVisaoGeral addObject:@"Endereço"];
    [camposVisaoGeral addObject:@"Bairro"];
    [camposVisaoGeral addObject:@"CEP"];
    [camposVisaoGeral addObject:@"Cidade/UF"];
    [camposVisaoGeral addObject:@"Preço"];
    [camposVisaoGeral addObject:@"Quarto"];
    [camposVisaoGeral addObject:@"Suite"];
    [camposVisaoGeral addObject:@"Banheiro"];
    [camposVisaoGeral addObject:@"Dispensa"];
    [camposVisaoGeral addObject:@"Área"];
    
    [camposCaractAdic addObject:@"Quintal?"];
    [camposCaractAdic addObject:@"Varanda?"];
    [camposCaractAdic addObject:@"Salão de jogos?"];
    [camposCaractAdic addObject:@"Salão de festa?"];
    [camposCaractAdic addObject:@"Churrasqueira?"];
    [camposCaractAdic addObject:@"Piscina?"];
    [camposCaractAdic addObject:@"Varanda Gourmet?"];
    
    self.btnEmail.target = self;
    self.btnEmail.action = @selector(buttonEnviarEmail:);
    
    self.telefonar.target = self;
    self.telefonar.action = @selector(buttonTelefonar:);
    
    self.favorites.target = self;
    self.favorites.action = @selector(buttonFavorites:);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"favoritos"];
    [defaults synchronize];
    
    NSString *imageName = nil;
    
    favoritos = [[Favoritos alloc] init];
    
    int index = [favoritos getIndexFromArrayWithID:imovel.idImov];
    
    if(index == -1)
        imageName = @"Star-25";
    else
        imageName = @"Star Filled-25";
    
    self.favorites.image = [UIImage imageNamed:imageName];
}

- (void)setDetails {
    [valoresVisaoGeral addObject:[imovel endereco]];
    [valoresVisaoGeral addObject:[imovel bairro]];
    [valoresVisaoGeral addObject:[imovel cep]];
    [valoresVisaoGeral addObject:[NSString stringWithFormat:@"%@/%@", [imovel cidade], [imovel uf]]];
    [valoresVisaoGeral addObject:[self convertePrecoToStringWith:[imovel preco]]];
    [valoresVisaoGeral addObject:[NSString stringWithFormat:@"%d", [imovel qtdQuarto]]];
    [valoresVisaoGeral addObject:[NSString stringWithFormat:@"%d", [imovel qtdSuite]]];
    [valoresVisaoGeral addObject:[NSString stringWithFormat:@"%d", [imovel qtdBanheiro]]];
    [valoresVisaoGeral addObject:[NSString stringWithFormat:@"%d", [imovel qtdDispensa]]];
    [valoresVisaoGeral addObject:[NSString stringWithFormat:@"%.2fm²", [imovel area]]];
    
    [valoresCaractAdic addObject:[imovel temQuintal] ? @"Sim" : @"Não"];
    [valoresCaractAdic addObject:[imovel temVaranda] ? @"Sim" : @"Não"];
    [valoresCaractAdic addObject:[imovel temSalaoJogos] ? @"Sim" : @"Não"];
    [valoresCaractAdic addObject:[imovel temSalaoFesta] ? @"Sim" : @"Não"];
    [valoresCaractAdic addObject:[imovel temChurraqueira] ? @"Sim" : @"Não"];
    [valoresCaractAdic addObject:[imovel temPiscina] ? @"Sim" : @"Não"];
    [valoresCaractAdic addObject:[imovel temVarandaGourmet] ? @"Sim" : @"Não"];
}

- (void)enviarEmail {
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    
    mailComposer.mailComposeDelegate = self;
    
    if([MFMailComposeViewController canSendMail]) {
        //Proprietario *p = [[Proprietario alloc] init];
        
        [mailComposer setSubject:@"App ImovServices"];
        //[mailComposer setToRecipients:@[p.email]];
        [mailComposer setToRecipients:[NSArray arrayWithObjects:@"sac@imovservices.com.br", nil]];
        
        // Display the mail composer
        [self presentViewController:mailComposer animated:YES completion:nil];
    }
}

- (void)buttonFavorites:(id)sender {
    NSMutableArray *imoveis = [[NSMutableArray alloc] initWithArray:[favoritos readFromNSUserDefaults]];
    
    int index = [favoritos getIndexFromArrayWithID:imovel.idImov];
    
    if(index == -1) {
        [imoveis addObject:self.imovel];
        [favoritos writeToNSUserDefaultsWithArray:imoveis];
        
        self.favorites.image = [UIImage imageNamed:@"Star Filled-25"];
    }
    else {
        [imoveis removeObjectAtIndex:index];
        [favoritos removeFavorito];
        [favoritos writeToNSUserDefaultsWithArray:imoveis];
        
        self.favorites.image = [UIImage imageNamed:@"Star-25"];
    }
}

- (void)buttonEnviarEmail:(id)sender {
    [self enviarEmail];
}

- (void)buttonTelefonar:(id)sender {
    NSURL *url = [NSURL URLWithString:@"telprompt:123456789"];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    // Dismiss the mail composer
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [titleSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0)
        return [camposVisaoGeral count];
    
    return [camposCaractAdic count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [titleSections objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = nil;
    NSMutableArray *camposAux = nil;
    NSMutableArray *valoresAux = nil;
    
    if(indexPath.section == 0) {
        cellID = @"cellVisaoGeral";
        camposAux = [camposVisaoGeral mutableCopy];
        valoresAux = [valoresVisaoGeral mutableCopy];
    }
    else {
        cellID = @"cellCaractAdic";
        camposAux = [camposCaractAdic mutableCopy];
        valoresAux = [valoresCaractAdic mutableCopy];
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        
        cell.textLabel.text = [camposAux objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [valoresAux objectAtIndex:indexPath.row];
    }
    
    // Configure the cell...
    
    return cell;

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
    if ([segue.identifier isEqualToString:@"galeriaSegue"]) {
        
        FotosCollectionViewController *vc = segue.destinationViewController;
        vc.imagens = [imovel.fotos mutableCopy];
    }
    else if([segue.identifier isEqualToString:@"mapaSegue"]) {
        
    }
}

@end
