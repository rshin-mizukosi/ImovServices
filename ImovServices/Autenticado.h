//
//  Autenticado.h
//  ImovServices
//
//  Created by Renan Shin Mizukosi on 9/30/15.
//  Copyright © 2015 Renan Shin Mizukosi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Login.h"

@interface Autenticado : NSObject {
    NSUserDefaults *defaults;
}

@property (nonatomic, retain) Login *login;

- (void)setAutenticadoWithPerfil:(Login *)perfil;
- (BOOL)isAutenticado;
- (BOOL)isImobiliaria;
- (void)removeAutenticado;
- (NSString *)getInfoPerfilWithKey:(NSString *)key;

@end
