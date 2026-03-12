import Foundation

/// Resultado de búsqueda provisional de datos de vehículo.
struct VehicleLookupResult: Codable, Equatable {
    var plate: String
    var brand: String
    var model: String
    var year: Int?
    var version: String?
    var color: String?
    var vehicleType: String?
    var notes: String?

    static let empty = VehicleLookupResult(
        plate: "",
        brand: "",
        model: "",
        year: nil,
        version: nil,
        color: nil,
        vehicleType: nil,
        notes: nil
    )
}
