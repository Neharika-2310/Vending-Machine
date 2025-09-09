//=========================================
// Vending Machine Controller (Verilog)
// Items: A=15, B=20, C=25
// Coins: 5, 10, 20
// Features: FSM, refund, low-stock warning
//=========================================

module vending_machine (
    input clk,
    input reset,
    input [1:0] coin_in,        // 01=5, 10=10, 11=20
    input [1:0] select_item,    // 01=A, 10=B, 11=C
    input cancel,
    output reg dispense_A,
    output reg dispense_B,
    output reg dispense_C,
    output reg refund,
    output reg [7:0] change_out,
    output reg low_stock
);

    // -----------------------------
    // Parameters
    // -----------------------------
    parameter PRICE_A = 15;
    parameter PRICE_B = 20;
    parameter PRICE_C = 25;

    // FSM states
    parameter IDLE         = 3'b000;
    parameter COIN_ACCEPT  = 3'b001;
    parameter SELECTION    = 3'b010;
    parameter CHECK_BAL    = 3'b011;
    parameter DISPENSE     = 3'b100;
    parameter REFUND_STATE = 3'b101;

    reg [2:0] current_state, next_state;

    // Internal registers
    reg [7:0] balance;
    reg [7:0] price;
    reg [1:0] item_selected;

    // Stock counters
    reg [3:0] stock_A;
    reg [3:0] stock_B;
    reg [3:0] stock_C;

    // -----------------------------
    // Reset + state update
    // -----------------------------
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            balance <= 0;
            stock_A <= 3;
            stock_B <= 3;
            stock_C <= 3;
        end else begin
            current_state <= next_state;

            // Balance update
            if (coin_in == 2'b01) balance <= balance + 5;
            else if (coin_in == 2'b10) balance <= balance + 10;
            else if (coin_in == 2'b11) balance <= balance + 20;
            else if (current_state == DISPENSE && balance >= price)
                balance <= balance - price;
            else if (current_state == REFUND_STATE)
                balance <= 0;
        end
    end

    // -----------------------------
    // Next state + outputs
    // -----------------------------
    always @(*) begin
        // Default outputs
        dispense_A = 0;
        dispense_B = 0;
        dispense_C = 0;
        refund     = 0;
        change_out = 0;
        low_stock  = 0;
        next_state = current_state;
        price      = 0;

        case (current_state)
            IDLE: begin
                if (coin_in != 2'b00) next_state = COIN_ACCEPT;
            end

            COIN_ACCEPT: begin
                if (cancel) next_state = REFUND_STATE;
                else if (select_item != 2'b00) next_state = SELECTION;
            end

            SELECTION: begin
                case (select_item)
                    2'b01: price = PRICE_A;
                    2'b10: price = PRICE_B;
                    2'b11: price = PRICE_C;
                endcase
                item_selected = select_item;
                next_state = CHECK_BAL;
            end

            CHECK_BAL: begin
                if (balance >= price) next_state = DISPENSE;
                else next_state = COIN_ACCEPT;
            end

            DISPENSE: begin
                case (item_selected)
                    2'b01: if (stock_A > 0) begin
                               dispense_A = 1;
                               stock_A = stock_A - 1;
                           end
                    2'b10: if (stock_B > 0) begin
                               dispense_B = 1;
                               stock_B = stock_B - 1;
                           end
                    2'b11: if (stock_C > 0) begin
                               dispense_C = 1;
                               stock_C = stock_C - 1;
                           end
                endcase
                if (balance > price) change_out = balance - price;
                if (stock_A <= 2 || stock_B <= 2 || stock_C <= 2)
                    low_stock = 1;
                next_state = IDLE;
            end

            REFUND_STATE: begin
                refund = 1;
                change_out = balance;
                next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end
endmodule
