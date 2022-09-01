#' Model ui function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @import pins
#' @import ggeffects

mod_model_ui <- function(id) {
  ns <- NS(id)
  tagList(
    
    div(
      class = "ui two column grid",
      div(class = "eight wide column",
          div( class = "card_grey",
          dataTableOutput(ns('testdata')),
          div(  class="ui horizontal divider header",
            div(  class="center align icon",
               ),
            h5("Adjusting the table")
           ),
          
          h4("Select variables from dropdowns below: "),
          div( class = "ui stackable two column grid",
               div( class = "column",  
                    selectInput(ns("gender"),"Gender",
                                choices = c("Man","Woman")),
               ),
               div( class = "column",
                    selectInput(ns("edulevel"),"Level of education",
                                choices = c("High School","College degree","Master's degree", "Professional degree (MD, JD, etc.)", "PhD"))
               ),
               div( class = "column",
                    selectInput(ns("expyrs"),"Years of Experience",
                                choices = c("1 year or less", "2 - 4 years", "5-7 years", "8 - 10 years","11 - 20 years", "21 - 30 years","31 - 40 years", "41 years or more"))
               ),
               div(class = "column",
                   selectInput(ns('age'), "Age",
                               choices = c("under 18", "18-24", "25-34", "35-44", "45-54","55-64", "65 or over"))
                   )
          ),
          
          br(),
          
          # div(
          #   class = "ui purple button",
          #   actionButton(ns('add_rows'),'Add Row(s)')
          #  
          # ),
          # 
          # br(),
          
         div(class="ui stackable buttons",
             div(
               class = "ui teal button",
               actionButton(ns("update"),"Update table")
             ), br(),
             div(
               class = "ui olive button",
               actionButton(ns("submit"),"Submit for prediction")
             )
             ),
         br(),
         div(
           class = "sixteen wide column",
           
           shiny::uiOutput(ns('predUI'))
           
         )
          
          )
      ),
      div(class = "eight wide column",
          div( class = "card_grey",
               
          # div( class="ui small stackable horizontal statistics",
          #   div( class="red statistic",
          #   div( class="value",
          #     textOutput(ns('auc'))
          #   ),
          #   div( class="label",
          #   h4("Model accuracy (AUC)")
          #   )
          #   )
          # ),
          div(
            class = "ui stacked segment",
            h3("Logistic regression"),
            p("The algorithm used in modelling the data is a logistic regression model. 
              This is a type of regression in which the response/dependent variable of the model has categorical values, say Male and Female, or Yes and No. 
              It can be used to solve classification problems. Logistic regression can be further classified into, binomial, nominal or ordinal. 
              For this case the data was of a binomial nature where we had two categories of salary earnings ( <100000USD/yr and <100000USD/yr).
              The accuracy (AUC) of the resulting model is: ",code("0.64"))
            
          ),
          # div(
          #   class = "ui segment",
          #   div(class = "ui header",
          #       h4("Model Accuracy (AUC): ")
          #       ),
          #   div(class = "sub header",
          #       textOutput(ns('auc'))
          #       )
          # ),
          
          
          
          div(
            class = "sixteen wide column",
            
            plotOutput(ns("allvars"))
          ),
          br(),
          div(
            class = "ui stackable two column grid",
            div(class = "column",
                plotOutput(ns('gender_effect'))
                ),
            div(class = "column",
                plotOutput(ns('LofEd'))
                ),
            div(class = "column",
                plotOutput(ns('YrsofExp'))
                )
          )
          )
      )
      
    )
  )
}

#' Model Server Function
#' @import data.table
#' @import DescTools
#' @import dplyr
#' @import caret
#' @import pROC
#' @noRd
#'
mod_model_server <- function(input, output, session) {
  ns <- session$ns
 
   library(pROC)
 
   library(pins)
  
  # Load the model from pins board
  modeldataboard <- board_folder("./../modeldata_board")
 
  glm_logit_model <- modeldataboard %>% pin_read("logistic_glm_model")
  test_data <- modeldataboard %>% pin_read("test_data")
  
  
  # Updating the table
  
  this_table <- reactiveVal(test_data[1:5,1:4])  
  
  observeEvent(input$update, {  
 
    t = rbind(data.frame(gender = input$gender,
                         highest_edu_level = input$edulevel,
                         professional_experience_years=input$expyrs,
                         age = input$age  
                         ),this_table())
    
    this_table(t)
    
  })
  
 observeEvent(input$submit,{
   
   
   predicted <- round(predict(glm_logit_model, newdata = this_table() ,type = "response"),2)
   
   t2 <- cbind(this_table(),predicted)
   
   output$predUI <- renderUI({
     
     dataTableOutput(ns('predictions'))
     
   })
   
   output$predictions <- renderDataTable(t2,
                                      class = 'cell-border stripe',
                                      #filter = 'top',
                                      #options = list(dom = 't'),
                                      escape = F,
                                      caption = htmltools::tags$caption(style = 'caption-side: bottom; text-align: left; color: black',
                                                                        htmltools::em('Note: The predicted values are in probabilities. 
                                                                        > 0.5 means the person falls in the category of those earning  >100,000USD/yr,
                                                                                      otherwise its <100000USD/yr')),
                                      options = list(dom = 't',scrollX = TRUE,
                                                     buttons = c('csv'),
                                                     initComplete = JS( "function(settings, json) {",
                                                                        "$(this.api().table().header()).css({'background-color': 'grey', 'color': 'black'});",
                                                                        "}")))
   
 })
  
  # Display the test data using DT package
  
  output$testdata <- renderDataTable(this_table(),
                                class = 'cell-border stripe',
                                #filter = 'top',
                                #options = list(dom = 't'),
                                escape = F,
                                caption = htmltools::tags$caption(style = 'caption-side: bottom; text-align: left; color: black',
                                                                          htmltools::em('Note: To update the table and run your predictions, 
                                                                                        tweak the dropdowns on below section,Update & Submit.')),
                                options = list(dom = 't',scrollX = TRUE,
                                                              buttons = c('csv'),
                                                              initComplete = JS( "function(settings, json) {",
                                                                                 "$(this.api().table().header()).css({'background-color': 'grey', 'color': 'black'});",
                                                                                                            "}")))
  
 
  # Model evaluation  
  
  test_prob <- predict(glm_logit_model, newdata = test_data ,type = "response")  
  
  test_roc <- roc(test_data$categories ~ test_prob) 
  
  output$auc <- renderText({
    
    model.auc <- auc(test_roc)
    
  })
  
  library(ggeffects) # for plotting and also getting the predicted probabilities 
  library(ggplot2) # will need to use the labs function on the plot 
  
  output$allvars <- renderPlot({
    
    all_effect <- ggpredict(glm_logit_model, terms = c("gender","highest_edu_level","professional_experience_years"))
    plot(all_effect) + labs(title = "All variables Effect", subtitle = "subtitle", y = "% probability of earning >100000USD/yr")
    
  })
  
  output$gender_effect <- renderPlot({
    
    gender_effect <- ggpredict(glm_logit_model, "gender")
    plot(gender_effect) + labs(title = "Gender Effect", subtitle = "subtitle",y="% probability of earning >100000USD/yr")
    
  })
  
  output$LofEd <- renderPlot({
    
    lofedu_effect <- ggpredict(glm_logit_model, "highest_edu_level")
    plot(lofedu_effect) + labs(title = "Highest level of education Effect", subtitle = "subtitle", y = "% probability of earning >100000USD/yr") +
      theme(axis.text.x = element_text(angle = 45, hjust = 1,vjust = 1))
    
  })
  
  output$YrsofExp <- renderPlot({
    
    expyrs_effect <- ggpredict(glm_logit_model, "professional_experience_years")
    plot(expyrs_effect) + labs(title = "Years of experience Effect", subtitle = "subtitle", y = "% probability of earning >100000USD/yr") +
      theme(axis.text.x = element_text(angle = 45, hjust = 1,vjust = 1))
    
  })
  
}

## To be copied in the server
# callModule(mod_rwanda_server, "rwanda_ui_1")