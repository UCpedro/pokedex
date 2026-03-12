import Foundation

/// ViewModel para la colección principal de autos.
@MainActor
final class CollectionViewModel: ObservableObject {
    @Published private(set) var entries: [CarEntry] = []

    private weak var repository: InventoryRepository?

    func bind(repository: InventoryRepository) {
        self.repository = repository
        refresh()
    }

    func refresh() {
        entries = repository?.fetchAll() ?? []
    }

    func toggleFavorite(id: UUID) {
        repository?.toggleFavorite(id: id)
        refresh()
    }

    func delete(id: UUID) {
        repository?.delete(id: id)
        refresh()
    }
}
