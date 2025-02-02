library(shiny)
library(leaflet)
library(lubridate)
#library(magrittr)
#library(dplyr)
#library(tigris)
#library(shinythemes)

source("select.R")

data <- read.csv("data/Estaciones.csv")
datos <- read.csv("data/1_lagunas.csv", sep=";", dec=",")
datos$FECHA <- as.Date(datos$FECHA, format='%d/%m/%Y')
detos <- read.csv("data/tabla.csv", sep=";", dec=",")
Buitrago <- readOGR("data/Sendero_Laguna_Buitrago.shp")
Chingaza <- readOGR("data/Sendero_Laguna_Chingaza.shp")
Siecha <- readOGR("data/Sendero_Laguna_Siecha.shp")
Suasie <- readOGR("data/Sendero_Suasie.shp")
Pnn <- readOGR("data/Chingaza1.shp")

# Definir UI ----

ui<-fluidPage(
  
#  theme = shinytheme("cerulean"),
  
  titlePanel(strong("Visor de precipitación asociada a los senderos ecoturisticos en el Parque Nacional Natural Chingaza")),

  sidebarLayout(
    
    sidebarPanel(h3(strong("Parque Nacional Chingaza")),
                 p("El Parque Nacional Natural Chingaza, es un tesoro natural y cultural del centro de Colombia, la magia de sus montañas guarda secretos y pensamientos heredados de  los Muiscas y los Guayupes, pueblos indígenas que resguardaban este territorio, así como de comunidades campesinas que habitaron la región hace menos de 40 años. En la actualidad es refugio de fauna y flora de los Andes que revelan al visitante el secreto de la vida"),
                 p("Está ubicado en la cordillera oriental de los Andes, al noreste de Bogotá conformado por 11 municipios, 7 de Cundinamarca: Fómeque, Choachí, La Calera, Guasca, Junín, Gachalá y Medina, y 4 municipios del Meta: San Juanito, El Calvario, Restrepo y Cumaral."),
                 p("Fuente:https://www.parquesnacionales.gov.co/portal/es/ ecoturismo/parques/region-amazonia-y-orinoquia/parque-nacional-natural-chingaza/"),
                 div(tags$img(src="img1.jpg", height = 240, width = 350), style ="text-align: center;")
    ),
    
    mainPanel(
      tabsetPanel(
        
        tabPanel(h3(strong("Estaciones y Senderos")),
                 fluidPage(leafletOutput("mymap3"),
                           br(),
                           h4("El Parque Nacional Natural Chingaza cuenta con estaciones metereológicas de IDEAM y la Empresa de Acueducto y Alcantarillado de BogotÃ¡ (EAAB), de las cuales en el mapa se proyecta la ubicación de 7 estaciones (Santa Cruz de Siecha-IDEAM, Chuza campamento monterredondo-EAAB, Laguna Chingaza-EAAB, Laguna Seca-EAAB, Palacio el angulo-EAAB, Chingaza campamento-EAAB y Alto del gorro-EAAB) asociadas a 4 senderos ecoturisticos (sendero Lagunas de Siecha, Lagunas de Buitrago, Suasie y las Plantas del Camino).")
                           
                 )),
        
        tabPanel(h3(strong("Datos Estaciones meteorológicas")),
                 br(),
                 br(),
                 sidebarPanel(h4(strong("Seleccione la variable a graficar")),
                              
                              selectInput("NOMBRE",
                                          strong("Seleccione la estación"),
                                          datos$"NOMBRE"),
                              p("En esta lista desplegable puede seleccionar la estacion metereológica de su interes, al costado derecho se presentan los registros diarios de precipitación en tabla o gráfico."),
                              br(),
                              p("Puede descargar los datos de las estaciones en el boton descargar"),
              # Boton descargar
                downloadButton("downloadData", "Descargar")
                              
                 ),
                 
                 
                 mainPanel(
                   tabsetPanel( tabPanel(h4(strong("Tabla Datos")),
                                         fluidRow(column(5,
                                                         tableOutput('table2')),
                                         )),
                                tabPanel(h4(strong("Graficas Precipitación")),
                                         plotOutput("plot1")
                                         
                         ),
                   )
                 )
      ),
          tabPanel(h3(strong("Créditos")),
                   br(),
                   br(),
                   h4("Este visor fue desarrollado por los estudiantes externos Gabriel Felipe Rubiano Arambulo y Elkin Mauricio Pedraza Sarmiento; quienes hicieron parte de la clase, gracias a la oferta de los cursos libres de la Universidad Agraria de Colombia - UNIAGRARIA. El visor presentado, corresponde al proyecto final de la materia SIG y Percepciones Remotas."),
                   br(),
                   div(tags$img(src="gabriel.jpg", height = 200, width = 200), img(src="elkin.jpg", height = 200, width = 200), style ="text-align: center;"),
                   br(),
                   div(tags$img(src="logo.jpg", height = 150, width = 650), style ="text-align: center;")
)
    )
  )
)
)
# Definir LÃ³gica del servidor ----

server<-function(input, output){
  
  
      output$mymap3 <- renderLeaflet({    
    leaflet(data=data) %>% addTiles(group="OpenStreetMap") %>% #Add default OpenStreetMap map tiles

#marcadores personalizados

#    caminante <- makeIcon(iconUrl = "https://www.freeiconspng.com/uploads/walking-icon-16.png",
#                           iconWidth = 9, iconHeight = 9)
#    estacion <- makeIcon(iconUrl = "https://www.freeiconspng.com/uploads/rain-cloud-icon-16.png",
#                               iconWidth = 9, iconHeight = 9)

          #poligono PNN Chingaza      
      addPolygons(data=Pnn, weight = 5, fillColor = "darkgreen", group = "Parque Nacional Natural Chingaza") %>%

          #Marcadores estaciones 
      addMarkers(lng = data$X, lat = data$Y, popup = paste(data$ID,"", data$NOMBRE), group = "Estaciones" ) %>%
#icon = estacion

          #Senderos - rutas y marcadores
      addPolylines(data=Buitrago, weight = 3, fillColor = "orange", group = "Sendero Lagunas de Buitrago") %>%
      addMarkers(lng=-73.8422, lat=4.73663, label = ("Sendero Lagunas de Buitrago"), labelOptions = labelOptions(textOnly = TRUE, textsize = "20px"), popup = paste("<h3>Lagunas de Buitrago<h3>", img(src="buitrago.jpg", height = 140, width = 300)), group = "Sendero Lagunas de Buitrago") %>%
#icon = caminante     

      addPolylines(data=Chingaza, weight = 3, fillColor = "orange", group = "Sendero Las Plantas del Camino") %>%
      addMarkers(lng=-73.75756537897637, lat=4.529504652239183, label = ("Sendero Las Plantas del Camino"), labelOptions = labelOptions(textOnly = TRUE, textsize = "20px"), popup = paste("<h3>Laguna de Chingaza<h3>", img(src="plantas.jpg", height = 140, width = 300)), group = "Sendero Las Plantas del Camino") %>%
#icon = caminante
                
      addPolylines(data=Siecha, weight = 3, fillColor = "orange", group = "Sendero Lagunas de Siecha") %>%
      addMarkers(lng=-73.86656043785102, lat=4.768857626255013, label = ("Sendero Lagunas de Siecha"), labelOptions = labelOptions(textOnly = TRUE, textsize = "20px"), popup = paste("<h3>Lagunas de Siecha<h3>", img(src="sie.jpg", height = 140, width = 300)), group = "Sendero Lagunas de Siecha") %>%
#icon = caminante
                
      addPolylines(data=Suasie, weight = 3, fillColor = "orange", group = "Sendero SuaSie") %>%
      addMarkers(lng=-73.72621017664973, lat=4.627364816174776, label = ("Sendero SuaSie"), labelOptions = labelOptions(textOnly = TRUE, textsize = "20px"), popup = paste("<h3>Sendero SuaSie<h3>", img(src="suasie.jpg", height = 140, width = 300)), group = "Sendero SuaSie") %>%
#icon = caminante
          
#Layers control
      
      addLayersControl(
        
        baseGroups = c("OpenStreetMap"),
        
        overlayGroups = c("Parque Nacional Natural Chingaza", "Estaciones", "Sendero Lagunas de Buitrago", "Sendero Las Plantas del Camino", "Sendero Lagunas de Siecha", "Sendero SuaSie"),
        
        options = layersControlOptions(collapsed = TRUE))
    
  })
#Tablas y graficas
  
  selectedData <- reactive ({
    datos[,input$ycol]
  })
  
  x <- reactive ({
    
    sel <- select(datos,input$NOMBRE)
    sel$FECHA
    
  })
  
  y <- reactive ({
    
    sel2 <- select(datos,input$NOMBRE)
    sel2$PRECIPITACION
    
  })
  
  output$table2 <- renderTable({ select(detos,input$NOMBRE) })
  
  output$plot1 <- renderPlot({ plot(x(), y(), type = "l",
                                    col = "darkblue", pch =1, cex= 1, xlab = "Año", ylab= "mm")})
  
# Downloadable csv of selected dataset ----
  
  output$downloadData <- downloadHandler(
    filename = function() {
    paste("estaciones-", Sys.Date(), ".csv", sep = "")
      },
    content = function(file) {
      write.csv(datos,file)
    })
#  output$downloadData <- downloadHandler(
#    filename = function() {
#      paste(input$datosset, ".csv", sep = "")
#    },
#    content = function(file) {
#      write.csv(datossetInput(), file, row.names = FALSE)  
#    })
}
# Run the app ----

shinyApp(ui = ui, server = server)