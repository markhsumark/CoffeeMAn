//
//  MApViewModel.swift
//  CoffeeMan
//
//  Created by 徐易中 on 2021/12/25.
//

import MapKit
import SwiftUI

enum MapDetail{
    static let startingLocation = CLLocationCoordinate2D(latitude: 24.5, longitude: 121.5)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
}

final class MapViewModel : NSObject, ObservableObject, CLLocationManagerDelegate{
    
    var Cafe = CafeViewModel()
    @Published var region = MKCoordinateRegion(center: MapDetail.startingLocation,
                                               span: MapDetail.defaultSpan)
    @Published var AnnotationPlace: [IdentifiablePlace] = []
    var locationManager: CLLocationManager?
    
    func checkIfLocationServicesIsEnable(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager = CLLocationManager()
            locationManager!.delegate = self
        }else{
            print("show nan alert letting then know this is off")
        }
    }
    
    override init(){
        super.init()
        locationManager?.delegate = self
    }
    func requestAllowOnceLocationPermission(){
        locationManager!.requestLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else{
            //show an error
            return
        }
        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(center: latestLocation.coordinate,
                                        span: MapDetail.defaultSpan)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    private  func checkLocationAuthorization(){
        guard let locationManager = locationManager else {
            return
        }
        switch locationManager.authorizationStatus{
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Your location is restricted!")
        case .denied:
            print("You have deny this app location permission")
        case .authorizedAlways, .authorizedWhenInUse:
            region = MKCoordinateRegion(center: locationManager.location!.coordinate,
                                        span: MapDetail.defaultSpan)
        @unknown default:
            break
        }
        
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    func changeRegion(location : CLLocationCoordinate2D){
        self.region = MKCoordinateRegion(center: location,
                                    span: MapDetail.defaultSpan)
    }

}
