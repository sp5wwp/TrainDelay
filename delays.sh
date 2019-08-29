for j in {1..100}
do
	#download page
	curl -s "https://portalpasazera.pl/Opoznienia?s=4&p="$j > get.html

	#check file size
	filesize=$(stat -c%s "get.html")

	if [[ filesize -lt 30000 ]]; then
		echo "Błąd połączenia"
		exit
	fi
	
	#extract date
	date=`grep -F "Dane wygenerowano:" get.html | awk -F["><"] '{print $3}'`

	#extract record number
	num=`grep -F "Liczba wyników:" get.html | awk -F["><"] '{print $5}'`
	if [[ j -eq 1 ]]; then
		let "pages=(num+5)/6"
		echo -e "\n$date"
		echo -e "Pozycji: "$num"\n"
		printf 'Lp.\033[6`Przewoźnik\033[45`Nazwa\033[75`Od\033[100`Do\033[130`Numer\033[150`Opóźnienie\n'
	fi

	for i in {1..6}
	do
		let "lp=(j-1)*6+i"
		let "b=1+(i-1)*5"
		carrier=`grep -F "visuallyhidden hidden--phone" get.html | sed -n "$b"'p' | awk -F["><"] '{print $7}'`
		let b++
		name=`grep -F "item-value" get.html | sed -n "$b"'p' | awk -F["><"] '{print $3}'`
		let b++
		number=`grep -F "item-value" get.html | sed -n "$b"'p' | awk -F["><"] '{print $3}' | sed -e 's/&[^;]*;//g'`
		let b++
		let "k=i*2-1"; let "m=k+1"
		from=`grep -F "span lang" get.html | sed -n "$k"'p' | awk -F["><"] '{print $3}'`
		to=`grep -F "span lang" get.html | sed -n "$m"'p' | awk -F["><"] '{print $3}'`
		let b++
		delay=`grep -F "item-value" get.html | sed -n "$b"'p' | awk -F["><"] '{print $3}'`
		
		printf '%d\033[6`%s\033[45`%s\033[75`%s\033[100`%s\033[130`%s\033[150`%s\n' "$lp" "$carrier" "$name" "$from" "$to" "$number" "$delay"
		
		if [[ lp -eq num ]]; then
			rm get.html
			exit
		fi
	done
done
