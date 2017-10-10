#ifndef __CC1101_H__
#define __CC1101_H__

#include <spi.h>

typedef struct _CC1101 {
	int portpair;
	int state;
	void* cbaddr;
} CC1101;

int cc1101_initialize( CC1101 *radio,
	GPIOPIN pClock, GPIOPIN pDataInBi, GPIOPIN pDataOut,
	long options
);
int cc1101_power_state( CC1101 *radio, uint8_t state );
int cc1101_set_callback( CC1101 *radio, int cb );

#endif
