//
//  CookRKTableViewController.swift
//  IceboxAndCookbook
//
//  Created by Mrosstro on 2017/5/7.
//  Copyright © 2017年 Mrosstro. All rights reserved.
//

import UIKit

class CookRKTableViewController: UITableViewController {

    //▼範例用
    var testRK: [String] = ["1","2","3","4"]
    var testName: [String] = ["貢丸湯","豬肉水餃","番茄義大利麵","羊肉爐"]
    var testLike: [String] = ["5000","3000","3000","1000"]
    var testWatch: [String] = ["10000","50000","20000","30000"]
    
    //▼初始化
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    //▼有幾組 row
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return testName.count
    }
    
    //▼顯示 row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CookRKTableViewCell", for: indexPath) as! CookRKTableViewCell
        
        switch testRK[indexPath.row] {
        case "1":
            cell.CRk.textColor =
                UIColor(colorLiteralRed: 255/255, green: 191/255, blue: 0/255, alpha: 1.0)
            cell.CRk.font = UIFont(name: cell.CRk.font.fontName, size: 26)
            break;
        case "2":
            cell.CRk.textColor =
                UIColor(colorLiteralRed: 192/255, green: 192/255, blue: 192/255, alpha: 1.0)
            cell.CRk.font = UIFont(name: cell.CRk.font.fontName, size: 24)
            break;
        case "3":
            cell.CRk.textColor =
                UIColor(colorLiteralRed: 184/255, green: 115/255, blue: 51/255, alpha: 1.0)
            cell.CRk.font = UIFont(name: cell.CRk.font.fontName, size: 22)
            break;
        default:
            cell.CRk.textColor =
                UIColor(colorLiteralRed: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
            cell.CRk.font = UIFont(name: cell.CRk.font.fontName, size: 20)
        }
        
        cell.CRk.text = "\(testRK[indexPath.row])"
        cell.CName.text = "\(testName[indexPath.row])"
        cell.CLike.text = "❤️：\(testLike[indexPath.row])"
        cell.CWatch.text = "👁‍🗨：\(testWatch[indexPath.row])"
        
        return cell
    }
    
}
