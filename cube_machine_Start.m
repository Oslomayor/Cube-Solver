function varargout = cube_machine_Start(varargin)
% CUBE_MACHINE_START MATLAB code for cube_machine_Start.fig
%      CUBE_MACHINE_START, by itself, creates a new CUBE_MACHINE_START or raises the existing
%      singleton*.
%
%      H = CUBE_MACHINE_START returns the handle to a new CUBE_MACHINE_START or the handle to
%      the existing singleton*.
%
%      CUBE_MACHINE_START('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CUBE_MACHINE_START.M with the given input arguments.
%
%      CUBE_MACHINE_START('Property','Value',...) creates a new CUBE_MACHINE_START or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cube_machine_Start_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cube_machine_Start_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cube_machine_Start

% Last Modified by GUIDE v2.5 09-Jun-2019 18:59:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cube_machine_Start_OpeningFcn, ...
                   'gui_OutputFcn',  @cube_machine_Start_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before cube_machine_Start is made visible.
function cube_machine_Start_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cube_machine_Start (see VARARGIN)
% 调用子窗口
cube_machine_GUI;
% Choose default command line output for cube_machine_Start
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes cube_machine_Start wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = cube_machine_Start_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 根据所选摄像头ID，显示相应画面
global vid
global location
global box
global edge_x
global edge_y
global edge_w
global edge_h
edge_x = 280;edge_y = 145;edge_w = 345;edge_h = 345;
location = [edge_x edge_y edge_w edge_h]; %[280 145 345 345]
camera_ID = get(hObject,'value')-1;
vid = videoinput('winvideo',camera_ID,'MJPG_800x600');
set(vid,'ReturnedColorSpace','rgb');
vidRes = vid.VideoResolution; 
nBands = vid.NumberOfBands;
hImage = image(zeros(vidRes(2), vidRes(1), nBands));
preview(vid, hImage);
box = rectangle('Position',location,'LineWidth',2,'EdgeColor','r');
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% 搜索当前PC上的摄像头设备
camera_info = imaqhwinfo('winvideo');
camera_num =  size(camera_info.DeviceIDs,2);
camera_list = cell(1,camera_num+1);
camera_list{1} = '—请选择摄像头—';
for ii=1:camera_num
    info = imaqhwinfo('winvideo',ii);
    camera_list{ii+1} = info.DeviceName;
end
% 将可用摄像头添加至下拉列表
set(hObject,'String',camera_list);
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
axis off

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 捕获按钮
global img_name 
global img_cnt
global vid
global location
global flag_capture
global scom_flag
flag_capture = 1;
sequence_capture = {'call_move_R','call_move_F',...
    'call_move_D','call_move_L','call_move_B','call_move_U'};
% for ii = 1:6
    img = getsnapshot(vid);
    img = img(location(2):location(2)+location(4),location(1):location(1)+location(3),:);
    fpath = ['captures\',img_name{img_cnt},'.jpg'];
    imwrite(img,fpath);
    axes_value = ['handles.axes',num2str(img_cnt+1)];
    eval_value = ['axes(',axes_value,')'];
    eval(eval_value);
    imshow(fpath);
    % 拍摄下一个面
    if scom_flag == 1
        eval(sequence_capture{img_cnt});
    end
    if img_cnt == 6
        flag_capture = 0;
    end
    if img_cnt < 6
        img_cnt = img_cnt + 1;
    end
    text = img_name{img_cnt}(2);
    set(handles.text4,'string',text);
    pause(0.2);
% end

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 颜色识别
global cube_stateString
global cube_stateColor
path = [pwd,'\captures\'];
[cube_stateString,cube_stateColor] = colordetect(path);
Str1 = cube_stateColor(1:27);
Str2 = cube_stateColor(28:54);
Str = {Str1;Str2};
set(handles.text10,'string',Str);
set(handles.text6,'string',cube_stateString);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 解算
global cube_stateString
global move
move = kociemba(cube_stateString);
set(handles.text7,'string',move);

% --- Executes during object creation, after setting all properties.
function pushbutton1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% 捕获按钮
global img_name 
global img_cnt
img_cnt = 1;
img_name = {'1U','2R','3F','4D','5L','6B'};
% 创建保存魔方图像的文件夹
if exist('captures','dir') == 0
    mkdir('captures');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 打开串口按钮
global scom_flag;
global scom;
global port;
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
    % scom.TimerFcn = @receive_data;
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

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 关闭串口按钮
global scom_flag;
global scom;
global port;
if false == scom_flag
    return;
else
    fclose(scom);
    delete(scom);
    msgbox(strcat(port,' is closed.'));
end
% 接受串口数据
% function [data] = receive_data(~,~)
% global scom;
% data = fread(scom,10,'uint8');
% disp(data);
% warning off;

% --- Executes during object creation, after setting all properties.
function pushbutton4_CreateFcn(hObject, eventdata, handles)
% 打开串口按钮
global scom_flag;
global scom;
global port;
scom_flag = false;
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% ---机械指令---
% call_A_N90
function call_A_N90(~,~)
global scom;
fwrite(scom,'01111100');
fwrite(scom,13);
fwrite(scom,10);
% call_A_P90
function call_A_P90(~,~)
global scom;
fwrite(scom,'01001111');
fwrite(scom,13);
fwrite(scom,10);
% call_A_0
function call_A_0(~,~)
global scom;
fwrite(scom,'01110011');
fwrite(scom,13);
fwrite(scom,10);
% call_B_P90
function call_B_P90(~,~)
global scom;
fwrite(scom,'10001111');
fwrite(scom,13);
fwrite(scom,10);
% call_B_N90
function call_B_N90(~,~)
global scom;
fwrite(scom,'10111100');
% 13,10 为换行回车符
fwrite(scom,13);
fwrite(scom,10);
% call_B_0
function call_B_0(~,~)
global scom;
fwrite(scom,'10110011');
fwrite(scom,13);
fwrite(scom,10);
% call_A_catch
function call_A_catch(~,~)
global scom;
fwrite(scom,'01001100');
fwrite(scom,13);
fwrite(scom,10);
% call_A_lose
function call_A_lose(~,~)
global scom;
fwrite(scom,'01100001');
fwrite(scom,13);
fwrite(scom,10);
% call_B_catch
function call_B_catch(~,~)
global scom;
fwrite(scom,'10001100');
fwrite(scom,13);
fwrite(scom,10);
% call_B_lose
function call_B_lose(~,~)
global scom;
fwrite(scom,'10100001');
fwrite(scom,13);
fwrite(scom,10);
% call reset
function call_reset(~,~)
call_A_lose;
pause(0.01);
call_B_lose;
pause(0.01);
call_A_0;
pause(0.01);
call_B_0;
% call ready
function call_ready(~,~)
call_A_catch;
pause(0.01);
call_B_catch;
pause(0.01);
call_A_0;
pause(0.01);
call_B_0;
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
% call_X_N90
function call_X_N90(~,~)
call_X_P90;
call_X_P90;
call_X_P90;
% call_X_180
function call_X_180(~,~)
call_X_P90;
pause(0.2);
call_X_P90;
pause(0.2);
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
% call_Y_180
function call_Y_180(~,~)
call_Y_P90;
pause(0.2);
call_Y_P90;
pause(0.2);
% call_move_D
function call_move_D(~,~)
global flag_capture
if 0 == flag_capture
    call_B_P90;
    pause(0.4);
    call_B_lose;
    pause(0.4);
    call_B_0;
    pause(0.4);
    call_B_catch;
    pause(0.4);
else
    call_Y_N90;
    call_X_P90;
    call_Y_P90;
end
% call_move_Di
function call_move_Di(~,~)
call_B_N90;
pause(0.4);
call_B_lose;
pause(0.4);
call_B_0;
pause(0.4);
call_B_catch;
pause(0.4);
% call_move_D2
function call_move_D2(~,~)
call_move_D;
call_move_D;
% call_move_U
function call_move_U(~,~)
global flag_capture
if 0 == flag_capture
    call_X_180;
    call_move_D;
    call_X_180;
else
    call_Y_P90;
    call_X_P90;
    call_Y_P90;
end
% call_move_Ui
function call_move_Ui(~,~)
call_X_180;
call_move_Di;
call_X_180;
% call_move_U2
function call_move_U2(~,~)
call_X_180;
call_move_D2;
call_X_180;
% call_move_R
function call_move_R(~,~)
global flag_capture
if 0 == flag_capture
    call_X_P90;
    call_move_D;
    call_X_180;
    call_X_P90;
else
    call_X_N90;
    call_Y_N90;
end
% call_move_Ri
function call_move_Ri(~,~)
call_X_P90;
call_move_Di;
call_X_180;
call_X_P90;
% call_move_R2
function call_move_R2(~,~)
call_X_P90;
call_move_D2;
call_X_180;
call_X_P90;
% call_move_L
function call_move_L(~,~)
global flag_capture
if 0 == flag_capture
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
% call_move_Li
function call_move_Li(~,~)
call_X_180;
call_X_P90;
call_move_Di;
call_X_P90;
% call_move_L2
function call_move_L2(~,~)
call_X_180;
call_X_P90;
call_move_D2;
call_X_P90;
% call_move_F
function call_move_F(~,~)
global flag_capture
if 0 == flag_capture
    call_A_P90;
    pause(0.4);
    call_A_lose;
    pause(0.4);
    call_A_0;
    pause(0.4);
    call_A_catch;
    pause(0.4);
else
    call_X_P90;
end
% call_move_Fi
function call_move_Fi(~,~)
call_A_N90;
pause(0.4);
call_A_lose;
pause(0.4);
call_A_0;
pause(0.4);
call_A_catch;
pause(0.4);
% call_move_F2
function call_move_F2(~,~)
call_move_F;
call_move_F;
% call_move_B
function call_move_B(~,~)
global flag_capture
if 0 == flag_capture
    call_Y_180;
    call_move_F;
    call_Y_180;
else
    call_X_P90;
end
% call_move_Bi
function call_move_Bi(~,~)
call_Y_180;
call_move_Fi;
call_Y_180;
% call_move_B2
function call_move_B2(~,~)
call_Y_180;
call_move_F2;
call_Y_180;

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 执行还原按钮
global move
global scom_flag
step = strsplit(move{1});
step = strrep(step,'''','i');
lenth = size(step,2);
if scom_flag == 1
    call_Y_180;
    call_Y_180;
    call_X_180;
    call_X_180;
    for ii = 1 : lenth
        eval_value = strcat('call_move_',step{ii});
        eval(eval_value);
        disp(strcat(num2str(ii),'/',num2str(lenth)));
        pause(0.5);
    %     if mod(ii,3) == 0
    %         call_X_180;
    %         call_X_180;
    %     end
    end
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
call_ready;
call_Y_180;
call_Y_180;
call_X_180;
call_X_180;
% 捕获
pushbutton1_CreateFcn(hObject, eventdata, handles);
for ii = 1:6
    pushbutton1_Callback(hObject, eventdata, handles);
end
% 颜色识别
pushbutton2_Callback(hObject, eventdata, handles);
% 解算
pushbutton3_Callback(hObject, eventdata, handles);
% 执行还原
pushbutton6_Callback(hObject, eventdata, handles);


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global box
global location
[img_target, rect] = imcrop(handles.axes1);
location = fix(rect);
delete(box);% 删除原先的框
box = rectangle('Position',location,'LineWidth',2,'EdgeColor','r');
