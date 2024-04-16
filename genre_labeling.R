library(tidyverse)

df <- read.csv(file = "spotify-genres-classification.csv")

View(df)
df <- df %>% 
  select(-c("X", "playlist_id", "playlist_img", "playlist_owner_name", "playlist_owner_id", "track.id", "analysis_url", "added_at", "is_local", "primary_color", "added_by.href", "added_by.id", "added_by.type", "added_by.uri", "added_by.external_urls.spotify", "track.disc_number", "track.episode", "track.href", "track.is_local", "track.preview_url", "track.track", "track.track_number", "track.type", "track.uri", "track.album.album_type", "track.album.href", "track.album.id", "track.album.name", "track.album.total_tracks", "track.album.type", "track.album.uri", "track.album.external_urls.spotify", "track.external_ids.isrc", "track.external_urls.spotify", "video_thumbnail.url"))

table(df$playlist_name)

df$genre <- "NA"

metal_playlists <- c("00s Metal Classics", "10s Metal Classics", "Metal Essentials")
newage_playlists <- c("1980s New Age Classics", "Early New Age", "New Age Classics")
rock_playlists <- c("All New Rock", "Rock Classics")
blues_playlists <- c("Blues Classics", "Blues Standards", "Classic Blues Guitar", "Electric Blues Classics")
classical_playlists <- c("Classical Essentials", "Classical New Releases")
country_playlists <- c("Country's Greatest Hits", "Country Top 50", "Hot Country")
folk_playlists <- c("Fresh Folk", "Roots Rising")
jazz_playlists <- c("Jazz Classics")
reggae_playlists <- c("One Love", "Reggae Classics", "Summer Sunshine Reggae")

df[df$playlist_name %in% metal_playlists,]$genre <- "metal" 
df[df$playlist_name %in% newage_playlists,]$genre <- "newage" 
df[df$playlist_name %in% rock_playlists,]$genre <- "rock" 
df[df$playlist_name %in% blues_playlists,]$genre <- "blues" 
df[df$playlist_name %in% classical_playlists,]$genre <- "classical" 
df[df$playlist_name %in% country_playlists,]$genre <- "country" 
df[df$playlist_name %in% folk_playlists,]$genre <- "folk" 
df[df$playlist_name %in% jazz_playlists,]$genre <- "jazz" 
df[df$playlist_name %in% reggae_playlists,]$genre <- "reggae" 

library(ggplot2)
ggplot(df, aes(x = track.popularity, fill = genre)) + geom_histogram(bins = 10) + facet_wrap(vars(genre))
summary(df$track.popularity)

any(is.na(df))

write.csv(df, "spotify_dataset.csv")
