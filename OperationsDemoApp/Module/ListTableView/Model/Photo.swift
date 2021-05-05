//
//  Photo.swift
//  OperationsDemoApp
//
//  Created by Debarshee on 5/3/21.
//

import Foundation

struct PhotoCollection: Decodable {
    var photos: [Photo]?
}

struct Photo: Decodable {
    var id: String?
    var title: String?
    var description: String?
    var publishedAt: String?
    var lastCollectedAt: String?
    var updatedAt: String?
    var curated: Bool
    var featured: Bool
    var totalPhotos: Int?
    var isPrivate: Bool
    var shareKey: String?
    var tags: [PhotoInfo]?
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, curated, featured, tags
        case publishedAt = "published_at"
        case lastCollectedAt = "last_collected_at"
        case updatedAt = "updated_at"
        case totalPhotos = "total_photos"
        case isPrivate = "private"
        case shareKey = "share_key"
    }
}

struct PhotoInfo: Decodable {
    var type: String?
    var title: String?
    var source: PhotoSource?
    
    enum CodingKeys: String, CodingKey {
        case type, title, source
    }
}

struct PhotoSource: Decodable {
    var ancestry: Ancestry?
    var title: String?
    var subtitle: String?
    var description: String?
    var metaTitle: String?
    var metaDescription: String?
    var coverPhoto: CoverPhotoInfo?
    
    enum CodingKeys: String, CodingKey {
        case ancestry, title, subtitle, description
        case metaTitle = "meta_title"
        case metaDescription = "meta_description"
        case coverPhoto = "cover_photo"
    }
}

struct Ancestry: Decodable {
    var type: AncestryType?
    var category: AncestryCategory?
    var subcategory: AncestrySubcategory?
    
    enum CodingKeys: String, CodingKey {
        case type, category, subcategory
    }
}

struct AncestryType: Decodable {
    var slug: String?
    var prettySlug: String?
    
    enum CodingKeys: String, CodingKey {
        case slug
        case prettySlug = "pretty_slug"
    }
}

struct AncestryCategory: Decodable {
    var slug: String?
    var prettySlug: String?
    
    enum CodingKeys: String, CodingKey {
        case slug
        case prettySlug = "pretty_slug"
    }
}

struct AncestrySubcategory: Decodable {
    var slug: String?
    var prettySlug: String?
    
    enum CodingKeys: String, CodingKey {
        case slug
        case prettySlug = "pretty_slug"
    }
}

struct CoverPhotoInfo: Decodable {
    var id: String?
    var createdAt: String?
    var updatedAt: String?
    var promotedAt: String?
    var width: Int?
    var height: Int?
    var color: String?
    var blurHash: String?
    var description: String?
    var altDescription: String?
    var urls: PhotoUrls?
    var links: PhotoLinks?
    var likes: Int?
    var likedByUser: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, width, height, color, urls, links, likes
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case promotedAt = "promoted_at"
        case blurHash = "blur_hash"
        case altDescription = "alt_description"
        case likedByUser = "liked_by_user"
    }
}

struct PhotoUrls: Decodable {
    var raw: String?
    var full: String?
    var regular: String?
    var small: String?
    var thumb: String?
    
    enum CodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
    }
}

struct PhotoLinks: Decodable {
    var photoLinksSelf: String?
    var html: String?
    var download: String?
    var downloadLocation: String?
    
    enum CodingKeys: String, CodingKey {
        case html, download
        case photoLinksSelf = "self"
        case downloadLocation = "download_location"
    }
}
