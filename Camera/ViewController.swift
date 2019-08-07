//
//  ViewController.swift
//  Camera
//
//  Created by shu on 2019/07/17.
//  Copyright © 2019 shu26. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // 画面遷移時に次の画面に渡す画像
    var captureImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var pictureImageView: UIImageView!
    @IBAction func cameraButton(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // 撮影後に呼ばれるdelegateメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        captureImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        dismiss(animated: true, completion: {
            self.performSegue(withIdentifier: "showEffectView", sender: nil)
        })
    }
    
    // 画面遷移する時に画像を渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let nextViewController = segue.destination as? EffectViewController {
            nextViewController.originalImage = captureImage
        }
    }
    
}


