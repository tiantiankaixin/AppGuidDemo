//
//  AppGuidViewController.m
//  AppGuidDemo
//
//  Created by wangtian on 15/6/26.
//  Copyright (c) 2015年 wangtian. All rights reserved.
//

#import "AppGuidViewController.h"
#import "GuidAnimation.h"
#import "AppDelegate.h"

#define M_Size [UIScreen mainScreen].bounds.size

@interface AppGuidViewController ()<UIScrollViewDelegate,UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) NSMutableArray *imageViewArray;
@property (strong, nonatomic) IBOutlet UIButton *startBtn;
@property (nonatomic, assign) CGFloat startBtndistanceWithBottom;//开始按钮距离下边界的距离
@property (nonatomic, strong) NSArray *distanceArray;
@property (copy, nonatomic) NSString *defatuleImageName;
@property (copy, nonatomic) NSString *selectImageName;
@property (nonatomic, strong) UIViewController *needLoadVC;

@end

@implementation AppGuidViewController


- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    if ([presented isEqual:self.needLoadVC])
    {
        return [GuidAnimation new];
    }
    return nil;
}

- (NSMutableArray *)imageViewArray
{
    if (_imageViewArray == nil)
    {
        _imageViewArray = [[NSMutableArray alloc] init];
    }
    return _imageViewArray;
}

- (AppGuidViewController *)initWithImageArray:(NSArray *)imageArray startBtnDistanceWithBottomArray:(NSArray *)distanceArray needLoadVC:(UIViewController *)needLoadVC
{
    if (self = [super init])
    {
        _imageArray = imageArray;
        _pageCount = imageArray.count;
        _distanceArray = distanceArray;
        _needLoadVC = needLoadVC;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpView];
     self.transitioningDelegate = self;
    // Do any additional setup after loading the view from its nib.
}

- (void)setUpView
{
    [self addImageView];
    self.contentScrollView.contentSize = CGSizeMake(M_Size.width * self.pageCount, M_Size.height);
    self.pageControl.numberOfPages = self.pageCount;
    //[self setUpStartBtn];
}

//- (void)setUpStartBtn
//{
//    if (SCREEN_HEIGHT == 568)
//    {
//        self.defatuleImageName = @"btn_default_4.0";
//        self.selectImageName = @"btn_selected_4.0";
//    }
//    else if (SCREEN_HEIGHT == 667)
//    {
//        self.defatuleImageName = @"btn_default_4.7";
//        self.selectImageName = @"btn_selected_4.7";
//    }
//    else if (SCREEN_HEIGHT == 736)
//    {
//        self.defatuleImageName = @"btn_default_5.5";
//        self.selectImageName = @"btn_selected_5.5";
//    }
//    else if (SCREEN_HEIGHT == 480)
//    {
//        self.defatuleImageName = @"btn_default_3.5";
//        self.selectImageName = @"btn_selected_3.5";
//    }
//    
//    [self.startBtn setBackgroundImage:[UIImage imageNamed:@"btnguid_default"] forState:UIControlStateNormal];
//     [self.startBtn setBackgroundImage:[UIImage imageNamed:@"btnguid_selected"] forState:UIControlStateHighlighted];
//}

#pragma mark - 添加imageView到scrollView
- (void)addImageView
{
    for (int i = 0; i < self.pageCount; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * M_Size.width, 0, M_Size.width, M_Size.height)];
        imageView.image = [self imageWithName:self.imageArray[i]];
        [self.contentScrollView addSubview:imageView];
        if (i == self.pageCount - 1)
        {
            [self addStartBtnWithImageView:imageView];
        }
    }
}

#pragma mark - scrollView代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat contentsetX = scrollView.contentOffset.x;
    self.currentPage = (int)contentsetX / M_Size.width;
    self.pageControl.currentPage = self.currentPage;
}

#pragma mark - 添加start按钮
- (void)addStartBtnWithImageView:(UIImageView *)imageView
{
    imageView.userInteractionEnabled = YES;
    self.startBtn.center = CGPointMake(M_Size.width / 2, M_Size.height / 2);
    CGRect startBtnFrame = self.startBtn.frame;
    startBtnFrame.origin.y = M_Size.height - [self getDistance];
    self.startBtn.frame = startBtnFrame;
    [imageView addSubview:self.startBtn];
}

- (UIImage *)imageWithName:(NSString *)imageName
{
    UIImage *image;
    NSString *imageExten = [imageName pathExtension];
    NSString *imageRealName = [imageName stringByDeletingPathExtension];
    NSString *fullImageName;
    int screenHeight = M_Size.height;
    switch (screenHeight)
    {
        case 480:
        {
            fullImageName = [NSString stringWithFormat:@"%@_3.5",imageRealName];
            break;
        }
        case 568:
        {
            fullImageName = [NSString stringWithFormat:@"%@_4.0",imageRealName];
            break;
        }
        case 667:
        {
            fullImageName = [NSString stringWithFormat:@"%@_4.7",imageRealName];
            break;
        }
        case 736:
        {
            fullImageName = [NSString stringWithFormat:@"%@_5.5",imageRealName];
            break;
        }
            
        default:
            break;
    }
    
    image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.%@",fullImageName,imageExten]];
    return image;
}

- (CGFloat)getDistance
{
    int screenHeight = M_Size.height;
    CGFloat distance;
    switch (screenHeight)
    {
        case 480:
        {
            distance = [self.distanceArray[0] floatValue];
            break;
        }
        case 568:
        {
            distance = [self.distanceArray[1] floatValue];
            break;
        }
        case 667:
        {
            distance = [self.distanceArray[2] floatValue];
            break;
        }
        case 736:
        {
            distance = [self.distanceArray[3] floatValue];
            break;
        }
            
        default:
            distance = 0;
            break;
    }
    return distance;
}

#pragma mark - 开始
- (IBAction)startApp:(UIButton *)sender
{
    self.needLoadVC.transitioningDelegate = self;
    if (self.start)
    {
        self.start();
    }
    [self presentViewController:self.needLoadVC animated:YES completion:nil];
}

#pragma mark - 应用是否为第一次启动
+ (BOOL)isFirstLaunch
{
    NSString *versionKey = (NSString *)kCFBundleVersionKey;
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:versionKey];
    NSString *currentVersion =[[[NSBundle mainBundle] infoDictionary] objectForKey:versionKey];
    if ([lastVersion isEqualToString:currentVersion])
    {
        return NO;
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:versionKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
