import Foundation

/// Modelo principal de un auto en la colección tipo Pokédex.
struct CarEntry: Identifiable, Codable, Equatable {
    enum SourceType: String, Codable, CaseIterable {
        case manual
        case ocr
        case web
    }

    let id: UUID
    var plate: String
    var brand: String
    var model: String
    var year: Int
    var version: String?
    var vehicleType: String?
    var color: String?
    var notes: String?
    var rarity: String
    var points: Int
    var isFavorite: Bool
    var photoCarPath: String?
    var photoPlatePath: String?
    var sourceType: SourceType
    let createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        plate: String,
        brand: String,
        model: String,
        year: Int,
        version: String? = nil,
        vehicleType: String? = nil,
        color: String? = nil,
        notes: String? = nil,
        rarity: String,
        points: Int,
        isFavorite: Bool = false,
        photoCarPath: String? = nil,
        photoPlatePath: String? = nil,
        sourceType: SourceType = .manual,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.plate = plate
        self.brand = brand
        self.model = model
        self.year = year
        self.version = version
        self.vehicleType = vehicleType
        self.color = color
        self.notes = notes
        self.rarity = rarity
        self.points = points
        self.isFavorite = isFavorite
        self.photoCarPath = photoCarPath
        self.photoPlatePath = photoPlatePath
        self.sourceType = sourceType
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
