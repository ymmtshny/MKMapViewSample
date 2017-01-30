//
//  ViewController.swift
//  MapKitSample
//
//  Created by Shinya Yamamoto on 2017/01/30.
//  Copyright © 2017年 shinyayamamoto. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var myLatitudeLabel: UILabel!
    @IBOutlet weak var myLongitudeLabel: UILabel!
    
    var myLocationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    
        // 現在地の取得.
        myLocationManager = CLLocationManager()
        myLocationManager.delegate = self
        
        // セキュリティ認証のステータスを取得.
        let status = CLLocationManager.authorizationStatus()
        print("authorizationStatus:\(status.rawValue)");
        
        // まだ認証が得られていない場合は、認証ダイアログを表示
        // (このAppの使用中のみ許可の設定) 説明を共通の項目を参照
        if(status == .notDetermined) {
            self.myLocationManager.requestWhenInUseAuthorization()
        }
        
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        myLocationManager.distanceFilter = 100
        myLocationManager.startUpdatingLocation()
        
        

        mapView.delegate = self
        
        
    }

    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = mapView.centerCoordinate
        print("center \(center)")
        self.updateLocationLabel(latitude: center.latitude, longitude: center.longitude)
    }
    
    private func setMapRegion(latitude: Double, longitude: Double) {
        
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        let span = MKCoordinateSpanMake(15.0, 15.0)
        let region = MKCoordinateRegionMake(coordinate, span)
        mapView.setRegion(region, animated:true)
    }
    
    private func addPinOnMap(latitude: Double, longitude: Double) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        annotation.title = "title"
        annotation.subtitle = "subtitle"
        self.mapView.addAnnotation(annotation)
    }
    
    private func updateLocationLabel(latitude: Double, longitude: Double) {
        // 緯度・経度の表示.
        myLatitudeLabel.text = "緯度：\(latitude)"
        myLongitudeLabel.text = "経度：\(longitude)"
    }

    /*
     位置情報取得に成功したときに呼び出されるデリゲート.
     */
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location  = manager.location else { return }
        let latitude = location.coordinate.latitude
        let longitide = location.coordinate.longitude
        self.setMapRegion(latitude: latitude, longitude: longitide)
        self.addPinOnMap(latitude:latitude, longitude: longitide)
        self.updateLocationLabel(latitude: latitude, longitude: longitide)
    }

    /*
     位置情報取得に失敗した時に呼び出されるデリゲート.
     */
    func locationManager(_ manager: CLLocationManager,didFailWithError error: Error){
        print("error")
    }

    /*
     認証に変化があった際に呼ばれる
     */
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        print("didChangeAuthorizationStatus");
        
        // 認証のステータスをログで表示.
        var statusStr: String = "";
        switch (status) {
        case .notDetermined:
            statusStr = "未認証の状態"
        case .restricted:
            statusStr = "制限された状態"
        case .denied:
            statusStr = "許可しない"
        case .authorizedAlways:
            statusStr = "常に使用を許可"
        case .authorizedWhenInUse:
            statusStr = "このAppの使用中のみ許可"
        }
        print(" CLAuthorizationStatus: \(statusStr)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

