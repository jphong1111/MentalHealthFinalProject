//
//  Bundle+Extension.swift
//  MentalHealth
//
//  Created by JungpyoHong on 8/8/24.
//

import Foundation

public final class MentalHealthResources {}

extension Bundle {
    static var mentalHealthBundle: Bundle {
        Bundle.moduleBundle(for: MentalHealthResources.self)
    }
    
    static var resources: Bundle {
        mentalHealthBundle
    }
}

extension Bundle {
    public static func moduleBundle(for className: AnyClass) -> Bundle! {
        let resourcePath = Bundle.mainApp.resourcePath
        guard let actualResourcePath = resourcePath,
              let moduleName = String(reflecting: className).split(separator: ".").first
        else {
            assertionFailure("Module name not found for \(className.debugDescription())")
            return nil
        }
        let bundleName = "\(moduleName)Resources.bundle"
        let bundlePath = "\(actualResourcePath)/\(bundleName)"
        guard let bundle = Bundle(path: bundlePath) ?? searchBundles(for: bundleName) else {
            //Note: Any Unit testing resource can be add it here
            assertionFailure("Bundle not found at \(bundlePath) for class \(className.debugDescription())")
            return nil
        }
        return bundle
    }
}

extension Bundle {
    private class var mainApp: Bundle {
        let main = Bundle.main
        let components = main.resourceURL!.pathComponents
        let mainAppName = components.first(where: { $0.contains(".app")} )
        let mainAppPathIndex = components.firstIndex(where: { $0 == mainAppName} )!
        
        return Bundle(path: components[...mainAppPathIndex].joined(separator: "/"))!
    }
    
    private static func searchBundles(for bundleName: String) -> Bundle? {
        bundleSearchArea
            .first(where: { (try? FileManager.default.contentsOfDirectory(atPath: $0).contains(bundleName)) ?? false })
            .flatMap { Bundle(path: "\($0)/\(bundleName)")}
    }
    
    private static let bundleSearchArea: [String] = [
        [Bundle.main.resourcePath],
        Bundle.allBundles.map(\.resourcePath)
    ].flatMap( { $0 }).compactMap( { $0 })
}

#if DEBUG
extension MentalHealthResources {
    var testHooks: TestHooks { .init(target: self) }

    struct TestHooks {
        var target: MentalHealthResources

    }
}
#endif