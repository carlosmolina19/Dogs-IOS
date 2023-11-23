import Foundation
import iOSSnapshotTestCase
import SwiftUI
import XCTest

@testable import Dogs_IOS

final class DogsListViewSnapshotTests: FBSnapshotTestCase {

    // MARK: - Typealias

    private typealias SUT = DogsListView

    // MARK: - Private Properties

    private var sut: SUT<DogListViewModelPreview>!
    private var mockViewModel: DogListViewModelPreview!
    private var viewController: UIViewController!

    // MARK: - Lifecycle

    override func setUp() {
        super.setUp()

        fileNameOptions = [.OS, .device, .screenScale]

        mockViewModel = .init()
        sut = SUT(viewModel: mockViewModel)

        self.viewController = UIHostingController(rootView: sut)
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = self.viewController
        window.makeKeyAndVisible()
    }

    override func tearDown() {
        super.tearDown()

        sut = nil
        viewController = nil
    }

    // MARK: - Tests

    func test_init_shouldBeEqualToSnapshot() {

        FBSnapshotVerifyViewController(viewController)
    }
}
