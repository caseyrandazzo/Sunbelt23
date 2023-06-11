#-----------------Temporal network analysis-----------------#
#Casey Randazzo, 6/10/23

#Adapted from https://programminghistorian.org/en/lessons/temporal-network-analysis-with-r
#Visit url for how to set up csv files

# Install Packages 
#install.packages("sna")
#install.packages("tsna")
#install.packages("ndtv")
#install.packages("readxl")

# Open Libraries 
library("sna")
library("tsna")
library("ndtv")
library("readxl")

# Import Static Data
#Visit above URL for how to set up
StaticEdges <- read.csv("~/Desktop/Sunbelt_June/Sunbelt_June/Sunbelt_Static_Edges_6_10_2.csv")
VertexAttributes <- read.csv("~/Desktop/Sunbelt_June/Sunbelt_June/Sunbelt_Static_Vertex_6_10_2.csv")

# Create Static Network & Visualize
staticnet <- network(
  StaticEdges,
  vertex.attr = VertexAttributes,
  vertex.attrnames = c("vertex.id", "name", "displaced", "setting",
                       "CommunityMobilization_Percent",	"DirectAssistance_Percent",
                       "DisasterResponse_Percent", "Housing_Percent"),
  directed = TRUE,
  bipartite = FALSE,
  multiple = FALSE #doesn't work with multiples, add weight edges instead
)
plot(staticnet)

#View details
staticnet

#Note: Node IDs have to be sequential numbers. Ex: If nodes are 1,2,5,10, you'll get an error

# Import Dynamic Data
#Visit above URL for how to set up
DynamicEdges <- read.csv("~/Desktop/Sunbelt_June/Sunbelt_June/Sunbelt_Dynamic_Edges_6_10_3.csv")
DynamicNodes <- read.csv("~/Desktop/Sunbelt_June/Sunbelt_June/Sunbelt_Dynamic_Vertex_6_10_2.csv")

# Make the Temporal Network
dynamicTH <- networkDynamic(
  staticnet,
  edge.spells = DynamicEdges,
  vertex.spells = DynamicNodes
)

# Check the temporal network
network.dynamic.check(dynamicTH)

# Plot network dynamic object as a static image
plot(dynamicTH)

#filmstrip doesn't allow for multiples
# Plot our dynamic network as a filmstrip
filmstrip(dynamicTH, displaylabels = FALSE)

# Calculate how to plot an animated version of the dynamic network
compute.animation(
  dynamicTH,
  animation.mode = "kamadakawai",
  slice.par = list(
    start = 44443,
    end = 44644,
    interval = 7,
    aggregate.dur = 1,
    rule = "any"
  )
)

# Render the animation and open it in a web browser
#See https://kateto.net/wp-content/uploads/2016/04/Sunbelt%202016%20R%20Network%20Visualization%20Workshop.R
#for visualizing other types of edges/attributes
render.d3movie(
  dynamicTH,
  displaylabels = FALSE,
  # Save to desktop
  #file = "~/Desktop/Sunbelt_June/Sunbelt_June/network610.html",
  # Add labels 
    vertex.tooltip = function(slice) {
    paste(
      "<b>Name:</b>", (slice %v% "name"),
      "<br>",
      "<b>Displaced:</b>", (slice %v% "displaced"),
      "<br>",
      "<b>Online/Offline:</b>", (slice %v% "setting"),
      "<br>",
      "<b>Discussed Moblization:</b>", (slice %v% "CommunityMobilization_Percent"),
      "<br>",
      "<b>Discussed Direct Assistance:</b>", (slice %v% "DirectAssistance_Percent"),
      "<br>",
      "<b>Discussed Disaster Response:</b>", (slice %v% "DisasterResponse_Percent"),
      "<br>",
      "<b>Discussed Housing:</b>", (slice %v% "Housing_Percent")
    )
  }
)
