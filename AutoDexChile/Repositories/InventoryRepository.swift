import Foundation

/// Fuente única de verdad de la colección local de autos.
/// Implementación en memoria, preparada para migrar a persistencia real más adelante.
@MainActor
final class InventoryRepository: ObservableObject {
    @Published private(set) var entries: [CarEntry] = []

    func save(_ entry: CarEntry) {
        entries.append(entry)
    }

    func fetchAll() -> [CarEntry] {
        entries.sorted { $0.createdAt > $1.createdAt }
    }

    func find(by id: UUID) -> CarEntry? {
        entries.first(where: { $0.id == id })
    }

    func update(_ entry: CarEntry) {
        guard let index = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        var updated = entry
        updated.updatedAt = Date()
        entries[index] = updated
    }

    func delete(id: UUID) {
        entries.removeAll { $0.id == id }
    }

    func toggleFavorite(id: UUID) {
        guard let index = entries.firstIndex(where: { $0.id == id }) else { return }
        entries[index].isFavorite.toggle()
        entries[index].updatedAt = Date()
    }

    func computeStats() -> AppStats {
        let total = entries.count
        let favorites = entries.filter(\.isFavorite).count
        let uniqueBrands = Set(entries.map { $0.brand.trimmingCharacters(in: .whitespacesAndNewlines).uppercased() }.filter { !$0.isEmpty }).count
        let points = entries.reduce(0) { $0 + $1.points }

        let rarityCounts = Dictionary(grouping: entries, by: { $0.rarity })
            .mapValues(\.count)

        return AppStats(
            totalCars: total,
            favoriteCars: favorites,
            uniqueBrands: uniqueBrands,
            totalPoints: points,
            rarityCounts: rarityCounts
        )
    }
}
