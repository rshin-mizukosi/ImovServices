//
//  SenhaViewController.m
//  ImovServices
//
//  Created by Renan Shin Mizukosi on 9/21/15.
//  Copyright © 2015 Renan Shin Mizukosi. All rights reserved.
//

#import "SenhaViewController.h"
#import "MBProgressHUD.h"

@interface SenhaViewController () <MBProgressHUDDelegate> {
    MBProgressHUD *hud;
}

@end

@implementation SenhaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _email.delegate = self;
    _enviar.target = self;
    
    _enviar.action = @selector(buttonAction:);
    self.navigationItem.rightBarButtonItems = @[_enviar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setJson {
    NSString *stringUrl = [NSString stringWithFormat:@"http://www.shintechnology.esy.es/imovservices/webservices/redefinir_senha.php?email=%@", _email.text];
    
    //transformando a string em uma url
    NSURL *url = [NSURL URLWithString:stringUrl];
    
    //criando o NSData e fazendo um request
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    //transformando o NSDATA para NSDICTIONARY o NSJSONSerialization faz o Parser do JSON
    NSError *error;
    json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
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
        _enviar.enabled = NO;
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
    _email.text = nil;
}

// 3 metodos utilizados para habilitar/desabilitar botao ENVIAR de acordo com o conteudo
// dos textfield (caso algum esteja em branco, botao fica desabilitado)
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:textField];
}

-(void)textDidChange:(NSNotification *)note {
    _enviar.enabled = _email.text.length > 0;
}

// Atribui uma acao quando botao RETURN é acionado
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == _email)
        [_email resignFirstResponder];
    
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
