//
//  XCUIElement+Extension.swift
//  MentalHealth
//
//  Created by JungpyoHong on 4/2/25.
//

import XCTest
import Foundation
import Combine

extension TimeInterval {
    #if IS_CI
    public static let defaultWait: TimeInterval = 30.0
    #else
    public static let defaultWait: TimeInterval = 5.0
    #endif
    public static let defaultNonWait: TimeInterval = 0.1
}

extension XCUIElement {
    public func swipeUpUntilElementFound () -> Bool {
        return true
    }
    
    public func waitForExistence(timeout: TimeInterval, scrollingFrom fromElement: XCUIElement) -> Bool {
        let found = exists || waitForExistence(timeout: timeout)
        if !isHittable {
            return fromElement.swipeUpUntilElementFound()
        }
        return found
    }
    
    public func waitForExistence() -> Bool {
        exists || waitForExistence(timeout: .defaultWait)
    }
}

public enum WaitError: Error {
    case timeout
    case nilvalue
    case waiterfailure(XCTWaiter.Result)
    case mismatchedValueCount
}

extension XCTestCase {
    public func waitForCondition(
        _ condition: @autoclosure () async throws -> Bool,
        timeout: TimeInterval = .defaultWait
    ) async throws {
        let start = Date()
        while try await !condition() {
            if Date().timeIntervalSince(start) > timeout {
                throw WaitError.timeout
            }
            try await Task.sleep(nanoseconds: 100_000_000)
        }
    }
    
    public func waitForValue<P: Publisher>(
        _ publisher: P,
        timeout: TimeInterval = .defaultWait,
        message: String = "",
        file: StaticString = #file,
        line: UInt = #line,
        _ work: () throws -> Void = {}
    ) throws -> P.Output {
        do {
            let values = try waitForValues(
                publisher,
                expectedCount: 1,
                timeout: timeout,
                message: message,
                file: file,
                line: line,
                work
            )
            guard let value = values.first else {
                throw WaitError.nilvalue
            }
            return value
        } catch {
            throw error
        }
    }
    
    public func waitForValues<P: Publisher>(
        _ publisher: P,
        expectedCount: Int,
        timeout: TimeInterval = .defaultWait,
        message: String = "",
        file: StaticString = #file,
        line: UInt = #line,
        _ work: () throws -> Void = {}
    ) throws -> [P.Output] {
        var values = [P.Output]()
        var error: P.Failure?
        
        let expectation = expectation(description: "wait for values: \(message)")
        expectation.expectedFulfillmentCount = expectedCount
        
        var fulfilledCount = 0
        
        let task = publisher.sink(receiveCompletion: { completion in
            guard case .failure(let failure) = completion else {
                while fulfilledCount < expectedCount {
                    expectation.fulfill()
                    fulfilledCount += 1
                }
                return
            }
            error = failure
            expectation.fulfill()
            fulfilledCount += 1
        }, receiveValue: {
            values.append($0)
            expectation.fulfill()
            fulfilledCount += 1
        })
        
        try work()
        
        do {
            try withExtendedLifetime(task) {
                try waitThrows(for: [expectation], timeout: timeout)
            }
            if let foundError = error {
                throw foundError
            }
            if values.count < expectedCount {
                throw WaitError.mismatchedValueCount
            }
            return values
        } catch let waitError {
            if let foundError = error {
                throw foundError
            }
            throw waitError
        }
    }

    public func waitThrows(
        for expectation: [XCTestExpectation],
        timeout: TimeInterval = .defaultWait,
        enforceOrder: Bool = false
    ) throws {
        try XCTWaiter.waitThrows(for: expectation, timeout: timeout, enforceOrder: enforceOrder)
    }
}

extension XCTWaiter {
    public static func waitThrows(
        for expectations: [XCTestExpectation],
        timeout: TimeInterval = .defaultWait,
        enforceOrder: Bool = false
    ) throws {
        let waitResult = wait(for: expectations, timeout: timeout, enforceOrder: enforceOrder)
        switch waitResult {
        case .completed:
            break
        case .timedOut:
            throw WaitError.timeout
        default:
            throw WaitError.waiterfailure(waitResult)
        }
    }
}
