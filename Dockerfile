FROM rocker/shiny-verse:latest

USER root

WORKDIR /shiny/dashboard

RUN apt-get update -y && apt-get install apt-utils libmagick++-dev libudunits2-dev lbzip2 libsodium-dev -y --no-install-recommends 

RUN R -e "devtools::install_version('DT', dependencies=T)"
RUN R -e "devtools::install_version('shiny.semantic', dependencies=T)"

RUN R -e "devtools::install_version('semantic.dashboard', dependencies=T)"
RUN R -e "devtools::install_version('data.table', dependencies=T)"
RUN R -e "devtools::install_version('plotly', dependencies=T)"
RUN R -e "devtools::install_version('pROC', dependencies=T)"
RUN R -e "devtools::install_version('pins', dependencies=T)"
RUN R -e "devtools::install_version('ggeffects', dependencies=T)"
RUN R -e "devtools::install_version('ggplot2', dependencies=T)"

COPY ./R/ /shiny/dashboard/R/
COPY ui.R /shiny/dashboard/
COPY server.R /shiny/dashboard/
COPY ./www/ /shiny/dashboard/www/
COPY ./modeldata_board/ /shiny/modeldata_board/
COPY ./data/ /shiny/dashboard/data/  


ENV PORT=3838
CMD R -e 'shiny::runApp("/shiny/dashboard", port = as.numeric(Sys.getenv("PORT")), host = "0.0.0.0")'
