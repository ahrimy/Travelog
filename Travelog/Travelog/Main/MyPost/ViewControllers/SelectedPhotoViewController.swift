//
//  SelectedPhotoViewController.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/04/12.
//

import UIKit
import PhotosUI

class SelectedPhotoViewController: UIViewController ,PHPickerViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource{

    var selectedPhotos:[UIImage] = [];
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

        let picker = PHPickerViewController(configuration: configuration)

        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async {
                    self.selectedPhotos.append(image as! UIImage)
                    self.collectionView.reloadData()
                }
            }
        } else {
            // TODO: Handle empty results or item provider not being able load UIImage
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("list count",selectedPhotos.count + 1)
        return selectedPhotos.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(indexPath.row == (selectedPhotos.count) )
        if indexPath.row == (selectedPhotos.count) {
            print("Last")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddButtonCell", for: indexPath) as! AddButtonCollectionViewCell
            cell.addPhotoButton.addTarget(self, action: #selector(didTouchUpInsideAddPhotoButton(_:)), for: .touchUpInside)
            
            return cell
        }
        print(selectedPhotos[indexPath.row])
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
