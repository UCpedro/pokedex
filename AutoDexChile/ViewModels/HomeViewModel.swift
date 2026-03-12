import Foundation

/// ViewModel de Home, expone textos principales de portada.
@MainActor
final class HomeViewModel: ObservableObject {
    @Published var title: String = "AutoDex Chile"
    @Published var subtitle: String = "Escanea, guarda y completa tu Pokédex de autos en Chile."
}
