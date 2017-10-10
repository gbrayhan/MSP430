MoodLight Proof of Concept
==========================

Note, this project is built on top of [lib430](/mspdev/lib430/README) so 
you need to check out the entire mspdev source tree in order to build it
for your microcontrollers.

## What it is

Currently, it runs a demo program producing output on one or more RGB leds. The
circuit is based on NPN-transistors and thus use high output levels for the off-state
and low output levels for the on-state.

It demonstrates how to do software PWM to produce a total of 10x10x10 colors (10
intensities of red, green and blue)

## What will it do

The goal is to have it read the red, green and blue value from three cheap
photoresistors covered by colored filters.

## How to build it

Use the makefile:

  $ make

## If you don't have lib430 built for your microcontroller

Then use the start.sh script from the mspdev root instead:

  $ ./start.sh

## License

Licensed under the GNU GPL Version 3 or later.
Copyright (c) 2012, NoccyLabs
