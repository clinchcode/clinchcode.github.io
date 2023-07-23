import TokamakDOM
import ClotGuideSwiftLibrary

//@main
struct ClotGuideSwift: App {
    var body: some Scene {
        WindowGroup("Tokamak App") {
            ContentView()
        }
    }
}

struct ContentView: View {
    @StateObject var clotGuideVM = ClotGuideViewModel()
    @State var ExtemA10  = 0.0
    @State var showResults = false
    @State var disclaimer = false
    // private let resultWidth: CGFloat = 40
    
    var body: some View {
        ZStack{
            VStack(alignment: .leading){
                Text("Input your Data").font(.title).fontWeight(.bold)
                Toggle(isOn: $heparin) {
                    Text("Have you used heparin?")
                }
                
                NumberInputField(value: $clotGuideVM.ExtemA10, title: "Ex-Test A10", min: 0, max: 60)
                NumberInputField(value: $clotGuideVM.ExtemCT, title: "Ex-Test CT", min: 0.0, max: 150)
                NumberInputField(value: $clotGuideVM.FibtemA10, title: "Fib-Test A10", min: 0, max: 40)
                NumberInputField(value: $clotGuideVM.IntemCT, title: "In-Test CT", min: 0.0, max: 400)
                NumberInputField(value: $clotGuideVM.HitemCT, title: "Hi Test CT", min: 0.0, max: 400)
                
                
//                let notComplete = ExtemA10 == 0 ||
//                FibtemA10 == 0 ||
//                (heparin && HitemCT == 0 ) ||
//                IntemCT == 0 ||
//                ExtemCT == 0
//
//
                Button {
                    if showResults{
                        clotGuideVM.ExtemCT = 0
                        clotGuideVM.ExtemA10 = 0
                        clotGuideVM.IntemCT = 0
                        clotGuideVM.FibtemA10 = 0
                        clotGuideVM.HitemCT = 0
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
                
                Button("Disclaimer") {
                    disclaimer = true
                }.foregroundColor(.red)
                
                //  NavigationLink("Disclaimer", destination: DisclaimerView())
                
                if showResults {
                    Divider()
                    HStack{
                        Text("Results").font(.title2)
                        Spacer()
                        Button {
                            key = true
                        } label: {
                            Label("Show Key", systemImage: "key.fill")
                        }
                        
                        Spacer()
                    }.padding()
                    
                    //If Heparin used, show heparin effects
                    if clotGuideVM.heparin {
                        VStack(alignment: .leading){
                            
                            Text("Heparin Effect").fontWeight(.semibold)
                            if clotGuideVM.heparinEffect() {
                                Text("Heparin Effect Likely").foregroundColor(.white).padding().background(Color.red).cornerRadius(10)
                            } else {
                                Text("Heparin Effect Unlikely").foregroundColor(.white).padding().background(Color.green).cornerRadius(10)
                            }
                        }
                    }
                    
                    //Plt and Fib
                    VStack(alignment: .leading){
                        Text("Platelets and Fibrinogen").fontWeight(.semibold)
                        if clotGuideVM.ExTestA10 < clotGuideVM.ExTestLowerLimit {
                            if clotGuideVM.FibTestA10 >= clotGuideVM.FibTestMiddleLimit {
                                Text("Platelets Low").foregroundColor(.white).padding().background(Color.red).cornerRadius(10)
                            } else {
                                Text("Platelets & Fibrinogen Low").foregroundColor(.white).padding().background(Color.red).cornerRadius(10)
                            }
                            
                        } else if clotGuideVM.ExTestA10 < clotGuideVM.ExTestMiddleLimit {
                            
                            if clotGuideVM.FibTestA10 < clotGuideVM.FibTestLowerLimit {
                                VStack(alignment: .leading){
                                    Text("Fibrinogen Low").foregroundColor(.white)
                                    Text("Platelets possibly low").font(.caption).foregroundColor(.white)
                                }.padding().background(Color.red).cornerRadius(10)
                            } else if clotGuideVM.FibTestA10 < clotGuideVM.FibTestMiddleLimit {
                                Text("Platelets & Fibrinogen Low").foregroundColor(.white).padding().background(Color.yellow).cornerRadius(10)
                            } else {
                                Text("Platelets Low").foregroundColor(.white).padding().background(Color.yellow).cornerRadius(10)
                            }
                            
                        } else {
                            
                            if clotGuideVM.FibTestA10 < clotGuideVM.FibTestLowerLimit {
                                Text("Fibrinogen Low").foregroundColor(.white).padding().background(Color.yellow).cornerRadius(10)
                            }else{
                                VStack(alignment: .leading){Text("Platelets & Fibrinogen OK").foregroundColor(.white)
                                    Text("fibrinogen possibly low if microvascular bleeding persists").font(.caption).foregroundColor(.white)
                                }.padding().background(Color.green).cornerRadius(10)
                            }
                        }
                        
                    }
                    
                    //Clotting Time Analysis
                    VStack(alignment: .leading){
                        Text("Clotting Time Analysis*").fontWeight(.semibold)
                        
                        if clotGuideVM.FibTestA10 < clotGuideVM.FibTestLowerLimit {
                            if clotGuideVM.clottingTimeHighLong().contains(true) {
                                
                                Text("Fibringen Low").foregroundColor(.white).padding().background(Color.red).cornerRadius(10)
                            } else if clotGuideVM.clottingTimeMediumLong().contains(true) {
                                Text("Fibringen Low").foregroundColor(.white).padding().background(Color.yellow).cornerRadius(10)
                            } else {
                                Text("Clotting Time OK").foregroundColor(.white).padding().background(Color.green).cornerRadius(10)
                            }
                            
                        }
                        
                        if clotGuideVM.heparinEffect() {
                            
                            if clotGuideVM.clottingTimeHighLong().contains(true) {
                                
                                Text("Heparin Effect").foregroundColor(.white).padding().background(Color.red).cornerRadius(10)
                            } else if clotGuideVM.clottingTimeMediumLong().contains(true) {
                                Text("Heparin Effect").foregroundColor(.white).padding().background(Color.yellow).cornerRadius(10)
                            } else {
                                Text("Clotting Time OK").foregroundColor(.white).padding().background(Color.green).cornerRadius(10)
                            }
                        }
                        
                        if (clotGuideVM.FibTestA10 >= clotGuideVM.FibTestLowerLimit && !clotGuideVM.heparinEffect())
                        {
                            if clotGuideVM.clottingTimeHighLong().contains(true) {
                                Text("Clotting Factors Low").foregroundColor(.white).padding().background(Color.yellow).cornerRadius(10)
                            } else if clotGuideVM.clottingTimeMediumLong().contains(true) {
                                Text("Clotting Factors Low").foregroundColor(.white).padding().background(Color.yellow).cornerRadius(10)
                            } else {
                                Text("Clotting Factors OK").foregroundColor(.white).padding().background(Color.green).cornerRadius(10)
                            }
                        }
                        Text("*Clotting Time can be unreliable and should be correlated with clincial picture").font(.caption)
                    }
                    
                    
                    
                }
                
                
            }.padding()
            if disclaimer{
                
                ZStack{
                    HStack(spacing: 0){
                        Rectangle().fill(Color.black)
                        Rectangle().fill(Color.black)
                    }
                    VStack{
                        Text("This project is only to be used as a guide to interpreting ROTEM and ClotPro.\nIt is based on NHS Lothian's ROTEM/ClotPro Algorithm.\nThis is NOT a substitute for clinical judgement,\nnor is it intended to advise what treatment to give.\nIt is intended to be used ONLY by trained professionals.").foregroundColor(.red).padding()
                        Button("hide") {
                            disclaimer = false
                        }
                    }
                    
                }
            }
        }
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

class ClotGuideViewModel: ObservableObject {
    //input variables
    @Published var ExTestA10  = 0.0
    @Published var FibTestA10 = 0.0
    @Published var ExTestCT   = 0.0
    @Published var InTestCT   = 0.0
    @Published var HiTestCT   = 0.0
    @Published var heparin   = false
    
    //limits
    @Published var ExTestLowerLimit = 22.0
    @Published var ExTestMiddleLimit = 39.0
    @Published var FibTestLowerLimit = 5.0
    @Published var FibTestMiddleLimit = 8.0
    @Published var heparinHiTestLimit = 211.0
    @Published var heparinInTestLimit = 228.0
    @Published var InTestCTUpperLimit = 300.0
    @Published var InTestCTMediumLimit = 240.0
    @Published var ExTestCTUpperLimit = 100.0
    @Published var ExTestCTMediumLimit = 80.0
    @Published var HiTestCTUpperLimit = 300.0
    @Published var HiTestCTMediumLimit = 240.0
    
    init(){
        self.ExTestA10  = 0.0
        self.FibTestA10 = 0.0
        self.ExTestCT   = 0.0
        self.InTestCT   = 0.0
        self.HiTestCT   = 0.0
        self.heparin   = false
        self.ExTestLowerLimit = 22.0
        self.ExTestMiddleLimit = 39.0
        self.FibTestLowerLimit = 5.0
        self.FibTestMiddleLimit = 8.0
        self.heparinHiTestLimit = 211.0
        self.heparinInTestLimit = 228.0
        self.InTestCTUpperLimit = 300.0
        self.InTestCTMediumLimit = 240.0
        self.ExTestCTUpperLimit = 100.0
        self.ExTestCTMediumLimit = 80.0
        self.HiTestCTUpperLimit = 300.0
        self.HiTestCTMediumLimit = 240.0
    }
    
    func heparinEffect() -> Bool {
        return (HiTestCT <= heparinHiTestLimit && InTestCT >= heparinInTestLimit && heparin)
    }
    func clottingTimeMediumLong() -> [Bool]{
        return [(InTestCT > InTestCTMediumLimit),( HiTestCT > HiTestCTMediumLimit),( ExTestCT > ExTestCTMediumLimit)]
    }
    func clottingTimeHighLong() -> [Bool] {
        return [(InTestCT > InTestCTUpperLimit),( HiTestCT > HiTestCTUpperLimit),(ExTestCT > ExTestCTUpperLimit)]
    }
    
    func notComplete() -> Bool {
        return ExTestA10 < 1 ||
        FibTestA10 < 1 ||
        (heparin && HiTestCT < 1 ) ||
        (heparin && InTestCT < 1) ||
        ExTestCT < 1
    }
    
}




ClotGuideSwift.main()
