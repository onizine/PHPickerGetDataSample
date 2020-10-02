//
//  ViewController.swift
//  PHPickerSample
//
//  Created by 鬼塚　峰行 on 2020/10/01.
//

import UIKit
import PhotosUI

class ViewController: UIViewController,PHPickerViewControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func onTapImageButton(_ sender: Any) {
    }
    
    
    private func showPhpicker() {
        //取得時に画像データだけであれば取得可能
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
            config.selectionLimit = 1
            config.filter = PHPickerFilter.images

            let pickerViewController = PHPickerViewController(configuration: config)
            pickerViewController.delegate = self

            self.present(pickerViewController, animated: true, completion: nil)

    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: {
            // TODO: PHPickerViewが閉じた後の処理
        })
        
        guard let provider = results.first?.itemProvider else { return }
        guard let typeIdentifer = provider.registeredTypeIdentifiers.first else { return }

        // 判定可能な識別子であるかチェック
        if provider.hasItemConformingToTypeIdentifier(typeIdentifer) {
            //Live Photoとして取得可能化
            if provider.canLoadObject(ofClass: PHLivePhoto.self) {
                //LivePhotoはClassを指定してLoadObjectで読み込み
                
                provider.loadObject(ofClass: PHLivePhoto.self) { (livePhotoObject, error) in
                    do {
                        if let livePhoto:PHLivePhoto = livePhotoObject as? PHLivePhoto {
                            // Live Photoのプロパティから静止画を抜き出す(HEIC形式)
                            if let imageUrl = livePhoto.value(forKey: "imageURL") as? URL {
                            
                                // URLからDataを生成（HEIC内のデータを参照してるため取得できる
                                let data:Data = try Data(contentsOf: imageUrl)
                                // UIImageも生成する
                                let image = UIImage(data: data)
                                
                                self.imageView.image = image
                                //パスを生成して画像を保存する
                                //data.write(to: <#T##URL#>)

                            }
                        }
                    } catch {
                        
                    }
                    
                }
                
            } else if provider.canLoadObject(ofClass: UIImage.self) {
                //一般的な画像
                // 画像の場合はloadObjectでUIImageまたはloadDataで取得する。
                // loadItemでURLを取得する場合、URLからUIImageまたはDataの取得はアルバムへのアクセス権限が必要になる。
                provider.loadDataRepresentation(forTypeIdentifier: typeIdentifer) { (data, error) in
                    if let imageData = data {
                        var ext = ""
                        switch typeIdentifer{
                        case "public.jpeg":
                            ext = ".jpg"
                        case "public.png":
                            ext = ".png"
                        default:
                            break
                        }
                        
                        //画像の保存
                        //data?.write(to: <#T##URL#>)
                            
                    }
                    
                }
            }

        }

    }

}

