import Foundation

/// Servicio stub para búsqueda manual/local de vehículos.
/// TODO: Implementar reglas manuales o base local según necesidad.
final class ManualVehicleLookupService: VehicleLookupProviding {
    func lookupVehicle(by plate: String) async throws -> VehicleLookupResult {
        VehicleLookupResult(plate: plate, brand: "", model: "", year: nil, color: nil)
    }
}
