import Combine

final class AppData {
    static let shared = AppData()
    private init() {}

    @Published var isInternetWorking: Bool = false
}
