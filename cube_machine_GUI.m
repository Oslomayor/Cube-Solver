% GUI for Magic Cube Machine 
% 双臂魔方机器的上位机
% Author: duzhentao
% Date: 2019-05-22

function cube_machine_GUI(~,~)

%% GUI Layout
figure('pos',[500 100 710 210],'menu','none','numbertitle','off','name','Cube Machine - DuZhentao');

%% 机械臂α和机械臂β，基于状态描述
uicontrol('pos',[200 10 80 40],'string','reset','callback',@call_reset,'fontsize',14);
uicontrol('pos',[420 10 80 40],'string','ready','callback',@call_ready,'fontsize',14);
uicontrol('pos',[30 90 40 30],'string','+90','callback',@call_A_P90,'fontsize',12);
uicontrol('pos',[70 90 40 30],'string','none','callback',@call_none,'fontsize',12);
uicontrol('pos',[30 130 40 30],'string','-90','callback',@call_A_N90,'fontsize',12);
uicontrol('pos',[70 130 40 30],'string','0','callback',@call_A_0,'fontsize',12);
uicontrol('pos',[30 170 40 30],'string','松','callback',@call_A_lose,'fontsize',12);
uicontrol('pos',[70 170 40 30],'string','夹','callback',@call_A_catch,'fontsize',12);
uicontrol('pos',[150 90 40 30],'string','+90','callback',@call_B_P90,'fontsize',12);
uicontrol('pos',[190 90 40 30],'string','none','callback',@call_none,'fontsize',12);
uicontrol('pos',[150 130 40 30],'string','-90','callback',@call_B_N90,'fontsize',12);
uicontrol('pos',[190 130 40 30],'string','0','callback',@call_B_0,'fontsize',12);
uicontrol('pos',[150 170 40 30],'string','松','callback',@call_B_lose,'fontsize',12);
uicontrol('pos',[190 170 40 30],'string','夹','callback',@call_B_catch,'fontsize',12);
uicontrol('Style','text','pos',[40 60 60 20],'string','机械臂α','fontsize',12);
uicontrol('Style','text','pos',[160 60 60 20],'string','机械臂β','fontsize',12);
uicontrol('Style','text','pos',[330 30 40 20],'string','串口','fontsize',12);
%% 串口模块
uicontrol('pos',[330 10 20 20],'string','开','callback',@start_serialport,'fontsize',8);
uicontrol('pos',[350 10 20 20],'string','关','callback',@close_serialport,'fontsize',8);
%% x轴和y轴，基于过程描述
uicontrol('pos',[260 170 40 30],'string','X+90','callback',@call_X_P90,'fontsize',11);
uicontrol('pos',[260 130 40 30],'string','X-90','callback',@call_X_N90,'fontsize',11);
uicontrol('pos',[260 90 40 30],'string','X180','callback',@call_X_180,'fontsize',11);
uicontrol('pos',[320 170 40 30],'string','Y+90','callback',@call_Y_P90,'fontsize',11);
uicontrol('pos',[320 130 40 30],'string','Y-90','callback',@call_Y_N90,'fontsize',11);
uicontrol('pos',[320 90 40 30],'string','Y180','callback',@call_Y_180,'fontsize',11);
uicontrol('Style','text','pos',[250 60 60 20],'string','X轴','fontsize',12);
uicontrol('Style','text','pos',[310 60 60 20],'string','Y轴','fontsize',12);
%% 'URFDLB'拧动按钮
uicontrol('pos',[390 170 40 30],'string','U','callback',@call_move_U,'fontsize',12);
uicontrol('pos',[390 130 40 30],'string','U''','callback',@call_move_Ui,'fontsize',12);
uicontrol('pos',[390 90 40 30],'string','U2','callback',@call_move_U2,'fontsize',12);
uicontrol('pos',[440 170 40 30],'string','R','callback',@call_move_R,'fontsize',12);
uicontrol('pos',[440 130 40 30],'string','R''','callback',@call_move_Ri,'fontsize',12);
uicontrol('pos',[440 90 40 30],'string','R2','callback',@call_move_R2,'fontsize',12);
uicontrol('pos',[490 170 40 30],'string','F','callback',@call_move_F,'fontsize',12);
uicontrol('pos',[490 130 40 30],'string','F''','callback',@call_move_Fi,'fontsize',12);
uicontrol('pos',[490 90 40 30],'string','F2','callback',@call_move_F2,'fontsize',12);
uicontrol('pos',[540 170 40 30],'string','D','callback',@call_move_D,'fontsize',12);
uicontrol('pos',[540 130 40 30],'string','D''','callback',@call_move_Di,'fontsize',12);
uicontrol('pos',[540 90 40 30],'string','D2','callback',@call_move_D2,'fontsize',12);
uicontrol('pos',[590 170 40 30],'string','L','callback',@call_move_L,'fontsize',12);
uicontrol('pos',[590 130 40 30],'string','L''','callback',@call_move_Li,'fontsize',12);
uicontrol('pos',[590 90 40 30],'string','L2','callback',@call_move_L2,'fontsize',12);
uicontrol('pos',[640 170 40 30],'string','B','callback',@call_move_B,'fontsize',12);
uicontrol('pos',[640 130 40 30],'string','B''','callback',@call_move_Bi,'fontsize',12);
uicontrol('pos',[640 90 40 30],'string','B2','callback',@call_move_B2,'fontsize',12);
uicontrol('Style','text','pos',[455 60 100 20],'string','URFDLB','fontsize',12);
uicontrol('Style','checkbox','pos',[555 60 120 20],'string','Capture','callback',@call_checkbox,'fontsize',12);

%% Serial Port
global scom_flag;
global scom;
global port;
scom_flag = false;

% 打开串口
function start_serialport(~,~)
serialinfo = instrhwinfo('serial');
port = serialinfo.SerialPorts;
if true == isempty(port)
    msgbox('Serial Port is not found.');
    return;
else
    scom = serial(port,'BaudRate',9600);
    scom.BytesAvailableFcnMode = 'byte';
    scom.Timeout = 1;
    scom.TimerPeriod = 2;
    %scom.TimerFcn = @receive_data;
end
try
    fopen(scom);
    if true == strcmp(scom.Status,'open')
        msgbox(strcat(port,' is opened.'));
        scom_flag = true;
    end
catch
    msgbox('Can not open Serial Port.');
    s = instrfind;
    fclose(s);
    delete(s);
end 
end

% 关闭串口  
function close_serialport(~,~)
if false == scom_flag
    return;
else
    fclose(scom);
    delete(scom);
    msgbox(strcat(port,' is closed.'));
end
end

end

% 接收串口数据
function [data] = receive_data(~,~)
global scom;
data = fread(scom,10,'uint8');
disp(data);
warning off;
end

% call_checkbox
function call_checkbox(hObject,~)
global value_checkbox
value_checkbox = get(hObject,'value');
end

%% 机械指令
% call_A_P90
function call_A_P90(~,~)
global scom;
fwrite(scom,'01001111');
fwrite(scom,13);
fwrite(scom,10);
end

% call_A_N90
function call_A_N90(~,~)
global scom;
fwrite(scom,'01111100');
fwrite(scom,13);
fwrite(scom,10);
end

% call_A_0
function call_A_0(~,~)
global scom;
fwrite(scom,'01110011');
fwrite(scom,13);
fwrite(scom,10);
end

% call_B_P90
function call_B_P90(~,~)
global scom;
fwrite(scom,'10001111');
fwrite(scom,13);
fwrite(scom,10);
end

% call_B_N90
function call_B_N90(~,~)
global scom;
fwrite(scom,'10111100');
% 13,10 为换行回车符
fwrite(scom,13);
fwrite(scom,10);
end

% call_B_0
function call_B_0(~,~)
global scom;
fwrite(scom,'10110011');
fwrite(scom,13);
fwrite(scom,10);
end

% call_A_catch
function call_A_catch(~,~)
global scom;
fwrite(scom,'01001100');
fwrite(scom,13);
fwrite(scom,10);
end

% call_A_lose
function call_A_lose(~,~)
global scom;
fwrite(scom,'01100001');
fwrite(scom,13);
fwrite(scom,10);
end

% call_B_catch
function call_B_catch(~,~)
global scom;
fwrite(scom,'10001100');
fwrite(scom,13);
fwrite(scom,10);
end

% call_B_lose
function call_B_lose(~,~)
global scom;
fwrite(scom,'10100001');
fwrite(scom,13);
fwrite(scom,10);
end

% call reset
function call_reset(~,~)
call_A_lose;
pause(0.1);
call_B_lose;
pause(0.1);
call_A_0;
pause(0.1);
call_B_0;
end

% call ready
function call_ready(~,~)
call_A_catch;
pause(0.1);
call_B_catch;
pause(0.1);
call_A_0;
pause(0.1);
call_B_0;
end

% call_X_P90
function call_X_P90(~,~)
call_B_lose;
pause(0.2);
call_A_P90;
pause(0.2);
call_B_catch;
pause(0.2);
call_A_lose;
pause(0.2);
call_A_0;
pause(0.2);
call_A_catch;
pause(0.2);
end

% call_X_N90
function call_X_N90(~,~)
call_X_P90;
call_X_P90;
call_X_P90;
end

% call_X_180
function call_X_180(~,~)
call_X_P90;
pause(0.2);
call_X_P90;
pause(0.2);
end

% call_Y_P90
function call_Y_P90(~,~)
call_A_lose;
pause(0.2);
call_B_P90;
pause(0.2);
call_A_catch;
pause(0.2);
call_B_lose;
pause(0.1);
call_B_0;
pause(0.3);
call_B_catch;
pause(0.2);
end

% call_Y_N90
function call_Y_N90(~,~)
call_A_lose;
pause(0.2);
call_B_N90;
pause(0.2);
call_A_catch;
pause(0.2);
call_B_lose;
pause(0.2);
call_B_0;
pause(0.2);
call_B_catch;
pause(0.2);
end

% call_Y_180
function call_Y_180(~,~)
call_Y_P90;
pause(0.2);
call_Y_P90;
pause(0.2);
end

% call_move_D
function call_move_D(~,~)
global value_checkbox
if 0 == value_checkbox
    call_B_P90;
    pause(0.4);
    call_B_lose;
    pause(0.4);
    call_B_0;
    pause(0.2);
    call_B_catch;
    pause(0.1);
else
    call_Y_N90;
    call_X_P90;
    call_Y_P90;
end
end
% call_move_Di
function call_move_Di(~,~)
call_B_N90;
pause(0.4);
call_B_lose;
pause(0.2);
call_B_0;
pause(0.2);
call_B_catch;
pause(0.1);
end
% call_move_D2
function call_move_D2(~,~)
call_move_D;
call_move_D;
end

% call_move_U
function call_move_U(~,~)
global value_checkbox
if 0 == value_checkbox
    call_X_180;
    call_move_D;
    call_X_180;
else
    call_Y_P90;
    call_X_P90;
    call_Y_P90;
end
end
% call_move_Ui
function call_move_Ui(~,~)
call_X_180;
call_move_Di;
call_X_180;
end
% call_move_U2
function call_move_U2(~,~)
call_X_180;
call_move_D2;
call_X_180;
end

% call_move_R
function call_move_R(~,~)
global value_checkbox
if 0 == value_checkbox
    call_X_P90;
    call_move_D;
    call_X_180;
    call_X_P90;
else
    call_X_N90;
    call_Y_N90;
end
end
% call_move_Ri
function call_move_Ri(~,~)
call_X_P90;
call_move_Di;
call_X_180;
call_X_P90;
end
% call_move_R2
function call_move_R2(~,~)
call_X_P90;
call_move_D2;
call_X_180;
call_X_P90;
end

% call_move_L
function call_move_L(~,~)
global value_checkbox
if 0 == value_checkbox
    call_X_180;
    call_X_P90;
    call_move_D;
    call_X_P90;
else
    call_Y_P90;
    call_X_P90;
    call_Y_N90;
    call_X_P90;
end
end
% call_move_Li
function call_move_Li(~,~)
call_X_180;
call_X_P90;
call_move_Di;
call_X_P90;
end
% call_move_L2
function call_move_L2(~,~)
call_X_180;
call_X_P90;
call_move_D2;
call_X_P90;
end

% call_move_F
function call_move_F(~,~)
global value_checkbox
if 0 == value_checkbox
    call_A_P90;
    pause(0.4);
    call_A_lose;
    pause(0.2);
    call_A_0;
    pause(0.2);
    call_A_catch;
    pause(0.2);
else
    call_X_P90;
end
end
% call_move_Fi
function call_move_Fi(~,~)
call_A_N90;
pause(0.4);
call_A_lose;
pause(0.2);
call_A_0;
pause(0.2);
call_A_catch;
pause(0.1);
end
% call_move_F2
function call_move_F2(~,~)
call_move_F;
call_move_F;
end

% call_move_B
function call_move_B(~,~)
global value_checkbox
if 0 == value_checkbox
    call_Y_180;
    call_move_F;
    call_Y_180;
else
    call_X_P90;
end
end
% call_move_Bi
function call_move_Bi(~,~)
call_Y_180;
call_move_Fi;
call_Y_180;
end
% call_move_B2
function call_move_B2(~,~)
call_Y_180;
call_move_F2;
call_Y_180;
end
