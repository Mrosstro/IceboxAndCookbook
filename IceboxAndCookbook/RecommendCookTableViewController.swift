//
//  RecommendCookTableViewController.swift
//  IceboxAndCookbook
//
//  Created by Mrosstro on 2017/5/6.
//  Copyright © 2017年 Mrosstro. All rights reserved.
//

//注意！！，cell的Identifier是否有打錯，cell是否有連結正確，class是否有連結

import UIKit

class RecommendCookTableViewController: UITableViewController {
    let db = DBManage()     // 呼叫資料庫
    
    var iName:[String] = [] // 食材名稱
    var iLove:[Int]    = [] // 食材有效下期
    var iView:[Int]    = [] // 食材數量

    //▼範例用
    var testName: [String] = ["番茄義大利麵","豬肉水餃","貢丸湯","羊肉爐"]
    var testLike: [String] = ["1000","3000","5000","3000"]
    var testWatch: [String] = ["10000","50000","30000","20000"]
    
    //▼初始化
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db.Init()
        
        if db.openDatabase() {
            var statement  = db.fetch(table: "iceBox", cond: "iId")
            var sql:String = ""
            var a:[String] = []
            
            a.removeAll()
            while sqlite3_step(statement) == SQLITE_ROW {
                let n:String = String(cString: sqlite3_column_text(statement, 1))
                a.append(n)
            }
            
            sqlite3_finalize(statement)
            
            for i in 0..<a.count {
                sql = sql + "iRequire like'%\(a[i])%'"
                sql = sql + ((i == (a.count-1)) ? "" : " OR ")
            }
            
            print(sql)
            
            iName.removeAll()
            iLove.removeAll()
            iView.removeAll()
            
            statement =  db.fetch(table: "recipeList", cond: sql)
            
            while sqlite3_step(statement) == SQLITE_ROW {
                let n:String = String(cString: sqlite3_column_text(statement, 2))
                let l:Int    = Int(sqlite3_column_int(statement, 4))
                let v:Int    = Int(sqlite3_column_int(statement, 5))
                iName.append(n)
                iLove.append(l)
                iView.append(v)
            }
            
            sqlite3_finalize(statement)
            
            db.closeDatabase()
        }
        
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    // row 選擇第＊個 didSelectRowAt
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("選擇：第 \(indexPath.row) 個")
    }
    
    
    //▼有幾組 row
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return iName.count
    }
    
    //▼顯示 row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecommendCookTableViewCell", for: indexPath) as! RecommendCookTableViewCell
        
        cell.RName.text  = "\(iName[indexPath.row])"
        cell.RLike.text  = "❤️：\(iLove[indexPath.row])"
        cell.RWatch.text = "👁‍🗨：\(iView[indexPath.row])"
        
        return cell
    }
    @IBAction func ClickLove(_ sender: UIButton) {
        
    }
}
