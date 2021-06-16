# devtools::install_github('charlie86/spotifyr') # apparently it has been removed from CRAN for complience reasons at the moment
library(spotifyr)
library(dplyr)
Sys.setenv(SPOTIFY_CLIENT_ID = 'xxxxxxxxxxxxxxxxxxx') # replace with your spotify developer clientId
Sys.setenv(SPOTIFY_CLIENT_SECRET = 'xxxxxxxxxxxxxxxxxxx') # replace with your spotify developer secret
access_token <- get_spotify_access_token()

artist_names = c("Serdar Ortaç", "Madonna")

datalist = list()
for(i in 1:length(artist_names)){
  discography <- get_artist_audio_features(artist_names[i]) # this does not include popularity
  datalist[[i]] <- discography
}

discographies <- bind_rows(datalist)

tracks <- discographies$track_id

track_popularity <- data.frame(matrix(nrow=0, ncol=2))
for (id in tracks){
  track_popularity <- rbind(track_popularity, get_track(id)[c("id", "popularity")]) # get_track includes popularity
}

discographies <- inner_join(discographies, track_popularity, by = c("track_id" = "id"), copy = FALSE)

columns = c("artist_name", "album_name", "track_id", "album_release_date", "danceability", "energy", "key", "loudness", "mode", "speechiness", "acousticness", "instrumentalness", "liveness", "valence", "tempo", "time_signature", "duration_ms", "track_name", "key_name", "mode_name", "key_mode", "popularity")
new_df <- discographies[columns]

write.csv(new_df, 'discographies.csv', fileEncoding = 'utf-8')
