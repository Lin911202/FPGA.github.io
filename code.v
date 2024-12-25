module divfreq(input CLK, output reg CLK_div);
    parameter COUNT_MAX = 50000;
    reg [24:0] Count = 0;

    always @(posedge CLK) begin
        if (Count > COUNT_MAX) begin
            Count <= 0;
            CLK_div <= ~CLK_div;
        end else begin
            Count <= Count + 1'b1;
        end
    end
endmodule

module divmove(input pause, input CLK, output reg CLK_div);
    parameter COUNT_MAX = 4000000;
    reg [24:0] Count = 0;

    always @(posedge CLK) begin
        if (!pause) begin
            if (Count > COUNT_MAX) begin
                Count <= 0;
                CLK_div <= ~CLK_div;
            end else begin
                Count <= Count + 1'b1;
            end
        end
    end
endmodule

module breakout(input CLK,
					 input sw_L,
					 input sw_R,
					 input shoot,
					 input pause,
					 input [3:0] back,    //背景變化
					 output [7:0] lightR,
					 output [7:0] lightG,
					 output [7:0] lightB,
					 output reg [2:0] whichCol,  //控制亮哪排
					 output EN,
					 output reg[7:0] win  //亮燈得分
);

reg [7:0] state [7:0];//表哪些燈有亮
reg [7:0] stateR [7:0];
reg [7:0] stateG [7:0];
reg [7:0] stateB [7:0];
integer i, panel_center, alreadyShoot, ball_x, ball_y, direction, forward, go_mode, background, point;
reg [22:0] j;
reg clk_4hz;
reg [16:0] count,div_num;//

always @(posedge CLK)//4hz
begin
if(j==23'h47868c)
begin
j<=0;
clk_4hz=~clk_4hz;
end
else
j=j+1'b1;
end


initial
begin
   background = 0;
	panel_center = 4;
	whichCol=0;
	alreadyShoot = 0;
	ball_x = 4;
	ball_y = 6;
	go_mode = 11;
	point = 0;
end

divfreq f0(CLK, CLK_div);
divmove f1(pause, CLK, CLK_move);

always @(posedge CLK_move)
begin
	case (back)
	    4'b0000: background=0;
		 4'b0001: background=1;
       4'b0010: background=2;
       4'b0100: background=3;
       4'b1000: background=4;
   endcase
	if(background==1)
	begin
	  win<=8'b00000000;  
	  for (i=0;i<8;i=i+1)
	  begin//背景形狀+顏色
       state[i] = 8'b00000100;
		 stateR[i] = 8'b00000000;
		 stateG[i] = 8'b00000100;
		 stateB[i] = 8'b00000100;
	    if (i>=3 & i<=5)
		 begin//
		   state[i][7]=1;
			stateR[i][7]=0;
			stateG[i][7]=0;
			stateB[i][7]=1;
		 end
		 if (i==4)
		 begin
         state[i][6] = 1;
			stateR[i][6] = 1;
			stateG[i][6] = 1;
			stateB[i][6] = 1;
		 end
	  end
	end
	
	if(background==2)
	begin
	  win<=8'b00000000;
	  for (i=0;i<8;i=i+1)
	  begin
       state[i] = 8'b00001001;
		 stateR[i] = 8'b00000000;
		 stateG[i] = 8'b00001001;
		 stateB[i] = 8'b00001001;
	    if (i>=3 & i<=5)
		 begin
		   state[i][7]=1;
			stateR[i][7]=0;
			stateG[i][7]=0;
			stateB[i][7]=1;
		 end
		 if (i==4)
		 begin
         state[i][6] = 1;
			stateR[i][6] = 1;
			stateG[i][6] = 1;
			stateB[i][6] = 1;
		 end
	  end
	end
	
	if(background==3)
	begin
	  win<=8'b00000000;
	  for (i=0;i<8;i=i+1)
	  begin
       state[i] = 8'b00001111;
	    stateR[i] = 8'b00000000;
		 stateG[i] = 8'b00001111;
		 stateB[i] = 8'b00001111;
	    if (i>=3 & i<=5)
		 begin
		   state[i][7]=1;
			stateR[i][7]=0;
			stateG[i][7]=0;
			stateB[i][7]=1;
		 end
		 if (i==4)
		 begin
         state[i][6] = 1;
			stateR[i][6] = 1;
			stateG[i][6] = 1;
			stateB[i][6] = 1;
		 end
	  end
	end
	
	if(background==4)
	begin
	  win<=8'b00000000;
	  state[0] = 8'b00000010;
	  state[1] = 8'b00000010;
	  state[2] = 8'b00000100;
	  state[3] = 8'b00001110;
  	  state[4] = 8'b00001110;
	  state[5] = 8'b00000100;
	  state[6] = 8'b00000010;
	  state[7] = 8'b00000010;
	  
	  stateR[0] = 8'b00000000;
	  stateR[1] = 8'b00000000;
	  stateR[2] = 8'b00000000;
	  stateR[3] = 8'b00000000;
  	  stateR[4] = 8'b00000000;
	  stateR[5] = 8'b00000000;
	  stateR[6] = 8'b00000000;
	  stateR[7] = 8'b00000000;
	  
	  stateG[0] = 8'b00000010;
	  stateG[1] = 8'b00000010;
	  stateG[2] = 8'b00000100;
	  stateG[3] = 8'b00001110;
  	  stateG[4] = 8'b00001110;
	  stateG[5] = 8'b00000100;
	  stateG[6] = 8'b00000010;
	  stateG[7] = 8'b00000010;
	  
	  stateB[0] = 8'b00000010;
	  stateB[1] = 8'b00000010;
	  stateB[2] = 8'b00000100;
	  stateB[3] = 8'b00001110;
  	  stateB[4] = 8'b00001110;
	  stateB[5] = 8'b00000100;
	  stateB[6] = 8'b00000010;
	  stateB[7] = 8'b00000010;
	  for (i=0;i<8;i=i+1)
	  begin
	    if (i>=3 & i<=5)
		 begin
		   state[i][7]=1;
			stateR[i][7]=0;
			stateG[i][7]=0;
			stateB[i][7]=1;
		 end
		 if (i==4)
		 begin
         state[i][6] = 1;
			stateR[i][6] = 1;
			stateG[i][6] = 1;
			stateB[i][6] = 1;
		 end
	  end
	end
	
	if(background==0)//開始玩
	begin
	if(point>0)
	begin
	   if(point==0)   win<=8'b00000000;
		else if(point==1)   win<=8'b00000001;
		else if(point==2)   win<=8'b00000011;
		else if(point==3)   win<=8'b00000111;
		else if(point==4)   win<=8'b00001111;
	   else if(point==5)   win<=8'b00011111;
	   else if(point==6)   win<=8'b00111111;
	   else if(point==7)   win<=8'b01111111;
	   else if(point==8)   
		begin //贏了
		   win<=8'b11111111;
			state[0] = 8'b00000110;
			state[1] = 8'b00010010;
			state[2] = 8'b00100110;
			state[3] = 8'b01000000;
			state[4] = 8'b01000000;
			state[5] = 8'b00100110;
			state[6] = 8'b00010010;
			state[7] = 8'b00000110;
			
			stateR[0] = 8'b00000110;			
			stateR[1] = 8'b00010010;
			stateR[2] = 8'b00100110;
			stateR[3] = 8'b01000000;
			stateR[4] = 8'b01000000;
			stateR[5] = 8'b00100110;
			stateR[6] = 8'b00010010;
			stateR[7] = 8'b00000110;
			
			stateG[0] = 8'b00000000;			
			stateG[1] = 8'b00000000;
			stateG[2] = 8'b00000000;
			stateG[3] = 8'b00000000;
			stateG[4] = 8'b00000000;
			stateG[5] = 8'b00000000;
			stateG[6] = 8'b00000000;
			stateG[7] = 8'b00000000;
			
			stateB[0] = 8'b00000110;
			stateB[1] = 8'b00010010;
			stateB[2] = 8'b00100110;
			stateB[3] = 8'b01000000;
			stateB[4] = 8'b01000000;
			stateB[5] = 8'b00100110;
			stateB[6] = 8'b00010010;
			stateB[7] = 8'b00000110;
			
			background=0;
			panel_center = 4;
			alreadyShoot = 0;
			ball_x = 4;
			ball_y = 6;
			go_mode = 11;
			point=0;
		end
	end
	
	if (sw_L)
	begin
		if (panel_center-2 >= 0)//防超出邊界
		begin
			panel_center = panel_center - 1;
			if (alreadyShoot==0)
			begin
				state[panel_center][6]=1;
				stateR[panel_center][6]=0;
				stateG[panel_center][6]=0;
				stateB[panel_center][6]=1;
				state[panel_center+1][6]=0;
				stateR[panel_center+1][6]=0;
				stateG[panel_center+1][6]=0;
				stateB[panel_center+1][6]=0;
				ball_x = ball_x - 1;
			end		
			state[panel_center-1][7]=1;
			stateR[panel_center-1][7]=0;
			stateG[panel_center-1][7]=0;
			stateB[panel_center-1][7]=1;
			state[panel_center+2][7]=0;
			stateR[panel_center+2][7]=0;
			stateG[panel_center+2][7]=0;
			stateB[panel_center+2][7]=0;
		end
	end
	
	if (sw_R)
	begin
		if (panel_center+2 <= 7)
		begin
			panel_center = panel_center + 1;
			if (alreadyShoot==0)
			begin
				state[panel_center][6]=1;
				stateR[panel_center][6]=0;
				stateG[panel_center][6]=0;
				stateB[panel_center][6]=1;
				state[panel_center-1][6]=0;
				stateR[panel_center-1][6]=0;
				stateG[panel_center-1][6]=0;
				stateB[panel_center-1][6]=0;
				ball_x = ball_x + 1;
			end
			state[panel_center+1][7]=1;
			stateR[panel_center+1][7]=0;
			stateG[panel_center+1][7]=0;
			stateB[panel_center+1][7]=1;
			state[panel_center-2][7]=0;
			stateR[panel_center-2][7]=0;
			stateG[panel_center-2][7]=0;
			stateB[panel_center-2][7]=0;
		end
	end
		
	if (shoot)
	begin
		state[ball_x][ball_y] = 0;
		stateR[ball_x][ball_y] = 0;
		stateG[ball_x][ball_y] = 0;
		stateB[ball_x][ball_y] = 0;
		alreadyShoot = 1;
		go_mode = 11;
	end	
		
	if (alreadyShoot)
	begin
		case(go_mode)
		11:     //直上
		begin
			state[ball_x][ball_y] = 0;
			stateR[ball_x][ball_y] = 0;
			stateG[ball_x][ball_y] = 0;
			stateB[ball_x][ball_y] = 0;
			ball_y = ball_y - 1;
			if (state[ball_x][ball_y]==1&&ball_y>=0)
			begin
			   point=point+1;
				ball_y = ball_y + 2;
				state[ball_x][ball_y] = 1;	
				stateR[ball_x][ball_y] = 1;	
				stateG[ball_x][ball_y] = 1;	
				stateB[ball_x][ball_y] = 1;	
				go_mode = 21;
				if (state[ball_x][ball_y-2]==1)
				begin
					state[ball_x][ball_y-2] = 0;
					stateR[ball_x][ball_y-2] = 0;
					stateG[ball_x][ball_y-2] = 0;
					stateB[ball_x][ball_y-2] = 0;
				end
			end
			else if(ball_y<0)
			begin
			   ball_y = ball_y + 2;
				state[ball_x][ball_y] = 1;	
				stateR[ball_x][ball_y] = 1;	
				stateG[ball_x][ball_y] = 1;	
				stateB[ball_x][ball_y] = 1;	
				go_mode = 21;
				if (state[ball_x][ball_y-2]==1)
				begin
					state[ball_x][ball_y-2] = 0;
					stateR[ball_x][ball_y-2] = 0;
					stateG[ball_x][ball_y-2] = 0;
					stateB[ball_x][ball_y-2] = 0;
				end
			end
			else
			begin
				state[ball_x][ball_y] = 1;
				stateR[ball_x][ball_y] = 1;
				stateG[ball_x][ball_y] = 1;
				stateB[ball_x][ball_y] = 1;
			end
		end
		12:     //左上
		begin
			state[ball_x][ball_y] = 0;
			stateR[ball_x][ball_y] = 0;
			stateG[ball_x][ball_y] = 0;
			stateB[ball_x][ball_y] = 0;
			if (ball_x==0||ball_y==0)//左邊界或上邊界
			begin
			   if(ball_x==0&&ball_y==0)//左上的腳
				begin
				   ball_x=ball_x+1;
					ball_y=ball_y+1;
					state[ball_x][ball_y]=1;
					stateR[ball_x][ball_y]=1;
					stateG[ball_x][ball_y]=1;
					stateB[ball_x][ball_y]=1;
					go_mode= 23;
				end
				else if(ball_x==0)//左邊界
				begin
					if(state[ball_x+1][ball_y-1]==1)
					begin
						state[ball_x+1][ball_y-1]=0;
						stateR[ball_x+1][ball_y-1]=0;
						stateG[ball_x+1][ball_y-1]=0;
						stateB[ball_x+1][ball_y-1]=0;
						point=point+1;
						state[ball_x][ball_y]=1;
						stateR[ball_x][ball_y]=1;
						stateG[ball_x][ball_y]=1;
						stateB[ball_x][ball_y]=1;
						go_mode=23;
					end
				   else
					begin
						ball_x=ball_x+1;
						ball_y=ball_y-1;
						state[ball_x][ball_y]=1;
						stateR[ball_x][ball_y]=1;
						stateG[ball_x][ball_y]=1;
						stateB[ball_x][ball_y]=1;
						go_mode=13;
					end
				end
				else
				begin
					ball_x=ball_x-1;
					ball_y=ball_y+1;
					state[ball_x][ball_y]=1;
					stateR[ball_x][ball_y]=1;
					stateG[ball_x][ball_y]=1;
					stateB[ball_x][ball_y]=1;
					go_mode=22;
				end			
			end
			else
			begin
				if(state[ball_x-1][ball_y-1]==1)//打到磚塊
				begin
				   state[ball_x-1][ball_y-1]=0;
					stateR[ball_x-1][ball_y-1]=0;
					stateG[ball_x-1][ball_y-1]=0;
					stateB[ball_x-1][ball_y-1]=0;
					point=point+1;
					go_mode=23;//右下
				end
				else
				begin
				   ball_x=ball_x-1;
					ball_y=ball_y-1;
					state[ball_x][ball_y]=1;
					stateR[ball_x][ball_y]=1;
					stateG[ball_x][ball_y]=1;
					stateB[ball_x][ball_y]=1;
					go_mode=12;
				end
			end
		end
		13:     //右上
		begin
			state[ball_x][ball_y] = 0;
			stateR[ball_x][ball_y] = 0;
			stateG[ball_x][ball_y] = 0;
			stateB[ball_x][ball_y] = 0;
			if (ball_x==7||ball_y==0)//右邊界或上邊界
			begin
			   if(ball_x==7&&ball_y==0)//右上的腳
				begin
				   ball_x=ball_x-1;
					ball_y=ball_y+1;
					state[ball_x][ball_y]=1;
					stateR[ball_x][ball_y]=1;
					stateG[ball_x][ball_y]=1;
					stateB[ball_x][ball_y]=1;
					go_mode= 22;//左下
				end
				else if(ball_x==7)//右邊界
				begin
					if(state[ball_x-1][ball_y-1]==1)
					begin
						state[ball_x-1][ball_y-1]=0;
						stateR[ball_x-1][ball_y-1]=0;
						stateG[ball_x-1][ball_y-1]=0;
						stateB[ball_x-1][ball_y-1]=0;
						point=point+1;
						state[ball_x][ball_y]=1;
						stateR[ball_x][ball_y]=1;
						stateG[ball_x][ball_y]=1;
						stateB[ball_x][ball_y]=1;
						go_mode=22;
					end
				   else
					begin
						ball_x=ball_x-1;
						ball_y=ball_y-1;
						state[ball_x][ball_y]=1;
						stateR[ball_x][ball_y]=1;
						stateG[ball_x][ball_y]=1;
						stateB[ball_x][ball_y]=1;
						go_mode=12;
					end
				end
				else//上邊界
				begin
					ball_x=ball_x+1;
					ball_y=ball_y+1;
					stateR[ball_x][ball_y]=1;
					stateG[ball_x][ball_y]=1;
					stateB[ball_x][ball_y]=1;
					state[ball_x][ball_y]=1;
					go_mode=23;
				end			
			end
			else//沒有打到邊界們
			begin
				if(state[ball_x+1][ball_y-1]==1)//打到磚塊
				begin
					state[ball_x+1][ball_y-1]=0;
					stateR[ball_x+1][ball_y-1]=0;
					stateG[ball_x+1][ball_y-1]=0;
					stateB[ball_x+1][ball_y-1]=0;
					point=point+1;
					go_mode=22;//左下
				end
				else//持續右上
				begin
				   ball_x=ball_x+1;
					ball_y=ball_y-1;
					state[ball_x][ball_y]=1;
					stateR[ball_x][ball_y]=1;
					stateG[ball_x][ball_y]=1;
					stateB[ball_x][ball_y]=1;
					go_mode=13;
				end
			end
		end
		21:      //直下
		begin
			state[ball_x][ball_y] = 0;
			stateR[ball_x][ball_y] = 0;
			stateG[ball_x][ball_y] = 0;
			stateB[ball_x][ball_y] = 0;
			if (ball_y==6 && ball_x >= panel_center-1 && ball_x <= panel_center+1)    //打到平台
			begin
				ball_y = ball_y - 1;
				if (ball_x == panel_center)     //打到平台中間
				begin
					go_mode = 11;
					state[ball_x][ball_y] = 1;
					stateR[ball_x][ball_y] = 1;
					stateG[ball_x][ball_y] = 1;
					stateB[ball_x][ball_y] = 1;
				end
				else //左或右                         
				begin
					if (ball_x == panel_center-1)  //打到平台左邊
					begin
						go_mode = 12;//左上
						if (ball_x-1 < 0)//左邊界
						begin
							ball_x = ball_x + 1;
							state[ball_x][ball_y] = 1;
							stateR[ball_x][ball_y] = 1;
							stateG[ball_x][ball_y] = 1;
							stateB[ball_x][ball_y] = 1;
							go_mode = 13;//右上
						end
						else//一直左上
						begin
							ball_x = ball_x - 1;
							state[ball_x][ball_y] = 1;
							stateR[ball_x][ball_y] = 1;
							stateG[ball_x][ball_y] = 1;
							stateB[ball_x][ball_y] = 1;
						end
					end
					else                           //打到平台右邊
					begin
						go_mode = 13;//右上
						if (ball_x + 1 > 7)//右邊界
						begin
							ball_x = ball_x - 1;
							go_mode = 12;//左上
							state[ball_x][ball_y] = 1;
							stateR[ball_x][ball_y] = 1;
						   stateG[ball_x][ball_y] = 1;
							stateB[ball_x][ball_y] = 1;
						end
						else//一直右上
						begin
							ball_x = ball_x + 1;
							state[ball_x][ball_y] = 1;
							stateR[ball_x][ball_y] = 1;
							stateG[ball_x][ball_y] = 1;
							stateB[ball_x][ball_y] = 1;
						end
					end
				end
			end
			else//沒有打到平台
			begin
				if (ball_y==7)//掉下去
				begin
					state[0] = 8'b10000001;
					state[1] = 8'b01000010;
					state[2] = 8'b00100100;
					state[3] = 8'b00011000;
					state[4] = 8'b00011000;
					state[5] = 8'b00100100;
					state[6] = 8'b01000010;
					state[7] = 8'b10000001;
					
					stateR[0] = 8'b10000001;
					stateR[1] = 8'b01000010;
					stateR[2] = 8'b00100100;
					stateR[3] = 8'b00011000;
					stateR[4] = 8'b00011000;
					stateR[5] = 8'b00100100;
					stateR[6] = 8'b01000010;
					stateR[7] = 8'b10000001;
					
					stateG[0] = 8'b00000000;
					stateG[1] = 8'b00000000;
					stateG[2] = 8'b00000000;
					stateG[3] = 8'b00000000;
					stateG[4] = 8'b00000000;
					stateG[5] = 8'b00000000;
					stateG[6] = 8'b00000000;
					stateG[7] = 8'b00000000;
					
					stateB[0] = 8'b00000000;
					stateB[1] = 8'b00000000;
					stateB[2] = 8'b00000000;
					stateB[3] = 8'b00000000;
					stateB[4] = 8'b00000000;
					stateB[5] = 8'b00000000;
					stateB[6] = 8'b00000000;
					stateB[7] = 8'b00000000;
					win<=8'b00000000;
					background=0;
					panel_center = 4;
					alreadyShoot = 0;
					ball_x = 4;
					ball_y = 6;
					go_mode = 11;
					point=0;
				end
				else//一直往下
				begin
					if(state[ball_x][ball_y+1] == 1)
					begin
						state[ball_x][ball_y+1] = 0;
						stateR[ball_x][ball_y+1] = 0;
						stateG[ball_x][ball_y+1] = 0;
						stateB[ball_x][ball_y+1] = 0;
						point=point+1;
						ball_y = ball_y - 1;
						state[ball_x][ball_y] = 1;
						stateR[ball_x][ball_y] = 1;
						stateG[ball_x][ball_y] = 1;
						stateB[ball_x][ball_y] = 1;
						go_mode=11;
					end
					else
					begin
						ball_y = ball_y + 1;
						state[ball_x][ball_y] = 1;
						stateR[ball_x][ball_y] = 1;
						stateG[ball_x][ball_y] = 1;
						stateB[ball_x][ball_y] = 1;
					end
				end
			end
		end
		22:      //左下
		begin
		   state[ball_x][ball_y] = 0;
			stateR[ball_x][ball_y] = 0;
			stateG[ball_x][ball_y] = 0;
			stateB[ball_x][ball_y] = 0;
			if(ball_y==7)//失敗
			begin
			   state[0] = 8'b10000001;
				state[1] = 8'b01000010;
				state[2] = 8'b00100100;
				state[3] = 8'b00011000;
				state[4] = 8'b00011000;
				state[5] = 8'b00100100;
				state[6] = 8'b01000010;
				state[7] = 8'b10000001;
			
			   stateR[0] = 8'b10000001;
				stateR[1] = 8'b01000010;
				stateR[2] = 8'b00100100;
				stateR[3] = 8'b00011000;
				stateR[4] = 8'b00011000;
				stateR[5] = 8'b00100100;
				stateR[6] = 8'b01000010;
				stateR[7] = 8'b10000001;
					
				stateG[0] = 8'b00000000;
				stateG[1] = 8'b00000000;
				stateG[2] = 8'b00000000;
				stateG[3] = 8'b00000000;
				stateG[4] = 8'b00000000;
				stateG[5] = 8'b00000000;
				stateG[6] = 8'b00000000;
				stateG[7] = 8'b00000000;
					
				stateB[0] = 8'b00000000;
				stateB[1] = 8'b00000000;
				stateB[2] = 8'b00000000;
				stateB[3] = 8'b00000000;
				stateB[4] = 8'b00000000;
				stateB[5] = 8'b00000000;
				stateB[6] = 8'b00000000;
				stateB[7] = 8'b00000000;
				win<=8'b00000000;
				background=0;
				panel_center = 4;
				alreadyShoot = 0;
				ball_x = 4;
				ball_y = 6;
				go_mode = 11;
				point=0;
			end
			else
			begin
			   if(ball_y==6)
				begin
					if((ball_x==panel_center||ball_x==panel_center+1||ball_x==panel_center-1))//打到板子
					begin
						if(ball_x==panel_center)
						begin
							ball_y=ball_y-1;
							state[ball_x][ball_y]=1;
							stateR[ball_x][ball_y]=1;
							stateG[ball_x][ball_y]=1;
							stateB[ball_x][ball_y]=1;
							go_mode=11;
						end
						else if(ball_x==panel_center-1)//打到底板左邊
						begin
							ball_x=ball_x-1;
							ball_y=ball_y-1;
							state[ball_x][ball_y]=1;
							stateR[ball_x][ball_y]=1;
							stateG[ball_x][ball_y]=1;
							stateB[ball_x][ball_y]=1;
							go_mode=12;
						end
						else//打到底板右邊
						begin
							ball_x=ball_x+1;
							ball_y=ball_y-1;
							state[ball_x][ball_y]=1;
							stateR[ball_x][ball_y]=1;
							stateG[ball_x][ball_y]=1;
							stateB[ball_x][ball_y]=1;
							go_mode=13;
						end
					end
					else
					begin//y+1
						ball_x=ball_x-1;
						ball_y=ball_y+1;				
					end
				end
				else if(ball_x==0)//左邊界
				begin
				   if(state[ball_x+1][ball_y+1]==1)
					begin
					   state[ball_x+1][ball_y+1]=0;
						stateR[ball_x+1][ball_y+1]=0;
						stateG[ball_x+1][ball_y+1]=0;
						stateB[ball_x+1][ball_y+1]=0;
						point=point+1;
						state[ball_x][ball_y]=1;
						stateR[ball_x][ball_y]=1;
						stateG[ball_x][ball_y]=1;
						stateB[ball_x][ball_y]=1;
						go_mode=13;
					end
					else
					begin
						ball_x=ball_x+1;
						ball_y=ball_y+1;
						state[ball_x][ball_y]=1;
						stateR[ball_x][ball_y]=1;
						stateG[ball_x][ball_y]=1;
						stateB[ball_x][ball_y]=1;
						go_mode=23;
					end
				end
				else if(state[ball_x-1][ball_y+1]==1)//打到磚塊
				begin
				   state[ball_x-1][ball_y+1]=0;
					stateR[ball_x-1][ball_y+1]=0;
					stateG[ball_x-1][ball_y+1]=0;
					stateB[ball_x-1][ball_y+1]=0;
					point=point+1;
					ball_x=ball_x+1;
					ball_y=ball_y-1;
				   state[ball_x][ball_y]=1;
					stateR[ball_x][ball_y]=1;
					stateG[ball_x][ball_y]=1;
					stateB[ball_x][ball_y]=1;
					go_mode=13;
				end
				else//持續左下
				begin
				   ball_x=ball_x-1;
					ball_y=ball_y+1;
				   state[ball_x][ball_y]=1;
					stateR[ball_x][ball_y]=1;
					stateG[ball_x][ball_y]=1;
					stateB[ball_x][ball_y]=1;
					go_mode=22;
				end
			end
		end
		23:      //右下
		begin
		   state[ball_x][ball_y] = 0;
			stateR[ball_x][ball_y] = 0;
			stateG[ball_x][ball_y] = 0;
			stateB[ball_x][ball_y] = 0;
			if(ball_y==7)//失敗
			begin
			   state[0] = 8'b10000001;
				state[1] = 8'b01000010;
				state[2] = 8'b00100100;
				state[3] = 8'b00011000;
				state[4] = 8'b00011000;
				state[5] = 8'b00100100;
				state[6] = 8'b01000010;
				state[7] = 8'b10000001;
				
				
			   stateR[0] = 8'b10000001;
				stateR[1] = 8'b01000010;
				stateR[2] = 8'b00100100;
				stateR[3] = 8'b00011000;
				stateR[4] = 8'b00011000;
				stateR[5] = 8'b00100100;
				stateR[6] = 8'b01000010;
				stateR[7] = 8'b10000001;
					
				stateG[0] = 8'b00000000;
				stateG[1] = 8'b00000000;
				stateG[2] = 8'b00000000;
				stateG[3] = 8'b00000000;
				stateG[4] = 8'b00000000;
				stateG[5] = 8'b00000000;
				stateG[6] = 8'b00000000;
				stateG[7] = 8'b00000000;
					
				stateB[0] = 8'b00000000;
				stateB[1] = 8'b00000000;
				stateB[2] = 8'b00000000;
				stateB[3] = 8'b00000000;
				stateB[4] = 8'b00000000;
				stateB[5] = 8'b00000000;
				stateB[6] = 8'b00000000;
				stateB[7] = 8'b00000000;
				win<=8'b00000000;
				background=0;
				panel_center = 4;
				alreadyShoot = 0;
				ball_x = 4;
				ball_y = 6;
				go_mode = 11;
				point=0;
			end
			else
			begin
			   if(ball_y==6)
				begin
					if((ball_x==panel_center||ball_x==panel_center+1||ball_x==panel_center-1))//打到板子
					begin
						if(ball_x==panel_center)
						begin
							ball_y=ball_y-1;
							state[ball_x][ball_y]=1;
							stateR[ball_x][ball_y]=1;
							stateG[ball_x][ball_y]=1;
							stateB[ball_x][ball_y]=1;
							go_mode=11;
						end
						else if(ball_x==panel_center-1)//打到底板左邊
						begin
							ball_x=ball_x-1;
							ball_y=ball_y-1;
							state[ball_x][ball_y]=1;
							stateR[ball_x][ball_y]=1;
							stateG[ball_x][ball_y]=1;
							stateB[ball_x][ball_y]=1;
							go_mode=12;
						end
						else//打到底板右邊
						begin
							ball_x=ball_x+1;
							ball_y=ball_y-1;
							state[ball_x][ball_y]=1;
							stateR[ball_x][ball_y]=1;
							stateG[ball_x][ball_y]=1;
							stateB[ball_x][ball_y]=1;
							go_mode=13;
						end
					end
					else
					begin//y+1
						ball_x=ball_x+1;
						ball_y=ball_y+1;
					end
				end
				else if(ball_x==7)//右邊界
				begin
				   if(state[ball_x-1][ball_y+1]==1)
					begin
					   state[ball_x-1][ball_y+1]=0;
						stateR[ball_x-1][ball_y+1]=0;
						stateG[ball_x-1][ball_y+1]=0;
						stateB[ball_x-1][ball_y+1]=0;
						point=point+1;
						state[ball_x][ball_y]=1;
						stateR[ball_x][ball_y]=1;
						stateG[ball_x][ball_y]=1;
						stateB[ball_x][ball_y]=1;
						go_mode=12;
					end
					else
					begin
						ball_x=ball_x-1;
						ball_y=ball_y+1;
						state[ball_x][ball_y]=1;
						stateR[ball_x][ball_y]=1;
						stateG[ball_x][ball_y]=1;
						stateB[ball_x][ball_y]=1;
						go_mode=22;
					end
				end
				else if(state[ball_x+1][ball_y+1]==1)//打到磚塊
				begin
				   state[ball_x+1][ball_y+1]=0;
					stateR[ball_x+1][ball_y+1]=0;
					stateG[ball_x+1][ball_y+1]=0;
					stateB[ball_x+1][ball_y+1]=0;
					point=point+1;
					ball_x=ball_x-1;
					ball_y=ball_y-1;
				   state[ball_x][ball_y]=1;
					stateR[ball_x][ball_y]=1;
					stateG[ball_x][ball_y]=1;
					stateB[ball_x][ball_y]=1;
					go_mode=12;//左上
				end
				else//持續右下
				begin
				   ball_x=ball_x+1;
					ball_y=ball_y+1;
				   state[ball_x][ball_y]=1;
					stateR[ball_x][ball_y]=1;
					stateG[ball_x][ball_y]=1;
					stateB[ball_x][ball_y]=1;
					go_mode=23;
				end
			end
		end	
		endcase//6
   end//begin alreadyShoot
  end
end

always @(posedge CLK_div)
begin
	whichCol = whichCol + 1;
end
assign EN=1;
assign lightR = ~stateR[whichCol];
assign lightG = ~stateG[whichCol];
assign lightB = ~stateB[whichCol];

endmodule
