//
//  InjectableDependency.swift
//  MentalHealth
//
//

import Foundation
import Combine
import UIKit

protocol InjectableDependency {}

struct ImageUpdatePublisher: InjectableDependency {
    let publisher: PassthroughSubject<UIImage, Never>
}
///e.g of how add more dependencies
//struct NameUpdatePublisher: InjectableDependency {
//    let publisher: PassthroughSubject<String, Never>
//}
//struct ImageUpdatePublisher: InjectableDependency {
//    let publisher: PassthroughSubject<UIImage, Never>
//}
///
