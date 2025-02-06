#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(shinyWidgets)
library(shinythemes)

# Define UI for application that draws a histogram
fluidPage(
  
  theme = shinytheme("lumen"),
  
  withMathJax(),
  
  # Application title
  titlePanel("Rescorla-Wagner-Simulator"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      
      h4("Modellparameter"),
      
      hr(),
      
      fluidRow(
        column(width = 3, checkboxInput("c1", "CS1", TRUE)),
        column(
          width = 9, 
          sliderInput("a1", "\\( \\alpha_1 \\)", step = .1,
                      ticks = F, min = 0, max = 1, value = .2)
        )
      ),
      
      fluidRow(
        column(width = 3, checkboxInput("c2", "CS 2", FALSE)),
        column(
          width = 9, 
          sliderInput("a2", "\\( \\alpha_2 \\)", min = 0, max = 1, value = .2, 
                      step = .1, ticks = F)
        )
      ),
      
      fluidRow(
        column(width = 3, checkboxInput("c3", "CS 3", FALSE)),
        column(
          width = 9, 
          sliderInput("a3", "\\( \\alpha_3 \\)", min = 0, max = 1, value = .2, 
                      step = .1, ticks = F)
        )
      ),
      
      fluidRow(
        column(
          width = 3, 
          checkboxInput("us", "US", TRUE),
          span(textOutput("type"), style = "color:red; font-size:20px; font-family:arial")
        ),
        column(
          width = 9, 
          sliderInput("b", "\\( \\beta \\)", min = 0, max = 1, value = 1, 
                      step = .1, ticks = F)
        )
      ),
      
      # textOutput("type"),
      
      hr(),
      
      fluidRow(
        
        column(
          width = 6, align = "center",
          # Button to initiate data visualization
          actionBttn("trial", 
                     label = "Lernen",
                     style = "simple", color = "primary",
                     no_outline = F, size = "sm")
        ),
        
        column(
          width = 6, align = "center",
          actionBttn("reset", 
                     label = "Zurücksetzen",
                     style = "simple", color = "primary",
                     no_outline = F, size = "sm")
        )
        
      )
      
      
      
      
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      
      tabsetPanel(
        
        id = "tab",
        
        tabPanel("Informationen",
                 
                 br(),
                 
                 p("Herzlich willkommen zum Rescorla-Wagner-Simulator!",
                   "Mit dieser ShinyApp können Sie die Assoziationsstärken",
                   "zwischen einem US und drei CS im Verlauf eines",
                   "Experiments zur Klassischen Konditionierung mit beliebig",
                   "vielen Akquisitions- und Extinktionstrials simulieren. Geben",
                   "Sie dazu an, welche Stimuli im jeweiligen Trial",
                   "berücksichtigt werden, und welche Lernparameter angenommen",
                   "werden. Zur Erinnerung: Die Veränderung der Assoziationsstärke",
                   "eines CS berechnet sich nach"),
                 
                 p(style="text-align: center;",
                   "\\( \\Delta V_i = \\alpha_i \\cdot \\beta (\\lambda - \\text V_\\bullet)\\),"),
                 
                 p("wobei in Akquisitionstrials \\( \\lambda = 100\\)",
                   "und in Extinktionstrials \\( \\lambda = 0 \\).")
        ),
        
        tabPanel(
          "Blockierung",
          br(),
          p(strong("Paradigma:")),
          
          HTML("<ul> 
               <li><b>Akquisitionsphase 1:</b> CS1 + US</li>
               <li><b>Akquisitionsphase 2:</b> CS1 + CS2 + US</li>
               <li><b>Extinktionsphase 1:</b> CS1</li>
               <li><b>Extinktionsphase 1:</b> CS2</li>
               </ul>"),
          
          p(strong("Befund:"), "Wird in der Akquisitionsphase ein Compound CS",
          "(CS1 + CS2) dargeboten, von dem eine Komponente (CS1) vorher bereits",
          "isoliert konditioniert wurde, löst die andere Komponente (CS2)",
          "keine konditionierte Reaktion mehr aus.")
          
        ),
        
        tabPanel(
          "Überschattung",
          br(),
          p(strong("Paradigma:")),
          
          HTML("<ul> 
               <li><b>Akquisitionsphase 1:</b> CS1 + CS2 + US</li>
               <li><b>Extinktionsphase 1:</b> CS1</li>
               <li><b>Extinktionsphase 1:</b> CS2</li>
               </ul>"),
          
          p(strong("Befund:"), "Wird in der Akquisitionsphase ein Compund CS",
            "(CS1 + CS2) dargeboten, von dem eine Komponente (CS1) salienter ist,",
            "wird diese die andere Komponente (CS2) überschatten, d.h., die",
            "konditionierte Reaktion deutlich besser auslösen.")
          
        ),
        
        tabPanel(
          "Superkonditionierung",
          br(),
          p(strong("Paradigma:")),
          
          HTML("<ul> 
               <li><b>Akquisitionsphase 1:</b> CS1 + US</li>
               <li><b>Extinktionsphase 1:</b> CS1 + CS2 (CS2 wird konditionierter Hemmreiz)</li> 
               <li><b>Akquisitionsphase 2:</b> CS3 + CS2 + US</li>
               </ul>"),
          
          p(strong("Befund:"), "Der Erwerb einer konditionierten Reaktion auf",
            "CS3 erfolgt", strong("schneller"), "und die Reaktion ist", 
            strong("stärker"), "im Vergleich zu einer Akquisitionsphase ohne",
            "CS2.")
          
        ),
        
        tabPanel(
          "Overexpectation-Effekt",
          br(),
          p(strong("Paradigma:")),
          
          HTML("<ul> 
               <li><b>Akquisitionsphase 1:</b> CS1 + US (bis Assoziation maximal)</li> 
               <li><b>Akquisitionsphase 2:</b> CS2 + US (bis Assoziation maximal)</li> 
               <li><b>Akquisitionsphase 3:</b> CS1 + CS2 + US</li>
               <li><b>Extinktionsphase 1:</b> CS1</li>
               <li><b>Extinktionsphase 2:</b> CS2</li>
               </ul>"),
          
          p(strong("Befund:"), "Werden zwei CS isoliert konditioniert, bis sie",
            "eine maximal starke konditionierte Reaktion auslösen, und",
            "anschließend erneut als Compund konditioniert, lösen beide",
            "CS in anschließenden Extinktionsphase schwächere konditionierte",
            "Reaktionen aus als", strong("ohne"), "zusätzliche Akquisitionsphase",
            "im Compound")
          
        ),
        
        selected = "Informationen"
        
      ),
      
      hr(),
      
      plotOutput("distPlot")
    )
  ),
  
  hr(),
  
  p("Diese App wurde für Demonstrationszwecke in der Lehre entwickelt und",
    "kann für vergleichbare, nicht-kommerzielle Zwecke eingesetzt werden.",
    "Der Quellcode der App ist",
    a("hier", href=""),
    "verfügbar. Bitte richten Sie Fragen oder Kommentare zu dieser ShinyApp an",
    a("Martin Schnuerch.", href="mailto:martin.schnuerch@gmail.com"),
    style = "font-size:15px; text-align:justify")
  
)
