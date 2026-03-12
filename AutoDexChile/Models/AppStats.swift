import Foundation

/// Estadísticas agregadas de la colección.
struct AppStats: Codable, Equatable {
    var totalCars: Int
    var favoriteCars: Int
    var uniqueBrands: Int
    var totalPoints: Int
    var rarityCounts: [String: Int]

    static let zero = AppStats(
        totalCars: 0,
        favoriteCars: 0,
        uniqueBrands: 0,
        totalPoints: 0,
        rarityCounts: [:]
    )
}
