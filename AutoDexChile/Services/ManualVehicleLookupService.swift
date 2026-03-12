import Foundation

/// Servicio stub para búsqueda manual/local de vehículos.
/// Devuelve notFound para forzar fallback manual en esta etapa.
final class ManualVehicleLookupService: VehicleLookupProviding {
    func lookupVehicle(by plate: String) async throws -> VehicleLookupResult {
        throw VehicleLookupError.notFound
    }
}
