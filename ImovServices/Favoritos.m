//
//  Favoritos.m
//  ImovServices
//
//  Created by Renan Shin Mizukosi on 10/27/15.
//  Copyright © 2015 Renan Shin Mizukosi. All rights reserved.
//

#import "Favoritos.h"

@implementation Favoritos

- (void)writeToNSUserDefaultsWithArray:(NSMutableArray *)imoveis {
    NSData *archivedObject = [NSKeyedArchiver archivedDataWithRootObject:imoveis];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:archivedObject forKey:@"favoritos"];
    [defaults synchronize];
}

- (NSMutableArray *)readFromNSUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *archivedObject = [defaults objectForKey:@"favoritos"];
    
    if(archivedObject != nil) {
        NSMutableArray *imoveis = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:archivedObject];
        
        return imoveis;
    }
    else
        return nil;
}

- (int)getIndexFromArrayWithID:(int)idImovel {
    NSMutableArray *imoveis = [[NSMutableArray alloc] initWithArray:[self readFromNSUserDefaults]];
    int index = 0;
    
    if(imoveis != nil) {
        for(int i=0; i<imoveis.count; i++) {
            if([[imoveis objectAtIndex:i] idImov] == idImovel)
                return index;
            
            index++;
        }
    }
    
    return -1;
}

- (void)removeFavorito {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"favoritos"];
    [defaults synchronize];
}

@end
