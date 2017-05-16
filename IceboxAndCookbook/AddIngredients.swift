//
//  AddIngredients.swift
//  添加食材
//  IceboxAndCookbook

//  注意！！，cell的Identifier是否有打錯，cell是否有連結正確，class是否有連結

import UIKit

class AddIngredients: UITableViewController, UIPickerViewDelegate {
    var db = DBManage()
    var fType:[String] = []
    
    var gData:Bool = false
    var gName:String?
    var gYear:Int?
    var gMonth:Int?
    var gDay:Int?
    
    //▼宣告
    @IBOutlet weak var pickerView:  UIPickerView!
    @IBOutlet weak var AzName:      UITextField!
    @IBOutlet weak var AzAmount:    UITextField!
    @IBOutlet weak var AzDate:      UIDatePicker!
    @IBOutlet weak var Finish:      UIBarButtonItem!
    var AzType:String?
    
    //▼初始化
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        
        db.Init()
        db.createDataBase()
        
        if db.openDatabase() {
            let statement = db.fetch(table: "foodType", cond: "iId")
            
            fType.removeAll()
            
            while sqlite3_step(statement) == SQLITE_ROW {
                let n:String = String(cString: sqlite3_column_text(statement, 1))
                fType.append(n)
            }
            
            sqlite3_finalize(statement)
        }
        
        if gData == true {
            let statement =  db.fetch(table: "iceBox", cond: "iName='\(gName!)'")
            
            while sqlite3_step(statement) == SQLITE_ROW {
                let n:String = String(cString: sqlite3_column_text(statement, 1))
                let t = String(cString: sqlite3_column_text(statement, 2))
                let a:Int    = Int(sqlite3_column_int(statement, 3))
                let d:String = String(cString: sqlite3_column_text(statement, 4))
                
                var aC:Int = 0
                var aI:Int = 0
                
                for i in fType {
                    if t.range(of: i) != nil {
                        aC = aI
                        print("aC=\(aC)")
                    }
                    
                    aI += 1
                }
                
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "yyyy-MM-dd"
                
                let date:Date = dateFormat.date(from: d)!
                
                self.title    = n
                AzName.text   = n
                AzAmount.text = "\(a)"
                pickerView.selectRow(aC, inComponent: 0, animated: true)
                AzDate.setDate(date, animated: true)
                
                AzName.isEnabled = false
                
                break
            }
            
            sqlite3_finalize(statement)
            
            if gYear! > 0 {
                return
            }
            
            if gMonth! > 0 {
                return
            }
            
            if gDay! >= 0 {
                return
            }
            
           // if gYear! < 0 && gMonth! < 0 && gDay! < 0 {
                let uiAC     = UIAlertController(title: "系統訊息！", message: "該 \(gName!) 食材過期，請刪除．", preferredStyle: .alert)
                let uiAA_del = UIAlertAction(title: "刪除", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                    print("1")
                    if self.db.openDatabase() {
                        print("2")
                        print("\(self.gName!)")
                        self.db.deleteData(table: "iceBox", kv: ["iName", "\(self.gName!)"])
                        self.navigationController?.popViewController(animated: true)
                    }
                })
                let uiAA_cl = UIAlertAction(title: "修改", style: UIAlertActionStyle.cancel, handler: nil)
                
                uiAC.addAction(uiAA_cl)
                uiAC.addAction(uiAA_del)
                
                self.present(uiAC, animated: true, completion: nil)
                
                return
           // }
            
        } else {
            self.Finish.title = "新增"
        }
    }
    //▼返回上一頁
    @IBAction func ClickBack(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        return
    }
    //▼完成
    @IBAction func ClickFinish(_ sender: UIBarButtonItem) {
        if AzName.text!.isEmpty || AzAmount.text!.isEmpty {
            ShowWarningWindow(title: "系統訊息！", message: "欄位不得空白．")
            return
        }
        
        if Int(AzAmount.text!)! <= 0 {
            ShowWarningWindow(title: "系統訊息！", message: "請輸入有效的數量．")
            return
        }
        
        if db.openDatabase() == false {
            ShowWarningWindow(title: "系統訊息！", message: "更新失敗，沒有使用資料庫．")
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if Finish.title == "新增" {
            var checkName:Bool = false
            
            let statement =  db.fetch(table: "iceBox", cond: "iName='\(AzName.text!)'")
            
            while sqlite3_step(statement) == SQLITE_ROW {
                checkName = true
            }
            
            sqlite3_finalize(statement)
            
            if checkName {
                ShowWarningWindow(title: "系統訊息！", message: "新增失敗，該食材已經有了．")
                return
            }
            
            db.addData(table: "iceBox", kv: ["iName", "\(AzName.text!)"], ["iAmount", "\(AzAmount.text!)"], ["iType", "\(AzType)"], ["iDate", formatter.string(from: AzDate.date)])
            ShowWarningWindow(title: "系統訊息！", message: "新增成功．", back: true)
        } else {
            db.updateData(table: "iceBox", kv: ["iName", "\(AzName.text!)"], kv2: ["iAmount", "\(AzAmount.text!)"], ["iType", "\(AzType)"], ["iDate", formatter.string(from: AzDate.date)])
            ShowWarningWindow(title: "系統訊息！", message: "更新成功．", back: true)
        }
        
    }
    
    
    func ShowWarningWindow(title:String, message:String, back:Bool = false)
    {
        let uiAC     = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var uiAA_cl:UIAlertAction? = nil
        
        
        if back {
            uiAA_cl = UIAlertAction(title: "確定", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                self.navigationController?.popViewController(animated: true)
                
            })
        } else {
            uiAA_cl = UIAlertAction(title: "確定", style: UIAlertActionStyle.cancel, handler: nil)
        }
        
        uiAC.addAction(uiAA_cl!)
        self.present(uiAC, animated: true, completion: nil)
        
    }
    
    // ▼UIPickerViewDataSource 必須實作的方法：
    // UIPickerView 有幾列可以選擇
    func numberOfComponentsInPickerView(
        pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // UIPickerViewDataSource 必須實作的方法：
    // UIPickerView 各列有多少行資料
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        // 返回陣列 fType 的成員數量
        return fType.count
    }
    
    // UIPickerView 每個選項顯示的資料
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        // 設置為陣列 fType 的第 row 項資料
        AzType = "\(fType[row])"

        return fType[row]
    }
    
    // UIPickerView 改變選擇後執行的動作
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int, inComponent component: Int) {
        AzType = "\(fType[row])"
    }
}
