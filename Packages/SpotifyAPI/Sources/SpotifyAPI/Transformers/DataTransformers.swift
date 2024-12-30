//
//  DataTransformers.swift
//  SpotifyAPI
//
//  Created by Luca Archidiacono on 30.12.2024.
//

import Foundation
import Models

enum DataTransformer {
    static func transform(_ data: GETTracksResponse) -> [StreamableSong] {
        data.tracks.items
            .compactMap { item in
                guard let year = extractYear(from: item.album.releaseDate),
                      let previewURL = URL(string: item.externalUrls.spotify)
                else { return nil }
                
                return StreamableSong(
                    id: item.id,
                    title: item.name,
                    artist: item.artists.map { $0.name }.joined(separator: ", "),
                    year: year,
                    previewURL: previewURL
                )
            }
    }
    
    private static func extractYear(from dateString: String) -> Int? {
        // Create a DateFormatter
        let dateFormatter = DateFormatter()
        
        // Set the date format to match the input string's format (yyyy-MM-dd)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Convert the string into a Date object
        if let date = dateFormatter.date(from: dateString) {
            // Extract the year component using Calendar
            let calendar = Calendar.current
            let year = calendar.component(.year, from: date)
            return year
        } else {
            // If the string cannot be parsed, return nil
            return nil
        }
    }
}
