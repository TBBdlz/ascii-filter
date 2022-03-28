#include <stdio.h>
#include <stdlib.h>

int main(int argc, char const *argv[])
{
	FILE *filePt;
	FILE *outFilePt;
	filePt = fopen("test_input.dat", "r");
	outFilePt = fopen("output.dat", "a");
	char line[200];
	char writeBuffer[200];

	// read content of the file
	while (!feof(filePt))
	{
		fgets(line, 200, filePt);
		puts(line); // for debug propose
		puts("----------------------");
		int j = 0;
		for (int i = 0; i < 200; i++)
		{
			char s = line[i];
			if ((s >= 65 && s <= 90) || (s >= 97 && s <= 122) || s == 10)
			{
				writeBuffer[j] = i;
				j++;
			}
		}
		writeBuffer[j + 1] = 0;
		fprintf(outFilePt, writeBuffer);
		puts(writeBuffer);
	}

	fclose(filePt);
	fclose(outFilePt);

	return 0;
}
