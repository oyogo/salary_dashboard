
library(shiny.semantic)
library(semantic.dashboard)
library(data.table)
library(DT)
#library(googlesheets4)
library(plotly)

source("R/mod_model.R")

ui <- shiny.semantic::semanticPage(
  
  includeCSS("www/style.css"),
  
  div(
    class = "ui inverted vertical masthead center segment",
    id = "banner",
    h1("Salary analysis dashboard"),
    
    br(),
    list(
      menu = "",
      tagList(
        tabset(
          id = "menu",
          menu_class = "ui tabular menu",
          list(
            list(
              menu=div("Exploratory data analysis"), 
              content = 
                div(
                  div(class = "ui two column grid",
                      div(
                        class = "six wide column",
                        br(),
                        div(
                          class = "ui centered grid",
                       
                          div(
                            class = "ui grey inverted circular segment",
                            div( class = "ui statistic",
                            div(
                              class = "value",
                              #h1("8975")
                              infoBoxOutput('records')
                            ),
                            #div(
                              #class = "sub header",
                              div( class = "label",
                              paste0("Number of submitted records as of: ", Sys.Date() )
                              )
                            )
                          )
                       
                        ),
                        br(),
                        div(
                          class = "row",
                          div( class = "card_grey",
                          plotlyOutput("gender_comparison.plot", height = "280px")
                          )
                        ),
                        div(
                          class = "row",
                          div( class = "card_grey",
                               plotlyOutput('spiderD') 
                          )
                        )
                        
                      ),
                      
                      div(
                        class = "ten wide column",
                        
                        div(
                          class = "row",
                          div( class = "card_grey",
                          plotlyOutput("bestpaying_industry.plot", height = "517px")
                          )
                        ),
                        div(
                          class = "row",
                        
                           div(
                             class = "ui two column grid",
                            
                             div(
                               class = "column",
                              div( class = "card_grey",
                                   plotlyOutput("experience_yrs.plot")
                              )
                            ),
                            
                            div(
                              class = "column",
                              div( class = "card_grey",
                                   plotlyOutput("age_industry.plot")
                                   
                              )
                            )
                            
                          )
                        )
                        
            
                     ) 
                    
                  )
                )
            ),
            list(
              menu=div("Prediction"),
              content= div( 
              mod_model_ui('model_ui_1')
              )
            )
          )
        )
      )
    )
  )
  
)