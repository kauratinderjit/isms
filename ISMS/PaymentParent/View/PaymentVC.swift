//
//  PaymentVC.swift
//  ISMS
//
//  Created by Poonam  on 17/08/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import UIKit
import PayUMoneyCoreSDK
import PlugNPlay
import CryptoSwift

class PaymentVC: BaseUIViewController {
    var merchantKey = "7001862"
    var salt = "hlAIVpWKGy"
    var PayUBaseUrl = "https://test.payu.in"
    @IBOutlet weak var btnPayment: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackButton()
        self.title = "Payment"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionPaymentBtn(_ sender: Any) {
        makePayment()
    }
    
    func makePayment()
    {
        let txnsID = self.generateRandomString()
        PlugNPlay .setMerchantDisplayName("Payment")
        
        //Customize UI of PayuMoney
        
        PlugNPlay .setButtonTextColor(UIColor.white)
        PlugNPlay .setButtonColor(UIColor(red: 75, green: 190, blue: 248, alpha: 0.5))
        PlugNPlay .setTopTitleTextColor(UIColor.white)
        PlugNPlay .setTopBarColor(UIColor(red: 75, green: 190, blue: 248, alpha: 0.5))
        PlugNPlay .setDisableCompletionScreen(true)
        PlugNPlay.setExitAlertOnBankPageDisabled(true)
        PlugNPlay.setExitAlertOnCheckoutPageDisabled(true)
        
        let txnParam = PUMTxnParam()
        txnParam.phone = "9992364445"
        txnParam.email = "cerebrumdev3@gmail.com"
        txnParam.amount = "2050"
        //txnParam.amount = "1"
        txnParam.environment = PUMEnvironment.test
        //txnParam.environment = PUMEnvironment.production
        txnParam.firstname = "userName"
        txnParam.key = "vnlMA5F0"
        txnParam.merchantid = "7001862"
        txnParam.txnID = txnsID
        txnParam.surl = "https://www.payumoney.com/mobileapp/payumoney/success.php"
        txnParam.furl = "https://www.payumoney.com/mobileapp/payumoney/failure.php"
        txnParam.productInfo = "kAppName"
        txnParam.udf1 = "as"
        txnParam.udf2 = "sad"
        txnParam.udf3 = "ud3"
        txnParam.udf4 = ""
        txnParam.udf5 = ""
        txnParam.udf6 = ""
        txnParam.udf7 = ""
        txnParam.udf8 = ""
        txnParam.udf9 = ""
        txnParam.udf10 = ""
        
        
        let hashSequence = "\(txnParam.key!)|\(txnParam.txnID!)|\(txnParam.amount!)|\(txnParam.productInfo! )|\(txnParam.firstname!)|\(txnParam.email!)|\(txnParam.udf1!)|\(txnParam.udf2!)|\(txnParam.udf3!)|\(txnParam.udf4!)|\(txnParam.udf5!)|\(txnParam.udf6!)|\(txnParam.udf7!)|\(txnParam.udf8!)|\(txnParam.udf9!)|\(txnParam.udf10!)|\(salt)"
        
        let data = hashSequence.data(using: .utf8)
        
        txnParam.hashValue = data?.sha512().toHexString()
        
        
        PlugNPlay.presentPaymentViewController(withTxnParams: txnParam, on: self)
        { (response, error, extraParam) in
            
            
            if (response != nil)
            {
                if let dict : Dictionary = response
                {
                    print(dict)
                    
                    let result = dict["result"]as? NSDictionary
                    let status  = result?.value(forKey: "status")as? String
                    let payMode  = result?.value(forKey: "mode")as? String
                    let errmsg = result?.value(forKey: "error_Message")as? String ?? "Unknown error occurred!"
                    let trscnID = "\(result?.value(forKey: "paymentId")as? Int ?? 0)"
                    
                    if (status == "success")
                    {
//                        self.viewModel?.updatePaymentStatus(transactionID: trscnID, paymentMODE: payMode ?? "", Status: "1", orderID: self.orderID, Amount: self.finalPriceTOTAL)
                    }
                    else
                    {
                        // let reason = self.get_transaction_failed_reason(dicnry: result ?? NSDictionary())
//                        self.showToastSwift(alrtType: .error, msg: errmsg, title: "kFailed")
//                        self.showAlert(Message: errmsg)
                        
                        // self.viewModel?.updatePaymentStatus(transactionID: trscnID, paymentMODE: payMode ?? "", Status: "2", orderID: self.orderID, Amount: self.finalPRICE)
                    }
                }
                else
                {
//                    self.showToastSwift(alrtType: .error, msg: kSomthingWrong, title: kOops)
//                    self.showAlert(Message: "errmsg")
                    // self.viewModel?.updatePaymentStatus(transactionID: trscnID, paymentMODE: self.payMode, Status: "2", orderID: self.orderID, Amount: self.finalPRICE)
                }
            }
            else
            {
//                self.showToastSwift(alrtType: .error, msg: error?.localizedDescription ?? "Payment failed!", title: kFailed)
//                 self.showAlert(Message: "errmsg")
                //  self.viewModel?.updatePaymentStatus(transactionID: "", paymentMODE: self.payMode, Status: "1", orderID: self.orderID, Amount: self.finalPRICE)
            }
            
        }
        
    }
    
    func generateRandomString() -> String
    {
        let letters : NSString = "0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< 10
        {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
}
