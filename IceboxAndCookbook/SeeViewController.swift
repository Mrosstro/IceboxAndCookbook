//
//  SeeViewController.swift
//  IceboxAndCookbook
//
//  Created by Mrosstro on 2017/5/10.
//  Copyright © 2017年 Mrosstro. All rights reserved.
//

import UIKit

class SeeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let db = DBManage()
    var statement:OpaquePointer? = nil
    
    var gData:Bool = false
    var gName:String?
    
    var checkLove:Bool = true
    @IBOutlet weak var iLike: UIBarButtonItem!
    
    //▼範例用
    var testimage: String = "image小黃瓜"
    var testName: String = "涼拌小黃瓜"
    var testIngredients: String = "小黃瓜300克,細砂糖40克,鹽1.5小匙,白醋40毫升,辣椒1根,蒜泥或薑泥1匙,香油數滴"
    var testDescription: String = "Step 1\n小黃瓜洗淨切除頭尾、切小段後拍碎(先拍後切也OK)。先加糖用手抓一抓後再加鹽拌勻\n\nStep 2\n先加糖用手抓一抓後再加鹽拌勻加入薑泥或蒜泥(磨成泥才能迅速入味)、辣椒和白醋拌勻，盛盤後滴入幾滴香油在小黃瓜上面，這樣就完成了。\n\nStep 3\n加入薑泥或蒜泥(磨成泥才能迅速入味)、辣椒和白醋拌勻， 盛盤後滴入幾滴香油在小黃瓜上面， 這樣就完成了。好快喔！趕快試吃一個真有入味嗎??~~好脆喔、酸酸甜甜，的確有入味耶\n\nStep 4\n好快喔！趕快試吃一個真有入味嗎?? ~~好脆喔、酸酸甜甜，的確有入味耶"
    

    @IBOutlet weak var SImage: UIImageView!

    //▼喜歡
    @IBAction func ClickLike(_ sender: UIBarButtonItem) {
        db.Init()
        
        if db.openDatabase() {
            statement =  db.fetch(table: "myRecipe", cond: "mRecipe='\(testName)'")
            checkLove = true;
            
            while sqlite3_step(statement) == SQLITE_ROW {
                checkLove = false
            }
            sqlite3_finalize(statement)
            
            print(checkLove)
            
            if checkLove {
                iLike.image = UIImage(named: "愛心")
                db.deleteData(table: "myRecipe", kv: ["mRecipe", "\(testName)"])
            } else {
                iLike.image = UIImage(named: "愛心(滿)")
                db.addData(table: "myRecipe", kv: ["mRecipe", "\(testName)"])
            }
            
            db.closeDatabase()
        }
    }
    
    //▼返回上一頁
    @IBAction func ClickBack(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //▼初始化
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SImage.image = UIImage(named: testimage)
        
        db.Init()
        
        if db.openDatabase() {
            if gData == true {
                statement =  db.fetch(table: "recipeList", cond: "rName='\(gName!)'")
                while sqlite3_step(statement) == SQLITE_ROW {
                    //let n:String = String(cString: sqlite3_column_text(statement, 1))
                    let _name:String    = String(cString: sqlite3_column_text(statement, 2))
                    let _require:String = String(cString: sqlite3_column_text(statement, 3))
                    let _desc:String    = String(cString: sqlite3_column_text(statement, 4))
                    
                    testName = _name
                    testIngredients = _require
                    testDescription = _desc
                    
                    break
                }
                
                sqlite3_finalize(statement)
                
                
                
                
                statement =  db.fetch(table: "myRecipe", cond: "mRecipe='\(gName!)'")
                checkLove = true;
                
                while sqlite3_step(statement) == SQLITE_ROW {
                    checkLove = false
                }
                sqlite3_finalize(statement)
                
                if checkLove {
                    iLike.image = UIImage(named: "愛心(滿)")
                }
            }
            
            db.closeDatabase()
        }
        
        iLike.image = UIImage(named: "愛心_滿")
    }
    
    //▼替換文字
    func CharacterChange(ChangeText: String) -> String {
        var finishChangeText: String
        finishChangeText = ChangeText.replacingOccurrences(of: ",", with: "\n")
        
        return finishChangeText
    }
    
    //▼有幾組 row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        tableView.estimatedRowHeight = 36
        tableView.rowHeight          = UITableViewAutomaticDimension
        
        return 3
    }
    
    //▼顯示 row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SeeCookBookTableViewCell", for: indexPath) as! SeeCookBookTableViewCell
        
        switch indexPath.row {
            case 0:
                print("準備名稱")
                print(indexPath.row)
                cell.SField.text = "名稱"
                cell.SValue.text = testName
                print("完成名稱")
                print(indexPath.row)
            case 1:
                print("準備食材")
                cell.SField.text = "食材"
                testIngredients = CharacterChange(ChangeText: testIngredients)
                cell.SValue.text = testIngredients
                print("完成食材")
            case 2:
                cell.SField.text = "做法"
                cell.SValue.text = testDescription
            default:
                cell.SField.text = ""
                cell.SValue.text = ""
        }
        
        return cell
    }
}
