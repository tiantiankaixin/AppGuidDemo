//
//  AppGuidViewController.h
//  AppGuidDemo
//
//  Created by wangtian on 15/6/26.
//  Copyright (c) 2015年 wangtian. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppGuidViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, copy) void(^start)(void);


/**
 *  引导页面初始化
 *
 *  @param imageArray    图片数组(图片命名规则：图片名_屏.图片扩展名 image_3.5.jpg指的就是4 4s的屏)
 *  @param distanceArray 开始按钮距离屏幕下边界的距离数组(从3.5屏开始、4.0、4.7、5.5)
 *  @param needLoadVC    点击开始按钮后需要加载的控制器
 *
 *  @return 引导页obj
 */
- (AppGuidViewController *)initWithImageArray:(NSArray *)imageArray startBtnDistanceWithBottomArray:(NSArray *)distanceArray needLoadVC:(UIViewController *)needLoadVC;

/**
 *  应用是否第一次启动
 *
 *  @return YES:是第一次启动  NO:否
 */
+ (BOOL)isFirstLaunch;

@end
