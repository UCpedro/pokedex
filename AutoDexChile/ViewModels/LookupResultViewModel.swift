import Foundation

/// ViewModel para búsqueda automática de datos de vehículo.
@MainActor
final class LookupResultViewModel: ObservableObject {
    enum State: Equatable {
        case idle
        case loading
        case success(VehicleLookupResult)
        case failure(String)
    }

    @Published private(set) var state: State = .idle
    @Published var draft: ScanDraft

    private let lookupService: VehicleLookupProviding

    init(draft: ScanDraft, lookupService: VehicleLookupProviding = WebVehicleLookupService()) {
        self.draft = draft
        self.lookupService = lookupService
    }

    func performLookup() async {
        let plate = ChilePlateNormalizer.normalize(draft.normalizedPlate)
        guard !plate.isEmpty else {
            state = .failure("No hay patente para buscar.")
            return
        }

        state = .loading

        do {
            let result = try await lookupService.lookupVehicle(by: plate)
            draft.lookupResult = result
            state = .success(result)
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? "No fue posible buscar datos automáticos."
            state = .failure(message)
        }
    }
}
