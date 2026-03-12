import SwiftUI

/// Punto de entrada de AutoDex Chile.
/// En esta etapa inicial solo inicia la navegación base y muestra Home.
@main
struct AutoDexChileApp: App {
    var body: some Scene {
        WindowGroup {
            AppRouter()
        }
    }
}
