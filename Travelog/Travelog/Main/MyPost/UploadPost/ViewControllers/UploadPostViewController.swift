//
//  UploadPostViewController.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/04/06.
//

import UIKit

class UploadPostViewController: UIViewController,LocationSearchViewControllerLocationDelegate {
    
    
    // MARK: - Properties
    var images:[UIImage] = []
    var date: String = ""
    var location = Location()
    var text = ""
    
    let locationSearchViewController = LocationSearchViewController()
    
    // MARK: - IBOutlet
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var publicPrivateSegmentedControl: UISegmentedControl!{
        didSet {
            publicPrivateSegmentedControl.setTitleTextAttributes([.foregroundColor : UIColor.white], for: .selected)
            publicPrivateSegmentedControl.setTitleTextAttributes([.foregroundColor : UIColor(red: 0.31, green: 0.16, blue: 0.36, alpha: 1.00)], for: .normal)
        }
    }
    @IBOutlet weak var postTextView: UITextView!{
        didSet{
            postTextView.tintColor = .white
            postTextView.backgroundColor = UIColor(red: 0.44, green: 0.29, blue: 0.49, alpha: 1.00)
            postTextView.textColor = UIColor(red: 0.86, green: 0.86, blue: 0.86, alpha: 1.00)
            postTextView.font = UIFont.systemFont(ofSize: 15)
            postTextView.text = "글을 입력하세요"
        }
    }
    @IBOutlet weak var uploadButton: UIBarButtonItem!{
        didSet{
            uploadButton.isEnabled = false
        }
    }
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tabBarController?.tabBar.isHidden = true
        self.postTextView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let locationSearchViewController = segue.destination as? LocationSearchViewController {
            locationSearchViewController.locationDelegate = self
        }
    }
    
    // MARK: - Actions
    
    @IBAction func cancelUpload(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func uploadPost(_ sender: Any) {
        print(postTextView.text as String)
        
    }
    // MARK: - Methods
    
    func setLocation(lat: Float, lng: Float, title: String, subTitle: String){
        location.lat = lat
        location.lng = lng
        location.title = title
        location.subTitle = subTitle
        
        checkRequiredForm()
    }
    
    func appendImage(image: UIImage){
        images.append(image)
        checkRequiredForm()
    }
    
    func setDate(date: String){
        self.date = date
        checkRequiredForm()
    }
    
    func setText(text: String){
        self.text = text
        checkRequiredForm()
    }
    
    func checkRequiredForm(){
        if images.count > 0, date != "", location.title != "", text != "" {
            uploadButton.isEnabled = true
            return
        }
        uploadButton.isEnabled = false
    }
}

extension UploadPostViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if postTextView.textColor == UIColor(red: 0.86, green: 0.86, blue: 0.86, alpha: 1.00) {
            postTextView.text = nil
            postTextView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if postTextView.text.isEmpty {
            postTextView.text = "글을 입력하세요"
            postTextView.textColor = UIColor(red: 0.86, green: 0.86, blue: 0.86, alpha: 1.00)
        } else {
            setText(text: postTextView.text)
        }
    }
}
