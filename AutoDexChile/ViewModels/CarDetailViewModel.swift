import Foundation

/// ViewModel de detalle de auto para acciones sobre la ficha.
@MainActor
final class CarDetailViewModel: ObservableObject {
    @Published private(set) var entry: CarEntry

    private let repository: InventoryRepository

    init(entry: CarEntry, repository: InventoryRepository) {
        self.entry = entry
        self.repository = repository
    }

    func refresh() {
        guard let current = repository.find(by: entry.id) else { return }
        entry = current
    }

    func toggleFavorite() {
        repository.toggleFavorite(id: entry.id)
        refresh()
    }

    func delete() {
        repository.delete(id: entry.id)
    }
}
