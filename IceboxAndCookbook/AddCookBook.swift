//
//  AddCookBook.swift
//  新增食譜...................................................
//  IceboxAndCookbook
//
//  Created by Mrosstro on 2017/5/12.
//  Copyright © 2017年 Mrosstro. All rights reserved.
//

import UIKit


class AddCookBook: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var ACUploadPhoto: UIButton!
    @IBOutlet weak var ACImage: UIImageView!
    @IBOutlet weak var ACName: UITextField!
    @IBOutlet weak var ACIngredients: UITextView!
    @IBOutlet weak var ACStep: UITextView!
    
    var imagePicker: UIImagePickerController!
    

    //▼初始化
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //▼返回上一頁
    @IBAction func ClickBack(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //▼完成
    @IBAction func ClickFinish(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ClickCamera(_ sender: UIButton) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        imagePicker.dismiss(animated: true, completion: nil)
        
        ACUploadPhoto.isEnabled = false
        ACUploadPhoto.isHidden  = true
        
        ACImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
       // UploadImageToWEB(image: (info[UIImagePickerControllerOriginalImage] as? UIImage)!, tag: "fgng")
    }
 
//    func UploadImageToWEB (image:UIImage, tag:String) -> String {
//        let storageRef = FIRStorage.storage().reference(forURL: "gs://cfsi-29f73.appspot.com/a.jpg")
//        
//        let riversRef = storageRef.child("images/rivers.jpg")
//        
//        // Upload the file to the path "images/rivers.jpg"
//        let uploadTask = riversRef.putData(image, metadata: nil) { (metadata, error) in
//            guard let metadata = metadata else {
//                // Uh-oh, an error occurred!
//                return
//            }
//            // Metadata contains file metadata such as size, content-type, and download URL.
//            let downloadURL = metadata.downloadURL
//        }
//        return "bdfb"
//    }
}
