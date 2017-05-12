//
//  Myicebox.swift
//  我的冰箱
//  IceboxAndCookbook

//  注意！！，cell的Identifier是否有打錯，cell是否有連結正確，class是否有連結

import UIKit

class Myicebox: UITableViewController {
    
    //▼宣告
    let db = DBManage()     // 呼叫資料庫
    
    var iName:[String] = [] // 食材名稱
    var iAmount:[Int]  = [] // 食材數量
    var iDay:[Int]     = [] // 食材有效下期

    var cDay:Int       = -1 // 取今日
    
    //▼刷新頁面
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
            
            _ = db.createTable(sql: "create table myLove (iId integer primary key autoincrement not null, iName text not null, iLove text not null)")
            
            db.closeDatabase()
        }
        
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    //▼傳送到...
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddIngredientsTableViewController" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let data = segue.destination as! AddIngredients
                
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
