// tb.v
// Self-checking testbench for 2-bit comparator (comp2.v)

module tb;

  reg  [1:0] t_a;
  reg  [1:0] t_b;
  wire       t_gt;
  wire       t_lt;
  wire       t_eq;

  // Instantiate the Device Under Test (DUT)
  comp2 DUT (
    .A (t_a),
    .B (t_b),
    .GT(t_gt),
    .LT(t_lt),
    .EQ(t_eq)
  );

  // Waveform dump configuration
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  integer i, j;
  integer errors = 0;

  initial begin
    for (i = 0; i < 4; i = i + 1) begin
      for (j = 0; j < 4; j = j + 1) begin
        t_a = i[1:0];
        t_b = j[1:0];
        #5;

        // Check if actual DUT outputs match expected logical expressions
        if ((t_gt !== (t_a > t_b)) || (t_lt !== (t_a < t_b)) || (t_eq !== (t_a == t_b))) begin
          $display("ERROR at %0t ns: A=%0d, B=%0d | GT=%b (exp %b), LT=%b (exp %b), EQ=%b (exp %b)",
                   $time, t_a, t_b,
                   t_gt, (t_a > t_b),
                   t_lt, (t_a < t_b),
                   t_eq, (t_a == t_b));
          errors = errors + 1;
        end
      end
    end

    if (errors == 0) begin
      $display("\n>>> SUCCESS: All 16 test cases passed successfully! <<<\n");
    end else begin
      $display("\n>>> FAILURE: %0d error(s) found during simulation. <<<\n", errors);
    end

    $finish;
  end

endmodule