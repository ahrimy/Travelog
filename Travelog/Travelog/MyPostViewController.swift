//
//  ViewController.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/03/22.
//

import UIKit


class MyPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func CameraButtonAction(_ sender: Any) {
        
        let picker = UIImagePickerController()

        let alert =  UIAlertController(title: "원하는 타이틀", message: "원하는 메세지", preferredStyle: .actionSheet)
        // 알림 메세지
        
        let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in
            picker.sourceType = .photoLibrary
            self.present(picker, animated: false, completion: nil)
        } // 앨범 열기
    

        let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in
            picker.sourceType = .camera
            self.present(picker, animated: false, completion: nil)
        } // 카메라 열기

        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        // 취소
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)

    }
    
    let picker = UIImagePickerController()

    
    
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.numberOfCell += 1
//        collectionView.reloadData()
//    }
    // collection View 기능 추가
    
    @IBOutlet weak var myProfileImage: UIImageView!
    @IBOutlet weak var myProfileEditButton: UIButton!
    @IBOutlet weak var mapListSegmentedControl: UISegmentedControl!
    
    
    @IBAction func touchUpSelectSettingButton(_sender: UIButton){
        // 설정 버튼 눌렀을 때 액션
        print("Setting button pressed")
    }
    
    @IBAction func touchUpSelectMyProfileEditButton(_sender: UIButton){
        // 프로필 id 버튼 눌렀을 때 액션
        print("My Profile Edit button pressed")
    }
    
    
    @IBOutlet weak var MyPostMapView: UIView!
    @IBOutlet weak var MyPostListView: UIView!
    
    @IBAction func SelectedSegmentedControl(_sender: UISegmentedControl){
        if _sender.selectedSegmentIndex == 0 {
            MyPostMapView.alpha = 1
            MyPostListView.alpha = 0
        } else {
            MyPostMapView.alpha = 0
            MyPostListView.alpha = 1
        }
    } // 지도 or 리스트 선택 했을 때 보이는 뷰 설정
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        mapListSegmentedControl.setTitleTextAttributes([.foregroundColor : UIColor.white], for: .selected)
        mapListSegmentedControl.setTitleTextAttributes([.foregroundColor :        UIColor(red: 0.31, green: 0.16, blue: 0.36, alpha: 1.00)], for: .normal)
        picker.delegate = self
        
        /*
        myView.layer.cornerRadius = 50
        myView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        //View 코너 둥글게
         */
    }
    
    




}

