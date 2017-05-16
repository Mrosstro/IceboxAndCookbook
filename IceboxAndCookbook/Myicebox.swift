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
    var iYear:[Int]     = [] // 食材有效下期
    var iＭonth:[Int]     = [] // 食材有效下期
    var iDay:[Int]     = [] // 食材有效下期
    
    let dateFormat     = DateFormatter()
    var cYear:Int      = -1 // 取今年
    var cＭonth:Int    = -1 // 取今月
    var cDay:Int       = -1 // 取今日
    
    //▼刷新頁面
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        dateFormat.dateFormat = "yyyy"
        cYear = Int(dateFormat.string(from: Date()))!
        
        dateFormat.dateFormat = "MM"
        cＭonth = Int(dateFormat.string(from: Date()))!
        
        dateFormat.dateFormat = "dd"
        cDay = Int(dateFormat.string(from: Date()))!

        db.Init()
        
        if db.openDatabase() {
            iName.removeAll()
            iAmount.removeAll()
            iYear.removeAll()
            iＭonth.removeAll()
            iDay.removeAll()
            
            statement = db.fetch(table: "iceBox", cond: "iId")
            
            while sqlite3_step(statement) == SQLITE_ROW {
                let _name:String = String(cString: sqlite3_column_text(statement, 1))
                let _amount:Int  = Int(sqlite3_column_int(statement, 3))
//                let _day:Int     = Int(String(cString: sqlite3_column_text(statement, 4)).components(separatedBy: "-")[2])! - cDay
                let _yMd:String    = String(cString: sqlite3_column_text(statement, 4))
                
                let aY:Int = Int(_yMd.components(separatedBy: "-")[0])! - cYear
                let aM:Int = Int(_yMd.components(separatedBy: "-")[1])! - cＭonth
                let aD:Int = Int(_yMd.components(separatedBy: "-")[2])! - cDay
                
                iName.append(_name)
                iAmount.append(_amount)
                //iDay.append(_day)
                iYear.append(aY)
                iＭonth.append(aM)
                iDay.append(aD)
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
            iYear.removeAll()
            iＭonth.removeAll()
            iDay.removeAll()
            
            statement = db.fetch(table: "iceBox", cond: "iId")
            
            while sqlite3_step(statement) == SQLITE_ROW {
                let _name:String = String(cString: sqlite3_column_text(statement, 1))
                let _amount:Int  = Int(sqlite3_column_int(statement, 3))
                //                let _day:Int     = Int(String(cString: sqlite3_column_text(statement, 4)).components(separatedBy: "-")[2])! - cDay
                let _yMd:String    = String(cString: sqlite3_column_text(statement, 4))
                
                let aY:Int = Int(_yMd.components(separatedBy: "-")[0])! - cYear
                let aM:Int = Int(_yMd.components(separatedBy: "-")[1])! - cＭonth
                let aD:Int = Int(_yMd.components(separatedBy: "-")[2])! - cDay
                
                iName.append(_name)
                iAmount.append(_amount)
                //iDay.append(_day)
                iYear.append(aY)
                iＭonth.append(aM)
                iDay.append(aD)
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
                
                data.gData  = true
                data.gName  = iName[indexPath.row]
                data.gYear  = iYear[indexPath.row]
                data.gMonth = iＭonth[indexPath.row]
                data.gDay   = iDay[indexPath.row]
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
        let riYear   = iYear[indexPath.row]  * -1
        let riＭonth = iＭonth[indexPath.row] * -1
        let riDay    = iDay[indexPath.row]   * -1
        //let rDay  = ((iDay[indexPath.row] < 0) ? "過期 (\(riDay) 天)" : ((iDay[indexPath.row] == 0) ? "今天 (即將)" : "\(iDay[indexPath.row]) 天"))
        
        var rYear = ((iYear[indexPath.row] < 0) ? riYear * -1 : ((iYear[indexPath.row] == 0) ? 0 : iYear[indexPath.row]))
        var rＭonth = ((iＭonth[indexPath.row] < 0) ? riＭonth * -1 : ((iＭonth[indexPath.row] == 0) ? 0 : iＭonth[indexPath.row]))
        var rDay  = ((iDay[indexPath.row] < 0) ? riDay * -1 : ((iDay[indexPath.row] == 0) ? 0 : iDay[indexPath.row]))
        
        cell.iName.text      = "\(iName[indexPath.row])"
        cell.iAmount.text    = "數量：\(iAmount[indexPath.row])"
        cell.iDate.text      = "有效期限："
        // cell.iDate.text = "\(rYear)年\(rＭonth)月\(rDay)號"
        if rYear == 0 {
            if rＭonth == 0 {
                if rDay == 0 {
                    cell.iDate.text      = cell.iDate.text! + "今天 (即將)"
                    cell.iDate.textColor = UIColor.blue
                } else if rDay < 0 {
                    cell.iDate.text      = cell.iDate.text! + "過期 (\(rDay * -1)天)"
                    cell.iDate.textColor = UIColor.red
                } else if rDay > 0 {
                    cell.iDate.text      = cell.iDate.text! + "\(rDay)天"
                    cell.iDate.textColor = UIColor.darkGray
                }
            } else if rＭonth < 0 {
                if rDay == 0 {
                    cell.iDate.text      = cell.iDate.text! + "過期 (\(rＭonth)月)"
                    cell.iDate.textColor = UIColor.red
                } else if rDay < 0 {
                    cell.iDate.text      = cell.iDate.text! + "過期 (\(rＭonth * -1)月\(rDay * -1)天)"
                    cell.iDate.textColor = UIColor.red
                } else if rDay > 0 {
                    cell.iDate.text      = cell.iDate.text! + "過期 (\(rＭonth * -1)月\(rDay)天)"
                    cell.iDate.textColor = UIColor.red
                }
            } else if rＭonth > 0 {
                if rDay == 0 {
                    cell.iDate.text      = cell.iDate.text! + "\(rＭonth)月"
                    cell.iDate.textColor = UIColor.darkGray
                } else if rDay < 0 {
                    cell.iDate.text      = cell.iDate.text! + "\(rＭonth)月\(rDay * -1)天"
                    cell.iDate.textColor = UIColor.darkGray
                } else if rDay > 0 {
                    cell.iDate.text      = cell.iDate.text! + "\(rＭonth)月\(rDay)天"
                    cell.iDate.textColor = UIColor.darkGray
                }
            }
        } else if rYear < 0 {
            if rＭonth == 0 {
                if rDay == 0 {
                    cell.iDate.text      = cell.iDate.text! + "過期 (\(rYear * -1)年)"
                    cell.iDate.textColor = UIColor.red
                } else if rDay < 0 {
                    cell.iDate.text      = cell.iDate.text! + "過期 (\(rYear * -1)年\(rDay * -1)天)"
                    cell.iDate.textColor = UIColor.red
                    
                } else if rDay > 0 {
                    cell.iDate.text      = cell.iDate.text! + "過期 (\(rYear * -1)年\(rDay)天)"
                    cell.iDate.textColor = UIColor.red
                }
            } else if rＭonth < 0 {
                if rDay == 0 {
                    cell.iDate.text      = cell.iDate.text! + "過期 (\(rYear * -1)年\(rＭonth * -1)月)"
                    cell.iDate.textColor = UIColor.red
                } else if rDay < 0 {
                    cell.iDate.text      = cell.iDate.text! + "過期 (\(rYear * -1)年\(rＭonth * -1)月\(rDay * -1)天)"
                    cell.iDate.textColor = UIColor.red
                } else if rDay > 0 {
                    cell.iDate.text      = cell.iDate.text! + "過期 (\(rYear * -1)年\(rＭonth * -1)月\(rDay)天)"
                    cell.iDate.textColor = UIColor.red
                }
            } else if rＭonth > 0 {
                if rDay == 0 {
                    cell.iDate.text      = cell.iDate.text! + "過期 (\(rYear * -1)年\(rＭonth)月)"
                    cell.iDate.textColor = UIColor.red
                } else if rDay < 0 {
                    cell.iDate.text      = cell.iDate.text! + "過期 (\(rYear * -1)年\(rＭonth)月\(rDay * -1)天)"
                    cell.iDate.textColor = UIColor.red
                } else if rDay > 0 {
                    cell.iDate.text      = cell.iDate.text! + "過期 (\(rYear * -1)年\(rＭonth)月\(rDay)天)"
                    cell.iDate.textColor = UIColor.red
                }
            }
        } else if rYear > 0 {
            if rＭonth == 0 {
                if rDay == 0 {
                    cell.iDate.text      = cell.iDate.text! + "\(rYear)年"
                    cell.iDate.textColor = UIColor.darkGray
                } else if rDay < 0 {
                    cell.iDate.text      = cell.iDate.text! + "\(rYear)年\(rDay * -1)天"
                    cell.iDate.textColor = UIColor.darkGray
                } else if rDay > 0 {
                    cell.iDate.text      = cell.iDate.text! + "\(rYear)年\(rDay)天"
                    cell.iDate.textColor = UIColor.darkGray
                }
            } else if rＭonth < 0 {
                if rDay == 0 {
                    cell.iDate.text      = cell.iDate.text! + "\(rYear)年\(rＭonth * -1)月"
                    cell.iDate.textColor = UIColor.darkGray
                } else if rDay < 0 {
                    cell.iDate.text      = cell.iDate.text! + "\(rYear)年\(rＭonth * -1)月\(rDay * -1)天"
                    cell.iDate.textColor = UIColor.darkGray
                } else if rDay > 0 {
                    cell.iDate.text      = cell.iDate.text! + "\(rYear)年\(rＭonth * -1)月\(rDay)天"
                    cell.iDate.textColor = UIColor.darkGray
                }
            } else if rＭonth > 0 {
                if rDay == 0 {
                    cell.iDate.text      = cell.iDate.text! + "\(rYear)年\(rＭonth)月"
                    cell.iDate.textColor = UIColor.darkGray
                } else if rDay < 0 {
                    cell.iDate.text      = cell.iDate.text! + "\(rYear)年\(rＭonth)月\(rDay * -1)天"
                    cell.iDate.textColor = UIColor.darkGray
                } else if rDay > 0 {
                    cell.iDate.text      = cell.iDate.text! + "\(rYear)年\(rＭonth)月\(rDay)天"
                    cell.iDate.textColor = UIColor.darkGray
                }
            }
        }
        
        //cell.iDate.text = "有效期限：\( (rYear == 0 && rMonth == 0 && rDay == 0) ? "今天" : ((rYear == 0 && rMonth == 0 && rDay => 1) ? "\(rDay)天" : ""))"
        
        
        //cell.iDate.text = "有效期限：\(((rYear < 0 || rＭonth < 0) && rDay <= 0) ? "已過期" : (((rYear == 0 || rＭonth == 0) && rDay == 0) ? "今天 (即將)" : "\((rYear > 0) ? "\(rYear)年" : "")\((rＭonth > 0) ? "\(rＭonth)月" : "")\((rDay > 0) ? "\(rDay)天" : "")"))"
        
        //cell.iDate.textColor = (((rYear < 0 || rＭonth < 0) && rDay <= 0) ? UIColor.red : (((rYear == 0 || rＭonth == 0) && rDay == 0) ? UIColor.blue : UIColor.darkGray))
        
        
       // cell.iDate.textColor = (((iYear[indexPath.row] < 0 || iＭonth[indexPath.row] < 0)  && (iDay[indexPath.row] < 0)) ? UIColor.red : ((iDay[indexPath.row] == 0) ? UIColor.blue : UIColor.darkGray))

        return cell
    }
}
