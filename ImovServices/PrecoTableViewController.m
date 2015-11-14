//
//  PrecoTableViewController.m
//  ImovServices
//
//  Created by Renan Shin Mizukosi on 10/19/15.
//  Copyright © 2015 Renan Shin Mizukosi. All rights reserved.
//

#import "PrecoTableViewController.h"

@interface PrecoTableViewController ()

@end

@implementation PrecoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeVar];
}

- (void)initializeVar {
    self.okButton.target = self;
    self.okButton.action = @selector(buttonOK:);
    self.minPreco.delegate = self;
    self.maxPreco.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAlerta {
    UIAlertController *alerta = [UIAlertController alertControllerWithTitle:@"Atenção" message:@"Preço máximo deve ser maior ou igual ao preço mínimo" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alerta dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alerta addAction:ok];
    [self presentViewController:alerta animated:YES completion:nil];
}

- (void)buttonOK:(id)sender {
    double minPreco = [self.minPreco.text doubleValue];
    double maxPreco = [self.maxPreco.text doubleValue];
    
    if(maxPreco > 0 && maxPreco < minPreco)
        [self showAlerta];
    else {
        [self.delegate setFaixaPrecoWithMinPreco:minPreco andMaxPreco:maxPreco];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// Atribui uma acao quando botao RETURN é acionado
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.minPreco)
        [self.maxPreco becomeFirstResponder];
    else if(textField == self.maxPreco)
        [self.maxPreco resignFirstResponder];
    
    return YES;
}

// 3 metodos utilizados para habilitar/desabilitar botao OK de acordo com o conteudo
// dos textfield (caso algum esteja em branco, botao fica desabilitado)
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:textField];
}

-(void)textDidChange:(NSNotification *)note {
    self.okButton.enabled = self.minPreco.text.length > 0 || self.maxPreco.text.length > 0;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
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
