#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

void main() {
    *(char*)0xb8000 = 'Q';
    return;
    while (1) { }
}
