### R School
### 6-16-2020
### Lesson 0 - Exercise results

##### Group 1 #####
as.character(mtcars$am)
as.factor(mtcars$am)
as.logical(mtcars$am)
#all of these work, no error messages

manual <- which(mtcars$am == 1)

round(min(mtcars$mpg[manual]), digits = 1)
round(max(mtcars$mpg[manual]), digits = 1)
# This will do these calculations for the mpgs of the manual cars

# To do it for all cars:
round(min(mtcars$mpg), digits = 1)
round(max(mtcars$mpg), digits = 1)

##### Group 2 #####
head(airquality)
View(airquality)

?class
class(airquality$Ozone)
head(airquality$Ozone)
numair<-as.numeric(airquality$Ozone)
class(numair)
head(numair)

class(airquality$Wind)
intwind<-as.integer(airquality$Wind)
class(intwind)
head(airquality$Wind)
head(intwind)
?mean
mean(na.omit(airquality$Ozone))

summary(airquality)

##### Group 3 #####
class(PlantGrowth$group)
as.numeric(PlantGrowth$group)
as.character(PlantGrowth$group)
toupper(PlantGrowth$group)

head(iris)
length(iris$Petal.Width)
unique(iris$Petal.Width)
length(unique(iris$Petal.Width))
