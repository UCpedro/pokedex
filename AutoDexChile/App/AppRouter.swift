import SwiftUI

/// Router principal de la app.
/// Configura dependencias compartidas y navegación raíz.
struct AppRouter: View {
    @StateObject private var repository = InventoryRepository()

    var body: some View {
        NavigationStack {
            HomeView(viewModel: HomeViewModel())
        }
        .environmentObject(repository)
    }
}
