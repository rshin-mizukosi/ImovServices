//
//  Imovel.h
//  ImovServices
//
//  Created by Renan Shin Mizukosi on 9/23/15.
//  Copyright © 2015 Renan Shin Mizukosi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Imovel : NSObject <NSCoding>

@property (nonatomic) int idImov;
@property (nonatomic, retain) NSString *endereco;
@property (nonatomic, retain) NSString *bairro;
@property (nonatomic, retain) NSString *cep;
@property (nonatomic, retain) NSString *cidade;
@property (nonatomic, retain) NSString *uf;
@property (nonatomic, retain) NSMutableArray *fotos;
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

@end
