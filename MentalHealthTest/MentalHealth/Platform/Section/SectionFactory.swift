//
//  SectionFactory.swift
//  MentalHealth
//
//

import Foundation
import UIKit

public final class SectionFactory {
    private let registry = SectionRegistry()

    init() {
        // Register
        /// e.g.
        ///registry.register(QuoteSectionViewController())
        ///registry.register(QuoteSection2ViewController())
        ///registry.register(QuoteSection3ViewController())
        ///so on..
        registry.register(QuoteSectionViewController())
        registry.register(WeeklyMoodSectionViewController())
        registry.register(GridSectionViewController())
        registry.register(ChartSectionViewController())
        registry.register(MeditationSectionViewController())
    }

    //NOTE: this is main function to resolve each BaseSectionViewController
    func createSection(with identifier: SectionIdentifier) -> BaseSectionViewController? {
        return registry.resolve(with: identifier)
    }
    
    //Custom create Section function to show only one at a time
    func createSection(for identifier: SectionIdentifier) -> UIViewController? {
        switch identifier {
        case QuoteSectionViewController.identifier:
            return QuoteSectionViewController()
        default:
            return nil
        }
    }
}

#if DEBUG
extension SectionFactory {
    var testHooks: TestHooks { TestHooks(target: self) }

    struct TestHooks {
        var target: SectionFactory

        func createSection(with identifier: SectionIdentifier) -> BaseSectionViewController? {
            target.createSection(with: identifier)
        }

        func createSection(for identifier: SectionIdentifier) -> UIViewController? {
            target.createSection(for: identifier)
        }
    }
}
#endif
