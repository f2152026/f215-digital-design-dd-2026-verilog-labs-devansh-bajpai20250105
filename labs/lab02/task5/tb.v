// tb.v
// Self-checking testbench for 4-bit ALU (alu.v)

module tb;

  reg  [3:0] t_a;
  reg  [3:0] t_b;
  reg        t_op;
  wire [3:0] t_result;

  // Instantiate the Device Under Test (DUT)
  alu DUT (
    .a     (t_a),
    .b     (t_b),
    .op    (t_op),
    .result(t_result)
  );

  // Waveform dump configuration
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  integer errors = 0;
  reg [3:0] expected;

  initial begin
    // ----------------------------------------------------
    // Test 1: Catches Sensitivity List Bug
    // Toggle op while keeping A and B constant
    // ----------------------------------------------------
    t_a = 4'd5; t_b = 4'd3; t_op = 1'b0; #5;
    expected = t_a + t_b;
    if (t_result !== expected) begin
      $display("ERROR at %0t ns [ADD]: A=%0d, B=%0d, op=%b | result=%0d (exp %0d)",
               $time, t_a, t_b, t_op, t_result, expected);
      errors = errors + 1;
    end

    // Change op ONLY (A=5, B=3 remain unchanged)
    t_op = 1'b1; #5;
    expected = t_a - t_b; // 5 - 3 = 2
    if (t_result !== expected) begin
      $display("ERROR at %0t ns [SUB sensitivity bug]: A=%0d, B=%0d, op=%b | result=%0d (exp %0d)",
               $time, t_a, t_b, t_op, t_result, expected);
      errors = errors + 1;
    end

    // ----------------------------------------------------
    // Test 2: Catches Blocking/Non-blocking Bug
    // Loop through inputs to verify subtraction path
    // ----------------------------------------------------
    for (integer i = 0; i < 8; i = i + 1) begin
      for (integer j = 0; j < 8; j = j + 1) begin
        t_a = i[3:0];
        t_b = j[3:0];

        // Addition check
        t_op = 1'b0; #5;
        expected = t_a + t_b;
        if (t_result !== expected) begin
          $display("ERROR at %0t ns [ADD]: A=%0d, B=%0d | result=%0d (exp %0d)",
                   $time, t_a, t_b, t_result, expected);
          errors = errors + 1;
        end

        // Subtraction check
        t_op = 1'b1; #5;
        expected = t_a - t_b;
        if (t_result !== expected) begin
          $display("ERROR at %0t ns [SUB non-blocking bug]: A=%0d, B=%0d | result=%0d (exp %0d)",
                   $time, t_a, t_b, t_result, expected);
          errors = errors + 1;
        end
      end
    end

    if (errors == 0) begin
      $display("\n>>> SUCCESS: All tests passed! <<<\n");
    end else begin
      $display("\n>>> FAILURE: %0d error(s) detected. <<<\n", errors);
    end

    $finish;
  end

endmodule