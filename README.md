# Single-Cycle RV32I Design in SystemVerilog

## Overview

This repository contains a simple single-cycle RV32I CPU design implemented in SystemVerilog. It supports the base integer instruction set architecture of 32-bit RISC-V.

## Dependencies

- Python 3.x (tested on python 3.14.7)
- Yosys and nextpnr-ice40 (for synthesizing, build file defaults to iCE40 HX8k)
- iverilog (for simulation, supports IEEE Std 1800-2012)
- gtkwave (for inspecting waveforms)

## Getting Started

The build file includes commands that should be enough to get this design simulated, or baked inside an FPGA.

### Simulation

```bash
python build.py --sim=TB_NAME
```

### Inspect Waveform

```bash
python build.py --wave
```

### Synthesizing

```bash
python build.py --synth
```

### Inspect Routing

```bash
python build.py --gui
```

## Contributing

Contributions are welcome. If you want to fix bugs, improve the simulation setup, etc., please follow these steps:

- Fork the repository
- Create your feature branch (git checkout -b feature/your-feature-name)
- Commit your changes
- Push to the branch (git push origin feature/your-feature-name)
- Open a pull request

Make sure any modifications pass your testbenches before submitting a pull request.
