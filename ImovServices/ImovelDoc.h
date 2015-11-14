//
//  ImovelDoc.h
//  ImovServices
//
//  Created by Renan Shin Mizukosi on 11/3/15.
//  Copyright © 2015 Renan Shin Mizukosi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Imovel.h"

@interface ImovelDoc : NSObject

@property(nonatomic, retain)Imovel *imovel;
@property(nonatomic, retain)NSMutableArray *listaDocs;

@end
