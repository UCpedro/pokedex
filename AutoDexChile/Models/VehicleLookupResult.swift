import Foundation

/// Resultado de búsqueda de datos de vehículo.
/// Por ahora representa un contenedor simple para resultados básicos.
struct VehicleLookupResult: Codable, Equatable {
    var plate: String
    var brand: String
    var model: String
    var year: Int?
    var color: String?

    static let empty = VehicleLookupResult(plate: "", brand: "", model: "", year: nil, color: nil)
}
