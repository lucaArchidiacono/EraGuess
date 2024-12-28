//
//  MKMapRect+.swift
//
//
//  Created by Luca Archidiacono on 20.07.2024.
//

import Foundation
import MapKit

public extension MKMapRect {
    init(region: MKCoordinateRegion) {
        let center = region.center
        let span = region.span
        let topLeft = CLLocationCoordinate2D(
            latitude: center.latitude + span.latitudeDelta * 0.5,
            longitude: center.longitude - span.longitudeDelta * 0.5
        )
        let bottomRight = CLLocationCoordinate2D(
            latitude: center.latitude - span.latitudeDelta * 0.5,
            longitude: center.longitude + span.longitudeDelta * 0.5
        )
        let topLeftPoint = MKMapPoint(topLeft)
        let bottomRightPoint = MKMapPoint(bottomRight)

        self.init(
            x: min(topLeftPoint.x, bottomRightPoint.x),
            y: min(topLeftPoint.y, bottomRightPoint.y),
            width: abs(topLeftPoint.x - bottomRightPoint.x),
            height: abs(topLeftPoint.y - bottomRightPoint.y)
        )
    }

    init(x: Double, y: Double, width: Double, height: Double) {
        self.init(origin: MKMapPoint(x: x, y: y), size: MKMapSize(width: width, height: height))
    }

    func contains(_ coordinate: CLLocationCoordinate2D) -> Bool {
        contains(MKMapPoint(coordinate))
    }
}
