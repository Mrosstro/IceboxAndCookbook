//
//  Myicebox.swift
//  我的冰箱
//  IceboxAndCookbook

//  注意！！，cell的Identifier是否有打錯，cell是否有連結正確，class是否有連結

import UIKit

class Myicebox: UITableViewController {
    
    //▼宣告
    let db = DBManage()     // 呼叫資料庫
    var statement:OpaquePointer? = nil
    
    var iName:[String] = [] // 食材名稱
    var iAmount:[Int]  = [] // 食材數量
    var iDay:[Int]     = [] // 食材有效下期
    
    let dateFormat     = DateFormatter()
    var cDay:Int       = -1 // 取今日
    var cDay:Int       = -1 // 取今日
    var cDay:Int       = -1 // 取今日
    
    //▼刷新頁面
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        dateFormat.dateFormat = "dd"
        cDay = Int(dateFormat.string(from: Date()))!

        db.Init()
        
        if db.openDatabase() {
            iName.removeAll()
            iAmount.removeAll()
            iDay.removeAll()
            
            statement = db.fetch(table: "iceBox", cond: "iId")
            
            while sqlite3_step(statement) == SQLITE_ROW {
                let _name:String = String(cString: sqlite3_column_text(statement, 1))
                let _amount:Int  = Int(sqlite3_column_int(statement, 3))
                let _day:Int     = Int(String(cString: sqlite3_column_text(statement, 4)).components(separatedBy: "-")[2])! - cDay
                
                iName.append(_name)
                iAmount.append(_amount)
                iDay.append(_day)
            }
            
            sqlite3_finalize(statement)
            
            db.closeDatabase()
        }
        
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.reloadData()
    }
    
    //▼初始化
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 70
        tableView.rowHeight          = UITableViewAutomaticDimension
        tableView.tableFooterView    = UIView()
        
        dateFormat.dateFormat = "dd"
        cDay = Int(dateFormat.string(from: Date()))!
        
        db.Init()
        
        if db.openDatabase() {
            iName.removeAll()
            iAmount.removeAll()
            iDay.removeAll()
            
            statement = db.fetch(table: "iceBox", cond: "iId")
            
            while sqlite3_step(statement) == SQLITE_ROW {
                let _name:String = String(cString: sqlite3_column_text(statement, 1))
                let _amount:Int  = Int(sqlite3_column_int(statement, 3))
                let _day:Int     = Int(String(cString: sqlite3_column_text(statement, 4)).components(separatedBy: "-")[2])! - cDay
                
                iName.append(_name)
                iAmount.append(_amount)
                iDay.append(_day)
            }
            
            sqlite3_finalize(statement)
            
            db.closeDatabase()
        }
        
        tableView.reloadData()
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
