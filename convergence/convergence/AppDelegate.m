//
//  AppDelegate.m
//  convergence
//
//  Created by admin on 2017/8/29.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "AppDelegate.h"
#import <ECSlidingViewController/ECSlidingViewController.h>
@interface AppDelegate ()<ECSlidingViewControllerDelegate>
@property (strong,nonatomic) ECSlidingViewController *slidingVC;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //设置app入口
    //初始化窗口（不用故事版设置入口箭头的时候，系统不会默认设置窗口，需要手动设置）
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //窗口可视化
    [_window makeKeyAndVisible];
    UINavigationController *navi = [Utilities getStoryboardInstance:@"Main" byIdentity:@"HomeNavi"];
    //创建门框（初始化的同时顺便设置好门框最外边的那层门，也就是用户首先看见的正中间的页面）
    _slidingVC = [[ECSlidingViewController alloc]initWithTopViewController:navi];
    //签协议
    //_slidingVC.delegate = self;
    //放好左边那扇门
    _slidingVC.underLeftViewController = [Utilities getStoryboardInstance:@"Left" byIdentity:@"Left"];
    //设置手势(让中间的门能够对拖拽与触摸响应)
    _slidingVC.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping|ECSlidingViewControllerAnchoredGesturePanning;
    //把上述手势添加到中间那扇门
    [navi.view addGestureRecognizer:_slidingVC.panGesture];
    //设置侧滑动画的执行时间
    _slidingVC.defaultTransitionDuration = 0.25;
    //设置滑动的幅度（中间那扇门打开的宽度）
    _slidingVC.anchorRightPeekAmount= UI_SCREEN_W/6;
    //设置app入口
    _window.rootViewController = _slidingVC;
    //注册策划按钮被按的监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(leftSwitchAction:) name:@"LeftSwitch" object:nil];
    return YES;
}
//当收到通知之后要做的事情
- (void)leftSwitchAction:(NSNotification *)note{
    NSLog(@"侧滑");
    //当合上的情况下打开，当打开的情况下合上
    if (_slidingVC.currentTopViewPosition == ECSlidingViewControllerTopViewPositionCentered) {
        //合上的状态下打开
        [_slidingVC anchorTopViewToRightAnimated:YES];
    } else {
        //打开的状态下合上
        [_slidingVC resetTopViewAnimated:YES];
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"convergence"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
