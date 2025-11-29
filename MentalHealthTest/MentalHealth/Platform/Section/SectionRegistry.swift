//
//  SectionRegistry.swift
//  MentalHealth
//
//

import Foundation
import UIKit

public enum SectionIdentifier: String, CaseIterable {
    case quote
    case weeklyMood
    case grid
    case chart
    case meditation

    //GridSection
    case aiCounselor
    case selfTest

    var isGridTile: Bool {
        switch self {
        case .aiCounselor, .selfTest:
            return true
        default:
            return false
        }
    }
}

public struct GridTile {
    public let title: String
    public let imageName: String
    public let onTap: (_ parent: UIViewController) -> Void
}

final class GridTileRegistry {
    private var tiles: [SectionIdentifier: GridTile] = [:]

    func register(tile: GridTile, for id: SectionIdentifier) {
        precondition(id.isGridTile, "Only grid-tile identifiers can be registered here.")
        precondition(tiles[id] == nil, "GridTile \(id) already registered.")
        tiles[id] = tile
    }

    func tile(for id: SectionIdentifier) -> GridTile {
        guard let t = tiles[id] else {
            fatalError("GridTile for \(id) not registered.")
        }
        return t
    }
}

/// This Protocol will get id for each section component
protocol SectionRegisterable {
    static var identifier: SectionIdentifier { get }
}

///
/// Register - Register Each Section ViewController into internal dependencies. After registering the viewController, you can use it for resolution.
/// Resolve - Resolve function will be only possible when the Section is registered.
///
/// Note: Section means each view controller component
final class SectionRegistry {
    private var dependencies: [SectionIdentifier: BaseSectionViewController] = [:]

    func register<T: BaseSectionViewController & SectionRegisterable>(_ viewController: T) {
        precondition(dependencies[T.identifier] == nil, "Section with \(T.identifier) is already registered.")
        dependencies[T.identifier] = viewController
    }

    func resolve<T: BaseSectionViewController & SectionRegisterable>() -> T {
        guard let viewController = dependencies[T.identifier] as? T else {
            fatalError("Section with identifier \(T.identifier) is not registered. Ensure that the viewController is registered before resolving.")
        }
        return viewController
    }

    func resolve(with identifier: SectionIdentifier) -> BaseSectionViewController? {
        return dependencies[identifier]
    }

    func registerPlaceholder(_ viewController: BaseSectionViewController, identifier: SectionIdentifier) {
        precondition(dependencies[identifier] == nil, "Section with identifier \(identifier) is already registered.")
        dependencies[identifier] = viewController
    }

    func resolvePlaceholder(with identifier: SectionIdentifier) -> BaseSectionViewController {
        guard let viewController = dependencies[identifier] else {
            fatalError("Placeholder viewController with identifier \(identifier) is not registered. Ensure that the placeholder is registered before resolving.")
        }
        return viewController
    }

    func unregister(for identifier: SectionIdentifier) {
        dependencies.removeValue(forKey: identifier)
    }
}

#if DEBUG
extension SectionRegistry {
    var testHooks: TestHooks { TestHooks(target: self) }

    struct TestHooks {
        var target: SectionRegistry

        var dependencies: [SectionIdentifier: BaseSectionViewController] { target.dependencies }

        func resolve(with identifier: SectionIdentifier) -> BaseSectionViewController? {
            target.resolve(with: identifier)
        }

        func registerPlaceholder(_ viewController: BaseSectionViewController, identifier: SectionIdentifier) {
            target.registerPlaceholder(viewController, identifier: identifier)
        }

        func resolvePlaceholder(with identifier: SectionIdentifier) -> BaseSectionViewController {
            target.resolvePlaceholder(with: identifier)
        }

        func unregister(for identifier: SectionIdentifier) {
            target.unregister(for: identifier)
        }
    }
}
#endif
