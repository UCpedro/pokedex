import Foundation

/// Servicio stub para lookup web de vehículos.
/// TODO: Implementar integración remota/scraping en una fase posterior.
final class WebVehicleLookupService: VehicleLookupProviding {
    func lookupVehicle(by plate: String) async throws -> VehicleLookupResult {
        VehicleLookupResult(plate: plate, brand: "", model: "", year: nil, color: nil)
    }
}
