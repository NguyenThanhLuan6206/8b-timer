// ============================================================================
// COVERAGE DATA STRUCTURES
// ============================================================================

packet apb_trans;     // APB transaction packet

// ============================================================================
// CONTROL SIGNAL EXTRACTION
// ============================================================================

bit count_down;      // TCR[1]
bit load;            // TCR[2]
bit [1:0] clk_div;   // TCR[4:3]
bit s_ovf;     // TIE[0]
bit s_unf;    // TIE[1]

// Function để extract bits từ APB transaction
function automatic void extract_control_signals();
    case (apb_trans.addr)
        8'h00: begin  // TCR (Timer Configuration Register)
            count_down = apb_trans.data[1];      // Bit 1
            load = apb_trans.data[2];            // Bit 2
            clk_div = apb_trans.data[4:3];       // Bits 4:3
        end
        
        8'h03: begin  // TIE (Timer Interrupt Enable)
            s_ovf = apb_trans.data[0];     // Bit 0
            s_unf = apb_trans.data[1];    // Bit 1
        end
    endcase
endfunction

// ============================================================================
// TIMER 8-BIT FUNCTIONAL COVERAGE
// ============================================================================

covergroup APB_GROUP;  // Manual sampling (không dùng trigger)
    
    // ===== COVERPOINT 1: APB Transfer Type =====
    apb_transfer: coverpoint apb_trans.transfer {
        bins read = {packet::READ};
        bins write = {packet::WRITE};
    }
    
    // ===== COVERPOINT 2: APB Address =====
    apb_addr: coverpoint apb_trans.addr {
        bins addr_TCR = {8'h00};       // Timer Configuration Register
        bins addr_TSR = {8'h01};       // Timer Status Register  
        bins addr_TDR = {8'h02};       // Timer Data Register
        bins addr_TIE = {8'h03};       // Timer Interrupt Enable
        bins addr_reserved = {[8'h04:8'hFF]};
    }
    
    // ===== COVERPOINT 3: APB Data =====
    apb_data: coverpoint apb_trans.data {
        bins zero = {8'h00};
        bins low = {[8'h01:8'h7F]};
        bins high = {[8'h80:8'hFE]};
        bins max = {8'hFF};
    }
    
    // ===== COVERPOINT 4: Count Direction =====
    apb_direction: coverpoint count_down {
        bins count_up = {1'b0};
        bins count_down = {1'b1};
    }
    
    // ===== COVERPOINT 5: Clock Divisor =====
    apb_clk_div: coverpoint clk_div {
        bins no_div = {2'b00};         // 200 MHz
        bins div_2 = {2'b01};          // 100 MHz
        bins div_4 = {2'b10};          // 50 MHz
        bins div_8 = {2'b11};          // 25 MHz
    }
    
    // ===== COVERPOINT 6: Load Feature =====
    apb_load: coverpoint load {
        bins no_load = {1'b0};
        bins load_active = {1'b1};
    }
    
    // ===== COVERPOINT 7: Overflow Enable =====
    apb_ovf_en: coverpoint s_ovf {
        bins disabled = {1'b0};
        bins enabled = {1'b1};
    }
    
    // ===== COVERPOINT 8: Underflow Enable =====
    apb_udf_en: coverpoint s_unf {
        bins disabled = {1'b0};
        bins enabled = {1'b1};
    }
    
    
    // ===== CROSS 1: Address × Data =====
    cross_addr_data: cross apb_addr, apb_data {
        bins TCR_write = binsof(apb_addr.addr_TCR) && binsof(apb_data);
        bins TSR_read = binsof(apb_addr.addr_TSR) && binsof(apb_data);
        bins TDR_all = binsof(apb_addr.addr_TDR) && binsof(apb_data);
        bins TIE_enable = binsof(apb_addr.addr_TIE) && binsof(apb_data);
        
        ignore_bins reserved = binsof(apb_addr.addr_reserved);
    }
    
    // ===== CROSS 2: Transfer Type × Address =====
    cross_transfer_addr: cross apb_transfer, apb_addr {
        bins read_TCR = binsof(apb_transfer.read) && binsof(apb_addr.addr_TCR);
        bins write_TCR = binsof(apb_transfer.write) && binsof(apb_addr.addr_TCR);
        bins read_TSR = binsof(apb_transfer.read) && binsof(apb_addr.addr_TSR);
        bins write_TDR = binsof(apb_transfer.write) && binsof(apb_addr.addr_TDR);
        bins read_TDR = binsof(apb_transfer.read) && binsof(apb_addr.addr_TDR);
        
        ignore_bins reserved_ops = binsof(apb_addr.addr_reserved);
    }
    
    // ===== CROSS 3: Clock Divisor × Direction =====
    cross_clkdiv_dir: cross apb_clk_div, apb_direction {
        bins no_div_up = binsof(apb_clk_div.no_div) && binsof(apb_direction.count_up);
        bins no_div_down = binsof(apb_clk_div.no_div) && binsof(apb_direction.count_down);
        bins div_2_up = binsof(apb_clk_div.div_2) && binsof(apb_direction.count_up);
        bins div_2_down = binsof(apb_clk_div.div_2) && binsof(apb_direction.count_down);
    }
    
    // ===== CROSS 4: Load × Direction =====
    cross_load_dir: cross apb_load, apb_direction {
        bins load_up = binsof(apb_load.load_active) && binsof(apb_direction.count_up);
        bins load_down = binsof(apb_load.load_active) && binsof(apb_direction.count_down);
        bins no_load_up = binsof(apb_load.no_load) && binsof(apb_direction.count_up);
        bins no_load_down = binsof(apb_load.no_load) && binsof(apb_direction.count_down);
    }
    
    // ===== CROSS 5: Enable Bits × Direction =====
    cross_enables_dir: cross apb_ovf_en, apb_udf_en, apb_direction {
        bins ovf_en_up = binsof(apb_ovf_en.enabled) && binsof(apb_direction.count_up);
        bins ovf_en_down = binsof(apb_ovf_en.enabled) && binsof(apb_direction.count_down);
        bins udf_en_up = binsof(apb_udf_en.enabled) && binsof(apb_direction.count_up);
        bins udf_en_down = binsof(apb_udf_en.enabled) && binsof(apb_direction.count_down);
        bins both_en = binsof(apb_ovf_en.enabled) && binsof(apb_udf_en.enabled);
    }
    
endgroup: APB_GROUP