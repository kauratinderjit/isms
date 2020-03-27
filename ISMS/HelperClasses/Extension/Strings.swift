//
//  Strings.swift
//  LatestArchitechtureDemo
//
//  Created by Atinder Kaur on 5/23/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation


extension String {
    
    //MARK:- Check Password Complexity
    func isPasswordValid() -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[0-9])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: self)
    }
    
    //MARK: Check the provided email is valid or not
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    //MARK:- Convert String Into Double
    func toDouble() -> Double?
    {
        return Double.init(self)
    }
    
    //MARK:- Convert String Into Float
    func toFloat() -> Float?
    {
        return Float.init(self)
    }
    
    //MARK:- Check provided url is valid url or not
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.endIndex.encodedOffset)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.endIndex.encodedOffset
        } else {
            return false
        }
    }
    
    //Check the min name length
    var nameMinLength : Bool
    {
        if self.count>1
        {
            return true
        }
        return false
    }
    
    //Check password minimum length
    var passwordMinLength : Bool
    {
        if self.count>7
        {
            return true
        }
        return false
    }
    
    
    
    //Check Password Minimum Complexity
    func checkTextSufficientComplexity() -> Bool{
        
        
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = texttest.evaluate(with: self)
        print("\(capitalresult)")
        
        
        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let numberresult = texttest1.evaluate(with: self)
        print("\(numberresult)")
        //
        //          let specialSymbolRegEx  =   ".*[^A-Za-z0-9].*"
        //        let texttest2 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        //        let specialSymbolresult = texttest1.evaluate(with: self)
        //        print("\(numberresult)")
        
        
        let specialCharacterRegEx  = ".*[!&^%$#@()/]+.*"
        let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        let specialSymbolresult = texttest2.evaluate(with: self)
        print("\(numberresult)")
        //  let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        
        //    let specialresult = texttest2.evaluate(with: text)
        //       print("\(specialresult)")
        
        // return capitalresult || numberresult || specialresult
        return capitalresult && numberresult && specialSymbolresult
        
    }
    
    func safelyLimitedTo(length n: Int)->String {
        if (self.count <= n) {
            return self
        }
        return String( Array(self).prefix(upTo: n) )
    }
    
    //MARK:- Check it is phone number or not
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    var isNumber: Bool {
        let characters = CharacterSet.decimalDigits.inverted
        return !self.isEmpty && rangeOfCharacter(from: characters) == nil
    }
    
    
}
