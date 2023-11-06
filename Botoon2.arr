include gdrive-sheets
include data-source
include shared-gdrive(
"dcic-2021",
  "1wyQZj_L0qqV9Ekgr9au6RX2iqt2Ga8Ep")


ssid = "1RYN0i4Zx_UETVuYacgaGfnFcv4l9zd9toQTTdkQkj7g"

#Load data from the spreadsheet
kWh-wealthy-consumer-data =
  load-table: komponent, energi
  source: load-spreadsheet(ssid).sheet-by-name("kWh", true)
         sanitize energi using string-sanitizer
  end



distance-travelled-per-day = 47.2 #47.2km gjennomsnitt distanse. Kilde: TOI
distance-per-unit-of-fuel= (distance-travelled-per-day / 10) * 0.5 # 0.5L per mil. kilde: Vianoor
energy-per-unit-of-fuel = 10 # kompendiet, link i oppgaveteksten

energy-per-day = ( distance-travelled-per-day / 
                            distance-per-unit-of-fuel ) * 
                                        energy-per-unit-of-fuel

#funksjon som konverterer string til tall.
fun energi-to-number(str :: String) -> Number:
  cases(Option) string-to-number(str):
    | some(a) => a
    | none => energy-per-day #endret fra o til energy-per-day
  end
where:
  energi-to-number("48") is 48
  energi-to-number("") is energy-per-day # byttet ut 0 med daglig energi forbruk for bil. 
end
kWh-wealthy-consumer-data-fixed = transform-column(kWh-wealthy-consumer-data, "energi", energi-to-number) 

sum(kWh-wealthy-consumer-data-fixed, "energi")

bar-chart(kWh-wealthy-consumer-data-fixed, "komponent", "energi")