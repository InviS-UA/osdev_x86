#pragma once

#include <stdint.h>
#include <stdbool.h>

void VgaClear(uint8_t color);
void VgaPutc(char c, int colored, uint8_t color);