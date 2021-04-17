//
//  SelectedPhotoViewController.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/04/12.
//

import UIKit
import PhotosUI

class SelectedPhotoViewController: UIViewController ,PHPickerViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource{

    var selectedPhotos:[UIImage] = []
    var itemProviders:[NSItemProvider] = []
    var iterator:IndexingIterator<[NSItemProvider]>?
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @objc func didTouchUpInsideAddPhotoButton(_ sender: Any) {
        var configuration = PHPickerConfiguration()
        configuration.filter = .any(of: [.images, .videos])
        configuration.selectionLimit = 10 - selectedPhotos.count

        let picker = PHPickerViewController(configuration: configuration)

        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        itemProviders = results.map(\.itemProvider)
        iterator = itemProviders.makeIterator()
        
        while let itemProvider = iterator?.next(),itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async {
                    self.selectedPhotos.append(image as! UIImage)
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(selectedPhotos.count >= 10){
            return 10
        }
        return selectedPhotos.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == (selectedPhotos.count), selectedPhotos.count < 10 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddButtonCell", for: indexPath) as! AddButtonCollectionViewCell
            cell.addPhotoButton.addTarget(self, action: #selector(didTouchUpInsideAddPhotoButton(_:)), for: .touchUpInside)
            cell.sizeToFit()
            
            
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedPhotoCell", for: indexPath) as! SelectedPhotoCollectionViewCell
        
        cell.imageView.image = selectedPhotos[indexPath.row]
        
        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SelectedPhotoViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if selectedPhotos.count == 0 {
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
        if indexPath.row == selectedPhotos.count {
            return CGSize(width: 180, height: 330)
        }
        return CGSize(width: 330, height: 330)
    }
}
