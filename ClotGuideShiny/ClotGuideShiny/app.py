from shiny import App, render, ui, reactive
  
app_ui = ui.page_fluid(
    {"style": "background-color: rgba(169, 169, 169, 0.7)"},
    ui.div({"style": "font-size: 300%;"},
        "ClotGuide",),
    ui.navset_tab(
        ui.nav("Guide", 
            ui.input_switch("hepUsed", "Heparin Used?"),
            ui.input_numeric("exTestCT", "Ex-Test CT", value = 0),
            ui.input_numeric("exTestA10", "Ex-Test A10", value= 0),
            ui.input_numeric("fibTestA10", "Fib-Test A10", value = 0),
            ui.input_numeric("inTestCT", "In-Test CT", value= 0),
            ui.row(
                ui.column(10, ui.output_ui("hepCTSlider")),
            ),
            ui.input_action_button("go","Go", class_="btn-primary"),
            ui.row(
                ui.column(10, ui.output_ui("result")),
            ),
            ui.row(
                ui.column(10, ui.output_ui("plateletsandfibrinogen")),
            ),
            ui.row(ui.div("---------")),
            ui.row(
                ui.column(10, ui.output_ui("clottingTime")),
            ),
            ui.row(
                ui.column(10, ui.input_action_link("key", "Key"))
            ),
        ),
        ui.nav("More",
               ui.row(ui.input_action_link("about", "About")),
               ui.row(ui.input_action_link("show", "Disclaimer")),
               
                   )
        
    )
)


def server(input, output, session):
    @output
    @render.ui
    def hepCTSlider():
        if input.hepUsed():
            return ui.TagList(
                ui.input_numeric("hiTestCT", "Hi-Test CT", value=0),
            )

    @output
    @render.ui
    @reactive.event(input.go)
    def result():
        if input.hepUsed():
            if input.inTestCT() >= (228) and input.hiTestCT() <= (211.0):
                hep = ui.div(
                    {"style": "font-weight: bold; color: red"},
                    "",
                           )
            else:
                hep = ui.row(ui.div(
                    {"style": "font-weight: bold"},
                    "Heparin Effect",
                           )),ui.row(ui.div(
                    {"style": "font-weight: bold; color: green"},
                    "Unlikely Heparin Effect",
                           )),ui.row(ui.div("---------"))
            return hep
            

    @output
    @render.ui
    @reactive.event(input.go)
    def plateletsandfibrinogen():
        if input.exTestA10() < 22:
        
        
            if input.fibTestA10() < 8:
                plt = ui.row(ui.div(
                    {"style": "font-weight: bold"},
                    "Fibrinogen and Platelets",
                           )),ui.row(ui.div(
                    {"style": "font-weight: bold; color: red"},
                    "Very Low Fibrinogen and Platelets",
                           ))
            
            
        elif input.exTestA10() < 39:
        
        
            if input.fibTestA10() < 5:
                plt = ui.row(ui.div(
                    {"style": "font-weight: bold"},
                    "Fibrinogen and Platelets",
                           )),ui.row(ui.div(
                    {"style": "font-weight: bold; color: red"},
                    "Very Low Fibrinogen, Low Platelets",
                ))
            
            elif input.fibTestA10() < 8:
                plt = ui.row(ui.div(
                    {"style": "font-weight: bold"},
                    "Fibrinogen and Platelets",
                           )),ui.row(ui.div(
                    {"style": "font-weight: bold; color: orange"},
                    "Low Platelets and Fibrinogen",
                           ))
                
            else:
                plt = ui.row(ui.div(
                    {"style": "font-weight: bold"},
                    "Fibrinogen and Platelets",
                           )),ui.row(ui.div(
                    {"style": "font-weight: bold; color: orange"},
                    "Low Platelets",
                           ))
                
        else:
        
        
            if input.fibTestA10() < 5:
               plt = ui.row(ui.div(
                    {"style": "font-weight: bold"},
                    "Fibrinogen and Platelets",
                           )),ui.row(ui.div(
                    {"style": "font-weight: bold; color: orange"},
                    "Low Fibrinogen",
                           ))
            elif input.fibTestA10() < 10:
                plt = ui.row(ui.div(
                    {"style": "font-weight: bold"},
                    "Fibrinogen and Platelets",
                           )),ui.row(ui.div({"style": "font-weight: bold; color: green"},
                    "OK Platelets and Fibrinogen*")),ui.row(ui.div("*if ongoing bleeding may require more Fibrinogen"))
            else:
                plt = ui.row(ui.div(
                    {"style": "font-weight: bold"},
                    "Fibrinogen and Platelets",
                           )),ui.row(ui.div(
                    {"style": "font-weight: bold; color: green"},
                    "OK Platelets and Fibrinogen",
                          ))
                    
            
            
        return plt

    @output
    @render.ui
    @reactive.event(input.go)
    def clottingTime():
        if input.hepUsed() and (input.inTestCT() >= (228) and input.hiTestCT() <= (211.0)):
            cf = ui.row(ui.div(
                    {"style": "font-weight: bold"},
                    "Clotting Time Analysis",
                           )),ui.row(ui.div(
                {"style": "font-weight: bold; color: red"},
                "Likely Residual Heparin Effect",
            ))
        elif input.fibTestA10() < 5:
            cf = ui.row(ui.div(
                    {"style": "font-weight: bold"},
                    "Clotting Time Analysis",
                           )),ui.row(ui.div(
                    {"style": "font-weight: bold; color: red"},
                    "Low Fibringoen",
                           ))
                
        else:
            if input.inTestCT() > 240 or input.exTestCT() > 80:
                cf = ui.row(ui.div(
                    {"style": "font-weight: bold"},
                    "Clotting Time Analysis",
                           )),ui.row(ui.div(
                    {"style": "font-weight: bold; color: orange"},
                    "Low Clotting Factors",
                ))
            else:
                cf = ui.row(ui.div(
                    {"style": "font-weight: bold"},
                    "Clotting Time Analysis",
                           )),ui.row(ui.div(
                    {"style": "font-weight: bold; color: green"},
                    "Clotting Time OK",
                ))
    
        return cf

    @reactive.Effect
    @reactive.event(input.show)
    def _():
        m = ui.modal(
            ui.HTML("This project is only to be used as a guide to interpreting ROTEM and ClotPro.<br>It is based on NHS Lothian's ROTEM/ClotPro Algorithm v1.11.<br>This is NOT a substitute for clinical judgement, nor is it intended to advise what treatment to give. Treatment plans should incorporate knowledge of the clinical picture.<br><br>If the advice seems incorrect, re-assess and escalate to a senior member of staff.<br><br>ClotGuide is intended to be used ONLY by trained professionals.<br><br>If you are unsure how to use this guide, seek senior help."),
            title="Disclaimer",
            easy_close=True,
            footer=None,
        )
        ui.modal_show(m)

    @reactive.Effect
    @reactive.event(input.key)
    def _():
        m = ui.modal(
            ui.HTML("<h1 style=color:red;>RED: Significant</h1><br><h1 style=color:orange;>Orange: Significant if Bleeding or High Risk of Bleeding</h1><br><h1 style=color:green;>GREEN: Rule out other causes of coagulopathy*</h1><br>*ROTEM/ClotPro does not detect the effect of Antiplatelets<br>*ROTEM/ClotPro has poor sensitivity for LMWH, Warfarin, DOACs"),
            title="Key",
            easy_close=True,
            footer=None,
        )
        ui.modal_show(m)
        
    @reactive.Effect
    @reactive.event(input.about)
    def _():
        m = ui.modal(
            ui.HTML("<h1>ClotGuide</h1><br><h4>Version 1.0</h4><br>ClotGuide was written by Nicholas Clinch<br><br>Currently Maintained by: Nicholas Clinch<br><br>Based on <i>NHS Lothian ROTEM/ClotPro Guidance Version 1.11</i><br>Last Updated: 18/08/2021"),
            title="About",
            easy_close=True,
            footer=None,
        )
        ui.modal_show(m)

app = App(app_ui, server)

