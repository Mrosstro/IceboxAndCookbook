//
//  MyCookBook.swift
//  我的食譜 顯示
//  IceboxAndCookbook


import UIKit

class MyCookBook: UITableViewController {
    let db = DBManage()     // 呼叫資料庫
    var statement:OpaquePointer? = nil
    var sql:String = "iId"
    
    var iName:[String] = [] // 食材名稱
    var iLove:[Int]    = [] // 食材有效下期
    var iView:[Int]    = [] // 食材數量
    
    //▼刷新頁面
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        db.Init()
        
        if db.openDatabase() {
            statement  = nil
            let sql:String = "iId"
            
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
            
            tableView.reloadData()
        }
    }
    
    //▼初始化
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 70
        tableView.rowHeight          = UITableViewAutomaticDimension
        tableView.tableFooterView    = UIView()
        
        
        db.Init()
        
        if db.openDatabase() {
            statement  = nil
            
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
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "rr2" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let data = segue.destination as! SeeViewController
                
                data.gData = true
                data.gName = iName[indexPath.row]
                print("----")
            }
            
            print("rr2")
        }
    }
    
    //▼有幾組 row
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return iName.count
    }
    
    //▼顯示 row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCookBookTableViewCell", for: indexPath) as! MyCookBookTableViewCell
        cell.MfoodImage.image = UIImage(named: "\(iName[indexPath.row])")
        cell.MName.text      = "\(iName[indexPath.row])"
        cell.MLike.text      = "❤️：\(iLove[indexPath.row])"
        cell.MWatch.text     = "👁‍🗨：\(iView[indexPath.row])"
        
        cell.MLike.isHidden  = true
        cell.MWatch.isHidden = true
        
        return cell
    }
    
}
