import PhotosUI
import SwiftUI

/// Vista del flujo de escaneo de patente usando galería.
struct ScanFlowView: View {
    @StateObject var viewModel: ScanFlowViewModel
    @State private var selectedPhotoItem: PhotosPickerItem?

    var body: some View {
        VStack(spacing: 16) {
            Text("Escaneo de patente")
                .font(.title2)
                .bold()

            PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                Label("Seleccionar imagen de patente", systemImage: "photo")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)

            if viewModel.selectedImageData != nil {
                Text("Imagen seleccionada")
                    .foregroundStyle(.secondary)
            }

            if viewModel.isLoading {
                ProgressView("Leyendo patente con OCR...")
            } else {
                Button("Ejecutar OCR") {
                    Task {
                        await viewModel.runOCR()
                    }
                }
                .buttonStyle(.bordered)
                .disabled(viewModel.selectedImageData == nil)
            }

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
                    .font(.footnote)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Escanear")
        .onChange(of: selectedPhotoItem) { _, newItem in
            guard let newItem else { return }
            Task {
                if let data = try? await newItem.loadTransferable(type: Data.self) {
                    await MainActor.run {
                        viewModel.selectedImageData = data
                    }
                }
            }
        }
        .navigationDestination(isPresented: $viewModel.shouldNavigateToReview) {
            PlateReviewView(
                viewModel: PlateReviewViewModel(result: viewModel.ocrResult)
            )
        }
    }
}

#Preview {
    NavigationStack {
        ScanFlowView(viewModel: ScanFlowViewModel())
    }
}
