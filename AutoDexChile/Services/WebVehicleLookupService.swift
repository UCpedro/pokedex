import Foundation

/// Servicio provisional de lookup automático.
/// No usa scraping real aún; entrega datos demo para algunas patentes y fallback a manual.
final class WebVehicleLookupService: VehicleLookupProviding {
    func lookupVehicle(by plate: String) async throws -> VehicleLookupResult {
        let normalized = ChilePlateNormalizer.normalize(plate)

        // Simula latencia de red para mostrar loading del flujo.
        try await Task.sleep(nanoseconds: 600_000_000)

        if normalized.hasPrefix("AB") {
            return VehicleLookupResult(
                plate: normalized,
                brand: "Toyota",
                model: "Yaris",
                year: 2020,
                version: "Sport",
                color: "Blanco",
                vehicleType: "Sedán",
                notes: "Resultado automático provisional"
            )
        }

        if normalized.hasPrefix("CD") {
            return VehicleLookupResult(
                plate: normalized,
                brand: "Kia",
                model: "Rio 5",
                year: 2019,
                version: nil,
                color: "Rojo",
                vehicleType: "Hatchback",
                notes: "Resultado automático provisional"
            )
        }

        throw VehicleLookupError.notFound
    }
}
