import Testing
@testable import SimplyGurbani

@Suite("Simply Gurbani Tests")
struct SimplyGurbaniTests {

    @Test("App Router initializes correctly")
    func appRouterInitialization() {
        let router = AppRouter()
        #expect(router.selectedTab == .home)
        #expect(router.homePath.isEmpty)
        #expect(router.browsePath.isEmpty)
        #expect(router.searchPath.isEmpty)
        #expect(router.bookmarksPath.isEmpty)
        #expect(router.settingsPath.isEmpty)
    }

    @Test("App Router navigates to shabad")
    func navigateToShabad() {
        let router = AppRouter()
        router.selectedTab = .browse
        router.navigateToShabad(123)

        #expect(router.browsePath.count == 1)
        if case .shabadReader(let id) = router.browsePath.first {
            #expect(id == 123)
        } else {
            Issue.record("Expected shabadReader route")
        }
    }

    @Test("App Router pops to root")
    func popToRoot() {
        let router = AppRouter()
        router.homePath = [.hukamnamaReader()]
        router.popToRoot()

        #expect(router.homePath.isEmpty)
    }
}
