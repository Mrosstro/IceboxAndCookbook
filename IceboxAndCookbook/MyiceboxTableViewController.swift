//
//  MyiceboxTableViewController.swift
//  IceboxAndCookbook
//
//  Created by Mrosstro on 2017/5/4.
//  Copyright © 2017年 Mrosstro. All rights reserved.
//

//注意！！，cell的Identifier是否有打錯，cell是否有連結正確，class是否有連結


import UIKit

class MyiceboxTableViewController: UITableViewController {
    
    //▼範例用
    var testName: [String] = ["番茄","茄子","豬肉","苦瓜","羊肉"]
    var testAmount: [String] = ["3","4","300","1","400"]
    var testDate: [String] = ["7","9","5","8","3"]

    //▼初始化
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    //▼有幾組 row
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return testName.count
    }

    //▼顯示 row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyiceboxTableViewCell", for: indexPath) as! MyiceboxTableViewCell

        cell.iName.text = "\(testName[indexPath.row])"
        cell.iAmount.text = "數量：\(testAmount[indexPath.row])"
        cell.iDate.text = "有效期限：\(testDate[indexPath.row]) 天"

        return cell
    }
}
