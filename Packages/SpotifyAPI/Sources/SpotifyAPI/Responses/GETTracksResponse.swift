//
//  GETTracksResponse.swift
//  SpotifyAPI
//
//  Created by DG-SM-8669 on 30.12.2024.
//

// {
//  "tracks": {
//    "href": "https://api.spotify.com/v1/search?offset=0&limit=20&query=track%3ABlinding%20Lights%20artist%3AThe%20Weeknd%20year%3A2019&type=track&market=CH&include_external=audio&locale=en-US,en;q%3D0.9",
//    "limit": 20,
//    "next": null,
//    "offset": 0,
//    "previous": null,
//    "total": 0,
//    "items": []
//  }
// }
//
// {
//  "tracks": {
//    "href": "https://api.spotify.com/v1/me/shows?offset=0&limit=20",
//    "limit": 20,
//    "next": "https://api.spotify.com/v1/me/shows?offset=1&limit=1",
//    "offset": 0,
//    "previous": "https://api.spotify.com/v1/me/shows?offset=1&limit=1",
//    "total": 4,
//    "items": [
//      {
//        "album": {
//          "album_type": "compilation",
//          "total_tracks": 9,
//          "available_markets": ["CA", "BR", "IT"],
//          "external_urls": {
//            "spotify": "string"
//          },
//          "href": "string",
//          "id": "2up3OPMp9Tb4dAKM2erWXQ",
//          "images": [
//            {
//              "url": "https://i.scdn.co/image/ab67616d00001e02ff9ca10b55ce82ae553c8228",
//              "height": 300,
//              "width": 300
//            }
//          ],
//          "name": "string",
//          "release_date": "1981-12",
//          "release_date_precision": "year",
//          "restrictions": {
//            "reason": "market"
//          },
//          "type": "album",
//          "uri": "spotify:album:2up3OPMp9Tb4dAKM2erWXQ",
//          "artists": [
//            {
//              "external_urls": {
//                "spotify": "string"
//              },
//              "href": "string",
//              "id": "string",
//              "name": "string",
//              "type": "artist",
//              "uri": "string"
//            }
//          ]
//        },
//        "artists": [
//          {
//            "external_urls": {
//              "spotify": "string"
//            },
//            "href": "string",
//            "id": "string",
//            "name": "string",
//            "type": "artist",
//            "uri": "string"
//          }
//        ],
//        "available_markets": ["string"],
//        "disc_number": 0,
//        "duration_ms": 0,
//        "explicit": false,
//        "external_ids": {
//          "isrc": "string",
//          "ean": "string",
//          "upc": "string"
//        },
//        "external_urls": {
//          "spotify": "string"
//        },
//        "href": "string",
//        "id": "string",
//        "is_playable": false,
//        "linked_from": {
//        },
//        "restrictions": {
//          "reason": "string"
//        },
//        "name": "string",
//        "popularity": 0,
//        "preview_url": "string",
//        "track_number": 0,
//        "type": "track",
//        "uri": "string",
//        "is_local": false
//      }
//    ]
//  },
//
// struct GETTracksResponseContainer: Codable {
//    let tracks: Tracks
//
//    struct Tracks: Codable {
//
//    }
// }
