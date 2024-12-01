module adaptive_filter(
    input wire clk,
    input wire rst_n,
    input wire [31:0] input_signal,
    input wire [31:0] desired_signal,
    output reg [31:0] filtered_signal // Change wire to reg
);

integer i;
reg [15:0] filter_coefficients [0:7]; // Coefficients for the filter
reg [15:0] delay_line [0:7];          // Delay line
reg [15:0] error_signal;
reg [15:0] update_value;

parameter LEARNING_RATE = 16'd10; // Learning rate

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        for ( i = 0; i < 8; i = i + 1) // Corrected loop condition
        begin
            filter_coefficients[i] <= 16'b0;
            delay_line[i] <= 32'b0;
        end
        error_signal <= 32'b0;
        update_value <= 32'b0;
        filtered_signal <= 32'd0; // Initialize filtered_signal here
    end
    else
    begin
        for (i = 7; i > 0; i = i - 1) // Corrected loop condition
        begin
            delay_line[i] <= delay_line[i - 1];
        end
        delay_line[0] <= input_signal;

        filtered_signal <= filter_coefficients[0] * delay_line[0]; // Update filtered_signal here
        for ( i = 1; i < 8; i = i + 1)
        begin
            filtered_signal <= filtered_signal + filter_coefficients[i] * delay_line[i];
        end

        error_signal <= desired_signal - filtered_signal;

        update_value <= LEARNING_RATE * error_signal * delay_line[0];
        filter_coefficients[0] <= filter_coefficients[0] + update_value;
        for (i = 1; i < 8; i = i + 1) // Corrected loop condition
        begin
            update_value <= LEARNING_RATE * error_signal * delay_line[i];
            filter_coefficients[i] <= filter_coefficients[i] + update_value;
        end
    end
end

endmodule
