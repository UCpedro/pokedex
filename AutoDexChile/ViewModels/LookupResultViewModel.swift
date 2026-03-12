import Foundation

/// ViewModel stub para estado de búsqueda de vehículo.
@MainActor
final class LookupResultViewModel: ObservableObject {
    @Published var result: VehicleLookupResult = .empty
    @Published var isLoading: Bool = false
}
