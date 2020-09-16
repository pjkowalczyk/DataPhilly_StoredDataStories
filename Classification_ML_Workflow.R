if(!require(pacman)) install.packages("pacman")
pacman::p_load("tidyverse", "magrittr", "ggthemes", "gcookbook", "RColorBrewer", "caret",
               "corrplot", "IDPmisc", "randomForest", "e1071", "class")

DataPhilly_colors <- c('#004785', # Wharton blue
                       '#f74902', # Flyers orange
                       '#a90533', # Wharton red
                       '#004953', # Eagles (midnight) green
                       '#ffc600', # Drexel yellow
                       '#c1c6c8'  # Temple silver
)

DataPhilly_theme <- function(base_family = "serif",
                             base_size = 12,
                             plot_title_family = 'sans',
                             plot_title_size = 20,
                             plot_title_color = DataPhilly_colors[1],
                             grid_col = '#dadada') {
  # use these variables
  aplot <-
    ggplot2::theme_minimal(base_family = base_family, base_size = base_size) #piggyback on theme_minimal
  aplot <- aplot + theme(panel.grid = element_line(color = grid_col))
  aplot <-
    aplot + theme(
      plot.title = element_text(
        size = plot_title_size,
        family = plot_title_family,
        color = plot_title_color
      )
    )
  aplot
}

df <- read.csv('data/BioDeg.csv', stringsAsFactors = FALSE) %>%
  NaRV.omit()

# bookkeeping
ID <- colnames(df)[1]
df$EndPt <- as.factor(df$EndPt)
EndPt <- colnames(df)[2]
descriptors <- colnames(df)[3:ncol(df)]

ggplot2::ggplot(df, aes(x = EndPt, fill = EndPt)) +
  geom_bar() +
  scale_fill_manual(values = DataPhilly_colors) +
  DataPhilly_theme() +
  labs(
    title = 'Biodegradability Endpoint Distribution',
    subtitle = 'NRB = Not Readily Biodegradable; RB = Readily Biodegradable',
    color = 'EndPt',
    x = 'Biodegradability',
    y = 'Count',
    caption = 'DataPhilly Workshop: StoredDataStories'
  ) +
  geom_text(stat='count', aes(label=..count..), vjust=-1)

# stratified train / test split -------------------------------------------

inTrain = caret::createDataPartition(df$EndPt, p = 0.8, list = FALSE)
dfTrain <- df[inTrain, ]
dfTest <- df[-inTrain, ]

dfTrain$set <- 'train'
dfTest$set <- 'test'

df <- rbind(dfTrain, dfTest)

ggplot(df, aes(x = EndPt,  group = set)) +
  geom_bar(aes(y = ..prop.., fill = factor(..x..)), stat = "count") +
  geom_text(aes(label = scales::percent(..prop..),
                y = ..prop..),
            stat = "count",
            vjust = -.5) +
  scale_fill_manual(values = DataPhilly_colors) +
  DataPhilly_theme() +
  labs(
    title = 'Biodegradability Endpoint Distribution: Train & Test Sets',
    subtitle = 'NRB = Not Readily Biodegradable; RB = Readily Biodegradable',
    color = 'EndPt',
    x = 'Biodegradability',
    y = "Percent",
    caption = 'DataPhilly Workshop: StoredDataStories'
  ) +
  facet_grid( ~ set) +
  scale_y_continuous(labels = scales::percent)

X_train <- dfTrain %>%
  select(-CASRN, -EndPt, -set)
y_train <- dfTrain %>%
  select(EndPt) %>%
  data.frame()

X_test <- dfTest %>%
  select(-CASRN, -EndPt, -set)
y_test <- dfTest %>%
  select(EndPt) %>%
  data.frame()

# curate data -------------------------------------------------------------

## near-zero variance descriptors

nzv <- caret::nearZeroVar(X_train, freqCut = 100/0)
colnames(X_train[ , nzv])
X_train <- X_train[ , -nzv]
### and
X_test <- X_test[ , -nzv]

## highly correlated descriptors

correlations <- cor(X_train)
corrplot::corrplot(correlations, order = 'hclust')
highCorr <- findCorrelation(correlations, cutoff = 0.85)
colnames(X_train[ , highCorr])
X_train <- X_train[ , -highCorr]
### and
X_test <- X_test[ , -highCorr]

correlations <- cor(X_train)
corrplot::corrplot(correlations, order = 'hclust')
## center & scale descriptors

preProcValues <- preProcess(X_train, method = c("center", "scale"))

X_trainTransformed <- predict(preProcValues, X_train)
### and
X_testTransformed <- predict(preProcValues, X_test)

# build models ------------------------------------------------------------

train <- cbind(y_train, X_trainTransformed)
test <- cbind(y_test, X_testTransformed)

## Random Forest Classification

rf <- randomForest(EndPt ~ ., data = train, importance = TRUE)

rf.pred <- predict(rf, X_testTransformed)

xtab <- table(rf.pred, dfTest$EndPt)

caret::confusionMatrix(xtab)

## Support Vector Machine Classification

sVect <- svm(
  EndPt ~ .,
  data = train,
  method = "C-classification",
  kernal = "radial",
  gamma = 0.1,
  cost = 10
)

sVect.pred <- predict(sVect, X_testTransformed)

xtab <- table(sVect.pred, dfTest$EndPt)

caret::confusionMatrix(xtab)

## k-Nearest Neighbors

neighbors <- knn(X_trainTransformed, X_testTransformed, cl = dfTrain$EndPt, k = 5)

xtab <- table(neighbors, dfTest$EndPt)

caret::confusionMatrix(xtab)
