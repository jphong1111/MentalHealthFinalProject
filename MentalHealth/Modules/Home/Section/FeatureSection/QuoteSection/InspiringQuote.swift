//
//  InspiringQuote.swift
//  MentalHealth
//
//  Created by JungpyoHong on 4/29/24.
//

import Foundation

struct QuoteData: Codable {
    let quoteData: [Quote]
}

struct Quote: Codable {
    let quote: String
    let name: String
}

func getRandomQuote() -> Quote? {
    let languageCode = SoliULanguageManager.shared.currentLanguage
    let fileName = languageCode == "en" ? "InspiringQuote_en" : "InspiringQuote_ko"
    
    guard let fileURL = Bundle.mentalHealthBundle.url(forResource: fileName, withExtension: "json") else {
        print("JSON file not found")
        return nil
    }

    do {
        let jsonData = try Data(contentsOf: fileURL)
        let decoder = JSONDecoder()
        let quoteData = try decoder.decode(QuoteData.self, from: jsonData)

        guard !quoteData.quoteData.isEmpty else {
            print("quoteData array is empty")
            return nil
        }

        return quoteData.quoteData.randomElement()
    } catch {
        print("Error decoding JSON: \(error)")
        return nil
    }
}

