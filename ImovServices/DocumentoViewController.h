//
//  DocumentoViewController.h
//  ImovServices
//
//  Created by Renan Shin Mizukosi on 10/15/15.
//  Copyright © 2015 Renan Shin Mizukosi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "Tarefa.h"
#import "Autenticado.h"

@protocol DocumentoViewControllerDelegate <NSObject>

- (void)saveTarefa:(Tarefa *)tarefa;

@end

@interface DocumentoViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITabBarDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *fotoDoc;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *salvar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *gallery;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *share;
@property (weak, nonatomic) IBOutlet UIToolbar *myToolBar;

@property (nonatomic, retain) Tarefa *tarefa;
@property (nonatomic) id<DocumentoViewControllerDelegate> delegate;
@property (nonatomic) BOOL navigationBarIsShowing;

- (void)confirmaSalvar;
- (NSString *)getCurrentDate;

- (void)initializeCampos;
- (void)hideNavigationBar;
- (void)showNavigationBar;

@end
