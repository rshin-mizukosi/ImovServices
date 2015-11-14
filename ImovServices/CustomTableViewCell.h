//
//  CustomTableViewCell.h
//  ImovServices
//
//  Created by Renan Shin Mizukosi on 9/30/15.
//  Copyright © 2015 Renan Shin Mizukosi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *endereco;
@property (weak, nonatomic) IBOutlet UILabel *quarto;
@property (weak, nonatomic) IBOutlet UILabel *suite;
@property (weak, nonatomic) IBOutlet UILabel *banheiro;
@property (weak, nonatomic) IBOutlet UILabel *area;
@property (weak, nonatomic) IBOutlet UILabel *preco;
@property (weak, nonatomic) IBOutlet UILabel *bairro;

@property (weak, nonatomic) IBOutlet UIImageView *imagem;

@end
