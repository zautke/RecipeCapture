//
//  DBRecipeModels.swift
//  playground
//
//  Created by Luke Zautke on 12/3/24.
//  Copyright © 2024 braisenly.com. All rights reserved.
//

import SwiftData
import Foundation

@Model
class DBAuthor: Codable, Identifiable {
    @Attribute(.unique) var id: Int = UUID().hashValue
    var name: String
    var url: String?
    var email: String?
    
    // Convenience initializer
    init(id: Int? = nil, name: String, url: String? = nil, email: String? = nil) {
        if let id = id {
            self.id = id
        }
        self.name = name
        self.url = url
        self.email = email
    }

    enum CodingKeys: String, CodingKey {
        case id, name, url, email
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id) ?? UUID().hashValue
        name = try container.decode(String.self, forKey: .name)
        url = try container.decodeIfPresent(String.self, forKey: .url)
        email = try container.decodeIfPresent(String.self, forKey: .email)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(url, forKey: .url)
        try container.encode(email, forKey: .email)
    }
}

@Model
class DBImageModel: Codable, Identifiable {
    @Attribute(.unique) var id: Int = UUID().hashValue
    var url: String
    var caption: String?
    var height: Int?
    var width: Int?
    
    // Convenience initializer
    init(id: Int? = nil, url: String, caption: String? = nil, height: Int? = nil, width: Int? = nil) {
        if let id = id {
            self.id = id
        }
        self.url = url
        self.caption = caption
        self.height = height
        self.width = width
    }

    enum CodingKeys: String, CodingKey {
        case id, url, caption, height, width
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id) ?? UUID().hashValue
        url = try container.decode(String.self, forKey: .url)
        caption = try container.decodeIfPresent(String.self, forKey: .caption)
        height = try container.decodeIfPresent(Int.self, forKey: .height)
        width = try container.decodeIfPresent(Int.self, forKey: .width)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(url, forKey: .url)
        try container.encode(caption, forKey: .caption)
        try container.encode(height, forKey: .height)
        try container.encode(width, forKey: .width)
    }
}

struct DBInstructionStep: Codable {
    let step: String
}

@Model
class DBNutrition: Codable {
    var calories: String?

    // Convenience initializer
    init(calories: String? = nil) {
        self.calories = calories
    }

    enum CodingKeys: String, CodingKey {
        case calories
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        calories = try container.decodeIfPresent(String.self, forKey: .calories)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(calories, forKey: .calories)
    }
}

@Model
class DBAggregateRating: Codable {
    var ratingCount: Int?
    var ratingValue: Double?
    
    // Convenience initializer
    init(ratingCount: Int? = nil, ratingValue: Double? = nil) {
        self.ratingCount = ratingCount
        self.ratingValue = ratingValue
    }
    
    enum CodingKeys: String, CodingKey {
        case ratingCount
        case ratingValue
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        ratingCount = try container.decodeIfPresent(Int.self, forKey: .ratingCount)
        ratingValue = try container.decodeIfPresent(Double.self, forKey: .ratingValue)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(ratingCount, forKey: .ratingCount)
        try container.encode(ratingValue, forKey: .ratingValue)
    }
}

@Model
class DBVideo: Codable {
    var url: String?
    
    // Convenience initializer
    init(url: String? = nil) {
        self.url = url
    }

    enum CodingKeys: String, CodingKey {
        case url
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decodeIfPresent(String.self, forKey: .url)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(url, forKey: .url)
    }
}

@Model
class DBRecipe: Codable, Identifiable {
    @Attribute(.unique) var id: Int = UUID().hashValue
    var name: String
    var desc: String?
    var authorId: Int?
    var image: DBImageModel?
    var datePublished: Date?
    var prepTime: String?
    var cookTime: String?
    var totalTime: String?
    var recipeYield: String?
    var recipeCategory: String?
    var recipeCuisine: String?
    var keywords: String?
    var suitableForDiet: [String] = []
    var recipeIngredient: [String] = []
    var recipeInstructions: [String] = []
    var nutrition: DBNutrition?
    var aggregateRating: DBAggregateRating?
    var video: DBVideo?
    
    // Convenience initializer
    init(
        id: Int? = nil,
        name: String,
        desc: String? = nil,
        authorId: Int? = nil,
        image: DBImageModel? = nil,
        datePublished: Date? = nil,
        prepTime: String? = nil,
        cookTime: String? = nil,
        totalTime: String? = nil,
        recipeYield: String? = nil,
        recipeCategory: String? = nil,
        recipeCuisine: String? = nil,
        keywords: String? = nil,
        suitableForDiet: [String] = [],
        recipeIngredient: [String] = [],
        recipeInstructions: [String] = [],
        nutrition: DBNutrition? = nil,
        aggregateRating: DBAggregateRating? = nil,
        video: DBVideo? = nil
    ) {
        if let id = id {
            self.id = id
        }
        self.name = name
        self.desc = desc
        self.authorId = authorId
        self.image = image
        self.datePublished = datePublished
        self.prepTime = prepTime
        self.cookTime = cookTime
        self.totalTime = totalTime
        self.recipeYield = recipeYield
        self.recipeCategory = recipeCategory
        self.recipeCuisine = recipeCuisine
        self.keywords = keywords
        self.suitableForDiet = suitableForDiet
        self.recipeIngredient = recipeIngredient
        self.recipeInstructions = recipeInstructions
        self.nutrition = nutrition
        self.aggregateRating = aggregateRating
        self.video = video
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case desc = "description"
        case authorId = "author_id"
        case image
        case datePublished = "date_published"
        case prepTime = "prep_time"
        case cookTime = "cook_time"
        case totalTime = "total_time"
        case recipeYield = "recipe_yield"
        case recipeCategory = "recipe_category"
        case recipeCuisine = "recipe_cuisine"
        case keywords
        case suitableForDiet = "suitable_for_diet"
        case recipeIngredient = "recipe_ingredient"
        case recipeInstructions = "recipe_instructions"
        case nutrition
        case aggregateRating = "aggregate_rating"
        case video
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Decode basic properties
        id = try container.decodeIfPresent(Int.self, forKey: .id) ?? UUID().hashValue
        name = try container.decode(String.self, forKey: .name)
        desc = try container.decodeIfPresent(String.self, forKey: .desc)
        authorId = try container.decodeIfPresent(Int.self, forKey: .authorId)
        image = try container.decodeIfPresent(DBImageModel.self, forKey: .image)

        // Handle datePublished with custom date format
        if let datePublishedString = try container.decodeIfPresent(String.self, forKey: .datePublished) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            datePublished = formatter.date(from: datePublishedString)
        }

        prepTime = try container.decodeIfPresent(String.self, forKey: .prepTime)
        cookTime = try container.decodeIfPresent(String.self, forKey: .cookTime)
        totalTime = try container.decodeIfPresent(String.self, forKey: .totalTime)
        recipeYield = try container.decodeIfPresent(String.self, forKey: .recipeYield)
        recipeCategory = try container.decodeIfPresent(String.self, forKey: .recipeCategory)
        recipeCuisine = try container.decodeIfPresent(String.self, forKey: .recipeCuisine)
        keywords = try container.decodeIfPresent(String.self, forKey: .keywords)
        suitableForDiet = try container.decodeIfPresent([String].self, forKey: .suitableForDiet) ?? []
        recipeIngredient = try container.decodeIfPresent([String].self, forKey: .recipeIngredient) ?? []

        // Decode recipeInstructions as [DBInstructionStep] and extract steps
        let instructionSteps = try container.decodeIfPresent([DBInstructionStep].self, forKey: .recipeInstructions) ?? []
        recipeInstructions = instructionSteps.map { $0.step }

        // Decode nested objects
        nutrition = try container.decodeIfPresent(DBNutrition.self, forKey: .nutrition)
        aggregateRating = try container.decodeIfPresent(DBAggregateRating.self, forKey: .aggregateRating)
        video = try container.decodeIfPresent(DBVideo.self, forKey: .video)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(desc, forKey: .desc)
        try container.encode(authorId, forKey: .authorId)
        try container.encode(image, forKey: .image)
        
        if let datePublished = datePublished {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let dateString = formatter.string(from: datePublished)
            try container.encode(dateString, forKey: .datePublished)
        } else {
            try container.encodeNil(forKey: .datePublished)
        }
        
        try container.encode(prepTime, forKey: .prepTime)
        try container.encode(cookTime, forKey: .cookTime)
        try container.encode(totalTime, forKey: .totalTime)
        try container.encode(recipeYield, forKey: .recipeYield)
        try container.encode(recipeCategory, forKey: .recipeCategory)
        try container.encode(recipeCuisine, forKey: .recipeCuisine)
        try container.encode(keywords, forKey: .keywords)
        try container.encode(suitableForDiet, forKey: .suitableForDiet)
        try container.encode(recipeIngredient, forKey: .recipeIngredient)
        
        let instructionSteps = recipeInstructions.map { DBInstructionStep(step: $0) }
        try container.encode(instructionSteps, forKey: .recipeInstructions)
        
        try container.encode(nutrition, forKey: .nutrition)
        try container.encode(aggregateRating, forKey: .aggregateRating)
        try container.encode(video, forKey: .video)
    }
}

@Model
class DBReview: Codable, Identifiable {
    @Attribute(.unique) var id: Int = UUID().hashValue
    var recipe: DBRecipe
    var author: DBAuthor?
    var reviewBody: String?
    var ratingValue: Double = 0.0
    var bestRating: Double = 5.0
    var worstRating: Double = 0.0
    var datePublished: Date = Date()

    // Convenience initializer
    init(
        id: Int? = nil,
        recipe: DBRecipe,
        author: DBAuthor? = nil,
        reviewBody: String? = nil,
        ratingValue: Double = 0.0,
        bestRating: Double = 5.0,
        worstRating: Double = 0.0,
        datePublished: Date = Date()
    ) {
        if let id = id {
            self.id = id
        }
        self.recipe = recipe
        self.author = author
        self.reviewBody = reviewBody
        self.ratingValue = ratingValue
        self.bestRating = bestRating
        self.worstRating = worstRating
        self.datePublished = datePublished
    }

    enum CodingKeys: String, CodingKey {
        case id, recipe, author, reviewBody, ratingValue, bestRating, worstRating
        case datePublished
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decodeIfPresent(Int.self, forKey: .id) ?? UUID().hashValue
        recipe = try container.decode(DBRecipe.self, forKey: .recipe)
        author = try container.decodeIfPresent(DBAuthor.self, forKey: .author)
        reviewBody = try container.decodeIfPresent(String.self, forKey: .reviewBody)
        ratingValue = try container.decodeIfPresent(Double.self, forKey: .ratingValue) ?? 0.0
        bestRating = try container.decodeIfPresent(Double.self, forKey: .bestRating) ?? 5.0
        worstRating = try container.decodeIfPresent(Double.self, forKey: .worstRating) ?? 0.0
        datePublished = try container.decodeIfPresent(Date.self, forKey: .datePublished) ?? Date()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(recipe, forKey: .recipe)
        try container.encode(author, forKey: .author)
        try container.encode(reviewBody, forKey: .reviewBody)
        try container.encode(ratingValue, forKey: .ratingValue)
        try container.encode(bestRating, forKey: .bestRating)
        try container.encode(worstRating, forKey: .worstRating)
        try container.encode(datePublished, forKey: .datePublished)
    }
}
