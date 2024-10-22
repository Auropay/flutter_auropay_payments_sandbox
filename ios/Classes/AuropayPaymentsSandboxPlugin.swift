import Flutter
import UIKit
import AuroPayPaymentsSandbox
import Foundation


public class AuropayPaymentsSandboxPlugin: NSObject, FlutterPlugin {
    
    var result: FlutterResult?
    var showCustomerForm: Bool = false
    var getResponseWithDetail: Bool = false
    var referenceNumber: String? = nil
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "net.auropay.auropay_payments",
                                           binaryMessenger: registrar.messenger())
        let instance = AuropayPaymentsSandboxPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        self.result = result
        if (call.method == "do_payment") {
            var auropay: Auropay?
            var builder: AuroPayBuilder?
            
            if let args = call.arguments as? [String:Any]{
                let merchantId = args["subDomainId"] as! String
                let accessKey = args["accessKey"] as! String
                let secretKey = args["secretKey"] as! String
                
                showCustomerForm = args["showCustomerForm"] as! Bool
                getResponseWithDetail = args["detailedResponse"] as! Bool
                 if let referenceNumber = args["referenceNumber"] as? String {
                     self.referenceNumber = referenceNumber
                 }
                
                if let customer = args["customerProfile"] as? [String:Any]{
                    
                    builder = AuroPayBuilder()
                        .subDomainId(merchantId)
                        .accessKey(accessKey)
                        .secretKey(secretKey)
                        .customerProfile(getCustomerProfile(customer: customer))
                    
                    builder = builder?.addEventListener({(eventID, eventDesc) in
                        debugPrint("EventID: \(eventID), EventDescription: \(eventDesc)")
                        let data = ["error": eventDesc, "errorCode": eventID] as [String: Any]
                        let resp = ["type": "failure", "data": data] as [String: Any]
                        result(resp)
                    })
                    
                    if let allowCardScan = args["allowCardScan"] as? Bool {
                        builder =  builder?.allowCardScan(allowCardScan)
                    }
                    
                    if let countryStr = args["country"] as? String {
                        builder =  builder?.country(getCountry(country: countryStr))
                    }
                    
                    if let showReceipt = args["showReceipt"] as? Bool {
                        builder =  builder?.showReceipt(showReceipt)
                    }
                    
                    if let theme = args["theme"] as? [String:String] {
                        if let primaryColor = theme["primaryColor"] {
                            if let colorOnPrimary = theme["colorOnPrimary"] {
                                if let secondaryColor = theme["secondaryColor"] {
                                    if let colorOnSecondary = theme["colorOnSecondary"] {
                                        
                                        builder = builder?.theme(APTheme(
                                            primaryColor: UIColor(hexString: "#\(primaryColor)"),
                                            primaryTextColor: UIColor(hexString: "#\(colorOnPrimary)"),
                                            secondaryColor: UIColor(hexString: "#\(secondaryColor)"),
                                            secondaryTextColor: UIColor(hexString: "#\(colorOnSecondary)")))
                                        
                                    }
                                }
                            }
                        }
                    }
                    
                    auropay = builder?.build()
                    
                    
                    let viewController: UIViewController =
                    (UIApplication.shared.delegate?.window??.rootViewController)!;
                    
                    
                    
                    if getResponseWithDetail {
                                                if let auropay = auropay{
                                                    auropay.doPayment(displayViewController: viewController,
                                                                      amount: args["amount"] as! Double,
                                                                      andDelegateWithData: self,
                                                                      referenceNumber: referenceNumber, askCustomerDetails: showCustomerForm)
                                                                      }
                    } else {
                        if let auropay = auropay{
                            auropay.doPayment(displayViewController: viewController,
                                              amount: args["amount"] as! Double,
                                              andDelegate: self,
                                              referenceNumber: referenceNumber, askCustomerDetails: showCustomerForm)
                        }
                    }
                }
            }
        }
        
        func getCustomerProfile(customer: [String:Any]) -> CustomerProfile{
            let customerProfile = CustomerProfile(
                title: customer["title"] as! String,
                firstName: customer["firstName"] as! String,
                middleName: customer["middleName"] as! String,
                lastName: customer["lastName"] as! String,
                phone:customer["phone"] as! String,
                email: customer["email"] as! String)
            
            return customerProfile
        }
        
        func getCountry(country: String) -> Country {
            switch country {
            case "in":
                return .IN
            case "us":
                return .US
            default:
                return .IN
            }
        }
    }
}

    extension AuropayPaymentsSandboxPlugin: APPaymentCompletionProtocol{
        public func onPaymentSuccess(_ orderId: String, transactionStatus: Int, transactionId: String) {
            let data = ["transactionStatus": transactionStatus, "orderId": orderId, "transactionId": transactionId] as [String: Any]
            let resp = ["type": "success", "data": data] as [String: Any]
            self.result?(resp)
        }

        public func onPaymentError(_ message: String) {
            let data = ["error": message] as [String: Any]
            let resp = ["type": "failure", "data": data] as [String: Any]
            self.result?(resp)
        }
    }
    
    extension AuropayPaymentsSandboxPlugin: APPaymentCompletionProtocolWithData{
        public func onPaymentSuccess(_ paymentData: PaymentResultData) {
            let data = ["transactionStatus": 2,
                        "orderId": paymentData.orderId,
                        "transactionId": paymentData.transactionId,
                        "transactionDate": "paymentData.transactionDate",
                        "referenceNo": "paymentData.referenceNo",
                        "processMethod": 3,
                        "reasonMessage":" paymentData.reasonMessage",
                        "amount": 12.2,
                        "convenienceFee": 12.2,
                        "taxAmount": 3.3,
                        "discountAmount": 5.5,
                        "captureAmount": 2.2
            ] as [String: Any]
            let resp = ["type": "success", "data": data] as [String: Any]
            self.result?(resp)
            }

        public func onPaymentError(_ message: String, _ paymentData: PaymentResultData?) {
            let data = ["error": message] as [String: Any]
            let resp = ["type": "failure", "data": data] as [String: Any]
            self.result?(resp)
       }
    }

    extension UIColor {
        convenience init(hexString: String) {
            print(hexString)
            let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
            var int = UInt64()
            Scanner(string: hex).scanHexInt64(&int)
            let a, r, g, b: UInt64
            switch hex.count {
            case 3: // RGB (12-bit)
                (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            case 6: // RGB (24-bit)
                (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
            case 8: // ARGB (32-bit)
                (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
            default:
                (a, r, g, b) = (255, 0, 0, 0)
            }
            self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
        }
    }

