//
//  SeeCookBookTableViewController.swift
//  IceboxAndCookbook
//
//  Created by Mrosstro on 2017/5/8.
//  Copyright © 2017年 Mrosstro. All rights reserved.
//

import UIKit

class SeeCookBookTableViewController: UITableViewController {

    @IBOutlet weak var SImage: UIImageView!
    //▼範例用
    var testimage: String = "image小黃瓜"
    var testName: String = "涼拌小黃瓜"
    var testIngredients: String = "小黃瓜300克,細砂糖40克,鹽1.5小匙,白醋40毫升,辣椒1根,蒜泥或薑泥1匙,香油數滴"
    var testDescription: String = "阿基師小黃瓜偷呷步快速入味法，臨時想吃的時候，完全不需等待、馬上入味^O^,鹽讓小黃瓜出水，所以也流失水分，反而使小黃瓜失去多汁的爽脆口感。,應該先使用糖，利用它的滲透壓讓小黃瓜快速入味。,糖和白醋都是小黃瓜的1/6，鹽少許即可。,但我不想吃太多糖，把糖和醋都減少10克也很入味喔。"
    
    //▼初始化
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 36
        tableView.rowHeight = UITableViewAutomaticDimension
        SImage.image = UIImage(named: testimage)
    }
    
    //▼替換文字
    func CharacterChange(ChangeText: String) -> String {
        var finishChangeText: String
        finishChangeText = ChangeText.replacingOccurrences(of: ",", with: "\n")
        return finishChangeText
    }
    
    //▼有幾組 row
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    //▼顯示 row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SeeCookBookTableViewCell", for: indexPath) as! SeeCookBookTableViewCell
        
        
        switch indexPath.row {
        case 0:
            print("準備名稱")
            print(indexPath.row)
            cell.SField.text = "名稱"
            cell.SValue.text = testName
            print("完成名稱")
            print(indexPath.row)
        case 1:
            print("準備食材")
            cell.SField.text = "食材"
            testIngredients = CharacterChange(ChangeText: testIngredients) 
            cell.SValue.text = testIngredients
            print("完成食材")
        case 2:
            cell.SField.text = "描述"
            cell.SValue.text = testDescription
        default:
            cell.SField.text = ""
            cell.SValue.text = ""

            
        }
        return cell
    }
}
