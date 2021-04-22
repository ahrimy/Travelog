import UIKit
import MapKit

class StarredPostMapViewController: UIViewController{
    public var mapView: MKMapView!
    public var locationManager:CLLocationManager!
    public var myLocationsInfo: [StarredPostLocation] = []
    public var imageIcon: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        imageIcon = UIImage(named: "img02")
        
        mapView = MKMapView()
        self.view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        mapView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        mapView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        setLocationManager()
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        /*
         한국 항공대 37.599558487494996, 126.86515342650488
         광안리 35.15315426675366, 129.1187047966697
         하남 스타필드 37.548222964493355, 127.22373658798466
         속초 38.193494695431426, 128.60247907060045
         전주 한옥마을 35.81556416232091, 127.15347967857576
         속리산 36.53899695013661, 127.90146575576792
         */
        // TODO: database에 담긴 위치 정보, 이미지 사용하는 코드로 변경
        let KAULocation = CLLocation(latitude: 37.599558487494996, longitude: 126.86515342650488)
        let BusanLocation = CLLocation(latitude: 35.15315426675366, longitude: 129.1187047966697)
        let HSFLocation = CLLocation(latitude: 37.548222964493355, longitude: 127.22373658798466)
        let SCLocation = CLLocation(latitude: 38.193494695431426, longitude: 128.60247907060045)
        let JJLocation = CLLocation(latitude: 35.81556416232091, longitude: 127.15347967857576)
        let SMLocation = CLLocation(latitude: 36.53899695013661, longitude: 127.90146575576792)
        addMapPin(with: KAULocation)
        addMapPin(with: BusanLocation)
        addMapPin(with: HSFLocation)
        addMapPin(with: SCLocation)
        addMapPin(with: JJLocation)
        addMapPin(with: SMLocation)
    }
    
    func setLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func addMapPin(with location: CLLocation){
        let pin = MKPointAnnotation()
        pin.coordinate = location.coordinate
        // TODO : Delta 값 수정 필요
        mapView.setRegion(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 3.0, longitudeDelta: 3.0)), animated: true)
        mapView.addAnnotation(pin)
    }
    
}

// MARK: - map
extension StarredPostMapViewController: MKMapViewDelegate {
    
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = .blue
        polylineRenderer.lineWidth = 4
        return polylineRenderer
    }
    
    // annotation이 만들어 질 때 실행
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        print("위치 정보 = \(annotation.coordinate)")
        return registerImageInMapView(mapView: mapView, annotation: annotation, imgParam: self.imageIcon!)
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

// MARK: - location delegate
extension StarredPostMapViewController: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latitude = locations[0].coordinate.latitude
        let longitude = locations[0].coordinate.longitude
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let date = formatter.string(from: Date())
        
        self.draw(latitude: latitude, longitude: longitude, date: date)
    }
    
    open func draw(latitude: Double, longitude: Double, date: String) {
        
        let latitudeTmp = latitude
        let longitudeTmp = longitude
        let curDate = date
        
        let totalData = StarredPostLocation()
        totalData.date = NumberFormatter().number(from: curDate)!.doubleValue
        totalData.latitude = latitudeTmp
        totalData.longitude = longitudeTmp
        
        myLocationsInfo.append(totalData)
        
        let spanX = 0.005
        let spanY = 0.005
        
        let newRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: spanX, longitudeDelta: spanY))
        
        mapView.setRegion(newRegion, animated: true)
        
    }
}

// MARK: - resize image
extension UIImage {
    class func resize(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    class func scale(image: UIImage, by scale: CGFloat) -> UIImage? {
        let size = image.size
        let scaledSize = CGSize(width: size.width * scale, height: size.height * scale)
        return UIImage.resize(image: image, targetSize: scaledSize)
    }
}

