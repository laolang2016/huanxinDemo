//
//  AddBuddyViewController.swift
//  huanxinDemo
//
//  Created by Apple on 16/9/18.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit

class AddBuddyViewController: UIViewController,EMChatManagerDelegate{

    @IBOutlet weak var inputTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        EaseMob.sharedInstance().chatManager.add(self, delegateQueue: nil)
    }

    @IBAction func addClick(_ sender: AnyObject) {
        let userName = self.inputTextField.text
        var error : EMError? = nil
        EaseMob.sharedInstance().chatManager.add(userName, message: "hello", error: &error)
        if error == nil {
            print("添加好友成功")
        }else{
            print("添加好友失败")
        }
    }
    //添加好友的代理方法
    func didAccepted(byBuddy username: String!) {
        let message:String = String(format: "\(username)同意了你的好友请求")
        let alert: UIAlertView = UIAlertView(title: "", message: message, delegate: self, cancelButtonTitle: "确定")
        alert.show()
        
    }
    func didRejected(byBuddy username: String!) {
        let message:String = String(format: "\(username)拒绝了你的添加好友请求")
        let alert:UIAlertView = UIAlertView(title: "", message: message, delegate: self, cancelButtonTitle: "确定")
        alert.show()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
