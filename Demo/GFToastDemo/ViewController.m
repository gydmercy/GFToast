//
//  ViewController.m
//  GFToastDemo
//
//  Created by Mercy on 15/9/21.
//  Copyright (c) 2015年 Mercy. All rights reserved.
//

#import "ViewController.h"
#import "GFToast.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UIButton *button5;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)button1Action:(id)sender {
    [GFToast showToastInView:self.view
                   withImage:[UIImage imageNamed:@"toast_pic"]
                        text:@"用户名或密码错误，请重试"
                       style:GFToastStyleLight
                    position:GFToastShowPositionBottom
                    duration:GFToastShowTimeShort
                   animation:GFToastAnimationShakeInZoomOut];
}

- (IBAction)button2Action:(id)sender {
    [GFToast showToastInView:self.view
                   withImage:[UIImage imageNamed:@"toast_pic"]
                        text:@"用户名或密码错误，请重试"
                       style:GFToastStyleDark
                    position:GFToastShowPositionCenter
                    duration:GFToastShowTimeLong
                    animation:GFToastAnimationZoomInFadeOut];
}

- (IBAction)button3Action:(id)sender {
    [GFToast showToastInView:self.view
                   withImage:[UIImage imageNamed:@"toast_pic"]
                        text:@"用户名或密码错误，请重试"
                       style:GFToastStyleLight
                    position:GFToastShowPositionCenter
                    duration:GFToastShowTimeShort
                   animation:GFToastAnimationZoomInZoomOut];
}

- (IBAction)button4Action:(id)sender {
    [GFToast showToastInView:self.view
                    withText:@"用户名或密码错误，请重试"
                       style:GFToastStyleDark];
}

- (IBAction)button5Action:(id)sender {
    [GFToast showToastInView:self.view
                   withImage:nil
                        text:@"人生是一段旅程，在旅行中遇到的每一个人，每一件事与每一个美丽景色，都有可能成为一生中难忘的风景。一路走来，我们无法猜测将是迎接什么样的风景，没有预兆目的地在哪，可是前进的脚步却始终不能停下，因为时间不允许我们在任何地方停留，只有在前进中不断学会选择，学会体会，学会欣赏。"
                       style:GFToastStyleLight
                    position:GFToastShowPositionBottom
                    duration:GFToastShowTimeLong
                   animation:GFToastAnimationShakeInFadeOut];
}

@end
