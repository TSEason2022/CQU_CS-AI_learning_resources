`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/21 19:46:59
// Design Name: 
// Module Name: pc_add
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


module pc_add(opc,npc);
input [31:0] opc;//ƫ����
output [31:0] npc;//��ָ���ַ
assign npc=opc+4;
endmodule