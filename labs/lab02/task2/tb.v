// tb.v
// Starter testbench template -- YOU complete this file.

module tb;
  localparam WIDTH = 8;
  localparam DEPTH = 4;



  // TODO: declare the inputs and outputs
  reg  [$clog2(DEPTH)-1:0] t_sel;
  wire [WIDTH-1:0]          t_dout;

  // TODO: instantiate DUT here
  lut #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
  ) DUT (
    .sel (t_sel),
    .dout(t_dout)
  );

  // Waveform dump configuration (DO NOT CHANGE)
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  initial begin
    // TODO: apply different input combinations
    integer i;
    for (i = 0; i < DEPTH; i = i + 1) begin
      t_sel = i;
      #5;
    end
    $finish;

  end

  initial
  $monitor($time, " sel=%0d (bin: %b) | dout=%0d (hex: 8'h%h)", t_sel, t_sel, t_dout, t_dout);

endmodule
