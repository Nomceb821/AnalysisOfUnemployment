#Import data 
file_path <- "C:/Users/1876343/Desktop/Project/Unemployment.csv"
data1 <- read.csv(file = file_path, sep = ',', skip = 4)
head(data1)
View(data1)

names(data1)
#Required libraries 
library('ggplot2')
library('dplyr')
library('tidyr')

#Checking the names of the column
names(data1)

#Extracting information I need for my plot
library(tidyverse)
df <- data1[data1$Country.Name %in% c('South Africa', 'Algeria',
                                      'Ghana'), ]

# Adjust pivot_longer to specify column
data_long <- df %>%
  pivot_longer(cols = c("X2000" : "X2022"), names_to = "Year", 
               values_to = "UnemploymentRate")

# Convert Year to numeric
data_long$Year <- as.numeric(gsub("X", "", data_long$Year))

# Remove rows with NA values in UnemploymentRate
data_long_clean <- data_long %>% drop_na(UnemploymentRate)

# Plot
ggplot(data_long_clean, aes(x = Year, y = UnemploymentRate,
                            color = Country.Name, 
                            group = Country.Name)) +
  geom_line(size = 1) +
  geom_point(size = 3) +
  scale_color_manual(values = c('brown', 'purple', 'red'),
                     labels = c('Algeria', 'Ghana', 'South Africa')) +
  scale_y_continuous(limits = c(0,35), 
                     breaks = seq(0, 35, by = 5), expand = c(0,0))+
  scale_x_continuous(limits = c(2000,2022), 
                     breaks = seq(2000, 2022, by = 2), expand = c(0,2)) +
  labs(title = "Trends of Unemployment Rate in Algeria,
       Ghana, and South Africa from the period of 2000 to 2022",
       x = "Year",
       y = "Unemployment Rate") +
  theme_minimal() +
  theme(panel.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.line = element_line(colour = 'black'),
        axis.title = element_text(size = 12, face = 'bold'),
        axis.text.x = element_text(face = 'bold', color = 'black'),
        axis.text.y = element_text(face = 'bold', color = 'black'),
        plot.title = element_text(size = 16, face = 'bold',
                                  hjust = 0.5, vjust = 2),
        legend.title = element_text(size = 14, face = 'bold', vjust = 1),
        legend.text = element_text(face = 'bold', color = 'black', size = 12)
  ) 

#Saving the image 
ggsave("C:/Users/1876343/Desktop/Project/plot1.png", 
       plot = last_plot(), width = 10, height = 8, dpi = 1300)




#CREATING A MAP


#Required library 
library('viridis')
library('sf')

#load shape file

shapefile <- st_read('C:/Users/1876343/Desktop/GIS/Africa_Boundaries.shp')

#View the file to check names of the columns
View(shapefile)

# Rename the column in shape file or data1
colnames(shapefile)[colnames(shapefile) == "ISO"] <- "Country_Code"
colnames(data1)[colnames(data1) == "Country.Code"] <- "Country_Code"

#Merge the data 
merged_data <- shapefile %>%
  left_join(data1, by = 'Country_Code')

#Creating Map 
ggplot(merged_data) +
  geom_sf(aes(fill = X2021)) +
  scale_fill_viridis(option = "inferno",                              
                     limits = c(0, 30),                       
                     breaks = c(10, 20,30),
                     labels = c('Low', 'Moderate', 'High')) + 
  labs(title = 'Geographic Distribution of Unemployment rate in 2021',
       fill = 'Unemployment Rate', 
       x = "Longitude (\u00B0)", y = "Latitude (\u00B0)") +
  theme_minimal() +
  theme(panel.grid.major = element_blank(),
        panel.background = element_blank(),
        panel.grid.minor = element_blank(),
        legend.title = element_text(size = 14, face = 'bold', 
                                    margin = margin(b = 15)),
        legend.text = element_text(size = 10, face = 'bold'),
        legend.key.size = unit(1, 'cm'),
        plot.title = element_text(size = 14, face = 'bold',
                                  hjust = 0.5),
        axis.title = element_text(size = 10, face = 'bold', color = 'black')
  )

#Saving the image 
ggsave("C:/Users/1876343/Desktop/Project/plot.png", 
       plot = last_plot(), width = 10, height = 7, dpi = 1300)




#3, CATAGORICAL DATA

#Creating categorial variable by randomly assigning the IncomeGroup

data1$incomeGroup <- sample(c('Low income', 'Middle income', 'High income'),
                            nrow(data1), replace = TRUE)

#Count the number of low, high, income countries
#Aim: Is to count the number of countries income Groups(low, middle, and high)

income_group<- data1 %>%
  #FILTERING OVER THE THREE INCOME GROUPS 
  filter(incomeGroup %in% c('Low income', 'Middle income', 'High income')) %>% 
  group_by(incomeGroup) %>% # group by each income
  summarise(count = n())

#Plot 
ggplot(data = income_group, aes(x = incomeGroup, y = count)) +
  geom_bar(stat = 'identity', width = 0.5, fill = 'lightblue') +
  labs( title = "Global Count of Countries by Income Classification",
        x = 'Income Groups',
        y = 'Total count ') +
  scale_y_continuous(expand = c(0,0))+
  scale_x_discrete(expand =c(0,0.5))+
  theme_minimal() +
  theme(panel.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        plot.title = element_text(hjust = 0.5,face = 'bold',size = 16),
        axis.title = element_text(size = 12, face = 'bold', color = 'black'),
        axis.text.x = element_text(face = 'bold', color = 'black'),
        axis.text.y = element_text(face = 'bold', color = 'black'),
        axis.line = element_line(color = 'black'),
        axis.ticks = element_line(color = 'black')
  )

#Saving the image 
ggsave("C:/Users/1876343/Desktop/Project/plot2.png", 
       plot = last_plot(), width = 10, height = 7, dpi = 1300)
