//
//  Favoritos.h
//  ImovServices
//
//  Created by Renan Shin Mizukosi on 10/27/15.
//  Copyright © 2015 Renan Shin Mizukosi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Imovel.h"

@interface Favoritos : NSObject

- (void)writeToNSUserDefaultsWithArray:(NSMutableArray *)imoveis;
- (NSMutableArray *)readFromNSUserDefaults;
- (int)getIndexFromArrayWithID:(int)idImovel;
- (void)removeFavorito;

@end
