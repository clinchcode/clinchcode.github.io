from shiny import App, render, ui

app_ui = ui.page_fluid(
    ui.input_slider("exTestCT", "Ex-Test CT", 0, 150, 1),
    ui.input_slider("inTestCT", "In-Test CT", 0, 400, 1),
    ui.input_slider("exTestA10", "Ex-Test A10", 0, 60, 1),
    ui.input_slider("fibTestA10", "Fib-Test A10", 0, 40, 1),
    ui.input_slider("hiTestCT", "Hi-Test CT", 0, 400, 1),
    ui.output_text_verbatim("txt"),
)


def server(input, output, session):
    @output
    @render.text
    def txt():
        return f"Ex-Test CT is {input.extestCT() * 2}"


app = App(app_ui, server)
