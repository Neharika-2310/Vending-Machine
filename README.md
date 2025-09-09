# Vending Machine System (Verilog)

## 📌 Introduction  
This project implements a *Vending Machine System* in *Verilog HDL, simulated using **VS Code with a Verilog simulator*.  
The system models a vending machine that accepts coins, allows product selection, dispenses items, and manages change and stock levels.

---

## ⚡ Features  
- Coin detection and accumulation logic.  
- Product selection with multiple dispense options.  
- Automatic change return and cancel functionality.  
- Stock monitoring and low-stock alert system.  
- Reset functionality to restore initial state.  

---

## 🛠 Tools & Technologies  
- *Language:* Verilog HDL  
- *Simulator:* Icarus Verilog
- *Editor:* Visual Studio Code  

---

## 📊 Simulation Result  
Below is a sample waveform output from the Verilog simulation, showing proper coin input, product selection, dispense, and change return:  

![Simulation Output](./simulation_waveform.jpg)  



## 🚀 How to Run  
1. Clone this repository.  
2. Open in *VS Code* with Verilog extension installed.  
3. Compile and run the Verilog code using your simulator (iverilog / modelsim).  
4. View the simulation waveform in *GTKWave* or built-in viewer.  

```bash
iverilog -o neha neha.v tb.v
vvp neha
gtkwave vending_machine.vcd
