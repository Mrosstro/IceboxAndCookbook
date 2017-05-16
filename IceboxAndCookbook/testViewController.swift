//
//  testViewController.swift
//  IceboxAndCookbook
//
//  Created by Mrosstro on 2017/5/6.
//  Copyright © 2017年 Mrosstro. All rights reserved.
//

import UIKit

class testViewController: UIViewController, UIPickerViewDelegate {

    let meals = ["肉類","蔬菜","奶類","豆類"]
    
    @IBOutlet weak var value: UILabel!

    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        value.text = meals[0]
        pickerView.delegate = self
    }
    
    // UIPickerViewDataSource 必須實作的方法：
    // UIPickerView 有幾列可以選擇
    func numberOfComponentsInPickerView(
        pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // UIPickerViewDataSource 必須實作的方法：
    // UIPickerView 各列有多少行資料
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        // 返回陣列 meals 的成員數量
        return meals.count
    }
    
    // UIPickerView 每個選項顯示的資料
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        // 設置為陣列 meals 的第 row 項資料
        return meals[row]
    }
    
    // UIPickerView 改變選擇後執行的動作
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int, inComponent component: Int) {
        // 將 UITextField 的值更新為陣列 meals 的第 row 項資料
        value?.text = meals[row]
    }

    
}
