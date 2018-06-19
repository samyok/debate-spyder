heartatk4R <- read.delim("C:/Users/SSO103/Downloads/Shared with campers/datasets/heartatk4R.txt")

df = heartatk4R
str(df)

df$DIAGNOSIS = as.factor(df$DIAGNOSIS)
df$SEX  = as.factor(df$SEX)
df$DRG = as.factor(df$DRG)
df$DIED = as.factor(df$DIED)
df$LOS = as.numeric(df$LOS)
df$AGE = as.numeric(df$AGE)

df = df[order(df$AGE),]

df$cpd = df$CHARGES/df$LOS
df$ag = floor(df$AGE/10)*10

boxplot(df$LOS ~ df$ag)

x2 = subset(df, SEX == "F")
x3 = subset(x2, AGE>=80)

summary(x3)
