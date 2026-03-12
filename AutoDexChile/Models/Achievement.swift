import Foundation

/// Modelo de logro de progresión tipo Pokédex.
/// En esta fase es solo una estructura base.
struct Achievement: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var isUnlocked: Bool

    init(id: UUID = UUID(), title: String, isUnlocked: Bool = false) {
        self.id = id
        self.title = title
        self.isUnlocked = isUnlocked
    }
}
