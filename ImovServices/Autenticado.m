//
//  Autenticado.m
//  ImovServices
//
//  Created by Renan Shin Mizukosi on 9/30/15.
//  Copyright © 2015 Renan Shin Mizukosi. All rights reserved.
//

#import "Autenticado.h"

@implementation Autenticado
@synthesize login;

- (void)setAutenticadoWithPerfil:(Login *)perfil {
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:perfil.email forKey:@"authEmail"];
    [defaults setObject:perfil.senha forKey:@"authSenha"];
    [defaults setObject:[NSString stringWithFormat:@"%@ %@", perfil.nome, perfil.sobrenome] forKey:@"authNome"];
    [defaults setInteger:perfil.permissao forKey:@"authPermissao"];
    
    login = [[Login alloc] init];
    [login setEmail:perfil.email];
    [login setSenha:perfil.senha];
    [login setNome:perfil.nome];
    [login setPermissao:perfil.permissao];
    
    [defaults synchronize];
}

- (BOOL)isAutenticado {
    defaults = [NSUserDefaults standardUserDefaults];
    NSString *e = [defaults objectForKey:@"authEmail"];
    NSString *s = [defaults objectForKey:@"authSenha"];
    
    if(e == nil || s == nil)
        return NO;
    
    return YES;
}

- (BOOL)isImobiliaria {
    defaults = [NSUserDefaults standardUserDefaults];
    NSInteger permissao = [defaults integerForKey:@"authPermissao"];
    
    if(permissao == 0)
        return NO;
    
    return YES;
}

- (void)removeAutenticado {
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"authEmail"];
    [defaults removeObjectForKey:@"authSenha"];
    [defaults removeObjectForKey:@"authNome"];
    [defaults removeObjectForKey:@"authPermissao"];
    [defaults synchronize];
}

- (NSString *)getInfoPerfilWithKey:(NSString *)key {
    defaults = [NSUserDefaults standardUserDefaults];
    
    if([key isEqualToString:@"authPermissao"]) {
        if([self isImobiliaria])
            return @"Imobiliária";
        else
            return @"Usuário";
    }
    
    return [defaults objectForKey:key];
}

@end
