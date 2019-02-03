# rlinky
r package to fetch linky data from enedis website - Bibliothèque en R pour récupérer les données de votre compteur linky à partir du site enedis

## Example - Exemple d'utilisation

```{r}
connect_enedis(secretfile = "~/.secret_enedis_json")
this_month_data <- query_daily_month(end_date = Sys.Date())
disconnect_enedis()
kWh <- this_month_data$graphe$data$valeur
day1 <- as.Date(this_month_data$graphe$periode$dateDebut, 
                format="\%d/\%m/\%Y")
Horodate <- seq(from = day1, length.out = length(kWh), by="day")
plot(Horodate, kWh, type="b", pch=16,
     main = paste("Daily records since ", day1),
     xlab = "Date", ylab = "power consumption (kWh)")
```

![](power20190201.png)