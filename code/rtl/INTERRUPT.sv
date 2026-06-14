module INTERRUPT (
  input logic ker_clk,
  input logic presetn,
  input logic cnt_en,
  input logic count_down,
  input logic load,
  input logic [7:0] cnt,
  input logic [1:0] tsr01,
  input logic [1:0] tie01,
  output logic s_ovf_stretched,
  output logic s_udf_stretched,
  output logic int_signal
);
  logic s_ovf, s_udf;
  logic [3:0] ovf_delay;
  logic [3:0] udf_delay;

  always_ff @(posedge ker_clk or negedge presetn) begin
    if (!presetn) begin
      s_ovf <= 1'b0;
    end else if (~load & cnt_en) begin
      if (~count_down && (cnt[7:0] == 8'hFF)) begin
        s_ovf <= 1'b1;
      end
      else begin
        s_ovf <= 1'b0;
      end
    end else begin
      s_ovf <= 1'b0;
    end
  end


  always_ff @(posedge ker_clk or negedge presetn) begin
    if (!presetn) begin
      s_udf <= 1'b0;
    end else if (~load & cnt_en) begin
      if (count_down && (cnt[7:0] == 8'h00)) begin
        s_udf <= 1'b1;
      end
      else begin
        s_udf <= 1'b0;
      end
    end else begin
      s_udf <= 1'b0;
    end
  end

  assign int_signal = (tsr01[0] && tie01[0]) || (tsr01[1] && tie01[1]);

  always_ff @(posedge ker_clk or negedge presetn) begin
    if (!presetn) begin
      ovf_delay <= 4'b0000;
    end else if (s_ovf) begin
      ovf_delay <= 4'b1111;
    end else begin
      ovf_delay <= {ovf_delay[2:0], 1'b0};
    end
  end

  assign s_ovf_stretched = ovf_delay[0] | ovf_delay[1] | ovf_delay[2] | ovf_delay[3];


  always_ff @(posedge ker_clk or negedge presetn) begin
    if (!presetn) begin
      udf_delay <= 4'b0000;
    end else if (s_udf) begin
      udf_delay <= 4'b1111;
    end else begin
      udf_delay <= {udf_delay[2:0], 1'b0};
    end
  end

  assign s_udf_stretched = udf_delay[0] | udf_delay[1] | udf_delay[2] | udf_delay[3];

endmodule
