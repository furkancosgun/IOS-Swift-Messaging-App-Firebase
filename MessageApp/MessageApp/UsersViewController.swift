//
//  UsersViewController.swift
//  MessageApp
//
//  Created by Furkan on 17.09.2022.
//

import UIKit
import Firebase
import FirebaseAuth
class UsersViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblView: UITableView!
    var userList = [String]()
    var ref : DatabaseReference?
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        tblView.delegate = self
        tblView.dataSource = self
        searchBar.delegate = self
        getAllPersons()
        navigationItem.hidesBackButton = true
    }
    
    func getAllPersons(){
        ref?.child("Emails").observe(.value,with: { snapshot in
            
            if let gelenVeriler = snapshot.value as? [String:AnyObject]{
                self.userList.removeAll()
                for gelenSatir in gelenVeriler{
                    
                    if let dict = gelenSatir.value as? NSDictionary{
                        print(gelenSatir.value)
                        let email = dict["Email"] as? String ?? ""
                        if email != Auth.auth().currentUser?.email{
                            self.userList.append(email)
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                }
            }
        })
        
    }
    
    func selectedPerson(Email:String){
         
        let sorgu = ref?.child("Emails").queryOrdered(byChild: "Email").queryStarting(atValue: Email)
        
          sorgu!.observe(.value,with: { snapshot in
              if let gelenVeriler = snapshot.value as? [String:AnyObject]{
                  self.userList.removeAll()
                  for gelenSatir in gelenVeriler{
                      
                      if let dict = gelenSatir.value as? NSDictionary{
                         
                          if let email = dict["Email"] as? String{
                              if email != Auth.auth().currentUser?.email{
                                  self.userList.append(email)
                              }
                              
                          }
                      }
                  }
                  DispatchQueue.main.async {
                      self.tblView.reloadData()
                  }
              }
          })
      }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToMess"{
            if let userTo = sender as? String{
                let destionation = segue.destination as! MessageViewController
                destionation.userTo = userTo
            }
          
        }
    }
    
    @IBAction func btnExit(_ sender: Any) {
        UserDefaults.standard.set(nil, forKey: "uname")
        UserDefaults.standard.set(nil, forKey: "pass")
        navigationController?.popViewController(animated: true)
    }
}
extension UsersViewController : UITableViewDelegate,UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          
        return userList.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "usersCell", for: indexPath)
        
        cell.textLabel?.text = userList[indexPath.row]
        cell.textLabel?.textColor = UIColor.systemIndigo
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToMess", sender: userList[indexPath.row])
    }
}

extension UsersViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        ref?.removeAllObservers()
        if searchText != ""{
            selectedPerson(Email: searchText)
        }else{
            getAllPersons()
        }
    }
}
