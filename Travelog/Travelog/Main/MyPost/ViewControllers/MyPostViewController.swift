//
//  ViewController.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/03/22.
//

import UIKit

class MyPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UploadPostViewControllerDelegate, PostDetailViewControllerDelegate {

    // MARK: - Properties

    var uploadPostViewController: UploadPostViewController?
    var myPostListViewController: MyPostListViewController?
    var myPostMapViewController: MyPostMapViewController?
    
    // MARK: - IBOutlet
    @IBOutlet weak var mapListSegmentedControl: UISegmentedControl!
    @IBOutlet weak var MyPostMapView: UIView!
    @IBOutlet weak var MyPostListView: UIView!
    let customeView = UIView()
    
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
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationItem.title = UserService.shared.user?.username
        self.navigationItem.backButtonDisplayMode = .minimal
        
        mapListSegmentedControl.setTitleTextAttributes([.foregroundColor : UIColor.white], for: .selected)
        mapListSegmentedControl.setTitleTextAttributes([.foregroundColor : UIColor(red: 0.31, green: 0.16, blue: 0.36, alpha: 1.00)], for: .normal)
        
        PostService.shared.loadMyPostOverviews(loadPosts: loadPost(posts:))

    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let myPostListViewController = segue.destination as? MyPostListViewController {
            self.myPostListViewController = myPostListViewController
        }
        if let myPostMapViewController = segue.destination as? MyPostMapViewController {
            self.myPostMapViewController = myPostMapViewController
        }
        if let myPostDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "PostDetailViewController") as? PostDetailViewController{
            myPostDetailViewController.delegate = self
            self.myPostListViewController?.myPostDetailViewController = myPostDetailViewController
            self.myPostMapViewController?.myPostDetailViewController = myPostDetailViewController
        }
        if let uploadPostViewController = segue.destination as? UploadPostViewController {
            uploadPostViewController.uploadPostViewControllerDelegate = self
        }
    }
    
    // MARK: - Methods
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
        let postId = UUID().uuidString
        PostService.shared.uploadImage(postId: postId, writer:writer, ids: imageIds, images: images ?? [])
        PostService.shared.uploadPostOverview(id:postId, data:data, imageId: imageIds[0])
        PostService.shared.uploadPostDetail(id:postId, data:data, imageIds: imageIds)
        self.appendPost(post: PostOverview(id: postId, image: (images?[0])!, imageUrl:"",date: data["date"] as! Date, text: data["text"] as! String, createdAt: data["createdAt"] as! Date, coordinate: (data["location"] as! Location).coordinate,locationName: "\((data["location"] as! Location).name), \((data["location"] as! Location).country)", likes: 0, comments: 0, writer: writer))
        completion()
    }
    func loadPost(posts:[PostOverview]){
        if let myPostListViewController = self.myPostListViewController {
            myPostListViewController.loadPosts(posts: posts )
        }
        if let myPostMapViewController = self.myPostMapViewController {
            myPostMapViewController.loadPosts(posts: posts)
        }
    }
    func appendPost(post: PostOverview){
        myPostListViewController?.appendPost(post: post)
        myPostMapViewController?.appendPost(post: post)
    }
    func deletePost(postId: String) {
        if let myPostMapViewController = self.myPostMapViewController {
            myPostMapViewController.deletePost(postId: postId)
        }
        if let myPostListViewController = self.myPostListViewController {
            myPostListViewController.deletePost(postId: postId)
        }
    }
    func updateLikes(index: Int, likes:Int){
        if let myPostListViewController = self.myPostListViewController {
            myPostListViewController.updateLikes(index: index, likes: likes)
        }
    }
}

