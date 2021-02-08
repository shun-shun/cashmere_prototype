//
//  CreateRoom.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/02.
//

import SwiftUI
import Firebase

struct CreateRoomView: View {
    @EnvironmentObject var model: Model
    @EnvironmentObject var RDDAO: RealtimeDatabeseDAO
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var gameEventFlag: GameEventFlag
    @EnvironmentObject var gameSet: GameSettingObserve
    // ルーム
    var room:Room
    
    init(host:Player) {
        // ルームの作成
        self.room = Room(name: "会場1", host: host)
    }

    var body: some View {
        VStack {
            VStack {
                GameruleSettingsView()
            }.padding()
            .padding(.top, 30)
                
            Spacer()
            
            Button(action: {
                model.playerInvitePushed = true
                // ルールモデルの反映
                RDDAO.updateGamerule(room: room)
                RDDAO.updatePosition(room: room)
                RDDAO.getGameRule(room: room) { rule in
                    if let r = rule {
                        self.room.rule = r
                    }
                    // FIXME: nilの場合は何もしない
                }
            }) {
                Text("プレイヤーを招待する")
                    .frame(width: 240, height: 60, alignment: .center)
            }
            .sheet(isPresented: $model.playerInvitePushed) {
                PlayerInviteView(room)
            }
            .buttonStyle(CustomButtomStyle(color: Color(UIColor(hex: "E94822"))))
            
            Button(action: {
                model.createRoomViewPushed = false
            }) {
                Text("もどる").foregroundColor(Color.black)
                    .frame(width: 240, height: 60, alignment: .center)
            }
            .buttonStyle(CustomButtomStyle(color: Color(UIColor(hex: "C9E8F1"))))
            
            VStack {
            }
            .background(EmptyView().fullScreenCover(isPresented: $gameEventFlag.isEscaping) {
                let escapeTime = room.rule.escapeTime
                let dispTime = Calendar.current.date(byAdding: .second, value: escapeTime * 60, to: Date())!
                EscapeTimeView(setDate: dispTime)
            })
            
            VStack {
            }
            .background(EmptyView().fullScreenCover(isPresented: $gameEventFlag.isGameStarted) {
                GameView(room)
            })
            
        }
        .frame(minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity
        ).background(Color(UIColor(hex: "212121"))).edgesIgnoringSafeArea(.all)
        .onAppear{
            roomInit(room: room)
            getLocation()
            RDDAO.updatePosition(room: room)
            RDDAO.getGameRule(room: room) { (rule) in
                if let r = rule {
                    room.rule = r
                }
                // TODO: あとで上記とマージ
            }
            RDDAO.getPlayers(roomId: room.id) { (result) in
                room.players = result
                room.players.sort { $0.id < $1.id }
                for playerDB in room.players {
                    // HELP: ここは何をしているんだ？
                    if room.host.id == playerDB.id {
                        room.host.latitude = playerDB.latitude
                        room.host.longitude = playerDB.longitude
                        room.host.onlineStatus = playerDB.onlineStatus
                        room.host.captureState = playerDB.captureState
                        if room.host.captureState == .captured {
                            gameEventFlag.isCaptured = true
                        }
                    }
                }
                if gameEventFlag.isGameStarted {
                    checkAllCaught(plyers: room.players){ (isAllCaught) in
                        if isAllCaught {
                            gameEventFlag.isGameOver = isAllCaught
                        }
                    }
                }
            }
            
        }
        .onDisappear{
//            roomDel(room: room.id)
        }
        .navigationBarBackButtonHidden(true)
        .onTapGesture {
            UIApplication.shared.closeKeyboard()
        }
    }
    
    private func ruleInit() {
        room.rule.escapeRange = gameSet.escapeRange
        room.rule.escapeTime = gameSet.escapeTime
        room.rule.killerCaptureRange = gameSet.killerCaptureRange
        room.rule.survivorPositionTransmissionInterval = gameSet.survivorPositionTransmissionInterval
        let hour = gameSet.hour
        let minute = gameSet.minute
        room.rule.toTime(hour: hour, minute: minute)
    }
    private func roomInit(room: Room) {
        room.host.role = .killer
        room.host.captureState = .tracking
        RDDAO.updateRoomStatus(roomId: room.id, state: .wating)
        RDDAO.addPlayer(roomId: room.id, player: room.host)
    }

    private func roomDel(room: String) {
//        player.role = ""
//        player.captureState = ""
        RDDAO.deleteRoom(roomId: room)
    }

    private func checkAllCaught(plyers: [Player], completionHandler: @escaping (Bool) -> Void) {
        var isAllCaught = true
        for player in room.players {
            if player.captureState != .captured && player.role == .fugitive {
                isAllCaught = false
            }
        }
        completionHandler(isAllCaught)
    }

    private func getLocation() {
        requestLocation().getLocation(comp: { roomLocation in
            let roomLatitude = roomLocation["roomLatitude"]!
            let roomLongitude = roomLocation["roomLongitude"]!
            room.point = Position(latitude: roomLatitude, longitude: roomLongitude)
        })
    }
    
}

extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
