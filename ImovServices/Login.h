//
//  Login.h
//  ImovServices
//
//  Created by Renan Shin Mizukosi on 10/20/15.
//  Copyright © 2015 Renan Shin Mizukosi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Login : NSObject

@property (nonatomic) int idUsuario;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *senha;
@property (nonatomic, retain) NSString *nome;
@property (nonatomic, retain) NSString *sobrenome;
@property (nonatomic, retain) NSString *sessao;
@property (nonatomic) int ativo;
@property (nonatomic) int permissao;

@end
