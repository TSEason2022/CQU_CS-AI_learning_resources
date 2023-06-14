`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/21 19:46:21
// Design Name: 
// Module Name: pc
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pc (input clk, input rst, input [31:0] pc_in, output reg [31:0] pc_out);

    always @ (posedge clk, posedge rst) begin
        if (rst) begin
            pc_out <= 32'h0; // �� pc_out ��ʼ��Ϊ 0
        end else begin
            pc_out <= pc_in; // �� pc_in ��ֵ���� pc_out
        end
    end

endmodule

