import SwiftUI

struct SignIn: View {
    @Binding var isStarted: Bool

    var body: some View {
        VStack {
            Image("simplespendmain") // Your logo
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300, height: 200)
                .padding(.top, -50)
            
            Button(action: {
                isStarted = true
            }) {
                Text("Start Saving!")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding()
                    .frame(width: 150, height: 50)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color(hex: "#dede50"), Color(hex: "#60a14a")]), startPoint: .leading, endPoint: .trailing)
                )
            .cornerRadius(25)
            }
            .padding()
        }
        .darkMode()
    }
}

struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        SignIn(isStarted: .constant(false))
            .darkMode()
    }
}
