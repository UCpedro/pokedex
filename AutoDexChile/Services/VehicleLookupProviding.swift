import Foundation

enum VehicleLookupError: LocalizedError {
    case notFound
    case unavailable

    var errorDescription: String? {
        switch self {
        case .notFound:
            return "No se encontraron datos automáticos para esta patente."
        case .unavailable:
            return "El servicio de búsqueda no está disponible en este momento."
        }
    }
}

/// Contrato para servicios de lookup de vehículos.
protocol VehicleLookupProviding {
    func lookupVehicle(by plate: String) async throws -> VehicleLookupResult
}
