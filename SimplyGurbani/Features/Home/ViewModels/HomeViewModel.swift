import Foundation
import Observation

@Observable
@MainActor
final class HomeViewModel {
    private let gurbaniService: GurbaniService

    // State
    private(set) var hukamnama: Hukamnama?
    private(set) var isLoading = false
    private(set) var error: APIError?

    init(gurbaniService: GurbaniService = .shared) {
        self.gurbaniService = gurbaniService
    }

    func loadHukamnama() async {
        guard !isLoading else { return }

        isLoading = true
        error = nil

        do {
            hukamnama = try await gurbaniService.fetchTodayHukamnama()
        } catch let apiError as APIError {
            error = apiError
        } catch {
            self.error = .networkError(error)
        }

        isLoading = false
    }
}
