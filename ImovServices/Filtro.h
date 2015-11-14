//
//  Filtro.h
//  ImovServices
//
//  Created by Renan Shin Mizukosi on 10/19/15.
//  Copyright © 2015 Renan Shin Mizukosi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Filtro : NSObject

@property (nonatomic, retain) NSString *endereco;
@property (nonatomic) double minPreco;
@property (nonatomic) double maxPreco;
@property (nonatomic) int minArea;
@property (nonatomic) int maxArea;
@property (nonatomic) int qtdQuartos;
@property (nonatomic) int qtdSuites;
@property (nonatomic) int qtdBanheiros;
@property (nonatomic, retain) NSString *ordenacao;
@property (nonatomic, retain) NSString *tipo_ordenacao;

@end
