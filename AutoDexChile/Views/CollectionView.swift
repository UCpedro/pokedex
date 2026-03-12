import SwiftUI

/// Pantalla principal de la colección tipo Pokédex.
struct CollectionView: View {
    @EnvironmentObject private var repository: InventoryRepository
    @StateObject private var viewModel = CollectionViewModel()

    var body: some View {
        ScrollView {
            if viewModel.entries.isEmpty {
                ContentUnavailableView(
                    "Sin autos aún",
                    systemImage: "car",
                    description: Text("Escanea una patente y guarda tu primer auto.")
                )
                .padding(.top, 60)
            } else {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 170), spacing: 12)], spacing: 12) {
                    ForEach(viewModel.entries) { entry in
                        NavigationLink {
                            CarDetailView(entryID: entry.id)
                        } label: {
                            CarCardView(
                                entry: entry,
                                onFavoriteTap: { viewModel.toggleFavorite(id: entry.id) }
                            )
                        }
                        .buttonStyle(.plain)
                        .contextMenu {
                            Button(role: .destructive) {
                                viewModel.delete(id: entry.id)
                            } label: {
                                Label("Eliminar", systemImage: "trash")
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Mi colección")
        .onAppear {
            viewModel.bind(repository: repository)
        }
        .onChange(of: repository.entries) { _, _ in
            viewModel.refresh()
        }
    }
}

#Preview {
    NavigationStack {
        CollectionView()
    }
    .environmentObject(InventoryRepository())
}
