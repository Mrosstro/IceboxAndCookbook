import Foundation

class DBManage {
    let databaseFileName = "database.sqlite"
    
    var databasePath: String!
    var database: OpaquePointer? = nil
    
    func Init() {
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        
        databasePath = documentsDirectory.appending("/\(databaseFileName)")
        
        print(">> DB Init")
    }
    
    func deleteDataBase() {
        let dir_ = FileManager.default
        
        do {
            try dir_.removeItem(atPath: databasePath)
            
            print(">> DB Detlte")
        } catch {}
    }
    
    func createDataBase() {
        let dir_ = FileManager.default
        
        if (dir_.fileExists(atPath: databasePath) == false) {
            print(">> not find SQLite File")
            dir_.createFile(atPath: databasePath, contents: nil)
            print(">> create: SQLite File")
            
            _ = openDatabase()
        } else {
            print(">> SQLite File Exist")
            
            _ = openDatabase()
        }
    }
    
    func openDatabase() -> Bool {
        var ok: Bool = false
        
        if sqlite3_open(databasePath, &database) == SQLITE_OK {
            ok = true
            
            print(">> SQLite File Open : OK")
        } else {
            print(">> SQLite File Open : ERROR")
        }
        
        return ok
    }
    
    func closeDatabase() {
        if openDatabase() == true {
            sqlite3_close(database)
            print(">> SQLite File Close")
        }
    }
    
    func createTable(sql: String) -> Bool {
        var ok: Bool = false
        
        if sqlite3_exec(database, "\(sql)", nil, nil, nil)
            == SQLITE_OK{
            ok = true
            print(sql)
        }
        
        return ok
    }
    
    func addData(table: String, kv: [String] ...) {
        var statement :OpaquePointer? = nil
        var sql = "INSERT INTO '\(table)' ('iId', "
        var sqlA = ""
        var sqlB = ""
        
        var j = 0
        for i in kv {
            
            if (j == (kv.count - 1)) {
                sqlA.append("'\(i[0])'")
                sqlB.append("'\(i[1])'")
            } else {
                sqlA.append("'\(i[0])', ")
                sqlB.append("'\(i[1])', ")
            }
            
            j += 1
        }
        
        sql = sql + sqlA + ") VALUES (NULL, " + sqlB + ")"
        print(sql)
        let addSQL = sqlite3_prepare_v2(database, "\(sql)", -1, &statement, nil)
        
        if addSQL == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DENY {
            }
            print("成功寫入")
            
            sqlite3_finalize(statement)
        } else {
            print("寫入失敗")
            
        }
    }
    
    func updateData(table: String, kv: [String], kv2: [String] ...) {
        var statement :OpaquePointer? = nil
        var sql = "UPDATE '\(table)' SET "
        var sqlA = ""
        
        var j = 0
        for i in kv2 {
            
            if (j == (kv2.count - 1)) {
                sqlA.append("\(i[0]) = '\(i[1])'")
            } else {
                sqlA.append("\(i[0]) = '\(i[1])', ")
            }
            
            j += 1
        }
        
        sql = sql  + sqlA + " WHERE \(kv[0]) = '\(kv[1])'"
        
        let updateSQL = sqlite3_prepare_v2(database, "\(sql)", -1, &statement, nil)
        
        if updateSQL == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_OK {
                print("update data: \(kv[1])")
            } else if sqlite3_step(statement) == SQLITE_BUSY {
                print("ERROR update data: \(kv[1])")
            } else if sqlite3_step(statement) == 21 {
                print("out of M update data: \(kv[1])")
            }
            
            print(sqlite3_step(statement))
            
            sqlite3_finalize(statement)
        } else {
            print("delete ERROR")
        }
    }
    
    func deleteData(table: String, kv: [String]) {
        var statement :OpaquePointer? = nil
        let sql = "DELETE FROM '\(table)' WHERE \(kv[0]) = '\(kv[1])'"
        
        let daleteSQL = sqlite3_prepare_v2(database, "\(sql)", -1, &statement, nil)
        
        if daleteSQL == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_OK {
                print("delete data: \(kv[1])")
            } else if sqlite3_step(statement) == SQLITE_BUSY {
                print("ERROR delete data: \(kv[1])")
            } else if sqlite3_step(statement) == 21 {
                print("out of M delete data: \(kv[1])")
            }
            
            print(sqlite3_step(statement))
            
            sqlite3_finalize(statement)
        } else {
            print("delete ERROR")
        }
    }
    
    func fetch(table :String, cond :String?) -> OpaquePointer {
        var statement :OpaquePointer? = nil
        var sql = "SELECT * FROM '\(table)' WHERE "
        if let condition = cond {
            sql += " \(condition)"
        }
        
        /*
         SELECT * FROM Customers
         WHERE CustomerName LIKE 'a%';
         
         */
        print(sql)
        
        sqlite3_prepare_v2(database, "\(sql)", -1, &statement, nil)
        
        return (statement)!
    }

}
