`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/03 19:29:54
// Design Name: 
// Module Name: clk_divider
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


module clk_divider (
  input clk,      // ����ʱ���ź�
  input rst,    // �ⲿ�����ź�
  output reg out  // ���ʱ�������ź�
);

parameter DIVIDER_THRESHOLD = 50000000;  // ��ֵΪ 100Mhz / 2 = 50,000,000

reg [31:0] counter;  // ������
reg flag = 1'b0;

always @(posedge clk or posedge rst) begin
  if (rst) begin
    counter <= 0;
    out <= 0;
  end 
  else 
  begin
    if (counter < 35 && flag == 0)
    begin
        out <= ~out;
        counter <= counter + 1; 
    end
    else if (counter >= DIVIDER_THRESHOLD) 
    begin
      out <= ~out;  // ���ʱ�������ź�
      counter <= 0; // ���ü�����
    end 
    else 
    begin
      flag = 1;
      counter <= counter + 1; // ���Ӽ�������ֵ
    end
  end
end

endmodule