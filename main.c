#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

FILE *f;
uint32_t f_siz=0, f_read=0;
char data[12000000];
char str[1000];
char needle[100];

uint32_t nr_pociagu=0;
char opoznienie[30];
uint16_t opoznienie_int=0;

int main(uint8_t argc, char *argv[])
{
	if(argc==2)
	{
		nr_pociagu=atoi(argv[1]);
	}
	else
		return 1;

	f = fopen("p.json", "rb");

	if(f == NULL)
   {
		printf("Nie udalo sie otworzyc pliku");
		return 1;
   }

	fseek(f, 0, SEEK_END);
	f_siz=ftell(f);
	//printf("Rozmiar  %d\n", f_siz);
	rewind(f);

	f_read=fread(data, 1, f_siz, f);
	//printf("Wczytano %d bajtow danych.\n", f_read);
	
	sprintf(needle, "\"NumerPociagu\":\"%d\"", nr_pociagu);
	//printf("%s\n", needle);
	if(strstr(data, needle)!=NULL)
	{
		memcpy(str, strstr(data, needle), 990);
		memcpy(opoznienie, strstr(str, "\"OpoznienieOdjazduStA\":"), 23+4);
		//printf("%s\n", opoznienie);

		opoznienie_int=atoi(&opoznienie[23]);

		printf("Pociag numer %d, opoznienie %d min\n", nr_pociagu, opoznienie_int);
	}
	else
		printf("Nie znaleziono pociagu numer %d\n", nr_pociagu);

	fclose(f);

	return 0;
}
