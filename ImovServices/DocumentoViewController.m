//
//  DocumentoViewController.m
//  ImovServices
//
//  Created by Renan Shin Mizukosi on 10/15/15.
//  Copyright © 2015 Renan Shin Mizukosi. All rights reserved.
//

#import "DocumentoViewController.h"

@interface DocumentoViewController ()

@end

@implementation DocumentoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initializeCampos];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeCampos {
    [self.navigationItem setTitle:self.tarefa.titulo];
    
    Autenticado *autenticado = [[Autenticado alloc] init];
    
    // Se tipo de usuário for imobiliária, bloqueia os botões de salvar a imagem e abrir galeria de fotos.
    // Se for usuário comum, habilita estes botões
    if(![autenticado isImobiliaria]) {
        self.salvar.target = self;
        self.salvar.action = @selector(buttonSalvar:);
        
        self.gallery.target = self;
        self.gallery.action = @selector(buttonChoosePhoto:);
    }
    else {
        self.salvar.enabled = NO;
        self.gallery.enabled = NO;
    }
    
    self.share.target = self;
    self.share.action = @selector(buttonShare:);
        
    self.navigationBarIsShowing = YES;
    
    if([self.tarefa.strImage isKindOfClass:[NSString class]])
        self.fotoDoc.image = [self decodeToBase64String:self.tarefa.strImage];
}

- (void)confirmaSalvar {
    UIAlertController *alerta = [UIAlertController alertControllerWithTitle:@"Confirmação" message:@"Deseja salvar este documento?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sim = [UIAlertAction actionWithTitle:@"Sim" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //self.tarefa.detalhe = [NSString stringWithFormat:@"Alterada em: %@", [self getCurrentDate]];
        self.tarefa.strImage = [self encodeToBase64String:self.fotoDoc.image];
        [self.delegate saveTarefa:self.tarefa];
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    UIAlertAction *nao = [UIAlertAction actionWithTitle:@"Não" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alerta dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alerta addAction:sim];
    [alerta addAction:nao];
    
    [self presentViewController:alerta animated:YES completion:nil];
}

- (void)buttonSalvar:(id)sender {
    [self confirmaSalvar];
}

- (NSString *)encodeToBase64String:(UIImage *)imagem {
    return [UIImagePNGRepresentation(imagem) base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
}

- (UIImage *)decodeToBase64String:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    return [UIImage imageWithData:data];
}

- (NSString *)getCurrentDate {
    NSDate *hoje = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy hh:mm:ss"];
    NSString *dateString = [dateFormat stringFromDate:hoje];
    
    return dateString;
}

- (void)buttonChoosePhoto:(id)sender {
    UIImagePickerController *myPickerController = [[UIImagePickerController alloc] init];
    
    myPickerController.delegate = self;
    myPickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:myPickerController animated:YES completion:nil];
}

- (void)buttonShare:(id)sender {
    //UIImageWriteToSavedPhotosAlbum(self.fotoDoc.image, self, nil, nil);
    
    Autenticado *autenticado = [[Autenticado alloc] init];
    
    NSArray *objectsToShare = @[self.fotoDoc.image];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = nil;
    
    if([autenticado isImobiliaria]) {
        excludeActivities = @[UIActivityTypeAddToReadingList,
                              UIActivityTypeAssignToContact,
                              UIActivityTypeOpenInIBooks,
                              UIActivityTypePostToVimeo];
    }
    else {
        excludeActivities = @[UIActivityTypeAddToReadingList,
                              UIActivityTypeAssignToContact,
                              UIActivityTypeOpenInIBooks,
                              UIActivityTypePostToFacebook,
                              UIActivityTypePostToFlickr,
                              UIActivityTypePostToTencentWeibo,
                              UIActivityTypePostToTwitter,
                              UIActivityTypePostToVimeo,
                              UIActivityTypePostToWeibo,
                              UIActivityTypePrint,
                              UIActivityTypeSaveToCameraRoll];
    }
    
    activityVC.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)showNavigationBar {
    self.navigationController.navigationBar.alpha = 1.0;
    self.myToolBar.alpha = 1.0;
    //[self.myToolBar setHidden:NO];
    //self.navigationController.toolbar.alpha = 1.0;
    self.navigationBarIsShowing = YES;
}

- (void)hideNavigationBar {
    self.navigationController.navigationBar.alpha = 0.0;
    self.myToolBar.alpha = 0.0;
    //[self.myToolBar setHidden:YES];
    //self.navigationController.toolbar.alpha = 0.0;
    self.navigationBarIsShowing = NO;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.fotoDoc;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    
    if(self.navigationBarIsShowing)
        [self hideNavigationBar];
    else
        [self showNavigationBar];
    
    [UIView commitAnimations];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *imagem = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    self.fotoDoc.image = imagem;
    [self dismissViewControllerAnimated:YES completion:nil];
    self.salvar.enabled = YES;
}

@end
