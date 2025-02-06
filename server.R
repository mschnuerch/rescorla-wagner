#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(shinyjs)
library(tidyverse)

do_plot <- function (values) {
  
  # get relevant values
  x = values$trials
  V1 = values$V1
  V2 = values$V2
  V3 = values$V3
  
  data.frame(x, V1, V2, V3) |> 
    ggplot(aes(x = x)) +
    geom_hline(aes(yintercept = 100), linetype = "dashed", lwd = 1) +
    geom_hline(aes(yintercept = 0), linetype = "dashed", lwd = 1) +
    geom_line(aes(y = V1, group = 1, color = "a"), lwd = 1) +
    geom_point(aes(y = V1, group = 1, color = "a"), size = 3) +
    geom_line(aes(y = V2, group = 1, color = "b"), lwd = 1, linetype = "dashed") +
    geom_point(aes(y = V2, group = 1, color = "b"), size = 3) +
    geom_line(aes(y = V3, group = 1, color = "c"), lwd = 1, linetype = "dotted") +
    geom_point(aes(y = V3, group = 1, color = "c"), size = 3) +
    scale_y_continuous("Assoziationsstärke", breaks = c(0, 100)) +
    scale_x_continuous("Lerndurchgang", breaks = 0:max(x)) +
    theme_classic() +
    theme(
      text = element_text(size = 15),
      axis.text = element_text(size = 15, color = "black"),
      legend.position = "bottom"
    ) +
    scale_color_manual(
      element_blank(),
      breaks = c("a", "b", "c"),
      values = c("firebrick", "dodgerblue2", "purple"),
      labels = c("CS1", "CS2", "CS3")
    )
  
}


# Define server logic required to draw a histogram
function(input, output, session) {
  
  useShinyjs()
  
  # Reactive object to store output
  values <- reactiveValues(
    trials = 0,
    V1 = 0,
    V2 = 0,
    V3 = 0,
    debug = 0
  )
  
  get_a1 <- eventReactive(input$trial, input$a1)
  get_a2 <- eventReactive(input$trial, input$a2)
  get_a3 <- eventReactive(input$trial, input$a3)
  get_V1 <- eventReactive(input$trial, values$V1)
  get_V2 <- eventReactive(input$trial, values$V2)
  get_V3 <- eventReactive(input$trial, values$V3)
  get_b <- eventReactive(input$trial, input$b)
  get_us <- eventReactive(input$trial, input$us)
  c1 <- eventReactive(input$trial, input$c1)
  c2 <- eventReactive(input$trial, input$c2)
  c3 <- eventReactive(input$trial, input$c3)

  learn <- eventReactive(input$trial, {
    
    n <- values$trials[length(values$trials)]
    a1 <- get_a1()
    a2 <- get_a2()
    a3 <- get_a3()
    V1 <- get_V1()
    V1_old <- V1[length(V1)]
    V2 <- get_V2()
    V2_old <- V2[length(V2)]
    V3 <- get_V3()
    V3_old <- V3[length(V3)]
    b <- get_b()

    if (get_us()) {
      lambda <- 100
    } else {
      lambda <- 0
    }

    V <- sum(c(V1_old, V2_old, V3_old)[c(c1(), c2(), c3())])

    if (c1())
      V1_new <- V1_old + a1 * b * (lambda - V)
    else
      V1_new <- V1_old
    if (c2())
      V2_new <- V2_old + a2 * b * (lambda - V)
    else
      V2_new <- V2_old
    if (c3())
      V3_new <- V3_old + a3 * b * (lambda - V)
    else
      V3_new <- V3_old

    return (
      list(
        trials = 0:(n + 1),
        V1 = c(V1, V1_new),
        V2 = c(V2, V2_new),
        V3 = c(V3, V3_new)
      )
    )

  })

  # React to click on "Reset" button
  observe({

    if (input$trial == 0){

      return()

    } else {

      tmp <- learn()
      values$trials <- tmp$trials
      values$V1 <- tmp$V1
      values$V2 <- tmp$V2
      values$V3 <- tmp$V3
    }
  })

  # React to click on "Reset" button
  observe({

    if(input$reset == 0){

      return()

    } else {

      values$trials <- 0
      values$V1 <- 0
      values$V2 <- 0
      values$V3 <- 0
      reset("trial")

    }

  })
  

# Render Output -----------------------------------------------------------

  # Plot data
  output$distPlot <- renderPlot({
    # tryCatch(
    #   {do_plot(values)},
    #   error = function(x) {""}
    # )
    do_plot(values)
    })
  
  output$type <- renderText({
    if (input$us)
      "Akquisition"
    else
      "Extinktion"
  })



  
  
  
}
