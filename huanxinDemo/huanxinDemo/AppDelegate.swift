//
//  AppDelegate.swift
//  huanxinDemo
//
//  Created by Apple on 16/9/18.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,EMChatManagerDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        EaseMob.sharedInstance().registerSDK(withAppKey: "填写你的APPKey", apnsCertName: nil)
        EaseMob.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        //添加聊天代理
        EaseMob.sharedInstance().chatManager.add(self, delegateQueue: nil)
        //判断是否设置自动登录
        if EaseMob.sharedInstance().chatManager.isAutoLoginEnabled! {
            self.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        }else{
            self.window?.rootViewController = UIStoryboard(name: "login", bundle: nil).instantiateInitialViewController()
        }
        return true
    }
    //自动登录回调
    func didAutoLogin(withInfo loginInfo: [AnyHashable : Any]!, error: EMError!) {
        if error == nil {
            print("自动登陆成功")
        }else{
            print("自动登陆失败")
        }
    }
    func applicationWillResignActive(_ application: UIApplication) {
         EaseMob.sharedInstance().applicationWillResignActive(application)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        EaseMob.sharedInstance().applicationDidEnterBackground(application)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        EaseMob.sharedInstance().applicationWillEnterForeground(application)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        EaseMob.sharedInstance().applicationDidBecomeActive(application)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        EaseMob.sharedInstance().applicationWillTerminate(application)
    }


}

