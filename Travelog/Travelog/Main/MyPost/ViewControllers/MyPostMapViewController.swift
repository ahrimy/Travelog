//
//  MyPostMapViewController.swift
//  Travelog
//
//  Created by 강예나 on 2021/03/31.
//

import UIKit
import MapKit

class MyPostMapViewController: UIViewController {
    
    // MARK: - Properties
    var posts:[PostOverview] = []
    
    // MARK: - IBOutlet
    @IBOutlet weak var mapView: MKMapView!

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureMapView()
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
    private func configureMapView(){
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        mapView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        mapView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        mapView.delegate = self
        mapView.register(
            MapItemAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(
            ClusterAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
    func appendPost(post:PostOverview){
        self.posts.append(post)
        self.addAnnotation(with: post)
        setRegion(coordinate: post.coordinate.coordinate)
    }
    func loadPosts(posts: [PostOverview]) {
        self.posts = posts.sorted(by: {$0.createdAt > $1.createdAt})
        if let recentPost = self.posts.first {
            setRegion(coordinate: recentPost.coordinate.coordinate)
        }
        self.posts.forEach{post in
            self.addAnnotation(with: post)
        }
    }
    
    private func addAnnotation(with post: PostOverview){
        mapView.addAnnotation(MapItem(post: post))
    }
    private func setRegion(coordinate: CLLocationCoordinate2D){
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 10.0, longitudeDelta: 10.0))
        mapView.setRegion(region, animated: true)
    }

}

// MARK: - map
extension MyPostMapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard view is ClusterAnnotationView else { return }
        
        // if the user taps a cluster, zoom in
        let currentSpan = mapView.region.span
        let zoomSpan = MKCoordinateSpan(latitudeDelta: currentSpan.longitudeDelta/10.0, longitudeDelta: currentSpan.longitudeDelta/10.0)
        let zoomCoordinate = view.annotation?.coordinate ?? mapView.region.center
        let zoomed = MKCoordinateRegion(center: zoomCoordinate, span: zoomSpan)
        mapView.setRegion(zoomed, animated: true)
    }

}
