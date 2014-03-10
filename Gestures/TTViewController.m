//
//  TTViewController.m
//  Gestures
//
//  Created by sergey on 3/2/14.
//  Copyright (c) 2014 sergey. All rights reserved.
//

#import "TTViewController.h"

@interface TTViewController () <UIGestureRecognizerDelegate>

@property (weak,nonatomic) UIImageView *imgView;
@property (assign,nonatomic) CGFloat scale;
@property (assign,nonatomic) CGFloat deltaRotation;

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
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightSwipeGesture:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftSwipeGesture:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapTouch:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    
//    Супермен
//    
//    8. Добавьте возможность зумить и отдалять картинку используя пинч
//    9. Добавьте возможность поворачивать картинку используя ротейшн
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchGesture:)];
    pinch.scale = 2.0;
    pinch.delegate = self;
    [self.view addGestureRecognizer:pinch];
    
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotationGesture:)];
    rotation.delegate = self;
    [self.view addGestureRecognizer:rotation];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)rotationGesture:(UIRotationGestureRecognizer *)gesture {

    CGAffineTransform transform = self.imgView.transform;
    
    CGFloat newRotation = gesture.rotation - self.deltaRotation;
    
    self.imgView.transform = CGAffineTransformRotate(transform, newRotation);
    
    self.deltaRotation = gesture.rotation;
    
}

- (void)pinchGesture:(UIPinchGestureRecognizer *)gesture {

    NSLog(@"%f",gesture.velocity);
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.scale = 1.f;
    }
    
    CGAffineTransform curentTransform = self.imgView.transform;
    
    CGFloat transform = 1.f + gesture.scale - self.scale;
    
    
    CGAffineTransform newTransform = CGAffineTransformScale(curentTransform, transform, transform);
    
    self.imgView.transform = newTransform;
    
    self.scale = gesture.scale;
    
}

- (void)runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations {
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:rotations];
    rotationAnimation.duration = duration;
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)doubleTapTouch:(UITapGestureRecognizer *)gesture {
    
    [self.imgView.layer removeAllAnimations];
    CGPoint point = CGPointMake(CGRectGetMidX([[self.imgView.layer presentationLayer] frame]), CGRectGetMidY([[self.imgView.layer presentationLayer] frame]));
    self.imgView.center = point;
}

- (void)leftSwipeGesture:(UISwipeGestureRecognizer *)gesture {
    
    [self runSpinAnimationOnView:self.imgView duration:2.0 rotations:M_PI*2 ];
}

- (void)rightSwipeGesture:(UISwipeGestureRecognizer *)gesture {

    [self runSpinAnimationOnView:self.imgView duration:2.0 rotations:-M_PI*2 ];
}

- (void)tapTouch:(UITapGestureRecognizer *)gesture {
    
    [self.imgView.layer removeAllAnimations];
    CGPoint point = CGPointMake(CGRectGetMidX([[self.imgView.layer presentationLayer] frame]), CGRectGetMidY([[self.imgView.layer presentationLayer] frame]));
    self.imgView.center = point;
    
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
