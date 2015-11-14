//
//  EnderecoTableViewController.m
//  ImovServices
//
//  Created by Renan Shin Mizukosi on 10/30/15.
//  Copyright © 2015 Renan Shin Mizukosi. All rights reserved.
//

#import "EnderecoTableViewController.h"

@interface EnderecoTableViewController ()

@end

@implementation EnderecoTableViewController
@synthesize cidades, cidadesFiltrado;
@synthesize estados, estadosFiltrado;
@synthesize resultSearchController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeArrays];
    [self setParametersSearchBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeArrays {
    estados = [[NSMutableArray alloc] init];
    estadosFiltrado = [[NSMutableArray alloc] init];
    
    NSURL *url = [NSURL URLWithString:@"http://www.shintechnology.esy.es/imovservices/webservices/todos_estados.php"];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    NSDictionary *dictEstados = [json objectForKey:@"data"];
    NSString *strEstado = [[NSString alloc] init];
    
    for(NSDictionary *temp in dictEstados) {
        strEstado = [temp objectForKey:@"SIGLA"];
        
        [estados addObject:strEstado];
    }
}

- (void)setParametersSearchBar {
    resultSearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    
    resultSearchController.searchResultsUpdater = self;
    resultSearchController.dimsBackgroundDuringPresentation = NO;
    resultSearchController.searchBar.placeholder = @"Rua, cidade, estado, ...";
    [resultSearchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = resultSearchController.searchBar;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(resultSearchController.active)
        return estadosFiltrado.count;
    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(resultSearchController.active)
        return @"Search results";
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    // Configure the cell...
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    
    if(resultSearchController.active)
        cell.textLabel.text = [estadosFiltrado objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [estadosFiltrado removeAllObjects];
    
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchController.searchBar.text];
    NSArray *filteredData = [estados filteredArrayUsingPredicate:searchPredicate];
    
    estadosFiltrado = [filteredData mutableCopy];
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *texto = [[NSString alloc] init];
    
    if(resultSearchController.active) {
        texto = [estadosFiltrado objectAtIndex:indexPath.row];
        resultSearchController.active = NO;
    }
    else
        texto = [estados objectAtIndex:indexPath.row];
    
    [self.delegate setEnderecoWithString:texto];
    [self.navigationController popViewControllerAnimated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
