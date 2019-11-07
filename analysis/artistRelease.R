library(data.table)
library(ggplot2)

amb <- fread("unzip -p ./data/discogs/artistMember.zip")
anm <- fread("unzip -p ./data/discogs/artistName.zip")
rel <- fread("unzip -p ./data/discogs/releaseName.zip")
lab <- fread("unzip -p ./data/discogs/labelGenreYear.zip")

nameOverTime1 <- function(regex){
    art <-
        unique(lab[,.(release_id, year)])[
            rel[
                anm[
                    amb[grepl(regex, artist_member)]
                  , on = "artist_id"]
              , on = "artist_id"]
          , on = "release_id"]

    art <- art[, .N, by = .(release_id, year)
               ][ year != 0][order(year)]
    
    ggplot(art, aes(year, N)) +
        geom_bar(stat = "identity")
}

## OR a different way to merge

nameOverTime2 <- function(regex){
    art <-
        merge(unique(lab[,.(release_id, year)]),
              merge(rel,
                    merge(anm, 
                          amb[grepl(regex, artist_member)],
                          all.y = T,
                          by = "artist_id"),
                    all.y = T,
                    by = "artist_id"),
              all.y = T,
              by = "release_id")[]

    art <- art[, .N, by = .(release_id, year)
               ][ year != 0 ][ order(year) ]
    
    ggplot(art, aes(year, N)) +
        geom_bar(stat = "identity")
}

nameOverTime1("Paul McCartney")
nameOverTime2("Paul McCartney")
