//
//  Room.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/08.
//
import SwiftUI

// ルームモデル
class Room {
    enum GameStatus:String {
        case wating = "wating"
        case playing = "playing"
        case stoping = "stoping"
        case finished = "finished"
    }
    // ルームのID
    let id:String = UUID().uuidString
    // ルーム名
    var name:String
    // 参加者
    var players: [Player] = []
    // ゲーム状態
    var gameStatus:GameStatus = .wating
    // ホスト
    var host:Player
    // 自分自身
    var me:Player
    // 位置情報
    var point:Position?
    // ルール
    var rule:Rule = Rule()
    // ゲーム開始時刻
    var startTime:String?
    
    // ルーム作成時
    init(name:String, host:Player) {
        self.name = name
        self.players.append(host)
        self.host = host
        self.me = host
    }
    
    func getStartTime() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        let startTime = dateFormatter.string(from: date)
        self.startTime = startTime
        return startTime
    }
}
// ゲームルール
class Rule {
    
    // 捕獲範囲(m)
    private var _killerCaptureRange:String = "10"
    var killerCaptureRange:Int {
        set {
            let value = newValue + 1
            self._killerCaptureRange = String(value)
        }
        get {
            return Int(_killerCaptureRange)!
        }
    }
    
    // 送信間隔(分)
    private var _survivorPositionTransmissionInterval:String = "2"
    var survivorPositionTransmissionInterval:Int{
        set {
            let value = newValue + 1
            self._survivorPositionTransmissionInterval = String(value)
        }
        get {
            return Int(_survivorPositionTransmissionInterval)!
        }
    }
    
    // 逃走時間(分)
    private var _escapeTime:String = "2"
    var escapeTime:Int {
        set {
            let value = newValue + 1
            self._escapeTime = String(value)
        }
        get {
            return Int(_escapeTime)!
        }
    }
    
    // 制限時間(分)
    private var _time:String = "59"
    var time:Int {
        get {
            return Int(_time)!
        }
    }
    // 制限時間変換用
    func toTime(hour:Int, minute:Int) {
        let time = hour * 60 + (minute + 1)
        self._time = String(time)
    }
    
    // 捕獲範囲(m)
    private var _escapeRange:String = "39"
    var escapeRange:Int {
        set {
            let value = (newValue + 1) * 10
            self._escapeTime = String(value)
        }
        get {
            return Int(_escapeTime)!
        }
    }
    
    init() {
        //なにもしない
    }
    
    //失敗可能イニシャライザ(DB不整合時)
    init?(src:[String:String]){
        self._time = src["timelimit"]!
        self._killerCaptureRange = src["killerCaptureRange"]!
        self._survivorPositionTransmissionInterval = src["survivorPositionTransmissionInterval"]!
        self._escapeTime = src["escapeTime"]!
        self._escapeRange = src["escapeRange"]!
    }
    
    func toDictionary() -> [String:String] {
        return ["timelimit": _time,
                "killerCaptureRange": _killerCaptureRange,
                "survivorPositionTransmissionInterval": _survivorPositionTransmissionInterval,
                "escapeTime": _escapeTime,
                //                "hour": hour),
                //                "minute": minute + 1),
                "escapeRange": _escapeRange,
                //                "roomLatitude": roomLatitude,
                //                "roomLongitude": roomLongitude
        ]
    }
}
// 位置情報を保持
class Position {
    // 緯度
    let roomLatitude:String
    // 経度
    let roomLongitude:String
    
    init(latitude:String,longitude:String) {
        self.roomLatitude = latitude
        self.roomLongitude = longitude
    }
    
    // 失敗可能イニシャライザ(DB不整合時)
    init?(src:[String:String]){
        self.roomLatitude = src["roomLatitude"]!
        self.roomLongitude = src["roomLongitude"]!
    }
    
    func toDictionary() -> [String:String] {
        return [
            "roomLatitude": roomLatitude,
            "roomLongitude": roomLongitude
        ]
    }
}
// ゲーム設定ビュー監視用
class GameSettingObserve : ObservableObject {
    @Published var hour:Int = 0
    @Published var minute:Int = 29
    @Published var killerCaptureRange:Int = 9
    @Published var survivorPositionTransmissionInterval:Int = 2
    @Published var escapeTime:Int = 2
    @Published var escapeRange:Int = 39
}
