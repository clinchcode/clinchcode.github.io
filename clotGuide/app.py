from shiny import App, render, ui

app_ui = ui.page_fluid(
  {"style": "background-color: rgba(0, 128, 255, 0.1)"},
    ui.input_switch("hepUsed", "Heparin Used?"),
    ui.input_slider("exTestCT", "Ex-Test CT", 0, 150, 1),
    ui.input_slider("inTestCT", "In-Test CT", 0, 400, 1),
    ui.input_slider("exTestA10", "Ex-Test A10", 0, 60, 1),
    ui.input_slider("fibTestA10", "Fib-Test A10", 0, 40, 1),
    
    ui.row(
        ui.column(10, ui.output_ui("hepCTSlider")),
    ),
 
    ui.row(
        ui.column(10, ui.output_text("result")),
    ),
    ui.row(
        ui.column(10, ui.output_text("platelets")),
    ),
    ui.row(
        ui.column(10, ui.output_text("fibrinogen")),
    ),
    ui.row(
        ui.column(10, ui.output_text("clottingFactors")),
    ),
  
    

)


def server(input, output, session):
    @output
    @render.ui
    def hepCTSlider():
      if input.hepUsed():
        return ui.TagList(
            ui.input_slider("hiTestCT", "Hi-Test CT", 0, 400, 1),
        )
      
    
    @output
    @render.text
    def result():
        if input.hepUsed():
          if input.inTestCT() >= (228) and input.hiTestCT() <= (211.0):
            hep = "Likely Residual Heparin Effect"
          else:
            hep = "No Residual Heparin Effect"
          return hep
      
    @output
    @render.text
    def platelets():
        if input.exTestA10() <22:
          plt = "Platelets Very Low"
        elif input.exTestA10() < 39:
          plt = "Platelets Low"
        else:
          plt = "Platelets OK"
        return plt
      
    @output
    @render.text
    def fibrinogen():
        if input.fibTestA10() <5:
          fib = "Fibronogen Very Low"
        elif input.fibTestA10() <8:
          fib = "Fibrinogen Low"
        else:
          fib = "Fibrinogen OK"
        return fib
      
    @output
    @render.text
    def clottingFactors():
        if input.inTestCT() > 300 or input.exTestCT() > 100:
          cf = "Clotting Factors Very Low"
        elif input.inTestCT() > 240 or input.exTestCT() > 80:
          cf = "Clotting Factors Low"
        else:
          cf = "Clotting Factors OK"
        return cf
        

app = App(app_ui, server)
