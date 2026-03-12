import Foundation

/// ViewModel para estadísticas agregadas de la colección.
@MainActor
final class StatsViewModel: ObservableObject {
    @Published private(set) var stats: AppStats = .zero

    private weak var repository: InventoryRepository?

    init(repository: InventoryRepository? = nil) {
        self.repository = repository
        refresh()
    }

    func bind(repository: InventoryRepository) {
        self.repository = repository
        refresh()
    }

    func refresh() {
        stats = repository?.computeStats() ?? .zero
    }
}
