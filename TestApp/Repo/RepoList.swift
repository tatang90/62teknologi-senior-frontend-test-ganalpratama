//
//  RepoList.swift
//  TestApp
//
//  Created by Icon+ Gaenael on 16/05/23.
//

import Foundation

class RepoList: BaseRepo{
    
    func getList(_ page: Int, keyword: String, completion: @escaping (RESBusiness?, Error?) -> Void){
        let kword = keyword.count > 0 ? keyword.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)! : "NYC"
        end_point = "businesses/search?location=\(kword)&sort_by=best_match&limit=20&offset=\(page*10)"
        load(type: RESBusiness.self) { data, err in
            completion(data, err)
        }
    }
    
}

struct RESBusiness: Decodable{
    let businesses: [MDBusiness]
}

struct MDBusiness: Decodable{
    let id,
        name: String
    
    let price: String?
    let categories: [MDBusinessCategory]
    let rating: Double
    let review_count: Int
}

struct MDBusinessCategory: Decodable{
    let title: String
}
