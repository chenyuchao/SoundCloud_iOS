//
//  AppDelegate.m
//  iSound
//
//  Created by Jumax.R on 13-9-27.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "AppDelegate.h"
#import "SignIn.h"
#import "MobClick.h"

#define UMengKey @"527e06ae56240bcfdb0959af"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [UMSocialData setAppKey:@"527e06ae56240bcfdb0959af"];//友盟
    [MobClick startWithAppkey:@"527e06ae56240bcfdb0959af"];
    [MobClick setLogEnabled:YES];
    self.rootController = (SignIn *)[(UINavigationController *) self.window.rootViewController topViewController];
    
    CGFloat version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version < 7.0 && version > 4.0)
    {
        [self.rootController.navigationController.navigationBar
         setBackgroundImage:[UIImage imageNamed:@"navigationbg"]
         forBarMetrics:UIBarMetricsDefault];
    }

    // Required
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)];
    // Required
    [APService setupWithOption:launchOptions];
    
    self.msgPath = [[Custom getDocumentDir] stringByAppendingPathComponent:@"message.plist"];
    self.messges = [NSMutableArray arrayWithContentsOfFile:self.msgPath];
    if (!self.messges)
    {
        self.messges = [NSMutableArray array];
    }
    if (launchOptions)
    {
        NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:[launchOptions valueForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"]];
        [result setObject:@"同意" forKey:@"state"];
        [self.messges insertObject:result atIndex:0];
        [self.messges writeToFile:self.msgPath atomically:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageNotification"
                                                            object:nil];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //友盟
    [UMSocialSnsService  applicationDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:userInfo];
    [result setObject:@"同意" forKey:@"state"];
    [self.messges insertObject:result atIndex:0];
    [self.messges writeToFile:self.msgPath atomically:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageNotification"
                                                        object:nil];
    [APService handleRemoteNotification:userInfo];
}

//友盟
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

@end
