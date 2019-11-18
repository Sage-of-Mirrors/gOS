#define VRAM 0xB8000
#define MAX_ROWS 25
#define MAX_COLS 80
#define WHITE_BLACK 0x0F

#define REG_SCREEN_CTRL 0x3D4
#define REG_SCREEN_DATA 0x3D5

#include "../kernel/low_level.h"
#include "../kernel/util.h"

void print_char(char character, int col, int row, char attributes);
void clear_screen();
void print(char* message);