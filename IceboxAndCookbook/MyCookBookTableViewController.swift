//
//  MyCookBookTableViewController.swift
//  IceboxAndCookbook
//
//  Created by Mrosstro on 2017/5/8.
//  Copyright © 2017年 Mrosstro. All rights reserved.
//

import UIKit

class MyCookBookTableViewController: UITableViewController {

    //▼範例用
    var testName: [String] = ["番茄義大利麵","豬肉水餃","貢丸湯","羊肉爐"]
    var testLike: [String] = ["1000","3000","5000","3000"]
    var testWatch: [String] = ["10000","50000","30000","20000"]
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCookBookTableViewCell", for: indexPath) as! MyCookBookTableViewCell
        
        cell.MName.text = "\(testName[indexPath.row])"
        cell.MLike.text = "❤️：\(testLike[indexPath.row])"
        cell.MWatch.text = "👁‍🗨：\(testWatch[indexPath.row])"
        
        return cell
    }
    
}
