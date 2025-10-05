# FPGA.github.io
author:110321077林聖崇
利用 FPGA 2388 8*8全彩矩陣實作一個打磚塊遊戲，包含：
1.LED 矩陣顯示磚塊、LED燈顯示分數
2.底板可左右移動反彈球
3.倒數計時（顯示在七段顯示器上）
4.支援暫停與重新開始
5.有4種關卡可以切換
各模組功能:
1.divfreq
分頻器，將輸入時鐘 CLK 分頻，產生遊戲邏輯運算需要的慢速時鐘。
2.divmove
控制遊戲暫停與移動速度的分頻器。當 pause = 1 時，暫停計數，不會推進遊戲。
3.countdown_timer
倒數計時器，初始值為 300 秒。每當計數器累積到 99999999 時，時間減一秒。
如果時間歸零，time_up 會被設為 1。
4.seven_segment_display
七段顯示器模組，將 0–9 的數字轉換成七段顯示器輸出 (LED_seg)。用來顯示剩餘時間。
5.project (主模組)
包含遊戲的主要邏輯：輸入控制
sw_L / sw_R → 控制底板左右移動
shoot → 發射球
pause → 遊戲暫停
clear → 重置遊戲
6.輸出
lightR, lightG, lightB → 控制 LED 矩陣顯示磚塊
whichCol → 指定哪一列 LED 被掃描
COMM, LED_seg → 七段顯示器顯示倒數計時
7.遊戲邏輯
紀錄 磚塊狀態 (state) 與 耐久度 (durability)。控制 球的座標 (ball_x, ball_y) 和 方向 (direction)。速度控制：球的移動速度會隨時間逐漸加快。
磚塊碰撞檢測：當球打到磚塊，會改變狀態並影響球的方向。倒數計時：若時間耗盡 (time_up=1)，遊戲結束。

<img width="271" alt="level1" src="https://github.com/user-attachments/assets/c496b986-c063-4452-9ff9-eb931dde6d82" />
