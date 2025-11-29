//
//  SectionHeightResolver.swift
//  MentalHealth
//
//
import UIKit

public struct SectionHeightResolver {
    static func height(for identifier: SectionIdentifier) -> CGFloat {
        switch identifier {
        case GridSectionViewController.identifier:
            return (UIScreen.main.bounds.width - 40) / 2
        case ChartSectionViewController.identifier:
            return 240
        case QuoteSectionViewController.identifier:
            return 130
        case WeeklyMoodSectionViewController.identifier:
            return 130
        case MeditationSectionViewController.identifier:
            return 130
        default:
            return 130 // fallback default
        }
    }
}
