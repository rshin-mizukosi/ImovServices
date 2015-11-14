//
//  RegistrarTableViewController.m
//  ImovServices
//
//  Created by Renan Shin Mizukosi on 9/25/15.
//  Copyright © 2015 Renan Shin Mizukosi. All rights reserved.
//

#import "RegistrarTableViewController.h"
#import "MBProgressHUD.h"

@interface RegistrarTableViewController () <MBProgressHUDDelegate> {
    MBProgressHUD *hud;
}

@end

@implementation RegistrarTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nome.delegate = self;
    self.sobrenome.delegate = self;
    self.email.delegate = self;
    self.senha.delegate = self;
    
    self.registrar.target = self;
    self.registrar.action = @selector(buttonAction:);
    self.navigationItem.rightBarButtonItems = @[self.registrar];
    
    [self initializePickerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializePickerView {
    tiposUsuario = [[NSMutableArray alloc] init];
    [tiposUsuario addObject:@"Cliente"];
    [tiposUsuario addObject:@"Imobiliária"];
}

- (void)setJson {
    NSString *stringUrl = @"http://www.shintechnology.esy.es/imovservices/webservices/add_user.php";
    
    //transformando a string em uma url
    NSURL *url = [NSURL URLWithString:stringUrl];
    
    //Criando uma requisição com a url informada
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //Definindo o método como Post
    [request setHTTPMethod:@"POST"];
    
    //setando uma chave para acesso aos dados
    //[request setValue:@"1234567890" forHTTPHeaderField:@"chave-api"];
    
    //Adiciona o Data no Body(Corpo) da requisição
    [request setHTTPBody:[[NSString stringWithFormat:@"nome=%@&sobrenome=%@&email=%@&senha=%@", _nome.text, _sobrenome.text,_email.text, _senha.text] dataUsingEncoding:NSUTF8StringEncoding]];
    
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

- (NSDictionary *)getJson {
    return json;
}

- (void)exibirAviso {
    int status = [[[self getJson] objectForKey:@"status"] intValue];
    NSString *mensagem = [[self getJson] objectForKey:@"mensagem"];
    
    // mensagem com UIAlertController
    UIAlertController *alerta = [UIAlertController
                                 alertControllerWithTitle:@""
                                 message:@""
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alerta dismissViewControllerAnimated:YES completion:nil];
        
        if(status == 200)
            [self.navigationController popViewControllerAnimated:YES];
    }];
    
    if(status == 200) {
        _registrar.enabled = NO;
        [self limpaCampos];
        
        alerta.title = @"Sucesso";
    }
    else
        alerta.title = @"Atenção";
    
    alerta.message = mensagem;
    
    [alerta addAction:ok];
    [self presentViewController:alerta animated:YES completion:nil];
}

- (void)buttonAction:(id)sender {
    [self.view endEditing:YES];
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
    hud.labelText = @"Loading";
    hud.userInteractionEnabled = false;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.navigationController.navigationBar setUserInteractionEnabled:NO];
        [self.view setUserInteractionEnabled:NO];
        [self setJson];
        
        dispatch_async(dispatch_get_main_queue(),^{
            [hud hide:true];
            [self.navigationController.navigationBar setUserInteractionEnabled:YES];
            [self.view setUserInteractionEnabled:YES];
            [self exibirAviso];
        });
    });
}

- (void)limpaCampos {
    _nome.text = nil;
    _sobrenome.text = nil;
    _email.text = nil;
    _senha.text = nil;
}

// 3 metodos utilizados para habilitar/desabilitar botao REGISTRAR de acordo com o conteudo
// dos textfield (caso algum esteja em branco, botao fica desabilitado)
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:textField];
}

-(void)textDidChange:(NSNotification *)note {
    _registrar.enabled = _nome.text.length > 0 && _sobrenome.text.length > 0 && _email.text.length > 0 && _senha.text.length > 0;
}

// Atribui uma acao quando botao RETURN é acionado
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == _nome)
        [_sobrenome becomeFirstResponder];
    else if(textField == _sobrenome)
        [_email becomeFirstResponder];
    else if(textField == _email)
        [_senha becomeFirstResponder];
    else if(textField == _senha)
        [_senha resignFirstResponder];
    
    return YES;
}

// Esconde o teclado quando tocado na tela
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
