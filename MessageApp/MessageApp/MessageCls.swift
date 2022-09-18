//
//  Message.swift
//  MessageApp
//
//  Created by Furkan on 17.09.2022.
//

import Foundation

class MessageCls : Codable {
    var from : String
    var to : String
    var message : String
    var time : String
    
    init(From:String,To:String,Message:String,Time:String)  {
        self.from = From
        self.to = To
        self.message = Message
        self.time = Time
    }
}
