//
//  LoginViewController.swift
//  huanxinDemo
//
//  Created by Apple on 16/9/18.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var accountTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func registerClick(_ sender: AnyObject) {
        let userName = self.accountTextField.text
        let password = self.passwordTextField.text
        EaseMob.sharedInstance().chatManager.asyncRegisterNewAccount(userName, password: password, withCompletion: { (userName, password, error) in
            if error == nil{
                print("注册成功")
            }else{
                print("注册失败")
            }
            }, on: nil)
    }
    @IBAction func loginClick(_ sender: AnyObject) {
        let userName = self.accountTextField.text
        let password = self.passwordTextField.text
        EaseMob.sharedInstance().chatManager.asyncLogin(withUsername: userName, password: password, completion: { (loginInfo, error) in
            if error == nil{
                print("登陆成功")
                EaseMob.sharedInstance().chatManager.enableAutoLogin!()
                self.view.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
            }else{
                print("登陆失败")
            }
            }, on: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
