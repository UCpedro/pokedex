import SwiftUI

/// Vista de estadísticas básicas de la colección.
struct StatsView: View {
    @EnvironmentObject private var repository: InventoryRepository
    @StateObject private var viewModel = StatsViewModel(repository: InventoryRepository())

    var body: some View {
        List {
            Section("Resumen") {
                statRow("Total de autos", "\(viewModel.stats.totalCars)")
                statRow("Favoritos", "\(viewModel.stats.favoriteCars)")
                statRow("Marcas distintas", "\(viewModel.stats.uniqueBrands)")
                statRow("Puntos acumulados", "\(viewModel.stats.totalPoints)")
            }

            Section("Rareza") {
                if viewModel.stats.rarityCounts.isEmpty {
                    Text("Sin datos aún")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(viewModel.stats.rarityCounts.keys.sorted(), id: \.self) { rarity in
                        statRow(rarity, "\(viewModel.stats.rarityCounts[rarity] ?? 0)")
                    }
                }
            }
        }
        .navigationTitle("Estadísticas")
        .onAppear {
            viewModel.bind(repository: repository)
        }
        .onChange(of: repository.entries) { _, _ in
            viewModel.refresh()
        }
    }

    private func statRow(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .bold()
        }
    }
}

#Preview {
    NavigationStack {
        StatsView()
    }
    .environmentObject(InventoryRepository())
}
