//
//  LoginViewController.h
//  ImovServices
//
//  Created by Renan Shin Mizukosi on 9/21/15.
//  Copyright © 2015 Renan Shin Mizukosi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate> {
    NSDictionary *json;
}

@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *senha;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *entrar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *fechar;
@property (nonatomic, retain) NSString *tela;

- (void)limpaCampos;
- (void)setJson;
- (NSDictionary *)getJson;
- (void)exibirAviso:(id)sender;

@end
