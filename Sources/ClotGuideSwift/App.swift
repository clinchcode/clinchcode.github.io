import TokamakDOM
import ClotGuideSwiftLibrary

//@main
struct TokamakApp: App {
    var body: some Scene {
        WindowGroup("Tokamak App") {
            ContentView()
        }
    }
}

struct ContentView: View {
    
    @State var ExtemA10  = 0.0
    @State var showResults = false
    @State var FibtemA10 = 0.0
    @State var ExtemCT   = 0.0
    @State var IntemCT   = 0.0
    @State var HitemCT   = 0.0
    @State var heparin   = false
    @State var disclaimer = false
    // private let resultWidth: CGFloat = 40
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Input your Data").font(.title).fontWeight(.bold)
            Toggle(isOn: $heparin) {
                Text("Have you used heparin?")
            }
            NumberInputField(value: $ExtemCT, title: "Ex-Test CT", min: 0.0, max: 150)
            NumberInputField(value: $IntemCT, title: "In-Test CT", min: 0.0, max: 400)
            if heparin {
                NumberInputField(value: $HitemCT, title: "Hi Test CT", min: 0.0, max: 400)
            }
            NumberInputField(value: $ExtemA10, title: "Ex-Test A10", min: 0, max: 60)
            NumberInputField(value: $FibtemA10, title: "Fib-Test A10", min: 0, max: 40)
            
       
            
                Button {
                    if showResults{
                        ExtemCT = 0
                        ExtemA10 = 0
                        IntemCT = 0
                        FibtemA10 = 0
                        HitemCT = 0
                        heparin = false
                    }
                    showResults.toggle()
                } label: {
                    if showResults {
                        Text("Reset")
                    } else {
                        Text("Show Results")
                    }
                }
                
            
            
            if showResults {
                Group{
                    Divider()
                    HStack{
                        Text("Results").font(.title).fontWeight(.bold)
                        Spacer()
                    }
                    if heparin {
                        VStack(alignment: .leading){
                            
                            Text("Heparin Effects").fontWeight(.semibold)
                            if HitemCT <= 211 && IntemCT >= 228 {
                                Text("Possible residual heparin effect").foregroundColor(.white).padding().background(Color.red).cornerRadius(10)
                            } else {
                                Text("Unlikely residual heparin effect").foregroundColor(.white).padding().background(Color.green).cornerRadius(10)
                            }
                        }
                    }
                    
                    VStack(alignment: .leading){
                        Text("Platelets").fontWeight(.semibold)
                        if ExtemA10 < 22 {
                            Text("Platelets Low").foregroundColor(.white).padding().background(Color.red).cornerRadius(10)
                        } else if ExtemA10 < 39 {
                            Text("Platelets Low").foregroundColor(.white).padding().background(Color.yellow).cornerRadius(10)
                        } else {
                            Text("Platelets OK").foregroundColor(.white).padding().background(Color.green).cornerRadius(10)
                        }
                        
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Fibrinogen").fontWeight(.semibold)
                        if FibtemA10 < 5 {
                            Text("Fibrinogen Low").foregroundColor(.white).padding().background(Color.red).cornerRadius(10)
                        } else if FibtemA10 < 8 {
                            Text("Fibrinogen Low").foregroundColor(.white).padding().background(Color.yellow).cornerRadius(10)
                        } else {
                            Text("Fibrinogen OK").foregroundColor(.white).padding().background(Color.green).cornerRadius(10)
                        }
                        
                    }
                    
                    VStack(alignment: .leading){
                        Text("Clotting Factors").fontWeight(.semibold)
                        if IntemCT > 300 || HitemCT > 300 || ExtemCT > 100 {
                            Text("Clotting Factors Low").foregroundColor(.white).padding().background(Color.red).cornerRadius(10)
                        } else if IntemCT > 240 || HitemCT > 240 || ExtemCT > 80 {
                            Text("Clotting Factors Low").foregroundColor(.white).padding().background(Color.yellow).cornerRadius(10)
                        } else {
                            Text("Clotting Factors OK").foregroundColor(.white).padding().background(Color.green).cornerRadius(10)
                        }
                    }
                    
                }
            }
            
            
        }.padding()
    }
}

struct NumberInputField: View {
    @State var value: Binding<Double>
    @State var title: String
    
    
    let min: Double
    let max: Double
    
    var body: some View{
        HStack{
            Text(title).fontWeight(.semibold).font(.body)
                .frame(width: 100).multilineTextAlignment(.leading)
            Spacer().frame(maxWidth: 100)
            // TextField("Value", value: value, format: .number).multilineTextAlignment(.trailing).font(.title3).keyboardType(.numberPad)
            Slider(value: value,
                   in: min...max,
                   step: 1)
            Text(String(format: "%.0f", value.wrappedValue))
            // TextField(title, value: value, format: .number).multilineTextAlignment(.trailing).frame(width: 40)
            
        }
    }
}
