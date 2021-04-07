//
//  UploadPostViewController.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/04/06.
//

import UIKit
import PhotosUI

class UploadPostViewController: UIViewController,PHPickerViewControllerDelegate, LocationSearchViewControllerDelegate {
    
    // MARK: - Properties
    
    let locationSearchViewController = LocationSearchViewController()
    
    @IBOutlet weak var setLocationLabel: UILabel!
    @IBOutlet weak var selectedPhoto: UIImageView!{
        didSet {
            selectedPhoto.isUserInteractionEnabled = true
        }
    }
    
    @IBOutlet weak var publicPrivateSegmentedControl: UISegmentedControl!{
        didSet {
            publicPrivateSegmentedControl.setTitleTextAttributes([.foregroundColor : UIColor.white], for: .selected)
            publicPrivateSegmentedControl.setTitleTextAttributes([.foregroundColor : UIColor(red: 0.85, green: 0.72, blue: 0.76, alpha: 1.00)], for: .normal)
        }
    }
    
//    @IBOutlet weak var closeButton: UIBarButtonItem!
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let locationSearchViewController = segue.destination as? LocationSearchViewController {
            locationSearchViewController.delegate = self
        }
    }
    
    // MARK: - Actions
    
    @IBAction func didTapImageView(_ sender: UITapGestureRecognizer) {
        var configuration = PHPickerConfiguration()
        configuration.filter = .any(of: [.images, .videos])
        
        let picker = PHPickerViewController(configuration: configuration)
        
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func cancelUpload(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Methods
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async {
                    self.selectedPhoto.image = image as? UIImage
                }
            }
        } else {
            // TODO: Handle empty results or item provider not being able load UIImage
        }
    }
    
    func setLocation(location: String) {
        setLocationLabel.text = location
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
