//
//  TTViewController.m
//  Gestures
//
//  Created by sergey on 3/2/14.
//  Copyright (c) 2014 sergey. All rights reserved.
//

#import "TTViewController.h"

@interface TTViewController ()

@property (weak,nonatomic) UIImageView *imgView;

@end

@implementation TTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    Ученик
//    
//    1. Добавьте квадратную картинку на вьюху вашего контроллера
//    2. Если хотите, можете сделать ее анимированной
    UIImage *img = [UIImage  imageNamed:@"tux.png"];
    UIImageView *view = [[UIImageView alloc]initWithImage:img];
    view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - img.size.width/4,[UIScreen mainScreen].bounds.size.height/2 - img.size.height/4, img.size.width/2, img.size.height/2);
    self.imgView = view;
    self.imgView.userInteractionEnabled = YES;
    self.imgView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:self.imgView];
//    Студент
//    
//    3. По тачу анимационно передвигайте картинку со ее позиции в позицию тача
//    4. Если я вдруг делаю тач во время анимации, то картинка должна двигаться в новую точку без рывка (как будто она едет себе и все)
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTouch:)];
    
    [self.view addGestureRecognizer:tap];
    
//    Мастер
//    
//    5. Если я делаю свайп вправо, то давайте картинке анимацию поворота по часовой стрелке на 360 градусов
//    6. То же самое для свайпа влево, только анимация должна быть против часовой (не забудьте остановить предыдущее кручение)
//    7. По двойному тапу двух пальцев останавливайте анимацию

    
}

- (void)tapTouch:(UITapGestureRecognizer *)gesture {
    
    self.imgView.frame = [[self.imgView.layer presentationLayer] frame];
    
    [UIView animateWithDuration:2
                     animations:^{
                         self.imgView.center = [gesture locationInView:self.view];
                     }];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
