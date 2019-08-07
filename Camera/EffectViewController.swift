//
//  EffectViewController.swift
//  Camera
//
//  Created by shu on 2019/07/26.
//  Copyright © 2019 shu26. All rights reserved.
//

import UIKit

class EffectViewController: UIViewController {
    
    // 何も加工などをしていない，撮影したときの画像
    var originalImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        effectImageView.image = originalImage
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBOutlet weak var effectImageView: UIImageView!
    
    // filter名を指定
    var filterName = Filter.Mono
    
    @IBAction func effectButtonAction(_ sender: Any) {
        // エフェクト前の画像をアンラップして取り出す
        if let image = originalImage {
            
            // フィルター名を指定する
            filterName.next()
            // 元々の画像の回転角度を取得
            let rotate = image.imageOrientation
            // UIImage型の画像をCIImage型に変換
            let inputImage = CIImage(image: image)
            // フィルターの種類を引数で指定されたものに指定してCIFilterインスタンスを取得
            guard let effectFilter = CIFilter(name: filterName.rawValue) else {
                return
            }
            // エフェクトのパラメータを初期化
            effectFilter.setDefaults()
            // インスタンスにエフェクトする元画像を設定
            effectFilter.setValue(inputImage, forKey: kCIInputImageKey)
            // エフェクトを適用したCGImage型の画像を取得
            guard let outputImage = effectFilter.outputImage else {
                return
            }
            // CIContextのインスタンスを取得
            let ciContext = CIContext(options: nil)
            // エフェクト後の画像をCIContext上に描画し，結果をCGImage型で取得
            guard let cgImage = ciContext.createCGImage(outputImage, from: outputImage.extent) else{
                return
            }
            // CGImage型からUIImage型に変換，回転角度を指定して表示
            effectImageView.image = UIImage(cgImage: cgImage, scale: 1.0, orientation: rotate)
        }
    }
    
    
    @IBAction func shareButtonAction(_ sender: Any) {
        // 表示画像をアンラップしてシェア画像を取り出す
        if let shareImage = effectImageView.image{
            // UIActivityViewControllerに渡す配列を作成
            let shareItems = [shareImage]
            // UIActivityViewControllerにシェア画像を渡す
            let activityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
            // UIActivityViewControllerを表示
            present(activityViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    enum Filter: String {
        case Mono = "CIPhotoEffectMono"
        case Instant = "CIPhotoEffectInstant"
        case Process = "CIPhotoEffectProcess"
        case Transfer = "CIPhotoEffectTransfer"
        case Sepia = "CISepiaTone"
        
        static let values = [Mono, Instant, Process, Transfer, Sepia]
        mutating func next() {
            let val = (Filter.values.firstIndex(of: self)! + 1) % Filter.values.count
            self = Filter.values[val]
        }
    }
}
