module counter(
    `ifdef USE_POWER_PINS   
    inout vdd,
    inout vss,
    `endif
    
    input clk_i,
    input nrst_i,

    output reg [3:0] count_o
);

    always @(posedge clk_i or negedge nrst_i) begin
        if (!nrst_i) begin
            count_o <= 4'b0000;
        end else begin
            count_o <= count_o + 1;
        end
    end

endmodule