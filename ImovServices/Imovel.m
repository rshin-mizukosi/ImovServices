//
//  Imovel.m
//  ImovServices
//
//  Created by Renan Shin Mizukosi on 9/23/15.
//  Copyright © 2015 Renan Shin Mizukosi. All rights reserved.
//

#import "Imovel.h"

@implementation Imovel

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    
    if(self) {
        self.idImov = [decoder decodeIntForKey:@"ID_IMOVEL"];
        self.endereco = [decoder decodeObjectForKey:@"ATTR_ENDERECO1"];
        self.bairro = [decoder decodeObjectForKey:@"ATTR_ENDERECO3"];
        self.cep = [decoder decodeObjectForKey:@"CEP"];
        self.cidade = [decoder decodeObjectForKey:@"CIDADE"];
        self.uf = [decoder decodeObjectForKey:@"UF"];
        [self.fotos addObject:[decoder decodeObjectForKey:@"FOTO_1"]];
        [self.fotos addObject:[decoder decodeObjectForKey:@"FOTO_2"]];
        [self.fotos addObject:[decoder decodeObjectForKey:@"FOTO_3"]];
        self.qtdQuarto = [decoder decodeIntForKey:@"QUARTO"];
        self.qtdSuite = [decoder decodeIntForKey:@"SUITE"];
        self.qtdBanheiro = [decoder decodeIntForKey:@"BANHEIRO"];
        self.qtdDispensa = [decoder decodeIntForKey:@"DISPENSA"];
        self.area = [decoder decodeDoubleForKey:@"METRAGEM"];
        self.preco = [decoder decodeDoubleForKey:@"VALOR_PROPOSTO"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInt:self.idImov forKey:@"ID_IMOVEL"];
    [encoder encodeObject:self.endereco forKey:@"ATTR_ENDERECO1"];
    [encoder encodeObject:self.bairro forKey:@"ATTR_ENDERECO3"];
    [encoder encodeObject:self.cep forKey:@"CEP"];
    [encoder encodeObject:self.cidade forKey:@"CIDADE"];
    [encoder encodeObject:self.uf forKey:@"UF"];
    
    NSString *key = @"FOTO_";
    
    for(int i=0; i<[self.fotos count]; i++) {
        [encoder encodeObject:[self.fotos objectAtIndex:i] forKey:[NSString stringWithFormat:@"%@%d", key, i]];
    }
    
    [encoder encodeInt:self.qtdQuarto forKey:@"QUARTO"];
    [encoder encodeInt:self.qtdSuite forKey:@"SUITE"];
    [encoder encodeInt:self.qtdBanheiro forKey:@"BANHEIRO"];
    [encoder encodeInt:self.qtdDispensa forKey:@"DISPENSA"];
    [encoder encodeDouble:self.area forKey:@"METRAGEM"];
    [encoder encodeDouble:self.preco forKey:@"VALOR_PROPOSTO"];
}

@end

/*
 @property (nonatomic, retain) NSString *cep;
 @property (nonatomic, retain) NSString *cidade;
 @property (nonatomic, retain) NSString *uf;
 @property (nonatomic, retain) NSString *foto1;
 @property (nonatomic, retain) NSString *foto2;
 @property (nonatomic, retain) NSString *foto3;
 @property (nonatomic) int qtdQuarto;
 @property (nonatomic) int qtdBanheiro;
 @property (nonatomic) int qtdSuite;
 @property (nonatomic) int qtdDispensa;
 @property (nonatomic) double area;
 @property (nonatomic) double preco;
 
 @property (nonatomic) BOOL temQuintal;
 @property (nonatomic) BOOL temVaranda;
 @property (nonatomic) BOOL temSalaoJogos;
 @property (nonatomic) BOOL temSalaoFesta;
 @property (nonatomic) BOOL temChurraqueira;
 @property (nonatomic) BOOL temPiscina;
 @property (nonatomic) BOOL temVarandaGourmet;
*/
