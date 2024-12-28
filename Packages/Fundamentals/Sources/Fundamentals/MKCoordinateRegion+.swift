//
//  MKCoordinateRegion+.swift
//
//
//  Created by Luca Archidiacono on 13.07.2024.
//

import Foundation
import MapKit

public extension MKCoordinateRegion {
    func contains(coordinate: CLLocationCoordinate2D) -> Bool {
        cos((center.latitude - coordinate.latitude) * Double.pi / 180) > cos(span.latitudeDelta / 2.0 * Double.pi / 180) &&
            cos((center.longitude - coordinate.longitude) * Double.pi / 180) > cos(span.longitudeDelta / 2.0 * Double.pi / 180)
    }
}
