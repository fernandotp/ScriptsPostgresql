#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <dirent.h>
#include <string.h>

void procesoArchivo(char *archivo);

int main()
{
	DIR *dir;
	struct dirent *ent;

	dir = opendir ("/home/fernando/backups");
	if (dir == NULL)
		printf("No puedo abrir el directorio");

	while ((ent = readdir (dir)) != NULL)
	{
    		if ( (strcmp(ent->d_name, ".")!=0) && (strcmp(ent->d_name, "..")!=0) )
		{
			if ( (strcmp(ent->d_name, )
				printf("%s \n", ent->d_name);
				/*procesoArchivo(ent->d_name);*/
    		}
    	}
	closedir (dir);

  	return EXIT_SUCCESS;
}

void procesoArchivo(char *archivo)
{

  	FILE *fich;
  	long ftam;

  	fich=fopen(archivo, "r");
  	if (fich)
    	{
      		fseek(fich, 0L, SEEK_END);
      		ftam=ftell(fich);
      		fclose(fich);
      		printf ("%s (%ld bytes)\n", archivo, ftam);
    	}
  	else
    	printf ("%s\n", archivo);
}

