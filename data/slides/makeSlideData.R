library(data.table)

set.seed(1)
nrec <- 50

connTab <- data.table(
    uid = sample(c("du43", "b4ud", "37du", "jhje"), nrec, replace = TRUE),
    type = sample(c("desktop", "phone"), nrec, replace = TRUE),
    date = sample(as.Date(1:5, "2019-10-31"), nrec, replace = TRUE)
)

userTab <- data.table(
    uid = c("du43", "b4ud", "37du", "jhje"),
    fname = c("Jack", "Jill", "Hansel", "Gretel"),
    lname = c("Hill", "Hill", "Woods", "Woods"),
    ccode = c("US", "US", "DE", "DE")
)

connTab[, conn:=(1:.N), by = names(connTab)]

mergTab <- userId[connTab, on = "uid"]

fwrite(connTab, "./data/slides/conntab.csv")
fwrite(userTab, "./data/slides/usertab.csv")
fwrite(mergTab, "./data/slides/mergtab.csv")
