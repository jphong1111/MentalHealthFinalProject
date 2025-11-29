//
//  SectionRegistryTests.swift
//  MentalHealth
//
//  Created by JungpyoHong on 6/5/25.
//

//import XCTest
//@testable import MentalHealth
//
//final class SectionRegistryTests: XCTestCase {
//    var registry: SectionRegistry!
//
//    override func setUp() {
//        super.setUp()
//        registry = SectionRegistry()
//    }
//
//    override func tearDownWithError() {
//        registry = nil
//        super.tearDownWithError()
//    }
//
//    func test_registerAndResolve_success() {
//        // Given
//        let dummyVC = DummySectionViewController()
//
//        // When
//        registry.register(dummyVC)
//
//        // Then
//        let resolvedVC = registry.resolve(with: DummySectionViewController.identifier)
//        XCTAssertNotNil(resolvedVC)
//        XCTAssertTrue(resolvedVC is DummySectionViewController)
//    }
//
//    func test_register_duplicate_shouldFail() {
//        // Given
//        let dummyVC1 = DummySectionViewController()
//        let dummyVC2 = DummySectionViewController()
//
//        registry.register(dummyVC1)
//
//        // When / Then
//        XCTAssertThrowsError(try {
//            registry.register(dummyVC2)
//        }(), "Expected duplicate registration to throw error")
//    }
//
//    func test_resolve_unregisteredIdentifier_returnsNil() {
//        // Given
//        let unresolved = registry.resolve(with: "UnregisteredIdentifier")
//
//        // Then
//        XCTAssertNil(unresolved)
//    }
//
//    func test_unregister_removesSection() {
//        // Given
//        let dummyVC = DummySectionViewController()
//        registry.register(dummyVC)
//        XCTAssertNotNil(registry.resolve(with: DummySectionViewController.identifier))
//
//        // When
//        registry.unregister(for: DummySectionViewController.identifier)
//
//        // Then
//        let resolved = registry.resolve(with: DummySectionViewController.identifier)
//        XCTAssertNil(resolved)
//    }
//
//    func test_registerPlaceholder_and_resolvePlaceholder_success() {
//        // Given
//        let dummyVC = DummySectionViewController()
//        let id = "PlaceholderID"
//
//        // When
//        registry.registerPlaceholder(dummyVC, identifier: id)
//        let resolved = registry.resolvePlaceholder(with: id)
//
//        // Then
//        XCTAssertEqual(resolved, dummyVC)
//    }
//
//    func test_resolvePlaceholder_notRegistered_fatalError() {
//        // Given
//        let id = "UnregisteredPlaceholderID"
//
//        // Then (expecting crash, so we mark this as intentionally skipped in normal XCTest)
//        // For real apps, you'd wrap this in expectation + assertFailure via custom fatalError handler.
//    }
//}
//
//final class DummySectionViewController: BaseSectionViewController, SectionRegisterable {
//    static var identifier: SectionIdentifier = "DummySection"
//}
