module background(input jump, input clk, input reset, input [9:0] x, input [9:0] y,
	output [9:0] red, output [9:0] green, output [9:0] blue, output [0:6] HEX0, output [0:6] HEX1);
	
reg [2:0] idx;
reg [25:0] sclk;
reg [25:0] sclkk;
reg [25:0] sclkkk;
reg [25:0] sclkkkk;

reg tree1_clk = 1;
reg tree2_clk = 1;
reg tree3_clk = 1;

reg hit = 0;
reg disappear1;
reg disappear2;
reg disappear3;

wire [9:0] tree1_height_bin;
wire [9:0] tree2_height_bin;
wire [9:0] tree3_height_bin;

integer tree1_height;
integer tree2_height;
integer tree3_height;
integer tree1_x_left;
integer tree1_x_right;
integer tree2_x_left;
integer tree2_x_right;
integer tree3_x_left;
integer tree3_x_right;

integer banana1_left;
integer	banana1_right;
integer	banana1_top;
integer banana1_bottom;

integer banana2_left;
integer banana2_right;
integer banana2_top;
integer banana2_bottom;

integer banana3_left;
integer banana3_right;
integer banana3_top;
integer banana3_bottom;

integer monkey;
integer monkey_x;

reg [3:0] scoreFirst;
reg [3:0] scoreSecond;

initial begin
	tree1_x_left = 120;
	tree1_x_right = 200;
	tree2_x_left = 330;
	tree2_x_right = 410;
	tree3_x_left = 544;
	tree3_x_right = 628;
	tree1_height = 400;
	tree2_height = 300;
	tree3_height = 100;
	monkey = 85;
	monkey_x = 305;
	disappear1 = 0;
	disappear2 = 0;
	disappear3 = 0;
	end

always @(posedge clk)
	begin
		sclk = sclk + 1;
		if (sclk == 26'h7A120)
			begin
				sclk = 0;
				if (tree1_x_left <= 0) 
					begin 
					tree1_clk = 1;
					tree1_x_left = 640;
					end
				else if (tree1_x_right <= 0) 
					begin
					tree1_clk = 0;
					tree1_x_right = 640;
					end
				else begin
					tree1_clk = 0;
					tree1_x_left = tree1_x_left - 1;
					tree1_x_right = tree1_x_right - 1; end
	end end
	
	//Random generate tree1 height
	random1 tree1 (tree1_clk, tree1_height_bin);
	
	always @(posedge clk)
	begin
		sclkk = sclkk + 1;
		if (sclkk == 26'h7A120)
			begin
				sclkk = 0;
				if (tree2_x_left <= 0) begin 
					tree2_x_left = 640;
					tree2_clk = 1; end
				else if (tree2_x_right <= 0) begin
					tree2_x_right = 640;
					tree2_clk = 0; end
				else begin
					tree2_x_left = tree2_x_left - 1;
					tree2_x_right = tree2_x_right - 1; 
					tree2_clk = 0; end
	end end
	
	//Random generate tree2 height
	random2 tree2 (tree2_clk, tree2_height_bin);
	
	always @(posedge clk)
	begin
		sclkkk = sclkkk + 1;
		if (sclkkk == 26'h7A120)
			begin
				sclkkk = 0;
				if (tree3_x_left <= 0) begin
					tree3_x_left = 640;
					tree3_clk = 1; end
				else if (tree3_x_right <= 0) begin
					tree3_x_right = 640;
					tree3_clk = 0; end
				else begin
					tree3_x_left = tree3_x_left - 1;
					tree3_x_right = tree3_x_right - 1; 
					tree3_clk = 0; end
	end end
	
	//Random generate tree3 height
	random3 tree3 (tree3_clk, tree3_height_bin);
	
	//Assign tree height to random gerneated binary number
	always begin
		tree1_height <= tree1_height_bin;
		tree2_height <= tree2_height_bin;
		tree3_height <= tree3_height_bin; end
	
	always @(posedge clk) begin
		sclkkkk = sclkkkk + 1;
			if (sclkkkk == 26'h2DC6C0)
				begin
				sclkkkk = 0;
				if (!jump && !hit)
					monkey = monkey - 10;
				//if reset, turn everything back to normal.
				else if (!reset) begin
					monkey = 85;
					hit <= 0;
					scoreFirst <= 0; 
					scoreSecond <= 0;
					monkey_x = 305; end
				else if (monkey - 30 <= 50) begin
					monkey = 80;
					hit <= 1; end
				else if (monkey >= 400) begin
					monkey = 400;
					hit <= 1; end
				else if (tree1_x_left <= monkey_x && tree1_x_right >= monkey_x + 30 && tree1_height <= monkey) begin
					monkey = monkey;
					monkey_x = tree1_x_left -30;
					hit <= 1; end
				else if (tree2_x_left <= monkey_x && tree2_x_right >= monkey_x + 30 && tree2_height <= monkey) begin
					monkey = monkey;
					monkey_x = tree2_x_left -30;
					hit <= 1; end
				else if (tree3_x_left <= monkey_x && tree3_x_right >= monkey_x + 30 && tree3_height <= monkey) begin
					monkey = monkey;
					monkey_x = tree3_x_left -30;
					hit <= 1; end
				else
					monkey = monkey + 5;
				
				
				if (tree1_x_right > 5)
					if (!hit && banana1_left <= monkey_x && banana1_right >= monkey_x + 30 && monkey >= banana1_top && !disappear1) begin
						disappear1 = 1;
						scoreFirst <= scoreFirst + 1'b1;
						if (scoreFirst == 4'b1010) begin
							scoreSecond <= scoreSecond + 1'b1;
							scoreFirst <= 0; end end
						//score <= score + 1'b1; end
				if (tree1_x_right < 5)
					disappear1 = 0;
				
				if (tree2_x_right > 5 )
					if ( !hit && banana2_left <= monkey_x && banana2_right >= monkey_x + 30 && monkey >= banana2_top && !disappear2) begin
						disappear2 = 1;
						scoreFirst <= scoreFirst + 1'b1;
						if (scoreFirst == 4'b1010) begin
							scoreSecond <= scoreSecond + 1'b1;
							scoreFirst <= 0; end end
						//score <= score + 1'b1; end
				if (tree2_x_right < 5)
					disappear2 = 0;


				if (tree3_x_right > 5)
					if (!hit &&  banana3_left <= monkey_x && banana3_right >= monkey_x + 30 && monkey >= banana3_top && !disappear3) begin
						disappear3 = 1;
						scoreFirst <= scoreFirst + 1'b1;
						if (scoreFirst == 4'b1010) begin
							scoreSecond <= scoreSecond + 1'b1;
							scoreFirst <= 0; end end
						//score <= score + 1'b1; end
				if (tree3_x_right < 5)
					disappear3 = 0;
				//score <= score + 1'b1;
				end
		end	
	//Eating banana logic
	/*always begin
		if (tree1_x_left != 0)
			if (banana1_left <= monkey_x && banana1_right >= monkey_x + 30) begin//  && monkey - 30 >= banana1_bottom && banana1_top <= monkey) begin
				disappear1 = 1; 
				score = score + 1; end
		else
			disappear1 = 0;
			
		if (tree2_x_left != 0)
			if (banana2_left <= monkey_x && banana2_right >= monkey_x + 30  && monkey <= banana2_bottom && monkey -30 >= banana2_top) begin
				disappear2 = 1; 
				score = score + 1; end
		else
			disappear2 = 0;
			
		if (tree3_x_left != 0)
			if (banana3_left <= monkey_x && banana3_right >= monkey_x + 30  && monkey <= banana3_bottom && monkey -30 >= banana3_top) begin
				disappear3 = 1;
				score = score + 1; end
		else
			disappear3 = 0;
	end*/
	
	//Show the current score
	//BCD DisplayScore(score, HEX0, HEX1);
	BCD DisplayScoreFirst(scoreFirst, HEX0);
	BCD DisplayScoreSecond(scoreSecond, HEX1);
	
	//Banana location logic
	always begin
		banana1_left = tree1_x_left + 20;
		banana1_right = tree1_x_right - 20;
		banana1_bottom = tree1_height - 30;
		banana1_top = tree1_height - 60;
		
		banana2_left = tree2_x_left + 20;
		banana2_right = tree2_x_right - 20;
		banana2_bottom = tree2_height - 30;
		banana2_top = tree2_height - 60;
		
		banana3_left = tree3_x_left + 20;
		banana3_right = tree3_x_right - 20;
		banana3_bottom = tree3_height - 30;
		banana3_top = tree3_height - 60;
	end
	
	always @(x && y)
	begin
		if (x >= 0 && x <= 640 && y >= 0 & y <= 480) idx <= 3'd6; //Otherwise, Sky
		
		if (x >= 0 && x <= 640 && y >= 400 && y <= 480) idx <= 3'd2; //Grass

		if (x >= 0 && x <= 640 && y >= 0 && y <= 50) idx <= 3'd4; //Cloud
		
		else if (x >= monkey_x && x <= monkey_x + 30 && y >= monkey -30 && y <= monkey ) idx <= 3'd5; //Monkey
		
		else if (x >= banana1_left && x <= banana1_right && y <= banana1_bottom && y >= banana1_top)
			if (disappear1) idx <= 3'd6;
			else idx <= 3'd3;
		
		else if (x >= tree1_x_left && x <= tree1_x_right && y >= tree1_height && y <= 400) idx <= 3'd0; //Tree1
		
		else if (x >= banana2_left && x <= banana2_right && y <= banana2_bottom && y >= banana2_top)
			if (disappear2) idx <= 3'd6;
			else idx <= 3'd3;
			
	   else if (x >= tree2_x_left && x <= tree2_x_right && y >= tree2_height && y <= 400) idx <= 3'd0; //Tree2
		
		else if (x >= banana3_left && x <= banana3_right && y <= banana3_bottom && y >= banana3_top)
			if (disappear3) idx <= 3'd6;
			else idx <= 3'd3;
		
		else if (x >= tree3_x_left && x <= tree3_x_right && y >= tree3_height && y <= 400) idx <= 3'd0; //Tree2
		
		if (hit) begin// hit 
			if (x >= 30 && x <= 610 && y >= 50 && y <= 450) idx <= 3'd0;
			if (x >= 130 && x <=510 && y <= 400 && y >= 100) begin
				idx <= 3'd7; 
				if (x >= 130 && x <= 170 && y <= 350 && y >= 100) idx <= 3'd0;
				if (x >= 240 && x <= 410 && y >= 200 && y <= 250) idx <= 3'd0;
				if (x >= 290 && x <= 337 && y >= 150 && y <= 350) idx <= 3'd0;
				if (x >= 460 && x <= 560 && y <= 350 && y >= 100) idx <= 3'd0; end
			end
	end

/*
begin
	if (x > 0 && x < 90 && y > 0 && y < 479) idx <= 3'd0; //Black
	else if (x < 160) idx <= 3'd1; //Red
	else if (x < 240) idx <= 3'd2; //Green
	else if (x < 320) idx <= 3'd3; //Yellow
	else if (x < 400) idx <= 3'd4; //Dark blue
	else if (x < 480) idx <= 3'd5; //Purple
	else if (x < 560) idx <= 3'd6; //Light blue
	else idx <= 3'd7; //White
end
*/

assign red = (idx[0]? 10'h3ff: 10'h000);
assign green = (idx[1]? 10'h3ff: 10'h000);
assign blue = (idx[2]? 10'h3ff: 10'h000);

endmodule



module random1(ccc, height);
  input ccc;
  output reg [9:0] height;
  

  reg [0:3] fib = 4'b1111;

  always @ ( posedge ccc )
    fib <= {fib[3]^fib[2], fib[0:2]};

  always begin
    case (fib)
      0 : height <= 10'b0100101100;
      1 : height <= 10'b0011011100;
      2 : height <= 10'b0010101010;
      3 : height <= 10'b0100100010;
      4 : height <= 10'b0011111010;
      5 : height <= 10'b0010110100;
      6 : height <= 10'b0110000110;
      7 : height <= 10'b0101010100;
      8 : height <= 10'b0100110001;
      9 : height <= 10'b0010010110;
      10 : height <= 10'b0110010000;
      11 : height <= 10'b0011011110;
      12 : height <= 10'b0101001101;
      13 : height <= 10'b0010100110;
      14 : height <= 10'b0100010100;
      15 : height <= 10'b0011000111;
    endcase
  end
endmodule

module random2(ccc, height);
  input ccc;
  output reg [9:0] height;
  

  reg [0:3] fib = 4'b1111;

  always @ ( posedge ccc )
    fib <= {fib[3]^fib[2], fib[0:2]};

  always begin
    case (fib)
      0 : height <= 10'b0011000111;
      1 : height <= 10'b0011011110;
      2 : height <= 10'b0010101010;
      3 : height <= 10'b0011111010;
      4 : height <= 10'b0010010110;
      5 : height <= 10'b0110010000;
      6 : height <= 10'b0100110001;
      7 : height <= 10'b0010100110;
      8 : height <= 10'b0010110100;
      9 : height <= 10'b0101010100;
      10 : height <= 10'b0100100010;
      11 : height <= 10'b0100101100;
      12 : height <= 10'b0110000110;
      13 : height <= 10'b0011011100;
      14 : height <= 10'b0100010100;
      15 : height <= 10'b0101001101;
    endcase
  end
endmodule

module random3(ccc, height);
  input ccc;
  output reg [9:0] height;
  

  reg [0:3] fib = 4'b1111;

  always @ ( posedge ccc )
    fib <= {fib[3]^fib[2], fib[0:2]};

  always begin
    case (fib)
      0 : height <= 10'b0010111111;
      1 : height <= 10'b0110010000;
      2 : height <= 10'b0100010001;
      3 : height <= 10'b0011110100;
      4 : height <= 10'b0110000110;
      5 : height <= 10'b0101000000;
      6 : height <= 10'b0010110010;
      7 : height <= 10'b0010100110;
      8 : height <= 10'b0010110100;
      9 : height <= 10'b0011001000;
      10 : height <= 10'b0100100010;
      11 : height <= 10'b0110000110;
      12 : height <= 10'b0011011110;
      13 : height <= 10'b0100100100;
      14 : height <= 10'b0100110111;
      15 : height <= 10'b0101010100;
    endcase
  end
endmodule

// Display scores
module BCD(m, Display0);
	input [3:0] m;
	output [0:6] Display0;
	
	assign Display0 [0:6] = (m[3:0] == 4'b0000) ? 7'b0000001: //0
									(m[3:0] == 4'b0001) ? 7'b1001111: //1
									(m[3:0] == 4'b0010) ? 7'b0010010: //2
									(m[3:0] == 4'b0011) ? 7'b0000110: //3
									(m[3:0] == 4'b0100) ? 7'b1001100: //4
									(m[3:0] == 4'b0101) ? 7'b0100100: //5
									(m[3:0] == 4'b0110) ? 7'b0100000: //6
									(m[3:0] == 4'b0111) ? 7'b0001111: //7
									(m[3:0] == 4'b1000) ? 7'b0000000: 7'b0000100; //8, else 9
endmodule
/*
module BCD(score, HEX0, HEX1);
	input [3:0] score;
	output [0:6] HEX0, HEX1;
	
	assign V[3:0] = score[3:0];

	wire [3:0]V;
	wire [3:0]m;
	wire [2:0]reduced;
	// comparator
	comparater compare1 (V[3:0], equal);
	
	// CircuitB
	circuit_b d1 (equal, HEX1);
	
	// CircuitA
	circuit_a d0 (V[2:0], reduced[2:0]);
	
	// multiplexer
	multiplexer M0 (V[0], reduced[0], equal, m[0]);
	multiplexer M1 (V[1], reduced[1], equal, m[1]);
	multiplexer M2 (V[2], reduced[2], equal, m[2]);
	multiplexer M3 (V[3], 0, equal, m[3]);
	
	// 7-segment decoder
	decoder decode (m, HEX0);
endmodule

module comparater (V, equal);
	input [3:0] V;
	output equal;
	
	assign equal = (V[3:0] >= 4'b1010);
endmodule


// subtract the input value by 010
module circuit_a(V, reduced);
	input [2:0] V;
	output [2:0] reduced;
	
	assign reduced[2:0] = (V[2:0] - 3'b010);
endmodule


module circuit_b(Z, Display1);
	input Z;
	output [0:6] Display1;
	
	assign Display1 [0:6] = (Z == 1'b0) ? 7'b0000001: 7'b1001111; //0, else 1
endmodule

// 7-segment decoder
module decoder(m, Display0);
	input [3:0] m;
	output [0:6] Display0;
	
	assign Display0 [0:6] = (m[3:0] == 4'b0000) ? 7'b0000001: //0
									(m[3:0] == 4'b0001) ? 7'b1001111: //1
									(m[3:0] == 4'b0010) ? 7'b0010010: //2
									(m[3:0] == 4'b0011) ? 7'b0000110: //3
									(m[3:0] == 4'b0100) ? 7'b1001100: //4
									(m[3:0] == 4'b0101) ? 7'b0100100: //5
									(m[3:0] == 4'b0110) ? 7'b0100000: //6
									(m[3:0] == 4'b0111) ? 7'b0001111: //7
									(m[3:0] == 4'b1000) ? 7'b0000000: 7'b0000100; //8, else 9
endmodule


module multiplexer(X, Y, S, O);
	input X, Y, S;
	output O;
	
	assign O = (~S & X) | (S & Y);
endmodule
*/