//
//  ModelResponse.swift
//  TestProject
//
//  Created by Bas on 24/8/2565 BE.
//

import Foundation

struct ModelResponse: Codable {
    let data: [MovieModel]
}

struct MovieModel: Codable {
    var mal_id: Int
    var url: String
    var images: ImagesModel
    var rating: String?
    var title: String
    var score: Double?
    var synopsis: String?
    var documentId: String?
    
    func toJson() -> [String: Any] {
        var dict = [String: Any]()
        dict["mal_id"] = mal_id
        dict["url"] = url
        dict["images"] = images.toJson()
        dict["title"] = title
        dict["score"] = score
        dict["synopsis"] = synopsis
        return dict
    }
    
    static func createModel(dict: [String : Any], doccumentId: String) -> MovieModel {
        var movie = MovieModel(mal_id: 0, url: "", images: ImagesModel(jpg: Images(image_url: "", small_image_url: "", large_image_url: "")), rating: "", title: "", score: 0.0, synopsis: "")
        movie.mal_id = dict["mal_id"] as? Int ?? 0
        movie.url = dict["url"] as? String ?? ""
        movie.images = ImagesModel.createModel(jpg: dict["images"] as? [String: Any] ?? [String: Any]())
        movie.rating = dict["rating"] as? String ?? ""
        movie.title = dict["title"] as? String ?? ""
        movie.score = dict["score"] as? Double ?? 0.0
        movie.synopsis = dict["synopsis"] as? String ?? ""
        movie.documentId = doccumentId
        return movie
    }
}

struct ImagesModel: Codable  {
    let jpg: Images
    
    func toJson() -> [String: Any] {
        var dict = [String: Any]()
        dict["jpg"] = jpg.toJson()
        return dict
    }
    
    static func createModel(jpg: [String : Any]) -> ImagesModel {
        let imageModel = ImagesModel(jpg: Images.createModel(image: jpg["jpg"] as? [String : Any] ?? [String: Any]()))
        return imageModel
    }
}

struct Images: Codable  {
    var image_url: String
    var small_image_url: String
    var large_image_url: String
    
    func toJson() -> [String: Any] {
        var dict = [String: Any]()
        dict["image_url"] = image_url
        dict["small_image_url"] = small_image_url
        dict["large_image_url"] = large_image_url
        return dict
    }
    
    static func createModel(image: [String : Any]) -> Images {
        var im = Images(image_url: "", small_image_url: "", large_image_url: "")
        im.image_url = image["image_url"] as? String ?? ""
        im.small_image_url = image["small_image_url"] as? String ?? ""
        im.large_image_url = image["large_image_url"] as? String ?? ""
        return im
    }
}



extension Int {
    var string: String {
        return String(self)
    }
}

extension Double {
    var string: String {
        return String(self)
    }
}
