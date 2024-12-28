//
//  CLLocationCoordinate2D+.swift
//
//
//  Created by Luca Archidiacono on 13.07.2024.
//

import Foundation
import MapKit

public let radiusOfEarth: Double = 6_372_797.6

public extension CLLocationCoordinate2D {
    func coordinate(onBearingInRadians bearing: Double, atDistanceInMeters distance: Double) -> CLLocationCoordinate2D {
        let distRadians = distance / radiusOfEarth // earth radius in meters

        let lat1 = latitude * .pi / 180
        let lon1 = longitude * .pi / 180

        let lat2 = asin(sin(lat1) * cos(distRadians) + cos(lat1) * sin(distRadians) * cos(bearing))
        let lon2 = lon1 + atan2(sin(bearing) * sin(distRadians) * cos(lat1), cos(distRadians) - sin(lat1) * sin(lat2))

        return CLLocationCoordinate2D(latitude: lat2 * 180 / .pi, longitude: lon2 * 180 / .pi)
    }

    var location: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }

    func distance(from coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        location.distance(from: coordinate.location)
    }
}
