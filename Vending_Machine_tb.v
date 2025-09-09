`timescale 1ns/1ps

module tb_vending_machine;
    reg clk, reset;
    reg [1:0] coin_in;
    reg [1:0] select_item;
    reg cancel;
    wire dispense_A, dispense_B, dispense_C, refund, low_stock;
    wire [7:0] change_out;

    // DUT
    vending_machine dut(
        .clk(clk), .reset(reset),
        .coin_in(coin_in), .select_item(select_item),
        .cancel(cancel),
        .dispense_A(dispense_A), .dispense_B(dispense_B), .dispense_C(dispense_C),
        .refund(refund), .change_out(change_out), .low_stock(low_stock)
    );

    // Clock
    always #5 clk = ~clk;

    initial begin
        $dumpfile("vending_machine.vcd");
        $dumpvars(0, tb_vending_machine);

        // Init
        clk=0; reset=1; coin_in=0; select_item=0; cancel=0;
        #10 reset=0;

        // Case 1: Buy A with exact 15
        coin_in=2'b10; #10; coin_in=0;   // insert 10
        coin_in=2'b01; #10; coin_in=0;   // insert 5
        select_item=2'b01; #10; select_item=0; #20;

        // Case 2: Buy B with extra (25 -> expect change 5)
        coin_in=2'b11; #10; coin_in=0;   // insert 20
        coin_in=2'b01; #10; coin_in=0;   // insert 5
        select_item=2'b10; #10; select_item=0; #20;

        // Case 3: Insert coins then cancel
        coin_in=2'b01; #10; coin_in=0;   // insert 5
        coin_in=2'b10; #10; coin_in=0;   // insert 10
        cancel=1; #10; cancel=0; #20;

        // Case 4: Low stock trigger
        repeat(3) begin
            coin_in=2'b11; #10; coin_in=0;
            coin_in=2'b01; #10; coin_in=0;
            select_item=2'b11; #10; select_item=0; #20;
        end

        $finish;
    end
endmodule
