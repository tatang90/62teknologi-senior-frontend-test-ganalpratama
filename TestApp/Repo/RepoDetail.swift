//
//  RepoDetail.swift
//  TestApp
//
//  Created by Icon+ Gaenael on 16/05/23.
//

import Foundation

class RepoDetail: BaseRepo{
    
    func getDetail(_ id: String, completion: @escaping (ResDetail?, Error?) -> Void){
        end_point = "businesses/\(id)"
        load(type: ResDetail.self) { data, err in
            completion(data, err)
        }
    }
    
    func getReview(_ id: String, completion: @escaping (RESReviews?, Error?) -> Void){
        end_point = "businesses/\(id)/reviews?limit=20&sort_by=yelp_sort/"
        load(type: RESReviews.self) { data, err in
            completion(data, err)
        }
    }
    
}

struct ResDetail: Decodable{
    let id,
        name,
        image_url,
        phone,
        display_phone: String
    let photos: [String]
    let coordinates : MDCoordinates
    let price: String?
    let categories: [MDBusinessCategory]
    let rating: Double
    let review_count: Int
}
    
struct MDCoordinates: Decodable{
    let latitude,
        longitude: Double
}

//REVIEW

struct RESReviews: Decodable{
    let reviews: [MDReview]
}

struct MDReview: Decodable{
    let time_created,
        text: String
    let rating: Double
}
