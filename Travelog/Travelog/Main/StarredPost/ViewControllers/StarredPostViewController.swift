//
//  StarredPostViewController.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/03/30.
//

import UIKit

class StarredPostViewController: UIViewController {
    
    var postService = PostService(username: "ahrimy")
    var starredPostListViewController: StarredPostListViewController?
    var starredPostMapViewController: StarredPostMapViewController?
    
    @IBOutlet weak var StarredPostMapView: UIView!
    @IBOutlet weak var StarredPostListView: UIView!
    @IBOutlet weak var mapListSegmentedControl: UISegmentedControl!
    
    @IBAction func SelectedSegmentedControl(_sender: UISegmentedControl){
        if _sender.selectedSegmentIndex == 0 {
            StarredPostMapView.alpha = 1
            StarredPostListView.alpha = 0
        } else {
            StarredPostMapView.alpha = 0
            StarredPostListView.alpha = 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        view.insetsLayoutMarginsFromSafeArea = false
        mapListSegmentedControl.setTitleTextAttributes([.foregroundColor : UIColor.white], for: .selected)
        mapListSegmentedControl.setTitleTextAttributes([.foregroundColor : UIColor(red: 0.31, green: 0.16, blue: 0.36, alpha: 1.00)], for: .normal)
        
        if let starredPostListViewController = self.starredPostListViewController {
            self.postService.loadPostOverviewsForStarredPostList(loadPosts: starredPostListViewController.loadPosts(posts:))
        }
        
        /*
        if let starredPostMapViewController = self.starredPostMapViewController {
         self.postService.loadPostOverviewsForStarredPostMap(appendPost: starredPostMapViewController.appendPost(post:))
        }
 */
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let starredPostListViewController = segue.destination as? StarredPostListViewController {
            self.starredPostListViewController = starredPostListViewController
        }
        if let starredPostMapViewController = segue.destination as? StarredPostMapViewController {
            self.starredPostMapViewController = starredPostMapViewController
        }
    }
    
    
    func appendPost(post: PostOverview){
        starredPostListViewController?.appendPost(post: post)
//        starredPostMapViewController?.appendPost(post: post)
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
