//
//  UploadPostViewController.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/04/06.
//

import UIKit

class UploadPostViewController: UIViewController,SelectedLocationViewControllerDelegate,SelectedPhotoViewControllerDelegate {
    
    
    // MARK: - Properties
    let group = DispatchGroup()
    
    let userId = "ahrimy"
    var postId:String = ""
    var post = Post(userId: "ahrimy")
    
    var images:[UIImage] = []
    
    var initialContentsHeight:CGFloat = CGFloat(40)
    
//    let locationSearchViewController = SelectedLocationViewController()
//    let selectedPhotoViewController = SelectedPhotoViewController()
//
    // MARK: - IBOutlet
    
    @IBOutlet weak var uploadButton: UIBarButtonItem!{
        didSet{
            uploadButton.isEnabled = false
        }
    }
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var selectedPhotoView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!{
        didSet{
            datePicker.date = self.post.date
            datePicker.maximumDate = Date()
        }
    }
    @IBOutlet weak var selectedLocationView: UIView!
    @IBOutlet weak var postTextView: UITextView!{
        didSet{
            postTextView.tintColor = .white
            postTextView.backgroundColor = UIColor(red: 0.44, green: 0.29, blue: 0.49, alpha: 1.00)
            postTextView.textColor = UIColor(red: 0.86, green: 0.86, blue: 0.86, alpha: 1.00)
            postTextView.font = UIFont.systemFont(ofSize: 15)
            postTextView.text = "글을 입력하세요"
        }
    }
    @IBOutlet weak var publicPrivateSegmentedControl: UISegmentedControl!{
        didSet {
            publicPrivateSegmentedControl.setTitleTextAttributes([.foregroundColor : UIColor.white], for: .selected)
            publicPrivateSegmentedControl.setTitleTextAttributes([.foregroundColor : UIColor(red: 0.31, green: 0.16, blue: 0.36, alpha: 1.00)], for: .normal)
        }
    }
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        self.postTextView.delegate = self
        self.addObservers()
        self.hideKeyboard()
        self.initialContentsHeight += selectedPhotoView.frame.height + datePicker.frame.height + selectedLocationView.frame.height + postTextView.frame.height + publicPrivateSegmentedControl.frame.height
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedPhotoViewController = segue.destination as? SelectedPhotoViewController {
            selectedPhotoViewController.selectedPhotoViewControllerDelegate = self
        }
        if let selectedLocationViewController = segue.destination as? SelectedLocationViewController {
            selectedLocationViewController.selectedLocationViewControllerDelegate = self
        }
    }
    
    // MARK: - Actions
    
    @IBAction func cancelUpload(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func dateValueChanged(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, YYYY"
        let dateString = dateFormatter.string(from: datePicker.date)
        print(dateString)
    }
    @IBAction func changePrivacy(_ sender: Any) {
        self.post.changePrivacy(isPublic: publicPrivateSegmentedControl.selectedSegmentIndex == 0)
    }
    @IBAction func uploadPost(_ sender: Any) {
        var imageData:[Data] = []
        images.forEach{image in
            imageData.append(image.jpegData(compressionQuality: 0.8)!)
        }
        let uploadImageQueue = DispatchQueue(label: "uploadImage")
        group.enter()
        uploadImageQueue.async(group: group) {
            self.post.upload(images: imageData, group: self.group)
        }
        
        group.notify(queue: .main) {
            self.completeUpload()
        }
    }
    
    // MARK: - Methods
    func setLocation(placeInfo: [String:String]){
        post.setLocation(placeInfo: placeInfo)
        self.activateUploadButton()
    }
    func resetLocation(){
        self.post.resetLocation()
        self.activateUploadButton()
    }
    func appendImage(image: UIImage){
        images.append(image)
        self.activateUploadButton()
    }
    func activateUploadButton(){
        if images.count > 0, self.post.location.name != "No Location", postTextView.textColor == .white, !postTextView.text.isEmpty {
            uploadButton.isEnabled = true
            return
        }
        uploadButton.isEnabled = false
    }
    func completeUpload(){
        if self.post.id != ""{
                self.navigationController?.popViewController(animated: false)
        }
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keybaordRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keybaordRectangle.height
            let bottomOffset = CGPoint(x: 0, y: (initialContentsHeight - keyboardHeight))
            scrollView.setContentOffset(bottomOffset, animated: true)
            bottomConstraint.constant =  keyboardHeight
        }
    }
    @objc private func keyboardWillHide(_ notification: Notification) {
        bottomConstraint.constant = CGFloat(0.0)
    }
}

extension UploadPostViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if postTextView.textColor == UIColor(red: 0.86, green: 0.86, blue: 0.86, alpha: 1.00){
            postTextView.text = ""
            postTextView.textColor = .white
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        self.post.updateText(text: postTextView.text)
        self.activateUploadButton()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if postTextView.text.isEmpty {
            postTextView.textColor = UIColor(red: 0.86, green: 0.86, blue: 0.86, alpha: 1.00)
            postTextView.text = "글을 입력하세요"
        }
    }
}

extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
