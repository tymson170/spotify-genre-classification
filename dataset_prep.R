library(spotifyr)
library(tidyverse)

playlist_names <- c(
  "Blues Classics", "Blues Standards", "Electric Blues Classics", "Classic Blues Guitar",
  "Classical Essentials", "Classical New Releases", 
  "Country's Greatest Hits", "Hot Country", "Country Top 50", 
  "Fresh Folk", "Roots Rising", 
  "jazz classics the best tunes in jazz history", 
  "Hip-Hop Drive", "Gold School", "RAP GENERACJA",
  "Reggae Classics", "Summer Sunshine Reggae", "celebrating the film bob marley one love", "Reggae Party", 
  "Rock Classics", "All New Rock",
  "Metal Essentials", "00s Metal Classics", "10s Metal Classics"
  )

pb <- txtProgressBar(min = 0,
                     max = length(playlist_names),
                     style = 3,
                     width = 50,
                     char = "=") 

dataset <- NULL

for (p in 1:length(playlist_names)) {
  
  search_results <- search_spotify(
    q = playlist_names[p], 
    type = c("playlist"), 
    authorization = get_spotify_access_token()
  )
  
  playlist_id <- search_results %>%  
    select(id, name, uri) %>% 
    slice_head(n = 1) %>% 
    select(id) %>% 
    pull()
  
  p_dt <- get_playlist_audio_features(
    username = "Spotify",
    playlist_uris = c(playlist_id), 
  )
  
  if (p == 1) {
    dataset <- p_dt
  }
  else {
    dataset <- rbind(dataset, p_dt)
  }

  setTxtProgressBar(pb, p)
}

View(dataset)

df <- as.data.frame(dataset)

df <- df[,-which(sapply(df, class) == "list")]

# write.csv(df, "spotify-genres-classification.csv")
write.csv(df, "spotify-genres-classification-new.csv")

View(df)


