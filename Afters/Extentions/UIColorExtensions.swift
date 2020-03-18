//
//  UIColorExtensions.swift
//  HealthWatch
//
//  Created by Suyog Kolhe on 12/03/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    convenience init(rgb: UInt, withAlpha: Float) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(withAlpha)
        )
    }
    
    public func appBarColor() -> UIColor{
        return UIColor.init(rgb: 0x643596)
    }
    
    public func appPrimaryColor() -> UIColor{
        return UIColor.init(rgb: 0x542685)
    }
        
    public func appAccentButtonColor() -> UIColor{
        return UIColor.init(rgb: 0x7F83D3)
    }
    
    public func blackOverlayColor() -> UIColor{
        return UIColor.init(rgb: 0x660000)
    }
    
    public func gridBorderColor() -> UIColor{
        return UIColor.init(rgb: 0xc6e4e3)
    }
    
    public func userItemBackColor() -> UIColor{
        return UIColor.init(rgb: 0xaeefef)
    }
    
    public func primaryTextColor() -> UIColor{
        return UIColor.init(rgb: 0x2f3031)
    }
    
    public func accentTextColor() -> UIColor{
        return UIColor.init(rgb: 0xFF4081)
    }
    
    public func secondaryTextColor() -> UIColor{
        return UIColor.init(rgb: 0xd86366)
    }
    
    public func bottomStripColor() -> UIColor{
        return UIColor.init(rgb: 0x643596)
    }
    
    public func dividerColor() -> UIColor{
        return UIColor.init(rgb: 0xe0e0e0)
    }
    
    public func findPartyTabBackColor() -> UIColor{
        return UIColor.init(rgb: 0x773eb8)
    }
    
    public func hostTabBackColor() -> UIColor{
        return UIColor.init(rgb: 0x513669)
    }
    
    public func editProfTabBackColor() -> UIColor{
        return UIColor.init(rgb: 0x9a6bd1)
    }
    
    public func loginBackGroundColor() -> UIColor{
        return UIColor.init(rgb: 0x966633)
    }
    
    public func splashbackgroundColor() -> UIColor{
        return UIColor.init(rgb: 0x694387)
    }
    
    public func navBarHeaderColor() -> UIColor{
        return UIColor.init(rgb: 0x7F83D3)
    }
    
    public func chatEditTextBackColor() -> UIColor{
        return UIColor.init(rgb: 0xd4d5ef)
    }
    
    public func transparentWhiteColor() -> UIColor{
        return UIColor.init(rgb: 0x66FFFF)
    }
    
    public func layout_backgroundColor() -> UIColor{
        return UIColor.init(rgb: 0xf0f2f2)
    }
    
    public func warmGrayColor() -> UIColor{
        return UIColor.init(rgb: 0x757575)
    }
    
    public func colorUsernameRectangle() -> UIColor{
        return UIColor.init(rgb: 0x990000)
    }
    
}

extension Date {
    
    var timeInterval:Double {
        return self.timeIntervalSinceReferenceDate
    }
    
    var age:Int {
        return (Calendar.current as NSCalendar)
            .components(NSCalendar.Unit.year,
                from: self,
                to: Date(),
                options: NSCalendar.Options(rawValue: 0)).year!
    }
    
    func stringFromDate ()-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: self)
    }
    
    func localTimeStringFromDate() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }
    
    func onlyTime12HrString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.string(from: self)
    }
    
    func timeStringFromDate() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self)
    }
    
    func stringForHostFromDate ()-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        return dateFormatter.string(from: self)
    }

    func newStringFromDate ()-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: self)
    }

    static func displayDateWithTime(dateString : String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let date = dateFormatter.date(from: dateString) ?? Date()
        
        let displayFormat = DateFormatter()
        displayFormat.dateFormat = "dd/MM/yyyy hh:mm a"
        displayFormat.amSymbol = "AM"
        displayFormat.pmSymbol = "PM"
        return displayFormat.string(from: date)
    }
    
    public func newTimeStringFromDate () -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        let dateString = formatter.string(from: Date())
        print(dateString)
        return dateString
    }
    
    static func googleDateToDisplayDate(dateString : String) -> String {
//        let strDate = "2015-11-01T00:00:00Z"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = dateFormatter.date(from:dateString) ?? Date()
        
        let displayFormat = DateFormatter()
        displayFormat.dateFormat = "dd/MM/yyyy"
//        displayFormat.amSymbol = "AM"
//        displayFormat.pmSymbol = "PM"
        return displayFormat.string(from: date)
        
    }
    
    static func googleDateToDate(dateString : String) -> Date {
        //        let strDate = "2015-11-01T00:00:00Z"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = dateFormatter.date(from:dateString) ?? Date()
        return date
    }
            
    public func shortDayString ()-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        return dateFormatter.string(from: self)
    }
    
 /*   func getDayOfWeek(_ today:String)->String? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let todayDate = formatter.date(from: today) {
            let myCalendar = Calendar(identifier: Calendar.Identifier.gregorian)
            let myComponents = (myCalendar as NSCalendar).components(.weekday, from: todayDate)
            let weekDay = myComponents.weekday
            switch weekDay {
            case ?1:
                return "Sun"
            case ?2:
                return "Mon"
            case ?3:
                return "Tue"
            case ?4:
                return "Wed"
            case ?5:
                return "Thu"
            case ?6:
                return "Fri"
            case ?7:
                return "Sat"
            default:
                print("Error fetching days")
                return "Day"
            }
        } else {
            return nil
        }
    }*/

}
