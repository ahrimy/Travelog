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
    var posts:[PostThumbnail] = []
    
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
    func reloadData(list: [PostThumbnail]) {
        self.posts = list
        
        self.posts.forEach{post in
            let url = URL(string:post.image)!
            do{
                let data = try Data(contentsOf: url)
                if let image = UIImage(data: data){
                    self.addMapPin(with: CLLocation(latitude: (post.latitude as NSString).doubleValue, longitude: (post.longitude as NSString).doubleValue), title: post.postId, image:image)
                }
            }catch{
                print("Error occured")
            }
            
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
            annotationView.canShowCallout = true
            annotationView.annotation = annotation
            
            let width = self.view.frame.width / 7
            let height = self.view.frame.height / 7
            let img = UIImage.resize(image: imgParam, targetSize: CGSize(width: width, height: height))
            annotationView.image = img
            
            return annotationView
        }
        
    }
}
