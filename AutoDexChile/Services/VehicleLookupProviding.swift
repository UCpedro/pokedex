import Foundation

/// Contrato para servicios de lookup de vehículos.
/// Permite intercambiar lookup manual, web, mock o testing.
protocol VehicleLookupProviding {
    func lookupVehicle(by plate: String) async throws -> VehicleLookupResult
}
