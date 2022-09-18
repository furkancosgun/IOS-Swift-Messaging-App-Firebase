//
//  MessageViewController.swift
//  MessageApp
//
//  Created by Furkan on 17.09.2022.
//

import UIKit
import Firebase
import FirebaseAuth

class MessageViewController: UIViewController {

    @IBOutlet weak var txtMes: UITextView!
    var ref : DatabaseReference?
    var user : User?
    var userTo : String?
    var from : String?
    var messageList = [MessageCls]()
    
    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        user =  Auth.auth().currentUser!
        tblView.delegate = self
        tblView.dataSource = self
        from = (user?.email!)!
        getAllMessages(from: from! , to: userTo!)
        navigationItem.title = userTo

    }
    @IBAction func btnSend(_ sender: Any) {
        let DT = Date()
        let Message = MessageCls(From: (user?.email)!, To: userTo!, Message: txtMes.text!, Time: String(describing: DT))
                
                //Kişi objesi dict tipine cevrilir kayı işlemleri obje tipi ile olmuyor ios ta
        let dict : [String:Any] = ["from":Message.from,"to":Message.to,"message":Message.message,"time":Message.time]
                
                //Kişiler tablosu oluşturur ve onun her degeri için unique deger atar diyebiliriz
                let newRef = ref?.child("Messages").childByAutoId()
                
                //Kayıt işlemi set value ile yapılır ve kişiler kolonu altına işlemler kayıt edielir
                newRef?.setValue(dict)
        ref?.removeAllObservers()
        txtMes.text = ""
        getAllMessages(from: from! , to: userTo!)
    }
    func getAllMessages(from:String,to:String){
    

      
        let sorgu = ref?.child("Messages")
               sorgu!.observe(.value,with: { snapshot in
        
                   if let gelenVeriler = snapshot.value as? [String:AnyObject]{
                       self.messageList.removeAll()
              
                       for gelenSatir in gelenVeriler{
                           
                           if let dict = gelenSatir.value as? NSDictionary{
                               
                               let from = dict["from"] as? String ?? ""
                               let to = dict["to"] as? String ?? ""
                               let mess = dict["message"] as? String ?? ""
                               let time = dict["time"] as? String ?? ""
                               let message = MessageCls(From: from, To: to, Message: mess, Time: time)
                             
                               if to == self.from && from == self.userTo || to == self.userTo && from == self.from {
                                       self.messageList.append(message)
                               }
                           }
                       }
                       DispatchQueue.main.async {
                           self.messageList.sort(by: { $0.time > $1.time })
                           self.tblView.reloadData()
                       }
                   }
               }
               )
    }
    
    
}
extension MessageViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.numberOfLines = 10;
      
        cell.textLabel?.text = messageList[indexPath.row].message
        cell.layer.cornerRadius = CGFloat(10)
        if messageList[indexPath.row].to == from{
            cell.backgroundColor = UIColor.systemGroupedBackground
            cell.textLabel?.textColor = UIColor.systemIndigo
            cell.layer.borderColor = UIColor.systemIndigo.cgColor
            cell.layer.borderWidth = CGFloat(3)

        }else{
            cell.backgroundColor = UIColor.systemIndigo
            cell.textLabel?.textColor = UIColor.systemGroupedBackground
            cell.layer.borderColor = UIColor.systemGroupedBackground.cgColor
            cell.layer.borderWidth = CGFloat(1)
        }

        return cell
}
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.txtMes.endEditing(true)
    }
}
