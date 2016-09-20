//
//  ChatViewCell.swift
//  huanxinDemo
//
//  Created by Apple on 16/9/19.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit

class ChatViewCell: UITableViewCell {
    @IBOutlet weak var messageLable: UILabel!
    
    var message: EMMessage? = nil{
        didSet{
            if self.message != nil {
                let body = message?.messageBodies[0] as! IEMMessageBody
                if body.messageBodyType == .eMessageBodyType_Text {
                    var textBody: EMTextMessageBody?
                    textBody = body as? EMTextMessageBody
                    self.messageLable.text = textBody?.text
                }else if body.messageBodyType == .eMessageBodyType_Voice{
                    self.messageLable.text = "【语音】"
                }
            }
        }
    }
    func cellHeight()->CGFloat{
        self.layoutIfNeeded()
        return self.messageLable.bounds.size.height + 30
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
