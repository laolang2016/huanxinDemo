//
//  ContectsViewController.swift
//  huanxinDemo
//
//  Created by Apple on 16/9/19.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit

class ContectsViewController: UITableViewController,EMChatManagerDelegate{
    
    var buddyList = [EMBuddy]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EaseMob.sharedInstance().chatManager.add(self, delegateQueue: nil)
        self.buddyList = EaseMob.sharedInstance().chatManager.buddyList as! [EMBuddy]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.buddyList.count
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var chatVc = ChatViewController()
        chatVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "chat") as! ChatViewController
        let selectRow = self.tableView.indexPathForSelectedRow?.row
        chatVc.buddy = self.buddyList[selectRow!]
        self.navigationController?.pushViewController(chatVc, animated: true)
    }
   
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contectCell", for: indexPath)
//        buddy: EMBuddy = self.buddyList[indexPath.row]
        var buddy = EMBuddy()
        buddy = self.buddyList[indexPath.row]
        cell.textLabel?.text = buddy.username
        return cell
    }
   
    //左滑删除好友
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        var buddy = EMBuddy()
        buddy = self.buddyList[indexPath.row]
        let deleteBuddy: String = buddy.username
        var error: EMError? = nil
        if editingStyle == .delete {
            
            EaseMob.sharedInstance().chatManager.remove(deleteBuddy, removeFromRemote: true, error: &error)
        }
    }
    //自动登录以后拉取好友列表
    func didAutoLogin(withInfo loginInfo: [AnyHashable : Any]!, error: EMError!) {
        if error == nil {
            self.buddyList = EaseMob.sharedInstance().chatManager.buddyList as! [EMBuddy]
            self.tableView.reloadData()
        }
    }
    //添加好友以后显示在好友列表
    func didAccepted(byBuddy username: String!) {
        
        EaseMob.sharedInstance().chatManager.asyncFetchList(completion: { (buddyList, error) in
            self.buddyList = buddyList as! [EMBuddy]
            self.tableView.reloadData()
            }, on: nil)
    }
    //收到添加好友信息以后，当你同意时，更新好友列表
    func didUpdateBuddyList(_ buddyList: [Any]!, changedBuddies: [Any]!, isAdd: Bool) {
        self.buddyList = buddyList as! [EMBuddy]
        self.tableView.reloadData()
    }
    //监听被好友删除
    func didRemoved(byBuddy username: String!) {
        EaseMob.sharedInstance().chatManager.asyncFetchList(completion: { (buddyList, error) in
            self.buddyList = buddyList as! [EMBuddy]
            self.tableView .reloadData()
            }, on: nil)
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
