
data.salary  <- fread("./../salary_analysis/data/salary_data_cleaned.csv")

server <- function(input,output,session){
  
  output$records <- semantic.dashboard::renderInfoBox({
    
    count.records <- data.salary[,.(count=.N)]
    count.records$count
  })
  
  output$bestpaying_industry.plot <- renderPlotly({
    
    salary.by.industry <- data.salary[,.(avg.salary=mean(annual_salary)),
                                         by=.(industry)][,.(avg.salary = sort(avg.salary, decreasing = TRUE),industry)]
    
    plot_ly(data = salary.by.industry[1:11,],
            x = ~reorder(industry,-avg.salary),
            y = ~avg.salary,
            type = "bar") %>% 
      layout(title = "Top 10 best paying industries in U.S in 2021",
             font = list(size=10, family = "Gravitas One"),
             yaxis = list(title = "Average annual salary", tickformat = "$", showgrid=FALSE),
             xaxis = list(title = "Industry", showgrid=FALSE),
             plot_bgcolor  = "rgba(0, 0, 0, 0)",
             paper_bgcolor = "rgba(0, 0, 0, 0)",
             fig_bgcolor   = "rgba(0, 0, 0, 0)"
      )%>%
      config(displayModeBar = FALSE, displaylogo = FALSE, 
             scrollZoom = FALSE, showAxisDragHandles = TRUE, 
             showSendToCloud = FALSE)
    
  })
  
  
  output$gender_comparison.plot <- renderPlotly({
    
    gender.data <- data.salary[gender %in% c("Woman","Man" ),]
    gender.data <- gender.data[,.(avg.salary = mean(annual_salary)), by=.(gender)]
    
    plot_ly(gender.data, 
            x = ~gender,
            y = ~avg.salary,
            color = ~gender,
            showlegend = FALSE,
            type = "bar") %>%
      layout(title = "Gender comparison",
             font = list(size=10, family = "Gravitas One"),
             xaxis = list(title = "Gender", showgrid=FALSE),
             yaxis = list(tickformat = "$", title = "Average annual salary", showgrid=FALSE),
             plot_bgcolor  = "rgba(0, 0, 0, 0)",
             paper_bgcolor = "rgba(0, 0, 0, 0)",
             fig_bgcolor   = "rgba(0, 0, 0, 0)")%>%
      config(displayModeBar = FALSE, displaylogo = FALSE, 
             scrollZoom = FALSE, showAxisDragHandles = TRUE, 
             showSendToCloud = FALSE)
  })
  
  
  output$edulevel.plot <- renderPlotly({
    
    # calculate the average annual salary according to the groupings of level of education.  
    salary.edulevel <- data.salary[,.(avg.salary=mean(annual_salary)),by=.(highest_edu_level)] 
    
    # plot a bar graph to see how they compare. 
    plot_ly(data = salary.edulevel,
            x = ~reorder(highest_edu_level,-avg.salary),
            y = ~avg.salary,
            color = ~highest_edu_level,
            type = "bar") %>%
      layout(title = "How different levels of education compare",
             font = list(size=10, family = "Gravitas One"),
             xaxis = list(title = "Higherst level of education", showgrid=FALSE),
             yaxis = list(title = "Average annual salary", tickformat = "$", showgrid=FALSE),
             plot_bgcolor  = "rgba(0, 0, 0, 0)",
             paper_bgcolor = "rgba(0, 0, 0, 0)",
             fig_bgcolor   = "rgba(0, 0, 0, 0)") %>%
      config(displayModeBar = FALSE, displaylogo = FALSE, 
             scrollZoom = FALSE, showAxisDragHandles = TRUE, 
             showSendToCloud = FALSE)
    
  })
  
  output$experience_yrs.plot <- renderPlotly({
    
    
    data.salary$professional_experience_years <- factor(data.salary$professional_experience_years, levels = c("1 year or less","2 - 4 years","5-7 years",
                                                                                                                    "8 - 10 years","11 - 20 years","21 - 30 years",
                                                                                                                    "31 - 40 years","41 years or more"),ordered = TRUE)
    
    # let us now calculate the average annual salary with respect to years of experience.  
    
    salary.experience <- data.salary[,.(avg.salary=mean(annual_salary)),by=.(professional_experience_years)] %>% arrange(professional_experience_years)
    
    # plot a line graph to see the relationship  
    
    plot_ly(salary.experience,
            x = ~professional_experience_years,
            y = ~avg.salary,
            type = "scatter",
            line = list(color = "pink", width = 5),
            mode = "lines+markers") %>%
      layout(title="Professional years of experience and salary?", 
             font = list(size=10, family = "Gravitas One"),
             yaxis = list(title = "Average annual salary", tickformat = "$", showgrid=FALSE),
             xaxis = list(title = "Professional years of experience", showgrid=FALSE),
             plot_bgcolor  = "rgba(0, 0, 0, 0)",
             paper_bgcolor = "rgba(0, 0, 0, 0)",
             fig_bgcolor   = "rgba(0, 0, 0, 0)") %>% 
      config(displayModeBar = FALSE, displaylogo = FALSE, 
             scrollZoom = FALSE, showAxisDragHandles = TRUE, 
             showSendToCloud = FALSE)
    
  })
  
  output$age_industry.plot <- renderPlotly({
    
    salary.tech <- data.salary[industry == "Computing or Tech",.(count=.N),by=.(age)]  
    
    # For this plot let us do a bubble chart just to explore the various data visualizations.  
    
    salary.tech %>% 
      plot_ly() %>%
      add_trace(x = ~reorder(age, -count), 
                y = ~count,
                size = ~count,
                color = ~age,
                alpha = 1.5,
                type = "scatter",
                mode = "markers",
                marker = list(symbol = 'circle', sizemode = 'diameter',
                              line = list(width = 2, color = '#FFFFFF'), opacity=0.8)) %>%
      add_text(x = ~reorder(age, -count), 
               y = ~age, text = ~count,
               showarrow = FALSE,
               color = I("black")) %>%
      layout(
        showlegend = FALSE,
        font = list(size=10, family = "Gravitas One"),
        title="Most tech guys are from which age group?",
        xaxis = list(showgrid=FALSE,
          title = "Age group"
        ),
        yaxis = list(showgrid=FALSE,
          title = "Number of Tech people from the sample."
        ),
        plot_bgcolor  = "rgba(0, 0, 0, 0)",
        paper_bgcolor = "rgba(0, 0, 0, 0)",
        fig_bgcolor   = "rgba(0, 0, 0, 0)"
      ) %>%
      config(displayModeBar = FALSE, displaylogo = FALSE, 
             scrollZoom = FALSE, showAxisDragHandles = TRUE, 
             showSendToCloud = FALSE)
  })
  
  
  output$spiderD <- renderPlotly({
    # image_file <- "../data/icons/np_ecology_1351663_FB8E59.png"
    # img.plot <- RCurl::base64Encode(readBin(image_file, "raw", file.info(image_file)[1, "size"]), "txt")
    
    f <- list(
      family = "Lato",
      size = "4rem",
      style = "regular",
      color = "black"
    )
    
    #salary.edulevel <- 
   radar.df <-  data.salary[,.(avg.salary=mean(annual_salary)),by=.(highest_edu_level)]# %>% #arrange(-avg.salary) %>%
     radar.df %>%  arrange(-avg.salary) %>%  
     plot_ly(#data.salary,
          
          type = 'scatterpolar',
          
          r = ~round(radar.df$avg.salary,0),
          
          theta = ~radar.df$highest_edu_level,
          
          fill = 'toself',
          text = ~ paste0("Level of education: ", radar.df$highest_edu_level,"\n", "Average annual salary: ", round(radar.df$avg.salary)),
          hoverinfo = "text"
          
        )  %>%
        
        layout(
          title = "Which level of education attracts more salary",
          font = f,
          polar = list(
            
            radialaxis = list(
              tickformat = "$",
              visible = T,
              
              range = c(0,max(radar.df$avg.salary))
              
            )
            
          ),
          plot_bgcolor  = "rgba(0, 0, 0, 0)",
          paper_bgcolor = "rgba(0, 0, 0, 0)",
          fig_bgcolor   = "rgba(0, 0, 0, 0)",
          showlegend = F
          
        ) %>%
       config(displayModeBar = FALSE, displaylogo = FALSE, 
              scrollZoom = FALSE, showAxisDragHandles = TRUE, 
              showSendToCloud = FALSE)
        
  }) 
  
 
  callModule(mod_model_server, "model_ui_1")
   
}