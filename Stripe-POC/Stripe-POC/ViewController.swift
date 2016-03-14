//
//  ViewController.swift
//  Stripe-POC
//
//  Created by Rohit Singh on 20/01/16.
//  Copyright © 2016 Home. All rights reserved.
//

/*
Important Links:

https://stripe.com/docs/mobile/ios#custom-form

www.appcoda.com/ios-stripe-payment-integration/ 

https://github.com/stripe/stripe-ios

http://rshankar.com/implementing-stripe-integration-in-swift/

*/

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var btnPay: UIButton!
    
    @IBOutlet var txtCardNumber: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtCVV: UITextField!
    @IBOutlet var txtDate: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtCardNumber.text = "4242424242424242"
        self.txtEmail.text = "s@s.com"
        self.txtDate.text = "11/2020"
        self.txtCVV.text = "123"
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tapPay(sender: UIButton) {
        
        let stripeCard : STPCard = STPCard()
        
        if self.txtDate.text?.isEmpty == false {
            var strDate = self.txtDate.text?.componentsSeparatedByString("/")
            let month = UInt(strDate![0])!
            let year = UInt(strDate![1])!
            
            stripeCard.number = self.txtCardNumber.text
            stripeCard.expMonth = month
            stripeCard.expYear = year
            stripeCard.cvc = self.txtCVV.text
            
            do {
                try stripeCard.validateCardReturningError()
                STPAPIClient.sharedClient().createTokenWithCard(
                    stripeCard,
                    completion: { (token: STPToken?, stripeError: NSError?) -> Void in
                        self.postStripeToken(token!)
                        
                        
                })
            } catch {
                print("There was an error.")
            }

            

        }
    }
    
    func postStripeToken(token: STPToken) {
        
        let URL = "http://zabius.com/stripe/stripe/payment.php"
        let params = ["stripeToken": token.tokenId,
            "amount": 100,
            "currency": "usd",
            "description": self.txtEmail.text!]
        
        let manager = AFHTTPRequestOperationManager()
        manager.POST(URL, parameters: params, success: { (operation, responseObject) -> Void in
            
            if let response = responseObject as? [String: String] {
                UIAlertView(title: response["status"],
                    message: response["message"],
                    delegate: nil,
                    cancelButtonTitle: "OK").show()
            }
            
            }) { (operation, error) -> Void in
                
                print(error.localizedDescription)
        }
    }
    
    
    
    @IBAction func tapNext(sender: UIButton) {
        self.openSettings()
    }
    
    
    func openSettings()
    {
           UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        
    }
    
    
    
    
    
    
    
    
    
    

}

