//
//  User.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/08.
//

import SwiftUI
import CoreLocation

struct Player:Hashable {
    enum CaptureStatus:String {
        case escaping = "逃走中"
        case tracking = "追跡中"
        case captured = "確保済"
        case hiding = "潜伏中"
    }
    
    enum Role:String {
        case killer = "鬼"
        case fugitive = "逃走者"
    }
    
    enum CommunicationStatus:String {
        case online = "オンライン"
        case returning = "復帰中"
    }
    // これはなに？
    var uid: String?
    // ユーザID
    let id = UUID().uuidString
    // プレイヤー名
    var name: String = "プレイヤー"
    // 緯度
    var latitude: CLLocationDegrees?
    // 経度
    var longitude: CLLocationDegrees?
    // 通信状況
    var onlineStatus: CommunicationStatus = .online
    // 確保状態
    var captureState: CaptureStatus = .escaping
    // 役割
    var role: Role = .fugitive
    // アイテム
    var items:[Item] = []
    
    init() {
        // なにもしない
    }
    
    //失敗可能イニシャライザ(DB不整合時)
    init?(id:String, src:[String:String]){
        self.id = id
        self.name = src["playername"]!
//        self.latitude = src["latitude"]!
//        self.longitude = src["longitude"]!
        self.onlineStatus = Player.CommunicationStatus(rawValue: src["onlineStatus"]!)!
        self.captureState = Player.CaptureStatus(rawValue: src["captureState"]!)!
        self.role = Player.Role(rawValue: src["role"]!)!
    }
    
    func toDictionary() -> [String:String] {
        return ["playername": name,
//                "latitude": latitude!.debugDescription,
//                "longitude": longitude!.description,
                "onlinestatus": onlineStatus.rawValue,
                "captureState": captureState.rawValue,
                "role": role.rawValue
        ]
    }
}
