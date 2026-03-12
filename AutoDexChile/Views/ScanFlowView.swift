import PhotosUI
import SwiftUI
import UIKit

/// Flujo guiado:
/// 1) Foto del auto
/// 2) Foto de la patente
/// 3) OCR
struct ScanFlowView: View {
    @StateObject var viewModel: ScanFlowViewModel

    @State private var selectedCarPhotoItem: PhotosPickerItem?
    @State private var selectedPlatePhotoItem: PhotosPickerItem?

    @State private var showingPicker = false
    @State private var pickerSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var pickerTarget: PickerTarget = .car

    private enum PickerTarget {
        case car
        case plate
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Escanear auto")
                    .font(.title2)
                    .bold()

                stepCard(
                    title: "Paso 1 · Foto del auto",
                    image: viewModel.carPreview,
                    isCompleted: viewModel.hasCarPhoto,
                    cameraAction: { openCamera(for: .car) },
                    galleryPicker: PhotosPicker(selection: $selectedCarPhotoItem, matching: .images) {
                        Label("Elegir foto del auto", systemImage: "photo")
                            .frame(maxWidth: .infinity)
                    }
                )

                stepCard(
                    title: "Paso 2 · Foto de la patente",
                    image: viewModel.platePreview,
                    isCompleted: viewModel.hasPlatePhoto,
                    cameraAction: { openCamera(for: .plate) },
                    galleryPicker: PhotosPicker(selection: $selectedPlatePhotoItem, matching: .images) {
                        Label("Elegir foto de la patente", systemImage: "photo")
                            .frame(maxWidth: .infinity)
                    }
                )

                VStack(alignment: .leading, spacing: 8) {
                    Text("Paso 3 · Leer patente")
                        .font(.headline)

                    if viewModel.isLoading {
                        ProgressView("Leyendo patente con OCR...")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        Button("Continuar con OCR") {
                            Task { await viewModel.runOCR() }
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(!viewModel.hasPlatePhoto)
                    }
                }

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundStyle(.red)
                }
            }
            .padding()
        }
        .navigationTitle("Escaneo")
        .onChange(of: selectedCarPhotoItem) { _, newItem in
            guard let newItem else { return }
            Task {
                if let data = try? await newItem.loadTransferable(type: Data.self) {
                    await MainActor.run { viewModel.setCarImageData(data) }
                }
            }
        }
        .onChange(of: selectedPlatePhotoItem) { _, newItem in
            guard let newItem else { return }
            Task {
                if let data = try? await newItem.loadTransferable(type: Data.self) {
                    await MainActor.run { viewModel.setPlateImageData(data) }
                }
            }
        }
        .sheet(isPresented: $showingPicker) {
            ImagePickerView(sourceType: pickerSource) { data in
                switch pickerTarget {
                case .car:
                    viewModel.setCarImageData(data)
                case .plate:
                    viewModel.setPlateImageData(data)
                }
            }
        }
        .navigationDestination(isPresented: $viewModel.shouldNavigateToReview) {
            PlateReviewView(
                viewModel: PlateReviewViewModel(result: viewModel.ocrResult, draft: viewModel.draft)
            )
        }
    }

    private func stepCard<PickerContent: View>(
        title: String,
        image: UIImage?,
        isCompleted: Bool,
        cameraAction: @escaping () -> Void,
        galleryPicker: PickerContent
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isCompleted ? .green : .secondary)
            }

            Group {
                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 160)
                        .frame(maxWidth: .infinity)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.secondarySystemBackground))
                        .frame(height: 120)
                        .overlay {
                            Text("Sin imagen")
                                .foregroundStyle(.secondary)
                        }
                }
            }

            Button {
                cameraAction()
            } label: {
                Label("Usar cámara", systemImage: "camera")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)

            galleryPicker
                .buttonStyle(.bordered)
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay {
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(.separator), lineWidth: 0.5)
        }
    }

    private func openCamera(for target: PickerTarget) {
        pickerTarget = target
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            pickerSource = .camera
        } else {
            pickerSource = .photoLibrary
        }
        showingPicker = true
    }
}

#Preview {
    NavigationStack {
        ScanFlowView(viewModel: ScanFlowViewModel())
    }
}
