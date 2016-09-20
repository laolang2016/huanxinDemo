//
//  ChatViewController.swift
//  huanxinDemo
//
//  Created by Apple on 16/9/19.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController,EMChatManagerDelegate ,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate{
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var tableV: UITableView!
    
    
    @IBOutlet weak var bottomViewBottomConstrain: NSLayoutConstraint!
    var tool: ChatViewCell?
    
    var textData = [AnyObject]()
    
    var buddy: EMBuddy?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = buddy?.username
        EaseMob.sharedInstance().chatManager .add(self, delegateQueue: nil)
        self.loadLoaclChatRecorder()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(note:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(note:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    //键盘弹出
    func keyboardWillShow(note: NSNotification){
//        let keyBoardEndFrame = ((note.userInfo![UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue)!
        let keyBoardBounds = (note.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//        let duration = (note.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let offsetY: CGFloat = keyBoardBounds.size.height
        self.bottomViewBottomConstrain.constant = offsetY
        UIView.animate(withDuration: 0.25) { 
            self.view.layoutIfNeeded()
        }
    }
    //键盘隐藏
    func keyboardWillHide(note: NSNotification){
        self.bottomViewBottomConstrain.constant = 0
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    ////////////////////////////////////////////////////////////////////
    func loadLoaclChatRecorder(){
        //获取本地聊天记录，会话
        let conversation: EMConversation = EaseMob.sharedInstance().chatManager.conversation!(forChatter: self.buddy?.username, conversationType: EMConversationType.eConversationTypeChat)
//        self.textData = (conversation.loadAllMessages() as AnyObject) as AnyObject as! [AnyObject]
        self.textData = (conversation.loadAllMessages() as AnyObject) as! [AnyObject]
        print(textData)
    }
    
/////////////////////////////////////////////////////////////////////////
    //tableView代理
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.textData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let receiveID = "receiveCell"
        let sendID = "sendCell"
        let message: AnyObject? = self.textData[indexPath.row];
        var cell = ChatViewCell()
        if message?.from == self.buddy?.username {
            cell = self.tableV.dequeueReusableCell(withIdentifier: receiveID, for: indexPath) as! ChatViewCell
        }else{
            cell = self.tableV.dequeueReusableCell(withIdentifier: sendID, for: indexPath) as! ChatViewCell
        }
        cell.message = self.textData[indexPath.row] as? EMMessage
//        cell.textLabel?.text = "我是你大哥"
        return cell
    }
    //textView代理
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.hasSuffix("\n") {
            self.sendMessage(text: textView.text)
            textView.text = nil
        }
    }
    //发送消息
    func sendMessage(text: String){
        print("要发送给\(self.buddy?.username)")
        //构造消息
        let chatText = EMChatText(text: text)
        let textBody = EMTextMessageBody(chatObject: chatText)
        //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        let obj = [EMTextMessageBody](arrayLiteral: textBody!)
        let msgObj = EMMessage(receiver: self.buddy?.username, bodies: obj)
        EaseMob.sharedInstance().chatManager.asyncSend(msgObj, progress: nil, prepare: { (message: EMMessage?, error: EMError?) in
            print("发送")
            }, on: nil, completion: { (message: EMMessage?, error: EMError?) in
                print("发送完成")
            }, on: nil)
        self.textData.append(msgObj!)
        self.tableV.reloadData()
        self.scrollToTop()
    }
    func scrollToTop(){
        if self.textData.count == 0 {
            return
        }
        let lastIndex = NSIndexPath(row: self.textData.count - 1, section: 0)
        self.tableV.scrollToRow(at: lastIndex as IndexPath, at: UITableViewScrollPosition.bottom, animated: true)
    }
    func didReceive(_ message: EMMessage!) {
        if message.from == self.buddy?.username {
            self.textData.append(message)
            self.tableV.reloadData()
            self.scrollToTop()
        }
    }
}
