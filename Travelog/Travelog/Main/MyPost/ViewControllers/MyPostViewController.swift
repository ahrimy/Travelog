//
//  ViewController.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/03/22.
//

import UIKit

class MyPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UploadPostViewControllerDelegate {

    // MARK: - Properties
//    var list = PostList()
//    let userService = UserService()
//    let username = "ahrimy"
//    let postService = PostService(username: "ahrimy")

    var uploadPostViewController: UploadPostViewController?
    var myPostListViewController: MyPostListViewController?
    var myPostMapViewController: MyPostMapViewController?
    
    // MARK: - IBOutlet
    @IBOutlet weak var mapListSegmentedControl: UISegmentedControl!
    @IBOutlet weak var MyPostMapView: UIView!
    @IBOutlet weak var MyPostListView: UIView!
    
    // MARK: - IBAction
    @IBAction func touchUpSelectSettingButton(_sender: UIButton){
        print("Setting button pressed")
    }
    
    @IBAction func SelectedSegmentedControl(_sender: UISegmentedControl){
        if _sender.selectedSegmentIndex == 0 {
            MyPostMapView.alpha = 1
            MyPostListView.alpha = 0
        } else {
            MyPostMapView.alpha = 0
            MyPostListView.alpha = 1
        }
    }
    @IBAction func touchUpNotificatioinButton(_ sender: Any) {
        UserService.shared.signOut(completion: presentSignInVC)
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        self.usernameItem.title = self.username
        self.navigationItem.title = UserService.shared.user?.username
        
        mapListSegmentedControl.setTitleTextAttributes([.foregroundColor : UIColor.white], for: .selected)
        mapListSegmentedControl.setTitleTextAttributes([.foregroundColor : UIColor(red: 0.31, green: 0.16, blue: 0.36, alpha: 1.00)], for: .normal)
        
//        self.list.loadPosts(listVC: self)
        if let myPostListViewController = self.myPostListViewController {
            PostService.shared.loadPostOverviewsForMyPostList(loadPosts: myPostListViewController.loadPosts(posts: ))
        }
        if let myPostMapViewController = self.myPostMapViewController {
            PostService.shared.loadPostOverviewsForMyPostMap(loadPosts: myPostMapViewController.loadPosts(posts: ))
        }
        /*
        myView.layer.cornerRadius = 50
        myView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        //View 코너 둥글게
         */
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let myPostListViewController = segue.destination as? MyPostListViewController {
            self.myPostListViewController = myPostListViewController
        }
        if let myPostMapViewController = segue.destination as? MyPostMapViewController {
            self.myPostMapViewController = myPostMapViewController
        }
        if let uploadPostViewController = segue.destination as? UploadPostViewController {
            uploadPostViewController.uploadPostViewControllerDelegate = self
        }
    }
    
    // MARK: - Methods
//    func reloadData(list: [PostThumbnail]){
//        print("Post Count: ", list.count)
//        self.myPostListViewController?.reloadData(list: list)
//        self.myPostMapViewController?.reloadData(list: list)
//    }
    
    func uploadPost(data: [String : Any], completion: () -> ()) {
        var imageIds:[String] = []
        let images = data["images"] as? [UIImage]
        guard let writer = data["writer"] as? String else {return}
        if (images != nil) {
            for _ in 0..<images!.count{
                let id = UUID().uuidString
                imageIds.append(id)
            }
        }
        PostService.shared.uploadImage(writer:writer, ids: imageIds, images: images ?? [])
        let postId = UUID().uuidString
        PostService.shared.uploadPostOverview(id:postId, data:data, imageId: imageIds[0])
        PostService.shared.uploadPostDetail(id:postId, data:data, imageIds: imageIds)
        self.appendPost(post: PostOverview(id: postId, image: (images?[0])!, date: data["date"] as! Date, text: data["text"] as! String, createdAt: data["createdAt"] as! Date, coordinate: (data["location"] as! Location).coordinate,locationName: (data["location"] as! Location).name, likes: 0, comments: 0, writer: writer))
        completion()
    }
    func appendPost(post: PostOverview){
        myPostListViewController?.appendPost(post: post)
        myPostMapViewController?.appendPost(post: post)
    }
    func presentSignInVC(){
        if let vc = self.storyboard?.instantiateViewController(identifier: "AuthViewController") {
            self.view.window?.rootViewController = vc
        }
    }
}

