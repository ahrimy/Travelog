//
//  UploadPostViewController.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/04/06.
//

import UIKit

class UploadPostViewController: UIViewController {
    
    // MARK: - Properties

    @IBOutlet weak var publicPrivateSegmentedControl: UISegmentedControl!{
        didSet {
            publicPrivateSegmentedControl.setTitleTextAttributes([.foregroundColor : UIColor.white], for: .selected)
            publicPrivateSegmentedControl.setTitleTextAttributes([.foregroundColor : UIColor(red: 0.85, green: 0.72, blue: 0.76, alpha: 1.00)], for: .normal)
        }
    }
    @IBOutlet weak var postTextView: UITextView!
    
//    @IBOutlet weak var closeButton: UIBarButtonItem!
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tabBarController?.tabBar.isHidden = true
        
        self.postTextView.backgroundColor = UIColor(red: 0.60, green: 0.45, blue: 0.66, alpha: 1.00)
        self.postTextView.delegate = self
        self.postTextView.text = "글을 입력하세요"
        self.postTextView.textColor = UIColor.lightGray
//        self.postTextView.font = UIFont(name: "Headline", size: 50)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Actions
    
    @IBAction func cancelUpload(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Methods
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension UploadPostViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if postTextView.textColor == UIColor.lightGray {
            postTextView.text = nil
            postTextView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if postTextView.text.isEmpty {
            postTextView.text = "글을 입력하세요"
            postTextView.textColor = UIColor.lightGray
        }
    }
}
