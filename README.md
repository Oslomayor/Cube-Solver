# Cube-Solver
解魔方机器人

## 运行效果

### 视频演示 [YouKu Video](<https://v.youku.com/v_show/id_XNDIyOTI5NDkzNg==.html?spm=a2hzp.8253869.0.0&from=y1.7-2>)

### 1. 硬件机械平台

* 双臂双爪机械手，4个舵机，完成拧魔方的动作

* USB 摄像头，完成魔方图像拍摄

![](https://github.com/Oslomayor/Markdown-Imglib/blob/master/Imgs/Cube_Solver_Camera.jpg?raw=true)

### 2. 上位机程序

MATLAB 写的上位机，完成图像识别，魔方解算，通过串口发送机械运动步骤给单片机

![](https://github.com/Oslomayor/Markdown-Imglib/blob/master/Imgs/Cube_Solver_GUI.jpg?raw=true)

## 文件说明

### 1. MATLAB 程序文件

- cube_machine_Start.m

  主程序，将MATLAB文件放在同一目录下，运行该文件启动程序。

- cube_machine_Start.fig

  GUI界面文件。

- colordetect.m

  对魔方进行颜色识别，主要采用了K-means聚类算法，鲁棒性较好，室内自然光下颜色识别基本不会出错。

- cube_machine_GUI.m

  辅助控制机械手的子窗口界面，该文件采用纯代码编写，运行主程序自动启动，也可以单独启动。

- kociemba.m

  根据魔方颜色识别结果，进行解算，返回还原步骤。该文件通过网络端口调用德国数学家Kociemba的解魔方程序cube explorer 提供的API. [Kociemba主页](<http://kociemba.org/cube.htm>) (需要梯子访问)。 

* whitebalance.m

  白平衡算法，用于修正图像色差

### 2. 单片机程序

* STM32F103C8T6.zip

  采用串口通信接收上位机的指令，用PWM波控制舵机，完成魔方的拧动。

### 3. 魔方样本图片 

* samples100.zip

费好大劲制作的100套实拍魔方图片，为颜色识别的软件测试提供样本。

![](https://github.com/Oslomayor/Markdown-Imglib/blob/master/Imgs/cube/cube100.jpg?raw=true)

### 致谢

从2018年12月份开始构思，直到2019年6月完成了这项工作，许多细节难以一一描写(好吧...我承认让一只技术猿写一份文档，真的比调试上千行代码还难受)。这期间，十分感谢圈圈老师的关照指点以及杨同学的协作帮助，我们一起完成了这个极具挑战的任务，没有他们我无法顺利完成。

如果说人生的意思在于以自己喜欢的方式度过有价值的一生，那么作为一只技术猿，也一样...
