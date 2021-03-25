//
//  ViewController.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/03/22.
//

import UIKit


class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let posts = [
        PostThumbnail(postId: "1", image: "https://user-images.githubusercontent.com/26592306/112343616-a7d4e680-8d06-11eb-928a-1714f8acc9bd.jpeg"),
        PostThumbnail(postId:"2",image:"https://user-images.githubusercontent.com/26592306/112343646-ab686d80-8d06-11eb-8d7d-8af1eddd0a74.jpeg"),
        PostThumbnail(postId: "3", image: "https://user-images.githubusercontent.com/26592306/112343650-ac010400-8d06-11eb-8845-56d5086add38.jpeg"),
        PostThumbnail(postId: "4", image: "https://user-images.githubusercontent.com/26592306/112343653-ad323100-8d06-11eb-9a10-50a65e6d24b2.jpeg"),
        PostThumbnail(postId: "5", image: "https://user-images.githubusercontent.com/26592306/112343655-adcac780-8d06-11eb-8e2f-1a28d6bb44ba.jpeg"),
        PostThumbnail(postId: "6", image: "https://user-images.githubusercontent.com/26592306/112343673-b02d2180-8d06-11eb-9ebd-1949c80ce163.jpeg"),
        PostThumbnail(postId: "7", image: "https://user-images.githubusercontent.com/26592306/112343684-b28f7b80-8d06-11eb-9804-effc377924fa.jpeg"),

        PostThumbnail(postId: "8", image: "https://user-images.githubusercontent.com/26592306/112343695-b3c0a880-8d06-11eb-9078-8f8a9e56d44e.jpeg"),
        PostThumbnail(postId: "9", image: "https://user-images.githubusercontent.com/26592306/112343702-b58a6c00-8d06-11eb-8ef9-b43986bc641c.jpeg"),

        PostThumbnail(postId: "10", image: "https://user-images.githubusercontent.com/26592306/112344303-4bbe9200-8d07-11eb-91ea-59f61b86e9d8.jpeg"),
        ]

    
    
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

    
    var numberOfCell: Int = 10
    // post cell 수
    let cellIdentifier: String = "cell"
    @IBOutlet weak var collectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ViewCell
        
        cell.postThumbnail = posts[indexPath.row]
        let url = URL(string:posts[indexPath.row].image)!
        do{
            let data = try Data(contentsOf: url)
            cell.thumbnailImage.image = UIImage(data: data)
        }catch{
            print("Error occured")
        }
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.numberOfCell += 1
//        collectionView.reloadData()
//    }
    // collection View 기능 추가
    
    
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileEditButton: UIButton!

    
    @IBAction func touchUpSelectSettingButton(_sender: UIButton){
        // 설정 버튼 눌렀을 때 액션
        print("Setting button pressed")
    }
    
    @IBAction func touchUpSelectProfileEditButton(_sender: UIButton){
        // 프로필 수정 버튼 눌렀을 때 액션
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

