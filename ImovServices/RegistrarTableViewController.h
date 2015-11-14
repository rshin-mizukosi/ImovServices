//
//  RegistrarTableViewController.h
//  ImovServices
//
//  Created by Renan Shin Mizukosi on 9/25/15.
//  Copyright © 2015 Renan Shin Mizukosi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistrarTableViewController : UITableViewController <UITextFieldDelegate> {
    NSDictionary *json;
    NSMutableArray *tiposUsuario;
}

@property (weak, nonatomic) IBOutlet UITextField *nome;
@property (weak, nonatomic) IBOutlet UITextField *sobrenome;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *senha;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *registrar;

- (void)limpaCampos;
- (void)setJson;
- (NSDictionary *)getJson;
- (void)exibirAviso;
- (void)initializePickerView;

@end
