//
//  AddCookBook.swift
//  新增食譜
//  IceboxAndCookbook
//
//  Created by Mrosstro on 2017/5/12.
//  Copyright © 2017年 Mrosstro. All rights reserved.
//

import UIKit

class AddCookBook: UITableViewController {
    
    @IBOutlet weak var ACImage: UIImageView!
    @IBOutlet weak var ACName: UITextField!
    @IBOutlet weak var ACIngredients: UITextView!
    @IBOutlet weak var ACStep: UITextView!
    
    //▼初始化
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //▼返回上一頁
    @IBAction func ClickBack(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //▼完成
    @IBAction func ClickFinish(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
