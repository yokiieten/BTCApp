//
//  ShowBTCViewModel.swift
//  BTCApp
//
//  Created by Sahassawat on 5/6/2566 BE.
//

import Foundation

struct BtcData: Codable {
    let time: Time
    let disclaimer: String
    let chartName: String
    let bpi: Bpi

    struct Time: Codable {
        let updated: String
        let updatedISO: String
        let updateduk: String
    }

    struct Bpi: Codable {
        let usd: Currency
        let gbp: Currency
        let eur: Currency
        
        enum CodingKeys: String, CodingKey {
            case usd = "USD"
            case gbp = "GBP"
            case eur = "EUR"
        }

        struct Currency: Codable {
            let code: String
            let symbol: String
            let rate: String
            let description: String
            let rateFloat: Float

            enum CodingKeys: String, CodingKey {
                case code, symbol, rate, description
                case rateFloat = "rate_float"
            }
        }
    }
}

import UIKit

class BtcViewModel {
    var btcData: BtcData? {
        didSet {
            // เมื่อราคาถูกอัปเดต แจ้งให้ Controller ทราบ
            DispatchQueue.main.async {
                self.didUpdatePrice?()
            }
        }
    }
    var updateTimer: Timer?
    var didUpdatePrice: (() -> Void)?

     func fetchData() {
        guard let url = URL(string: "https://api.coindesk.com/v1/bpi/currentprice.json") else {
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data else {
                print("No data available: \(error?.localizedDescription ?? "")")
                return
            }
            
            DispatchQueue.main.async {
                self?.btcData = self?.parseData(data: data)
            }
        }.resume()
    }

    private func parseData(data: Data) -> BtcData? {
        do {
            let decoder = JSONDecoder()
            let btcData = try decoder.decode(BtcData.self, from: data)
            return btcData
        } catch {
            print("Error parsing data: \(error)")
            return nil
        }
    }

    private func startAutoUpdate() {
        updateTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.fetchData()
        }
    }

    func stopAutoUpdate() {
        updateTimer?.invalidate()
        updateTimer = nil
    }
}