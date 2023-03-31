//
//  util.swift
//  IOSDemo
//
//  Created by EP_NonFunc on 2023/03/28.
//

import Foundation

func formatDateHelper(date: Date) -> Date{
    return Calendar.current.date(bySettingHour: 9, minute: 00, second: 0, of: date)!
}

func addMoreDate(date: Date, number: Int) -> Date{
    return Calendar.current.date(byAdding: .day, value: number, to: date)!
}

func numberOfDaysBetween(start: Date, end: Date) -> Int{
    return Calendar.current.dateComponents([.day], from: start, to: end).day!
}
