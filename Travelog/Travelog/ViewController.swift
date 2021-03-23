//
//  ViewController.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/03/22.
//

import UIKit


class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBAction func addAction(_ sender: Any) {

    let alert =  UIAlertController(title: "원하는 타이틀", message: "원하는 메세지", preferredStyle: .actionSheet)

    let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in self.openLibrary()

    }

    let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in
    self.openCamera()
    }

    let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    alert.addAction(library)
    alert.addAction(camera)
    alert.addAction(cancel)
    present(alert, animated: true, completion: nil)

    }
    
    let picker = UIImagePickerController()
    
    func openLibrary(){

      picker.sourceType = .photoLibrary

      present(picker, animated: false, completion: nil)

    }

    func openCamera(){

      picker.sourceType = .camera

      present(picker, animated: false, completion: nil)

    }

    
    var numberOfCell: Int = 10
    let cellIdentifier: String = "cell"
    @IBOutlet weak var collectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfCell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.numberOfCell += 1
        collectionView.reloadData()
    }
    // collection View 기능 추가
    
    
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var profileImage: UIImage!
    
    
    @IBAction func touchUpSelectCameraButton(_sender: UIButton){
        // 카메라 버튼 눌렀을 때 액션
        print("Camera button pressed")
    }
    
    @IBAction func touchUpSelectSettingButton(_sender: UIButton){
        // 설정 버튼 눌렀을 때 액션
        print("Setting button pressed")
    }
    
    @IBAction func touchUpSelectEditButton(_sender: UIButton){
        // 설정 버튼 눌렀을 때 액션
        print("Edit button pressed")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        picker.delegate = self

        
        let flowLayout: UICollectionViewFlowLayout
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.minimumLineSpacing = 5
        
        flowLayout.estimatedItemSize = CGSize(width: 125, height: 125)
        
        self.collectionView.collectionViewLayout = flowLayout
        // collectionView 레이아웃 설정
        
        
        
        myView.layer.cornerRadius = 50
        myView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        //View 코너 둥글게
    }
    
    




}

