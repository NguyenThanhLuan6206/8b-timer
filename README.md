# 8-Bit Timer

An 8-bit timer IP with APB interface, designed and verified using SystemVerilog.

## Overview

This project demonstrates design verification and implementation of a simple timer module with the following features:

- **8-bit counter** with count up and count down modes
- **APB slave interface** for register configuration
- **Clock division** (no divide, divide by 2/4/8)
- **Interrupt generation** with enable control
- **Dual clock domains**: PCLK (50 MHz) and KER_CLK (200 MHz)
- **Error handling** with wait state support

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

## Quick Start

For **complete documentation**, including:
- Register specifications (TCR, TSR, TDR, TIE)
- Functional descriptions
- Block diagrams and schematics
- Waveform analysis
- Design details

See [doc/8_bit_timer.md](doc/8_bit_timer.md)

## Key Components

| File | Description |
|------|-------------|
| `APB_SLAVE.sv` | APB interface handler |
| `CLK_DIV.sv` | Clock divisor block |
| `COUNTER.sv` | 8-bit counter core |
| `INTERRUPT.sv` | Interrupt generation logic |
| `TCR.sv` | Timer Configuration Register |
| `TSR.sv` | Timer Status Register |
| `TDR.sv` | Timer Data Register |
| `TIE.sv` | Timer Interrupt Enable Register |
| `timer_top.sv` | Top-level module |

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
