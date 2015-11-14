//
//  NavigationTableViewController.m
//  ImovServices
//
//  Created by Renan Shin Mizukosi on 9/21/15.
//  Copyright © 2015 Renan Shin Mizukosi. All rights reserved.
//

#import "NavigationTableViewController.h"
#import "SWRevealViewController.h"
#import "Autenticado.h"
#import "LoginViewController.h"

@interface NavigationTableViewController () {
    Autenticado *autenticado;
}

@end

@implementation NavigationTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    
    if(self) {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    principal = [[NSMutableArray alloc] init];
    sobre = [[NSMutableArray alloc] init];
    login = [[NSMutableArray alloc] init];
    
    imagensPrincipal = [[NSMutableArray alloc] init];
    imagensSobre = [[NSMutableArray alloc] init];
    imagensLogin = [[NSMutableArray alloc] init];
    
    autenticado = [[Autenticado alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self setItemsMenu];
}

- (void)setItemsMenu {
    [principal removeAllObjects];
    [imagensPrincipal removeAllObjects];
    [sobre removeAllObjects];
    [imagensSobre removeAllObjects];
    [login removeAllObjects];
    [imagensLogin removeAllObjects];
    
    [principal addObject:@"Buscar imóveis"];
    [principal addObject:@"Agendamento"];
    [principal addObject:@"Imóveis em interesse"];
    
    [imagensPrincipal addObject:@"Search-25"];
    [imagensPrincipal addObject:@"Calendar-25"];
    [imagensPrincipal addObject:@"Todo List-25"];
    
    if([autenticado isAutenticado]) {
        [login addObject:@"Meu perfil"];
        [imagensLogin addObject:@"Edit User-25"];
    }
    else {
        [login addObject:@"Login"];
        
        [imagensLogin addObject:@"Key-25"];
    }
    
    [sobre addObject:@"Institucional"];
    [sobre addObject:@"Fale conosco"];
    
    [imagensSobre addObject:@"Organization-25"];
    [imagensSobre addObject:@"Message-25"];
}

- (void)enviarEmail {
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    
    mailComposer.mailComposeDelegate = self;
    
    [mailComposer setSubject:@"App ImovServices"];
    [mailComposer setToRecipients:@[@"sac@imovservices.com.br"]];
    
    // Display the mail composer
    [self presentViewController:mailComposer animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 1)
        return @"Sobre o ImovServices";
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberRows = 0;
    
    switch (section) {
        case 0:
            numberRows = 3;
            break;
        case 1:
            numberRows = 2;
            break;
        case 2:
            numberRows = 1;
            break;
        default:
            break;
    }
    
    return numberRows;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            if(indexPath.row == 0)
                [self performSegueWithIdentifier:@"buscaSegue" sender:nil];
            else if(indexPath.row == 1) {
                [self avisoLoginWithTitle:@"Agendamento" andMessage:@"Tela em fase de implementação"];
                /*if(![autenticado isAutenticado])
                    [self avisoLoginWithTitle:@"agendamento"];
                else
                    [self performSegueWithIdentifier:@"agendaSegue" sender:nil];*/
            }
            else {
                if(![autenticado isAutenticado])
                    [self avisoLoginWithTitle:@"Acesso negado" andMessage:@"Usuário precisa logar-se para acessar a tela de Imóveis em interesse"];
                else
                    [self performSegueWithIdentifier:@"listaSegue" sender:nil];
            }
            break;
        case 1:
            if(indexPath.row == 0)
                [self performSegueWithIdentifier:@"sobreSegue" sender:nil];
            else
                [self enviarEmail];
            break;
        case 2:
            if(![autenticado isAutenticado]) {
                //[self performSegueWithIdentifier:@"loginSegue" sender:nil];
                LoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                [self presentViewController:vc animated:YES completion:nil];
            }
            else {
                [self performSegueWithIdentifier:@"perfilSegue" sender:nil];
                //[self avisoLogout];
            }
            break;
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *principalCellID = @"principalCell";
    static NSString *sobreCellID = @"sobreCell";
    static NSString *loginCellID = @"loginCell";
    UITableViewCell *cell = nil;
    
    switch (indexPath.section) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:principalCellID];
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:sobreCellID];
            break;
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:loginCellID];
            break;
        default:
            break;
    }
    
    if(cell == nil) {
        switch (indexPath.section) {
            case 0:
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:principalCellID];
                break;
            case 1:
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sobreCellID];
                break;
            case 2:
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:loginCellID];
                break;
            default:
                break;
        }
    }
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = [principal objectAtIndex:indexPath.row];
            cell.imageView.image = [UIImage imageNamed:[imagensPrincipal objectAtIndex:indexPath.row]];
            break;
        case 1:
            cell.textLabel.text = [sobre objectAtIndex:indexPath.row];
            cell.imageView.image = [UIImage imageNamed:[imagensSobre objectAtIndex:indexPath.row]];
            break;
        case 2:
            cell.textLabel.text = [login objectAtIndex:indexPath.row];
            cell.imageView.image = [UIImage imageNamed:[imagensLogin objectAtIndex:indexPath.row]];
            break;
        default:
            break;
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // Configure the cell...
    
    return cell;
}

- (void)avisoLogout {
    UIAlertController *alerta = [UIAlertController alertControllerWithTitle:@"Atenção" message:@"Deseja realmente efetuar logout?" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *sair = [UIAlertAction actionWithTitle:@"Sair" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [autenticado removeAutenticado];
        [self setItemsMenu];
        [self.myTableView reloadData];
        [self performSegueWithIdentifier:@"buscaSegue" sender:nil];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alerta dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alerta addAction:sair];
    [alerta addAction:cancel];
    [self presentViewController:alerta animated:YES completion:nil];
}

- (void)avisoLoginWithTitle:(NSString *)title andMessage:(NSString *)message {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    if(indexPath.section == 0 && indexPath.row == 1) {
        UIAlertController *alerta = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alerta addAction:ok];
        
        [self presentViewController:alerta animated:YES completion:nil];
    }
    else if(indexPath.section == 0 && indexPath.row == 2) {
        UIAlertController *alerta = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *logar = [UIAlertAction actionWithTitle:@"Login" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            LoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            [self presentViewController:vc animated:YES completion:nil];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [alerta dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alerta addAction:logar];
        [alerta addAction:cancel];
        
        [self presentViewController:alerta animated:YES completion:nil];
    }
}

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

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    // Dismiss the mail composer
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue isKindOfClass:[SWRevealViewControllerSegue class]]) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue *) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
    }
}

@end
