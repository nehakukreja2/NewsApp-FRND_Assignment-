//
//  newsModel.swift
//  NewsApp
//
//  Created by Neha Kukreja on 31/08/24.
//

import Foundation

enum DisplayType: String {
    case grid
    case list
}

struct TopHeadlines : Codable {
    let status : String?
    let sources : [Sources]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case sources = "sources"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        sources = try values.decodeIfPresent([Sources].self, forKey: .sources)
    }

}

struct Sources : Codable {
    let id : String?
    let name : String?
    let description : String?
    let url : String?
    let category : String?
    let language : String?
    let country : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case description = "description"
        case url = "url"
        case category = "category"
        case language = "language"
        case country = "country"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        category = try values.decodeIfPresent(String.self, forKey: .category)
        language = try values.decodeIfPresent(String.self, forKey: .language)
        country = try values.decodeIfPresent(String.self, forKey: .country)
    }

}

struct News : Codable {
    let status : String?
    let totalResults : Int?
    let articles : [Articles]?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case totalResults = "totalResults"
        case articles = "articles"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        totalResults = try values.decodeIfPresent(Int.self, forKey: .totalResults)
        articles = try values.decodeIfPresent([Articles].self, forKey: .articles)
    }
}

struct Articles : Codable {
    var source : Source? = Source()
    var author : String? = ""
    var title : String? = ""
    var description : String? = ""
    var url : String? = ""
    var urlToImage : String? = ""
    var publishedAt : String? = ""
    var content : String? = ""
    
    var id: String {
        source?.id ?? UUID().uuidString
    }

    enum CodingKeys: String, CodingKey {
        case source = "source"
        case author = "author"
        case title = "title"
        case description = "description"
        case url = "url"
        case urlToImage = "urlToImage"
        case publishedAt = "publishedAt"
        case content = "content"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        source = try values.decodeIfPresent(Source.self, forKey: .source)
        author = try values.decodeIfPresent(String.self, forKey: .author)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        urlToImage = try values.decodeIfPresent(String.self, forKey: .urlToImage)
        publishedAt = try values.decodeIfPresent(String.self, forKey: .publishedAt)
        content = try values.decodeIfPresent(String.self, forKey: .content)
    }
}

struct Source : Codable {
    var id : String? = ""
    var name : String? = ""

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
    
    init() {}
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }
}



