//
//  CustomAssertions.swift
//  MentalHealth
//
//  Created by JungpyoHong on 6/5/25.
//

import XCTest

// Verifies that collection view cell is ecptected type, and returns it.
// Upon failure, reports the actual type of the cell.
@discardableResult
func verifyCell<Cell>(
    actual: UICollectionViewCell?,
    expectedType: Cell.Type,
    file: StaticString = #filePath,
    line: UInt = #line
) -> Cell? {
    guard let typeCell = actual as? Cell else {
        XCTFail("Expected cell of type \(Cell.self), but got \(String(describing: actual))", file: file, line: line)
        return nil
    }
    return typeCell
}

//Having looked up a value in a disctionary, verifies that it is of the expected type.
func verifyEqual<T: Equatable>(
    _ actual: Any?, expected: T,
    file: StaticString = #filePath
    , line: UInt = #line
) {
    guard let unwrappedActual = actual else {
        XCTFail("Expected value of type \(T.self), but got nil", file: file, line: line)
        return
    }
    guard let actualValue = unwrappedActual as? T else {
        XCTFail("Expected value of type \(T.self), but got \(type(of: actual))", file: file, line: line)
        return
    }
    XCTAssertEqual(actualValue, expected, file: file, line: line)
}
