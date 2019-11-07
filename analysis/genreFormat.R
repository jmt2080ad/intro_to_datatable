library(data.table)
library(ggplot2)

dat <- fread("unzip -p ./data/discogs/labelGenreYear.zip")

## plotting formats over time, before 2018
ryf <- dat[year != 0 & year < 2018,
           .(rcount = length(unique(release_id))),
           by = c("year", "format")]

ggplot(ryf, aes(year, rcount, color = format)) +
    geom_line()

## plotting Dub, UK Garage, and Dubstep, over time, before 2018
d2d <- dat[year != 0 & year < 2018 & style %in% c("Dub", "UK Garage", "Dubstep"),
           .(rcount = length(unique(release_id))),
           by = c("year", "style")]

ggplot(d2d, aes(year, rcount, color = style)) +
    geom_line()

## disco and its side bands
psb <- merge(unique(dat[,.(release_id, style, year)]),
             unique(dat[style == "Disco", .(release_id)]))
psb <- psb[year != 0 & year < 2018, .N, by = .(year, style)]

ptl <- psb[, !"year"
           ][, .(total = sum(N)), by = "style"
             ][total > 300 & style != "Disco"]

ggplot(ptl, aes(style, total)) +
    geom_bar(stat = "identity") +
    theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5))

ggplot(merge(psb, ptl[style != "Disco"], by = "style"), aes(year, N, fill = style)) +
    geom_bar(stat = "identity")
