import SwiftUI

/// Pantalla principal de AutoDex Chile.
struct HomeView: View {
    @StateObject var viewModel: HomeViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text(viewModel.title)
                .font(.largeTitle)
                .bold()

            Text(viewModel.subtitle)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal)

            VStack(spacing: 12) {
                NavigationLink {
                    ScanFlowView(viewModel: ScanFlowViewModel())
                } label: {
                    Label("Escanear auto", systemImage: "camera.viewfinder")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                NavigationLink {
                    CollectionView()
                } label: {
                    Label("Mi colección", systemImage: "square.grid.2x2.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                NavigationLink {
                    StatsView()
                } label: {
                    Label("Estadísticas", systemImage: "chart.bar.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Home")
    }
}

#Preview {
    NavigationStack {
        HomeView(viewModel: HomeViewModel())
    }
    .environmentObject(InventoryRepository())
}
