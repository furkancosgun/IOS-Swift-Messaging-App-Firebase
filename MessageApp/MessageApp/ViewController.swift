//
//  ViewController.swift
//  MessageApp
//
//  Created by Furkan on 17.09.2022.
//

import UIKit
import FirebaseAuth
class ViewController: UIViewController {
    
    
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    
    override func viewWillAppear(_ animated: Bool) {
        let user = UserDefaults.standard
        let uname = user.string(forKey: "uname")
        let pass = user.string(forKey: "pass")

        if uname != nil && pass != nil {
            Auth.auth().signIn(withEmail: uname!, password: pass!)
            self.performSegue(withIdentifier: "goToMess", sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil);

    }
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -100 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        if txtEmail.text != "" && txtPass.text != ""{
            Auth.auth().signIn(withEmail: txtEmail.text!, password: txtPass.text!){ user, error in
                if user != nil && error == nil{
                    let uname = self.txtEmail.text!
                    let pass = self.txtPass.text!
                    let user = UserDefaults.standard
                    user.set(uname, forKey: "uname")
                    user.set(pass, forKey: "pass")
                    
                    self.performSegue(withIdentifier: "goToMess", sender: nil)
                }else{
                    let alertController = UIAlertController(title: "Warning", message: "Email or password wrong", preferredStyle: .alert)
            
                    let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    
                          alertController.addAction(okButton)
                          
                         
                    self.present(alertController, animated: true)
                }
            }
        }else{
            let alertController = UIAlertController(title: "Warning", message: "Enter your email and password", preferredStyle: .alert)
    
            let okButton = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            
                  alertController.addAction(okButton)
                  
           
                  self.present(alertController, animated: true)
        }
       
    }
    
}

