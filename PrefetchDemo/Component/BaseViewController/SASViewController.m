//
//  SASViewController.m
//  Le123PhoneClient
//
//  Created by CaiLei on 1/3/14.
//  Copyright (c) 2014 Ying Shi Da Quan. All rights reserved.
//

#import "SASViewController.h"
#import "UIButton+NTYExtension.h"
@interface SASViewController ()

@end

@implementation SASViewController
- (instancetype)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder*)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)dealloc {
    NSLogInfo(@"%@", NSStringFromClass([self class]));
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:[self preferredStatusBarStyle]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[MobClick beginLogPageView:NSStringFromClass([self class])];
    [[UIApplication sharedApplication] setStatusBarStyle:[self preferredStatusBarStyle]];

    #warning "temp comment"
    // 刷新记录上一个页面和当前页面的信息
    //ReportCenter.lastControllerName    = ReportCenter.currentControllerName;
    //ReportCenter.currentControllerName = NSStringFromClass([self class]);
    //[[DQGlobalSingelton shared] reportPvAndUvWithCurUrl:[DQGlobalSingelton shared].UmengTmpClassName
    //                                                ref:className];
    //[DQGlobalSingelton shared].UmengTmpClassName = className;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSString *className = @(object_getClassName(self));
    //[MobClick endLogPageView:className];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /// 包含在 UINavigationController
    if (self.navigationController && [self.navigationController.viewControllers containsObject:self]) {
        /// 不是rootViewController
        if (self.navigationController.viewControllers.firstObject != self) {
            UIView   *backButtonContainer = [[UIView alloc] initWithFrame:RECT(0.0f, 0.0f, 60.0f, 44.0f)];
            UIButton *backButton          = [[UIButton buttonWithType:UIButtonTypeCustom] sas_decorate:^(__kindof UIButton*_Nonnull button) {
                button.frame = RECT(0.0f, 0.0f, 60.0f, 44.0f);
                //button.tintColor = DQ_COLOR_BLACK;
                if (self.presentingViewController == nil) {
                    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
                    [button setImage:[UIImage imageNamed:@"back_click"] forState:UIControlStateSelected];
                    button.imageView.contentMode = UIViewContentModeCenter;
                    button.imageEdgeInsets = UIEdgeInsetsMake(0, -22, 0, 0);
                    [button addTarget:self forClickAction:@selector(backAction)];
                } else {
                    [button setTitle:@"关闭" forState:UIControlStateNormal];
                    [button addTarget:self forClickAction:@selector(closeAction)];
                }
            }];
            [backButtonContainer addSubview:backButton];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButtonContainer];
        }
    }

    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backBarButtonItem;
}

- (void)setTitle:(NSString*)title {
    [super setTitle:title];
    if (!self.navigationItem.titleView) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 120, 44)];
        label.textColor               = [UIColor blackColor];
        label.textAlignment           = NSTextAlignmentCenter;
        label.font                    = [UIFont systemFontOfSize:20.0f];
        label.text                    = self.title;
        label.tag                     = 888;
        self.navigationItem.titleView = label;
    } else {
        UILabel *label = [UILabel cast:self.navigationItem.titleView];
        label.text = title;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// pop之前调用
- (void)willBack {
}

- (void)backAction {
    [self willBack];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)closeAction {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Autorotate
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}


@end
