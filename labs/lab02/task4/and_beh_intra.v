// and_beh_intra.v
module and_beh_intra (
  input      a,
  input      b,
  output reg y
);

  always @(*) begin
    y = #5 a & b;
  end

endmodule