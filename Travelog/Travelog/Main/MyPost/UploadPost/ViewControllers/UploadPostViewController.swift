//
//  UploadPostViewController.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/04/06.
//

import UIKit

class UploadPostViewController: UIViewController,SelectedLocationViewControllerDelegate,SelectedPhotoViewControllerDelegate {
    
    // MARK: - Properties
    var images:[UIImage] = []
    var date: String = ""
    var location = Location()
    var text = ""
    
    var initialContentsHeight:CGFloat = CGFloat(40)
    
    let locationSearchViewController = SelectedLocationViewController()
    let selectedPhotoViewController = SelectedPhotoViewController()
    
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
            datePicker.date = Date()
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
        
        // Do any additional setup after loading the view.
        self.tabBarController?.tabBar.isHidden = true
        self.postTextView.delegate = self
        
        //        hideKeyboard()
        addObservers()
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
    //    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        self.view.endEditing(true)
    //    }
    
    // MARK: - Actions
    
    @IBAction func cancelUpload(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func uploadPost(_ sender: Any) {
        print(postTextView.text as String)
        print(datePicker.date)
        print(publicPrivateSegmentedControl.isSelected)
        print(publicPrivateSegmentedControl.selectedSegmentIndex)
        
    }
    @IBAction func dateValueChanged(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, YYYY"
        let dateString = dateFormatter.string(from: datePicker.date)
        print(dateString)
    }
    // MARK: - Methods
    
    //    func hideKeyboard() {
    //        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
    //            action: #selector(UIViewController.dismissKeyboard))
    //        view.addGestureRecognizer(tap)
    //    }
    //    @objc func dismissKeyboard() {
    //        view.endEditing(true)
    //    }
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
    
    func setLocation(lat: String, lng: String, title: String, subTitle: String){
        print("location")
        location.lat = lat
        location.lng = lng
        location.title = title
        location.subTitle = subTitle
        print(title)
        
        self.checkRequiredForm()
    }
    
    func appendImage(image: UIImage){
        print("append")
        images.append(image)
        self.checkRequiredForm()
    }
    
    func setText(text: String){
        self.text = text
        checkRequiredForm()
    }
    
    func checkRequiredForm(){
        print("count: ",images.count,"location: ",location.title, "text: ",postTextView.text)
        if images.count > 0, location.title != "", postTextView.textColor == .white, !postTextView.text.isEmpty {
            uploadButton.isEnabled = true
            return
        }
        uploadButton.isEnabled = false
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
        self.checkRequiredForm()
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
