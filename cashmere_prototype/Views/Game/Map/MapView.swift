import SwiftUI
import CoreLocation

struct MapView: View {
    @State var manager = CLLocationManager()
    @State var alert = false
    var room:Room
    
    var body: some View {
        let toDate = Calendar.current.date(byAdding:.minute, value: room.rule.time, to:Date())
        // ContentViewに地図を表示
        ZStack(alignment: .top) {
            mapView(manager: manager, alert: $alert, room:room)
                .edgesIgnoringSafeArea(.all)
                .statusBar(hidden: true)
                .alert(isPresented: $alert) {
              Alert(title: Text("Please Enable Location Access In Setting Panel!!!"))
            }
            TimerView(setDate: toDate!)
                .frame(width: 320, height: 60)
                .background(Color.gray)
                .foregroundColor(Color.white)
                .cornerRadius(20)
                .padding(.top, 40)
                .opacity(0.8)
                
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
    }
}
