##select es un script para hacer seleccion en tablas
##Creado por:Diego Alzate

select <- function(data,NOMBRE){
  
  data1 <- data[data$NOMBRE %in% c(NOMBRE), ]
  data1
}
