#include "../driver/screen.h"

void start()
{
	char test[] = "Rrha ki ra tie yor ini en nha\n";
	char test1[] = "Wee ki ra parge yor ar ciel\n";
	char test2[] = "Was yea ra chs mea yor en fwal\n";
	char test3[] = "Ma ki ga ks maya yor sec\n";
	clear_screen();
	
	print(test);
	print(test1);
	print(test2);
	print(test3);
}