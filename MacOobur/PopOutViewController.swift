//
//  PopOutViewController.swift
//  MacUber
//
//  Created by 2019 on 10/13/19.
//  Copyright © 2019 AlexMata. All rights reserved.
//

import Cocoa
import CoreLocation
import MapKit

class PopOutViewController: NSViewController {

    // MARK: - Properties
    
	let loader = UberLoader.shared
    let locationManager = CLLocationManager()

    // MARK: - VC Lifecycle
    
	override func viewDidLoad() {
		super.viewDidLoad()

        setupLocationManager()
		loader.test(path: "me") { jsonDict, error in
			if let error = error {
				print("error: \(error)")
				return
			}

			if let jsonDict = jsonDict {
				print(jsonDict)
			}
		}
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}


}

extension PopOutViewController {
	static func freshController() -> NSViewController {
		let storyboard = NSStoryboard(name: .init("Main"), bundle: nil)
		let identifer = NSStoryboard.SceneIdentifier("PopOutMenu")
		guard let viewController = storyboard.instantiateController(withIdentifier: identifer) as? PopOutViewController else {
			fatalError("Can't find 'PopOutMenu' in storybaord")
		}
		return viewController
	}
}

extension PopOutViewController: CLLocationManagerDelegate {
    // MARK: - Core Location
    
    func setupLocationManager(){
        locationManager.delegate = self
        if #available(OSX 10.14, *) {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
        } else {
            // Fallback on earlier versions
            NSLog("Outdated MacOS version trying to access Core Location")
        }
    }
    
    func openMapForPlace(lat:Double = 0, long:Double = 0, placeName:String = "") {
        let latitude: CLLocationDegrees = lat
        let longitude: CLLocationDegrees = long

        let regionDistance:CLLocationDistance = 100
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = placeName
        mapItem.openInMaps(launchOptions: options)
    }
    
    // MARK: - CL Delegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latitude = locationManager.location?.coordinate.latitude
        let longitude = locationManager.location?.coordinate.longitude

        print("HERE Latitude: \(latitude!) Longitude: \(longitude!) Location: \(locationManager.location)", locationManager.location?.coordinate)
        openMapForPlace(lat: latitude!, long: longitude!)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //Error
        print("Error loading user location: ", error)
    }
}
