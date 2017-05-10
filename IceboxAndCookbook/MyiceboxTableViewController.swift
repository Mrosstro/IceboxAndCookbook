//
//  MyiceboxTableViewController.swift
//  IceboxAndCookbook
//
//  Created by Mrosstro on 2017/5/4.
//  Copyright © 2017年 Mrosstro. All rights reserved.
//

//  注意！！，cell的Identifier是否有打錯，cell是否有連結正確，class是否有連結
//  喔！哪後呢？

import UIKit

class MyiceboxTableViewController: UITableViewController {
    let db = DBManage()     // 呼叫資料庫
    
    var iName:[String] = [] // 食材名稱
    var iAmount:[Int]  = [] // 食材數量
    var iDay:[Int]     = [] // 食材有效下期
    
    var cDay:Int       = -1 // 取今日
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd"
        
        cDay = Int(dateFormat.string(from: Date()))!
        
        db.Init();
        // db.deleteDataBase();
        db.createDataBase();
        
        if db.openDatabase() {
            let statement = db.fetch(table: "iceBox", cond: "iId")
            
            iName.removeAll()
            iAmount.removeAll()
            iDay.removeAll()
            
            while sqlite3_step(statement) == SQLITE_ROW {
                let n:String = String(cString: sqlite3_column_text(statement, 1))
                let a:Int    = Int(sqlite3_column_int(statement, 3))
                let d:Int    = Int(String(cString: sqlite3_column_text(statement, 4)).components(separatedBy: "-")[2])! - cDay
                
                iName.append(n)
                iAmount.append(a)
                iDay.append(d)
            }
            
            db.closeDatabase()
        }
        
        tableView.reloadData()
    }
    //▼初始化
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 設定格式為：天
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd"
        
        cDay = Int(dateFormat.string(from: Date()))!
        
        db.Init();
        // db.deleteDataBase();
        db.createDataBase();
        
        if db.openDatabase() {
            var tableEmpty:Bool = true
            var statement:OpaquePointer? = nil
            var sql:String      = ""
                sql = "create table iceBox ("
                sql = sql + "iId integer primary key autoincrement not null, "
                sql = sql + "iName  text not null, "
                sql = sql + "iType  text not null, "
                sql = sql + "iCount text not null, "
                sql = sql + "iDate  text not null"
                sql = sql + ")"
            
            // 創建：typeList 資料表
            _ = db.createTable(sql: "create table typeList (iId integer primary key autoincrement not null, iName text not null)")
            
            // 創建：iceBox 資料表
            _ = db.createTable(sql: sql)
            statement = db.fetch(table: "typeList", cond: "iId")
            
            while sqlite3_step(statement) == SQLITE_ROW {
                tableEmpty = false
                break;
            }
            
            if tableEmpty {
                print("typeList 資料表是空的")
                
                let foodtype = ["肉類","蔬菜","魚類","菇類","瓜類","豆類","奶類","水果","飲料","調味品","其他食材"]
                
                for ft in foodtype {
                    db.addData(table: "typeList", kv: ["iName", ft])
                    print("typeList 新增：\(ft)")
                }
            }
            
            sqlite3_finalize(statement)

//            self.db.deleteData(table: "iceBox", kv: ["iName", "番茄"])

//            db.addData(table: "iceBox", kv: ["iName", "番茄"], ["iType", "水果"], ["iCount", "3"],   ["iDate", "2017-05-09"])
//            db.addData(table: "iceBox", kv: ["iName", "茄子"], ["iType", "蔬菜"], ["iCount", "4"],   ["iDate", "2017-05-08"])
//            db.addData(table: "iceBox", kv: ["iName", "豬肉"], ["iType", "肉類"], ["iCount", "300"], ["iDate", "2017-05-07"])
//            db.addData(table: "iceBox", kv: ["iName", "苦瓜"], ["iType", "蔬菜"], ["iCount", "1"],   ["iDate", "2017-05-02"])
//            db.addData(table: "iceBox", kv: ["iName", "羊肉"], ["iType", "肉類"], ["iCount", "400"], ["iDate", "2017-05-19"])

            statement = db.fetch(table: "iceBox", cond: "iId")
            
            iName.removeAll()
            iAmount.removeAll()
            iDay.removeAll()
            
            while sqlite3_step(statement) == SQLITE_ROW {
                let n:String = String(cString: sqlite3_column_text(statement, 1))
                let a:Int    = Int(sqlite3_column_int(statement, 3))
                let d:Int    = Int(String(cString: sqlite3_column_text(statement, 4)).components(separatedBy: "-")[2])! - cDay
                
                iName.append(n)
                iAmount.append(a)
                iDay.append(d)
            }
            
            // 創建：recipeList 資料表
            //_ = db.createTable(sql: "drop table recipeList")
            
            _ = db.createTable(sql: "create table recipeList (iId integer primary key autoincrement not null, iImage text not null, iName text not null, iRequire text not null, iDesc text not null, iLove text not null, iView text not null)")

//            db.addData(table: "recipeList", kv: ["iImage", ""], ["iName", "大黃瓜貢丸湯"], ["iRequire", "芹菜,大黃瓜,貢丸"], ["iDesc", ""], ["iLove", "1"], ["iView", "4"])
//            db.addData(table: "recipeList", kv: ["iImage", ""], ["iName", "南瓜黃金泡菜"], ["iRequire", "小高麗菜,小南瓜,蒜,薑"], ["iDesc", ""], ["iLove", "2"], ["iView", "3"])
//            db.addData(table: "recipeList", kv: ["iImage", ""], ["iName", "焦糖小魚乾花生"], ["iRequire", "蒜,花生,丁香魚乾"], ["iDesc", ""], ["iLove", "3"], ["iView", "6"])
//            db.addData(table: "recipeList", kv: ["iImage", ""], ["iName", "涼拌水晶苦瓜"], ["iRequire", "檸檬,苦瓜"], ["iDesc", ""], ["iLove", "4"], ["iView", ""])
//            db.addData(table: "recipeList", kv: ["iImage", ""], ["iName", "涼拌小黃瓜"], ["iRequire", "小黃瓜,蒜"], ["iDesc", ""], ["iLove", "5"], ["iView", ""])
//            db.addData(table: "recipeList", kv: ["iImage", ""], ["iName", "黑糖薑茶"], ["iRequire", "薑母"], ["iDesc", ""], ["iLove", "6"], ["iView", ""])
//            db.addData(table: "recipeList", kv: ["iImage", ""], ["iName", "香蒜奶油干貝"], ["iRequire", "蒜,玉米筍,綠花椰菜,生干貝"], ["iDesc", "7"], ["iLove", ""], ["iView", "54"])
//            db.addData(table: "recipeList", kv: ["iImage", ""], ["iName", "紅燒川味牛肉"], ["iRequire", "薑,蔥,白蘿蔔,紅蘿蔔,牛肋條"], ["iDesc", "8"], ["iLove", ""], ["iView", "1"])
//            db.addData(table: "recipeList", kv: ["iImage", ""], ["iName", "皮蛋瘦肉粥"], ["iRequire", "蔥,薑,豬梅花"], ["iDesc", ""], ["iLove", "9"], ["iView", ""])
//            db.addData(table: "recipeList", kv: ["iImage", ""], ["iName", "甘醇鳳梨苦瓜雞湯"], ["iRequire", "豆鼓醃漬鳳梨罐,苦瓜,薑,土雞,黑豆鼓"], ["iDesc", ""], ["iLove", "3"], ["iView", ""])
//            db.addData(table: "recipeList", kv: ["iImage", ""], ["iName", "雞絲涼麵"], ["iRequire", "小黃瓜,黃麵條,紅蘿蔔,雞蛋,雞胸肉"], ["iDesc", "10"], ["iLove", ""], ["iView", ""])
//            db.addData(table: "recipeList", kv: ["iImage", ""], ["iName", "蒜香鹹小卷"], ["iRequire", "薑,蒜,辣椒,小卷"], ["iDesc", ""], ["iLove", ""], ["iView", ""])
//            db.addData(table: "recipeList", kv: ["iImage", ""], ["iName", "粉蒸排骨"], ["iRequire", "地瓜,蔥,排骨"], ["iDesc", ""], ["iLove", ""], ["iView", ""])
//            db.addData(table: "recipeList", kv: ["iImage", ""], ["iName", "茶葉蛋"], ["iRequire", "辣椒,薑,雞蛋"], ["iDesc", ""], ["iLove", ""], ["iView", ""])
//            db.addData(table: "recipeList", kv: ["iImage", ""], ["iName", "香菇肉燥飯"], ["iRequire", "(乾)香菇,豬腳肉"], ["iDesc", ""], ["iLove", ""], ["iView", ""])
//            db.addData(table: "recipeList", kv: ["iImage", ""], ["iName", "蘿蔔糕"], ["iRequire", "白蘿蔔,(乾)香菇"], ["iDesc", ""], ["iLove", ""], ["iView", ""])
//            db.addData(table: "recipeList", kv: ["iImage", ""], ["iName", "麻油雞"], ["iRequire", "薑,雞腿肉"], ["iDesc", ""], ["iLove", ""], ["iView", ""])
//            db.addData(table: "recipeList", kv: ["iImage", ""], ["iName", "蒜頭雞湯"], ["iRequire", "蒜,土雞腿,雞翅"], ["iDesc", ""], ["iLove", ""], ["iView", ""])
//            db.addData(table: "recipeList", kv: ["iImage", ""], ["iName", "豬肝粥"], ["iRequire", "薑,蔥,豬肝"], ["iDesc", ""], ["iLove", ""], ["iView", "3"])
            
            _ = db.createTable(sql: "create table myLove (iId integer primary key autoincrement not null, iName text not null, iLove text not null)")
            
            db.closeDatabase()
        }
        
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddIngredientsTableViewController" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let data = segue.destination as! AddIngredientsTableViewController
                
                data.gData = true
                data.gName = iName[indexPath.row]
                data.gDay  = iDay[indexPath.row]
            }
        }
    }
    //▼新增刪除按鈕( 將選項往右滑 )
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //刪除方法寫在裡面
        let nnn:String = "\(self.iName[indexPath.row])"
        let uiAC     = UIAlertController(title: "系統訊息！", message: "您確定要刪除 '\(nnn)' 該食材嗎？", preferredStyle: .alert)
        let uiAA_del = UIAlertAction(title: "刪除", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            
            self.db.Init()
            self.db.createDataBase()
            
            if self.db.openDatabase() {
                self.db.deleteData(table: "iceBox", kv: ["iName", "\(self.iName[indexPath.row])"])
            }
            
            self.db.closeDatabase()
            
            self.viewDidLoad()
            self.tableView.reloadData()
        })
        let uiAA_cl = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
        
        uiAC.addAction(uiAA_cl)
        uiAC.addAction(uiAA_del)
        
        self.present(uiAC, animated: true, completion: nil)
        
        return
    }
    
    
    //▼有幾組 row
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return iName.count
    }

    //▼顯示 row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "MyiceboxTableViewCell", for: indexPath) as! MyiceboxTableViewCell
        let riDay = iDay[indexPath.row] * -1
        let rDay  = ((iDay[indexPath.row] < 0) ? "過期 (\(riDay) 天)" : ((iDay[indexPath.row] == 0) ? "今天 (即將)" : "\(iDay[indexPath.row]) 天"))
        
        cell.iName.text      = "\(iName[indexPath.row])"
        cell.iAmount.text    = "數量：\(iAmount[indexPath.row])"
        cell.iDate.text      = "有效期限：\(rDay)"
        cell.iDate.textColor = ((iDay[indexPath.row] < 0) ? UIColor.red : ((iDay[indexPath.row] == 0) ? UIColor.blue : UIColor.darkGray))

        return cell
    }
}
