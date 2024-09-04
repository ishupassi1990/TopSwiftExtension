//
//  TopSwiftExtension.swift
//  TopSwiftExtension
//
//  Created by Ishu Passi on 04/09/24.
//

import Foundation
import UIKit

// #1: CREATE A COLOR WITH A HEX CODE
extension UIColor {
    public convenience init(string hex: String) {
        
        // DO SOME BASIC CLEANING
        var colorString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        // REMOVE THE # IF PRESENT
        if (colorString.hasPrefix("#")) {
            colorString.remove(at: colorString.startIndex)
        }
        
        // GUARANTEE 6 DIGITS
        if ((colorString.characters.count) != 6) {
            self.init(white: 0.5, alpha: 1.0)
        } else {
            
            // CONVERT
            var rgbValue:UInt32 = 0
            Scanner(string: colorString).scanHexInt32(&rgbValue)
            
            //INSTANCIATE
            self.init(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0)
            )
        }
    }
}

// #2: TRANSFORM A DATE INTO A STRING
extension Date{
    func toString(format:String = "MMMM dd yyyy") -> String {
        
        // SIMPLE US OF THE DATEFORMATTER HERE WITH A DEFAULT STRING RETURN PATTERN
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}


public extension NSObject {

    // #3: SHOW A SIMPLE ALERT MESSAGE FROM ANY VIEWCONTROLLER OR OBJECT
    func showMessage(with title: String, and body: String) {
        if(UIApplication.shared.applicationState == .active) {
            // IF THE APP IS ACTIVE, IT HAS AN UIVIEWCONTROLLER, LET SHOW USE IT FOR DISPLAYING THE MESSAGE
            if let vc =  UIApplication.shared.windows.first!.rootViewController {
                let alert = UIAlertController(title: title, message:body, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in })
                vc.present(alert, animated: true){}
            }
        } else {
            // ELSE, IF THE APP IS IN BACKGROUND, LET'S TRY TO ISSUE A LOCAL NOTIFICATION
            let localNotification:UILocalNotification = UILocalNotification()
            localNotification.alertAction = title
            localNotification.alertBody = body
            localNotification.fireDate = Date()
            UIApplication.shared.scheduleLocalNotification(localNotification)
        }
    }
    
    // #4: GET THE NEXT AVAILABLE PARENT VIEWCONTROLLER FROM AN OBJECT
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self as? UIResponder
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

public extension UIView {
    // #5: QUICKLY INSTANTIATE AN UIVIEW FROM A NIB / XIB FILE
    class func load(nib name: String) -> UIView? {
        return UINib(
            nibName: name,
            bundle: Bundle.main
            ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
    
    // #6: QUICKLY CREATE A SNAPSHOT OF A UIVIEWCONTROLLER AS A UIIMAGE
    func snapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

// #7: MISSING STRING FUNCTIONS THAT EVERYONE SHOULD HAVE IN A SIMPLIFIED WAY
extension String {

    // ACCESS LOCALIZED STRING
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    // CONVERT ANY STRING INTO BASE64
    func toBase64() -> String? {
        let data = self.data(using: String.Encoding.utf8)
        return data?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
    }
    
    // ENCODE STRING TO SEND AS A QUERYSTRING IN AN URL
    func enconde() -> String{
        let customAllowedSet =  CharacterSet(charactersIn:"=\"#%/<>?@\\^`{|}&").inverted
        let escapedString = self.addingPercentEncoding(withAllowedCharacters: customAllowedSet)
        return escapedString ?? ""
    }
    
    // REMOVE HTML CODE FROM A STRING
    func removeHtml() -> String{
        let str = self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        return str
    }
    
    // CONVERT A STRING INTO A DATE GIVEN A CERTAIN FORMAT
    func toDate(format:String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date ?? Date()
    }
}

// #8: REMOVE AN OBJECT FROM AN ARRAY
extension Array where Element: Equatable {
    mutating func remove(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}
