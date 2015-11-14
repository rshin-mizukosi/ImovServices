//
//  LoginViewController.m
//  ImovServices
//
//  Created by Renan Shin Mizukosi on 9/21/15.
//  Copyright © 2015 Renan Shin Mizukosi. All rights reserved.
//

#import "LoginViewController.h"
#import "MBProgressHUD.h"
#import "Autenticado.h"
#import "Login.h"
#import "SWRevealViewController.h"

@interface LoginViewController () <MBProgressHUDDelegate> {
    MBProgressHUD *hud;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.email.delegate = self;
    self.senha.delegate = self;
    
    _entrar.target = self;
    _entrar.action = @selector(buttonAction:);
    self.navigationItem.rightBarButtonItems = @[_entrar];
    
    _fechar.target = self;
    _fechar.action = @selector(fecharAction:);
    self.navigationItem.leftBarButtonItems = @[_fechar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setJson {
    NSString *stringUrl = @"http://www.shintechnology.esy.es/imovservices/webservices/login.php";
    
    //transformando a string em uma url
    NSURL *url = [NSURL URLWithString:stringUrl];
    
    //Criando uma requisição com a url informada
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //Definindo o método como Post
    [request setHTTPMethod:@"POST"];
    
    //setando uma chave para acesso aos dados
    //[request setValue:@"1234567890" forHTTPHeaderField:@"chave-api"];
    
    //Adiciona o Data no Body(Corpo) da requisição
    [request setHTTPBody:[[NSString stringWithFormat:@"email=%@&senha=%@", self.email.text, self.senha.text] dataUsingEncoding:NSUTF8StringEncoding]];
    
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

- (void)exibirAviso:(id)sender {
    int status = [[[self getJson] objectForKey:@"status"] intValue];
    NSString *mensagem = [[self getJson] objectForKey:@"mensagem"];
    NSDictionary *dicLogin = [[self getJson] objectForKey:@"data"];
    
    Login *login = nil;
    
    if(status == 200) {
        login = [[Login alloc] init];
        
        for(NSDictionary *temp in dicLogin) {
            [login setIdUsuario:[[temp objectForKey:@"ID_USUARIO"] intValue]];
            [login setEmail:[temp objectForKey:@"EMAIL"]];
            
            [login setSenha:[temp objectForKey:@"SENHA"]];
            [login setNome:[temp objectForKey:@"NOME"]];
            [login setSobrenome:[temp objectForKey:@"SOBRENOME"]];
            [login setSessao:[temp objectForKey:@"SESSAO"]];
            [login setAtivo:[[temp objectForKey:@"ATIVO"] intValue]];
            [login setPermissao:[[temp objectForKey:@"PERMISSAO"] intValue]];
        }
        
        Autenticado *autenticado = [[Autenticado alloc] init];
        [autenticado setAutenticadoWithPerfil:login];
        
        _entrar.enabled = NO;
        [self limpaCampos];
        
        SWRevealViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
        [self presentViewController:vc animated:YES completion:nil];
        
        /*
        SWRevealViewController *swRevealViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
        
        [self.navigationController showDetailViewController:swRevealViewController sender:sender];
        */
    }
    else {
        // mensagem com UIAlertController
        UIAlertController *alerta = [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@""
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [alerta dismissViewControllerAnimated:YES completion:nil];
        }];
        
        alerta.title = @"Atenção";
        alerta.message = mensagem;
        
        [alerta addAction:ok];
        [self presentViewController:alerta animated:YES completion:nil];
    }
}

- (void)fecharAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)buttonAction:(id)sender {
    self.entrar.enabled = NO;
    
    [self.view endEditing:YES];
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
    hud.labelText = @"Loading";
    hud.userInteractionEnabled = NO;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.navigationController.navigationBar setUserInteractionEnabled:NO];
        [self.view setUserInteractionEnabled:NO];
        [self setJson];
        
        dispatch_async(dispatch_get_main_queue(),^{
            [hud hide:true];
            [self.navigationController.navigationBar setUserInteractionEnabled:YES];
            [self.view setUserInteractionEnabled:YES];
            [self exibirAviso:sender];
        });
    });
}

- (void)limpaCampos {
    self.email.text = nil;
    self.senha.text = nil;
}

// 3 metodos utilizados para habilitar/desabilitar botao ENTRAR de acordo com o conteudo
// dos textfield (caso algum esteja em branco, botao fica desabilitado)
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
    
    //[self animateTextField:textField up:YES withOffset:textField.frame.origin.y / 2];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:textField];
    //[self animateTextField:textField up:NO withOffset:textField.frame.origin.y / 2];
}

-(void)textDidChange:(NSNotification *)note {
    _entrar.enabled = self.email.text.length > 0 && self.senha.text.length > 0;
}

// Atribui uma acao quando botao RETURN é acionado
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.email)
        [self.senha becomeFirstResponder];
    else if(textField == self.senha)
        [self.senha resignFirstResponder];
    
    return YES;
}

// Esconde o teclado quando tocado na tela
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

/*
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
*/

/*
- (void)animateTextField:(UITextField *)textField up:(BOOL)up withOffset:(CGFloat)offset {
    const int movementDistance = -offset;
    const float movementDuration = 0.4f;
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations:@"animateTextField" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
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
