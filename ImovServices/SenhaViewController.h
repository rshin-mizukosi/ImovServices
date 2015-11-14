//
//  SenhaViewController.h
//  ImovServices
//
//  Created by Renan Shin Mizukosi on 9/21/15.
//  Copyright © 2015 Renan Shin Mizukosi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SenhaViewController : UIViewController <UITextFieldDelegate> {
    NSDictionary *json;
}

@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *enviar;

- (void)limpaCampos;
- (void)setJson;
- (NSDictionary *)getJson;
- (void)exibirAviso;

@end
