
library(shiny.semantic)
library(semantic.dashboard)
library(data.table)
library(googlesheets4)
library(plotly)

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
          menu_class = "ui top attached tabular menu",
          list(
            list(
              menu=div("Exploratory data analysis"), 
              content = 
                div(
                  div(class = "ui two column grid",
                      div(
                        class = "six wide column",
                        
                        div(
                          class = "row",
                          
                          # div(
                          #   class = "ui statistic",
                          #   div(
                          #     class = "value",
                          #     h2("87,236")
                          #   ),
                          #   div(
                          #     class = "label",
                          #    h3("Records submitted as of: ",Sys.time())
                          #   )
                          # )
                          
                          div(
                            class = "ui circular segment",
                            div(
                              class = "ui header",
                              "8975"
                            ),
                            div(
                              class = "sub header",
                              "Number of submitted records"
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
                        br(),
                        div(
                          class = "row",
                          div( class = "card_grey",
                          #plotlyOutput("edulevel.plot")
                          plotlyOutput('spiderD')
                          )
                        )
                        
                      ),
                      
                      div(
                        class = "ten wide column",
                        
                        div(
                          class = "row",
                          div( class = "card_grey",
                          plotlyOutput("bestpaying_industry.plot", height = "480px")
                          )
                        ),
                        br(),
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
              content=
                h3("Predictions")
            )
          )
        )
      )
    )
  )
  
)