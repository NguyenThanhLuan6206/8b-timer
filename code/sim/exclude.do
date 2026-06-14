coverage exclude -du TCR -togglenode tcr -comment {reversed bit in TCR}
coverage exclude -du TSR -togglenode tsr -comment {reversed bit in TSR}
coverage exclude -du TIE -togglenode tie -comment {reversed bit in TIE}
coverage exclude -du timer_top -togglenode tcr -comment {reversed bit}
coverage exclude -du timer_top -togglenode tie -comment {reversed bit}
coverage exclude -du timer_top -togglenode tsr -comment {reversed bit}
coverage exclude -src ../rtl/INTERRUPT.sv -line 61 -code e -comment {the module only can generate 1000, 0100, 0010, 0001}
coverage exclude -src ../rtl/INTERRUPT.sv -line 74 -code e -comment {the module only can generate 1000, 0100, 0010, 0001}
coverage exclude -src ../rtl/APB_SLAVE.sv -line 18 -code e -comment {exclude because drive generate specific drive in data}
coverage exclude -src ../rtl/APB_SLAVE.sv -line 17 -code e -comment {exclude because drive generate specific drive in data}