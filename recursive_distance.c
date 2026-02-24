#include <stdio.h>
#include <math.h>

unsigned char seven_seg_digits[10] = {
    0x3F, // 0
    0x06, // 1
    0x5B, // 2
    0x4F, // 3
    0x66, // 4
    0x6D, // 5
    0x7D, // 6
    0x07, // 7
    0x7F, // 8
    0x6F  // 9
};

#define SEVEN_SEG ((volatile unsigned int *)0x10000020)

int num_segment(int x1, int y1, int x2, int y2){
int dx = x1 -x2 ; 
int dy = y1 -y2 ; 
int d2 = dx * dx + dy * dy;
return count_segment(d2, 1);
}

int count_segment( int d2, int k){
if ( k * k > d2) 
	return 0 ; 
return 1 + count_segment( d2 , k +1);	
}

void display_number(int number) {
    int d0 = number % 10;
    int d1 = (number / 10) % 10;
    int d2 = (number / 100) % 10;
    int d3 = (number / 1000) % 10;

    unsigned int code0 = seven_seg_digits[d0];
    unsigned int code1 = seven_seg_digits[d1];
    unsigned int code2 = seven_seg_digits[d2];
    unsigned int code3 = seven_seg_digits[d3];

    if (number < 10) {
        code1 = 0; code2 = 0; code3 = 0;
    } else if (number < 100) {
        code2 = 0; code3 = 0;
    } else if (number < 1000) {
        code3 = 0;
    }
    *SEVEN_SEG = code0 | (code1 << 8) | (code2 << 16) | (code3 << 24);
}
int main(){
	
	int x1 = 1, y1 = 2 ;
	int x2 = 4, y2 = 6 ;
	
	int result = num_segment(x1, y1, x2, y2);
  display_number(result);
	
	while(1);
}









