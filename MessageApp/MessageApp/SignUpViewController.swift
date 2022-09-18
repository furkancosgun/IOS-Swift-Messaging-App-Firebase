//
//  SignUpViewController.swift
//  MessageApp
//
//  Created by Furkan on 17.09.2022.
//

import UIKit
import Firebase
import FirebaseAuth
class SignUpViewController: UIViewController {

    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    var ref : DatabaseReference?
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
    }
  

    @IBAction func btnSave(_ sender: Any) {
        if txtPassword.text != "" && txtEmail.text != ""{
            Auth.auth().createUser(withEmail: txtEmail.text!, password: txtPassword.text!)
            saveToDbUserEmails(email: txtEmail.text!)
            let alertController = UIAlertController(title: "Info", message: "User successfully registered!", preferredStyle: .alert)
    
            let okButton = UIAlertAction(title: "Ok", style: .default, handler: {_ in
                      self.dismiss(animated: true)
                  })
                  
                  alertController.addAction(okButton)
                  
                  //ALert dialog called with  present like screen call
                  self.present(alertController, animated: true)
        }else{
            let alertController = UIAlertController(title: "Warning", message: "Enter your email and password", preferredStyle: .alert)
    
            let okButton = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            
                  alertController.addAction(okButton)
                  
                  //ALert dialog called with  present like screen call
                  self.present(alertController, animated: true)
        }
    }
    
    func saveToDbUserEmails(email:String){
      
                let Email = ["Email": email]
                
                
                //Kişiler tablosu oluşturur ve onun her degeri için unique deger atar diyebiliriz
                let newRef = ref?.child("Emails").childByAutoId()
                
                //Kayıt işlemi set value ile yapılır ve kişiler kolonu altına işlemler kayıt edielir
                newRef?.setValue(Email)
            
    }
    
}
