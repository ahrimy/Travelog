//
//  SelectedPhotoViewController.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/04/12.
//

import UIKit
import PhotosUI

protocol SelectedPhotoViewControllerDelegate: AnyObject{
    func activateUploadButton()
}

class SelectedPhotoViewController: UIViewController ,PHPickerViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource{

    // MARK: - Properties

    var images:[UIImage] = []
    var itemProviders:[NSItemProvider] = []
    var iterator:IndexingIterator<[NSItemProvider]>?
    
    // Delegate
    weak var selectedPhotoViewControllerDelegate: SelectedPhotoViewControllerDelegate?
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // MARK: - Methods
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        itemProviders = results.map(\.itemProvider)
        iterator = itemProviders.makeIterator()
        
        // Image Metadata
//        let identifiers = results.compactMap(\.assetIdentifier)
//        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
//
//        for i in 0..<fetchResult.count{
//            print(fetchResult.object(at: i))
//        }
          
        while let itemProvider = iterator?.next(),itemProvider.canLoadObject(ofClass: UIImage.self) {
            print(itemProvider.registeredTypeIdentifiers)
            itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier){[weak self](file,error)in
                if (file != nil) {
                    do{
                        let data = try Data(contentsOf: file!)
                        let image = UIImage(data: data)
                        
                        DispatchQueue.main.async {
//                            self?.selectedPhotoViewControllerDelegate?.appendImage(image: image!)
                            self?.images.append(image!)
                            self?.collectionView.reloadData()
                        }
                    }catch{
                        print("Error occured")
                    }
                }
                if (error != nil){
                    print("error")
                }
            }
        }
        
        if self.images.count > 0 {
            self.selectedPhotoViewControllerDelegate?.activateUploadButton()
        }
    }
    
    @objc func didTouchUpInsideAddPhotoButton(_ sender: Any) {
        var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        configuration.filter = .any(of: [.images, .videos])
        configuration.selectionLimit = 10 - images.count
        configuration.preferredAssetRepresentationMode = .current

        let picker = PHPickerViewController(configuration: configuration)

        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }

}

extension SelectedPhotoViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(images.count >= 10){
            return 10
        }
        return images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == (images.count), images.count < 10 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddButtonCell", for: indexPath) as! AddButtonCollectionViewCell
            cell.addPhotoButton.addTarget(self, action: #selector(self.didTouchUpInsideAddPhotoButton(_:)), for: .touchUpInside)
            cell.sizeToFit()
            
            
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedPhotoCell", for: indexPath) as! SelectedPhotoCollectionViewCell
        
        cell.imageView.image = images[indexPath.row]
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if images.count == 0 {
            return UIEdgeInsets(top: 0, left: (collectionView.frame.size.width-180)/2, bottom: 0, right: (collectionView.frame.size.width-180)/2)
        }
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == images.count {
            return CGSize(width: 180, height: 330)
        }
        return CGSize(width: 330, height: 330)
    }
}
