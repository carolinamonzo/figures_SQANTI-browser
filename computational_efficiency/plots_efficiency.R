library(ggplot2)
library(RColorConesa)
library(tidyr)
library(ggpubr)
library(scales)

# We read the table
tabla <- read.csv("times_memory.csv")
tabla$RAM <- tabla$RAM * 10**(-6)
colorSpecies <- colorConesa(7, palette = "complete")

# Pivoting the table to "long" format
tabla_long <- pivot_longer(tabla,
                           cols = c(time_seconds, RAM),
                           names_to = "metric",
                           values_to = "value")
if (!dir.exists("plots")) {
  dir.create("plots")
}

for (i in 1:7){
for (j in 1:7){
  ggplot(tabla_long, aes(x =num_isoforms, value, color = metric)) +
  geom_line(size = 1) +
  geom_point(size = 3.5, shape = 21, color = "white", fill = colorSpecies[j]) +
  facet_wrap(
    ~metric,
    scales = "free_y",
    labeller = labeller(
      metric = c(
        time_seconds = "Time (s)",
        RAM = "RAM (GB)"
      )
    )
  ) +
  scale_color_manual(values = c(
    time_seconds = colorSpecies[i],
    RAM = colorSpecies[i]
  )) +
  labs(
    x = "Number of isoforms",
    y = "Value"
  ) +
  theme_bw() +
  theme(legend.position = "none",
        panel.grid = element_blank(),
        strip.background = element_rect(fill="white"),
        panel.spacing = unit(1.5, "cm"),
        plot.margin=margin(10,15,10,10),
        axis.text.x = element_text(angle = 35, hjust = 1)) +
  expand_limits(x=0,y=0) +
  scale_x_continuous(expand = expansion(mult = c(0.0, 0.05))) +
  scale_y_continuous(expand = expansion(mult = c(0.0, 0.1))) 
  #scale_x_continuous(expand = c(0, 0)) + scale_y_continuous(expand = c(0, 0)) 
  ggsave(paste("plots/plot_",i,"_",j,".pdf",sep=""))
}}

  