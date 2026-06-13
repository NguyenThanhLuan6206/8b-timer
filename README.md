# 8-Bit Timer

An 8-bit timer IP with APB interface, designed and verified using SystemVerilog.

## Overview

This project is a good practice for getting familiar with:
- SystemVerilog design and verification
- Basic UVM concepts (not fully implemented and not call factory)
- using perl scripts (sim/regress.pl)
- example of configuation file format (sim/regress.cfg)
- basic functional coverage


## Project Structure

```
8b_timer/
├── code/
│   ├── rtl/              # RTL design files (SystemVerilog)
│   ├── sim/              # Simulation files (ModelSim/Questa)
│   └── tb/               # Testbench and verification environment
├── doc/                  # Complete documentation
│   ├── 8_bit_timer.md   # Detailed specification and design
│   ├── design/           # Block diagrams (DrawIO)
│   ├── picture/          # Design diagrams
│   └── waveform/         # Simulation waveforms
└── README.md            # This file
```



## Documentation

- **[Full Specification](doc/8_bit_timer.md)** - Detailed design documentation
- **Design Diagrams** - Located in `doc/design/` (DrawIO format)
- **Waveforms** - Located in `doc/waveform/` (JSON format)

## Simulation

The project includes:
- Comprehensive testbench in `code/tb/`
- Test cases in `code/testcase/`
- Simulation scripts and Makefile in `code/sim/`

## Author

LuanNguyen

## Version

1.0 (Initial version)
