import UIKit

class Home: UIViewController {
    let db = DBManage()
    var statement:OpaquePointer? = nil
    
    var checkTimer:Timer?
    
    @IBOutlet weak var clickStrat: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clickStrat.isEnabled = false
        
        db.Init()
        //db.deleteDataBase()
        db.createDataBase()
        
        if db.openDatabase() {
            // 使用者列表
            _ = db.createTable(sql: "create table userList (iId integer primary key autoincrement not null, uName text not null)")
            
            // 食物類型
            _ = db.createTable(sql: "create table foodType (iId integer primary key autoincrement not null, fName text not null)")
            
            // 冰箱
            _ = db.createTable(sql: "create table iceBox (iId integer primary key autoincrement not null, iName text not null, iType text not null, iAmount text not null, iDate text not null)")
            
            // 食譜列表
            _ = db.createTable(sql: "create table recipeList (iId integer primary key autoincrement not null, rImage text not null, rName text not null, rRequire text not null, rDesc text not null, rLove text not null, rView text not null)")
            
            // 我的食譜
            _ = db.createTable(sql: "create table myRecipe (iId integer primary key autoincrement not null, mName text not null, mRecipe text not null)")
            
            //  檢查“食物類型”是否為空的，若是空的添加“食物類型”資料
            var typeEmpty:Bool = true
            
            statement = db.fetch(table: "foodType", cond: "iId")
            
            while sqlite3_step(statement) == SQLITE_ROW {
                typeEmpty = false
                break;
            }
            
            sqlite3_finalize(statement)
            
            if typeEmpty {
                let data:[String] = ["肉類","蔬菜","魚類","菇類","瓜類","豆類","奶類","水果","飲料","調味品","其他食材"]
                
                for i in data {
                    db.addData(table: "foodType", kv: ["fName", i])
                }
            }
            
            
            
            //  檢查“食譜列表”是否為空的，若是空的添加“食譜列表”資料
            var recipeEmpty:Bool = true
            
            statement = db.fetch(table: "recipeList", cond: "iId")
            
            while sqlite3_step(statement) == SQLITE_ROW {
                recipeEmpty = false
                break;
            }
            
            sqlite3_finalize(statement)
            
            if recipeEmpty {
                let data:[[String]] = [
                    ["大黃瓜貢丸湯", "芹菜,大黃瓜,貢丸"],
                    ["南瓜黃金泡菜", "小高麗菜,小南瓜,蒜,薑"],
                    ["焦糖小魚乾花生", "蒜,花生,丁香魚乾"],
                    ["涼拌水晶苦瓜", "檸檬,苦瓜"],
                    ["涼拌小黃瓜", "小黃瓜,蒜"],
                    ["黑糖薑茶", "薑母"],
                    ["香蒜奶油干貝", "蒜,玉米筍,綠花椰菜,生干貝"],
                    ["紅燒川味牛肉", "薑,蔥,白蘿蔔,紅蘿蔔,牛肋條"],
                    ["三杯杏鮑菇(紫蘇口味)", "薑,蔥,蒜,紅蘿蔔,黑木耳,杏鮑菇,紫蘇"],
                    ["花開富貴把把在握", "蒜,紅蘿蔔,綠花椰菜,九孔"],
                    ["炒海瓜子", "九層塔,薑,蔥,蒜,海瓜子"],
                    ["橙汁排骨", "柳丁汁,排骨、雞蛋"],
                    ["乾煎大蝦", "洋蔥,蒜,草蝦"],
                    ["排骨蓮藕湯", "蔥,蒜,蓮藕,魷魚乾"],
                    ["南瓜天婦羅", "南瓜"],
                    ["茄子熱沙拉", "九層塔,茄子"]
                ]
                
                for i in data {
                    db.addData(table: "recipeList", kv: ["rImage", ""], ["rName", "\(i[0])"], ["rRequire", "\(i[1])"], ["rDesc", "-"], ["rLove", "0"], ["rView", "0"])
                }
            }
            
            
            
            //  檢查“使用者列表”是否為空的，若是空的執行下方功能
            var userEmpty:Bool = true
            
            statement = db.fetch(table: "userList", cond: "iId")
            
            while sqlite3_step(statement) == SQLITE_ROW {
                userEmpty = false
                
                break;
            }
            
            sqlite3_finalize(statement)
            
            if userEmpty {
                checkTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(checkRunTimer), userInfo: nil, repeats: true)
            } else {
                clickStrat.isEnabled = true
            }
            
            db.closeDatabase()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func checkRunTimer() {
        Login()
        
        checkTimer?.invalidate()
        checkTimer = nil
    }
    
    func Login() {
        let uiAC  = UIAlertController(title: "系統登錄", message: "請輸入用戶名稱", preferredStyle: .alert)
        let uiBtn = UIAlertAction(title: "登錄", style: UIAlertActionStyle.default) { (UIAlertAction) in
            let uiText = (uiAC.textFields?.first)! as UITextField
            
            if uiText.text!.isEmpty {
                self.Login()
                return
            }
            
            self.db.Init()
            
            if self.db.openDatabase() {
                self.db.addData(table: "userList", kv: ["uName", uiText.text!])
                
                self.clickStrat.isEnabled = true
            }
            
            self.db.closeDatabase()
        }
        
        uiAC.addTextField { (UITextField) in
            UITextField.placeholder = "使用者名稱"
        }
        uiAC.addAction(uiBtn)
        self.present(uiAC, animated: true, completion: nil)
    }
}
