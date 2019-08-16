echo "Czekaj..."
curl -s -c ciacho.txt https://portalpasazera.pl/MapaOL > /dev/null

token=`cat ciacho.txt | head -n 7 | tail -1 | awk '{print $7;}'`

#curl -d "__RequestVerificationToken="$token https://portalpasazera.pl/MapaOL/BiezacaDataGodzina

curl -s -d "jezyk=PL&__RequestVerificationToken="$token https://portalpasazera.pl/MapaOL/PociagiNaMapieAktualizacjaDanych > p.json