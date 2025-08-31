library(tidyverse)

mtcars

cars <- mtcars %>%
  rownames_to_column("Car")

head(cars)
glimpse(cars)

cars <- cars %>%
  mutate(
    cyl = as.factor(cyl),
    gear = as.factor(gear),
    carb = as.factor(carb),
    am = factor(am, labels = c("Automatic", "Manual")),
    vs = factor(vs, labels = c("V-shaped", "Straight")))

# Plot histogram of miles per gallon (MPG)
cars %>%
  ggplot(aes(mpg)) +
  geom_histogram(bins = 10, fill = "steelblue", color = "black") +
  labs(title = "Distribution of MPG")

# Scatterplot Weight vs MPG
cars %>%
  ggplot(aes(x = wt, y = mpg)) +
  geom_point(size = 3) +
  labs(title = "Weight vs MPG")

# Create efficiency and performance metrics
cars <- cars %>%
  mutate(
    eff = mpg / (hp * wt),
    perf = as.numeric(scale(hp - qsec)))

# Summarize average MPG and HP by transmission type and cylinder count
cars %>%
  group_by(am, cyl) %>%
  summarise(
    avg_mpg = mean(mpg),
    avg_hp = mean(hp),
    .groups = "drop")

# Scatterplot of Efficiency vs Performance
cars %>%
  ggplot(aes(eff, perf, color = am, size = hp)) +
  geom_point(alpha = 0.7) +
  labs(
    title = "Efficiency vs Performance by Transmission",
    x = "Efficiency (mpg / hp*wt)",
    y = "Performance (scaled hp - qsec)",
    color = "Transmission (0=Auto, 1=Manual)",
    size = "Horsepower")

# Bar plot of car counts by transmission type
cars %>%
  ggplot(aes(am, fill = am)) +
  geom_bar() +
  labs(title = "Count of Cars by Transmission", x = "Transmission", y = "Count")

# Density plot of horsepower grouped by transmission type
cars %>%
  ggplot(aes(hp, fill = am)) +
  geom_density(alpha = 0.5) +
  labs(title = "Horsepower Density by Transmission", x = "Horsepower", y = "Density")

# Bubble plot: Horsepower vs Weight, bubble size = MPG, color = cylinders
cars %>%
  ggplot(aes(wt, hp, size = mpg, color = cyl)) +
  geom_point(alpha = 0.7) +
  labs(title = "Horsepower vs Weight (Bubble Size = MPG)")

# Line + scatter plot of MPG vs Horsepower (ordered by hp)
cars %>%
  arrange(hp) %>%
  ggplot(aes(hp, mpg)) +
  geom_line(color = "steelblue") +
  geom_point() +
  labs(title = "MPG vs Horsepower", x = "Horsepower", y = "MPG")

# Heatmap of count of cars by cylinders and gears
cars %>%
  count(cyl, gear) %>%
  ggplot(aes(x = factor(gear), y = factor(cyl), fill = n)) +
  geom_tile() +
  scale_fill_gradient(low = "lightblue", high = "darkblue") +
  labs(
    title = "Heatmap of Cylinders vs Gears",
    x = "Gear",
    y = "Cylinders",
    fill = "Count") +
  theme_minimal()

# Add car names as a column again (applies to mtcars directly)
mtcars <- mtcars %>% rownames_to_column("Car")

# Scatterplot with regression line: MPG vs Weight
cars %>%
  ggplot(aes(x = wt, y = mpg)) +
  geom_point(color = "blue", size = 3, alpha = 0.7) +
  geom_smooth(method = "lm", se = TRUE, color = "red") +
  labs(
    title = "Scatterplot of MPG vs Weight",
    x = "Weight (1000 lbs)",
    y = "Miles per Gallon (MPG)"
  ) +
  theme_minimal()

# Boxplots comparing metrics (mpg, hp, qsec) between Manual and Automatic
cars %>%
  pivot_longer(cols = c(mpg, hp, qsec), names_to = "Metric", values_to = "Value") %>%
  ggplot(aes(x = am, y = Value, fill = am)) +
  geom_boxplot(alpha = 0.7) +
  facet_wrap(~ Metric, scales = "free_y") + 
  labs(
    title = "Manual vs Automatic Comparison",
    x = "Transmission Type",
    y = "Value"
  ) +
  theme_minimal() +
  theme(legend.position = "none")


