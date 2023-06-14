`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/03 19:23:22
// Design Name: 
// Module Name: PC
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


module PC(
    input clk,
    input rst,
    output[31:0] pc,
    output reg inst_ce
    );
    reg [31:0] pc_reg; // PC �Ĵ���
    always @(posedge clk, posedge rst) 
    begin
        if (rst) 
        begin // ��λ�ź�Ϊ�ߵ�ƽ
          pc_reg <= 32'h0; // �� PC �Ĵ�������
          inst_ce <= 1'b1;
        end 
        else begin // ��������״̬
          pc_reg <= pc_reg + 4; // PC �Ĵ������� 4
          inst_ce <= 1'b1;
        end
    end
    assign pc = pc_reg; // �� PC �Ĵ�����ֵ����� pc �˿� 
endmodule
