import Foundation
import Observation

@Observable
@MainActor
final class ReaderViewModel {
    private let gurbaniService: GurbaniService

    // Content
    private(set) var shabad: Shabad?
    private(set) var baniContent: BaniContent?

    // State
    private(set) var isLoading = false
    private(set) var error: APIError?

    // Display settings
    var showGurmukhi = true
    var showTransliteration = true
    var showTranslation = true
    var useLarivaar = false

    init(gurbaniService: GurbaniService = .shared) {
        self.gurbaniService = gurbaniService
    }

    // MARK: - Load Shabad

    func loadShabad(id: Int) async {
        guard !isLoading else { return }

        isLoading = true
        error = nil

        do {
            shabad = try await gurbaniService.fetchShabad(id: id)
        } catch let apiError as APIError {
            error = apiError
        } catch {
            self.error = .networkError(error)
        }

        isLoading = false
    }

    // MARK: - Load Bani

    func loadBani(id: Int) async {
        guard !isLoading else { return }

        isLoading = true
        error = nil

        do {
            baniContent = try await gurbaniService.fetchBani(id: id)
        } catch let apiError as APIError {
            error = apiError
        } catch {
            self.error = .networkError(error)
        }

        isLoading = false
    }

    // MARK: - Computed Properties

    var verses: [Verse] {
        if let shabad {
            return shabad.verses
        } else if let bani = baniContent {
            return bani.verses
        }
        return []
    }

    var title: String {
        if let shabad {
            return "Ang \(shabad.ang)"
        } else if let bani = baniContent {
            return bani.name
        }
        return "Loading..."
    }

    var subtitle: String? {
        if let shabad {
            return shabad.sourceName
        } else if let bani = baniContent {
            return bani.transliteration
        }
        return nil
    }

    // MARK: - Share

    func shareText() -> String {
        var content = ""

        for verse in verses {
            content += verse.gurmukhiUnicode + "\n"
            if showTransliteration, let translit = verse.transliteration {
                content += translit + "\n"
            }
            if showTranslation, let translation = verse.translation {
                content += translation + "\n"
            }
            content += "\n"
        }

        if let shabad {
            content += "- \(shabad.sourceName), Ang \(shabad.ang)"
        } else if let bani = baniContent {
            content += "- \(bani.name)"
        }

        return content
    }
}
