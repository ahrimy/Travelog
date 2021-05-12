//
//  MyPostMapViewController.swift
//  Travelog
//
//  Created by 강예나 on 2021/03/31.
//

import UIKit
import MapKit

class MyPostMapViewController: UIViewController,CLLocationManagerDelegate {
    
    // MARK: - Properties
    var locationManager = CLLocationManager()
//    var posts:[PostThumbnail] = []
    var posts:[PostOverview] = []
    
    // MARK: - IBOutlet
    @IBOutlet weak var mapView: MKMapView!

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: - Methods
    private func setup(){
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        mapView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        mapView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        setLocationManager()
        mapView.delegate = self
        mapView.showsUserLocation = true
    }
    private func setLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    func appendPost(post:PostOverview){
        self.posts.append(post)
        self.addMapPin(with: post.coordinate, title: post.id, image: post.image)
    }
    func reloadData(list: [PostOverview]) {
//        self.posts = list
        
        self.posts.forEach{post in
            self.addMapPin(with: post.coordinate, title: post.id, image:post.image)
        }
    }
    
    func addMapPin(with location: CLLocation, title:String, image :UIImage){
        // TODO : Delta 값 수정 필요
        mapView.setRegion(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 3.0, longitudeDelta: 3.0)), animated: true)
        mapView.addAnnotation(PostAnnotation(coordinate: location.coordinate, title:title, image: image))
    }

}

// MARK: - map
extension MyPostMapViewController: MKMapViewDelegate {
    // annotation이 만들어 질 때 실행
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is PostAnnotation){
            return nil
        }
        
        let postAnnotation = annotation as! PostAnnotation
//        print("위치 정보 = \(annotation.coordinate)")
        return registerImageInMapView(mapView: mapView, annotation: annotation, imgParam: postAnnotation.image)
    }
    
    private func registerImageInMapView(mapView: MKMapView, annotation: MKAnnotation, imgParam: UIImage) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        } else {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "reuseId") ?? MKAnnotationView()
            let width = self.mapView.frame.width / 7
            annotationView.annotation = annotation
            
            let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: width + 10, height: width + 10 ))
            backgroundView.backgroundColor = UIColor.white
            backgroundView.layer.cornerRadius = 5
            
            let imageView = UIImageView(image: imgParam)
            imageView.layer.masksToBounds = true
            imageView.layer.cornerRadius = 5

            backgroundView.addSubview(imageView)
            annotationView.addSubview(backgroundView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.92),
                imageView.heightAnchor.constraint(equalTo: backgroundView.heightAnchor, multiplier: 0.92),
                imageView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            ])
            
            return annotationView
        }
        
    }
}
