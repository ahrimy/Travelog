//
//  ViewController.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/03/22.
//

import UIKit

class MyPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Properties
    var list = PostList()

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
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        mapListSegmentedControl.setTitleTextAttributes([.foregroundColor : UIColor.white], for: .selected)
        mapListSegmentedControl.setTitleTextAttributes([.foregroundColor :        UIColor(red: 0.31, green: 0.16, blue: 0.36, alpha: 1.00)], for: .normal)
        
        self.list.loadPosts(listVC: self)
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
    }
    
    // MARK: - Methods
    func reloadData(list: [PostThumbnail]){
        print("Post Count: ", list.count)
        self.myPostListViewController?.reloadData(list: list)
        self.myPostMapViewController?.reloadData(list: list)
    }
}

