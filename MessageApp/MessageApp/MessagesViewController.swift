//
//  MessagesViewController.swift
//  MessageApp
//
//  Created by Furkan on 17.09.2022.
//

import UIKit
import Firebase

class MessagesViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    var userList = [String]()
    
    var ref : DatabaseReference?
    var userListMode = false
    

