//
//  PerfilTableViewController.m
//  ImovServices
//
//  Created by Renan Shin Mizukosi on 10/27/15.
//  Copyright © 2015 Renan Shin Mizukosi. All rights reserved.
//

#import "PerfilTableViewController.h"
#import "Autenticado.h"
#import "SWRevealViewController.h"

@interface PerfilTableViewController () {
    Autenticado *autenticado;
}

@end

@implementation PerfilTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    
    if(revealViewController) {
        [self.menuBar setTarget:self.revealViewController];
        [self.menuBar setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [self setPerfil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setPerfil {
    for(int i=0; i<3; i++)
        [self setDetailsRowForIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
}

- (void)setDetailsRowForIndexPath:(NSIndexPath *)indexPath {
    autenticado = [[Autenticado alloc] init];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if(indexPath.row == 0)
        cell.detailTextLabel.text = [autenticado getInfoPerfilWithKey:@"authEmail"];
    else if(indexPath.row == 1)
        cell.detailTextLabel.text = [autenticado getInfoPerfilWithKey:@"authNome"];
    else if(indexPath.row == 2) {
        cell.detailTextLabel.text = [autenticado getInfoPerfilWithKey:@"authPermissao"];
    }
    
    [self.tableView reloadData];
}

- (void)avisoLogout {
    UIAlertController *alerta = [UIAlertController alertControllerWithTitle:@"Atenção" message:@"Deseja fazer logout?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sim = [UIAlertAction actionWithTitle:@"Sim" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        autenticado = [[Autenticado alloc] init];
        
        [autenticado removeAutenticado];
        
        SWRevealViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
        [self presentViewController:vc animated:YES completion:nil];
    }];
    
    UIAlertAction *nao = [UIAlertAction actionWithTitle:@"Não" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alerta dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alerta addAction:sim];
    [alerta addAction:nao];
    
    [self presentViewController:alerta animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0)
        return 3;
    
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 1)
        [self avisoLogout];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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
