//
//  UploadPostViewController.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/04/06.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class UploadPostViewController: UIViewController,SelectedLocationViewControllerDelegate,SelectedPhotoViewControllerDelegate {
    
    
    // MARK: - Properties
    let storage = Storage.storage()
    let db = Firestore.firestore()
    let group = DispatchGroup()
    
    let userId = 1;
    let postId = 1;
    
    var images:[UIImage] = []
    var imageRefs:[String] = []
    var location = Location()
    
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
    @IBAction func uploadPost(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd "
        let dateString = dateFormatter.string(from: datePicker.date)
        print("Photo count: ",images.count)
        print("Date: ", dateString)
        print("Location: ", location.title)
        print("Latitude: ", location.lat, " Longitude: ", location.lng)
        print("Text: ", postTextView.text as String)
        let privacy = publicPrivateSegmentedControl.selectedSegmentIndex == 0 ? "Public" : "Private"
        print("Privacy: ", privacy)
        let uploadImageQueue = DispatchQueue(label: "uploadImage")
        group.enter()
        uploadImageQueue.async(group: group) {
            self.uploadImages()
        }
        
        group.notify(queue: .main) {
            self.addPost()
        }
    }
    @IBAction func dateValueChanged(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, YYYY"
        let dateString = dateFormatter.string(from: datePicker.date)
        print(dateString)
    }
    
    // MARK: - Methods
    
    func setLocation(lat: String, lng: String, title: String, subTitle: String){
        location.lat = lat
        location.lng = lng
        location.title = title
        location.subTitle = subTitle
        
        self.checkRequiredForm()
    }
    func appendImage(image: UIImage){
        images.append(image)
        self.checkRequiredForm()
    }
    func checkRequiredForm(){
        if images.count > 0, location.title != "", postTextView.textColor == .white, !postTextView.text.isEmpty {
            uploadButton.isEnabled = true
            return
        }
        uploadButton.isEnabled = false
    }
    func uploadImages(){
        var data = Data()
        var imageId = 1;
        let filepath = "\(self.userId)/\(self.postId)/image"
        let storageRef = storage.reference()
        self.images.forEach{image in
            let imageRef = storageRef.child(filepath + String(imageId))
            data = image.jpegData(compressionQuality: 0.8)!
            imageRef.putData(data, metadata: nil){
                (metaData, error) in if let error = error {
                    print(error.localizedDescription)
                    return
                }else{
                    imageRef.downloadURL { (url, error) in
                        guard let downloadURL = url else {
                            print(error?.localizedDescription ?? "Error occured")
                            return
                        }
                        print(downloadURL)
                        self.imageRefs.append(downloadURL.absoluteString)
                        
                        if self.imageRefs.count == imageId - 1 {
                            self.group.leave()
                        }
                    }
                }
            }
            imageId = imageId + 1
        }
    }
    func addPost(){
        db.collection("posts").addDocument(data: [
                                            "write":"ahrimy",
                                            "date":Timestamp(date: datePicker.date),
                                            "imageRefs": imageRefs,
                                            "text":postTextView.text ?? "",
                                            "Location":[
                                                "title":location.title,
                                                "latitude":location.lat,
                                                "longitude":location.lng],
                                            "isPublic":publicPrivateSegmentedControl.selectedSegmentIndex == 0,
                                            "createdAt":Timestamp(date: Date()),
                                            "updatedAt":Timestamp(date: Date())]){ err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
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
