## DX11 基础  
#### 设置设备  
- 渲染任何3D场景，首先要做的是创建三个对象：一个设备（device），一个直接的上下文（immediate context），一个交换链（swap chain）。  
设备用于执行渲染和资源的创建；交换链负责接收设备渲染的缓冲区，并在实际监视器屏幕上显示内容。  
- 资源视图允许资源在特定场合绑定到图形管道上。将资源视图看成是C语言中的类型转换。  

#### 修改消息循环  
一个bug：GetMessage()：  
如果应用程序窗口的队列中没有消息，则GetMessage()会阻塞，并且在消息可用之前不会返回。  
解决方案：  
可以使用PeekMessage()而不是GetMessage()来解决这个问题。 PeekMessage()可以检索像GetMessage()那样的消息，但是当没有消息等待时，PeekMessage()会立即返回而不是阻塞。 然后我们可以花时间做一些渲染。  

#### 渲染  
在Direct3D 11中，使用单一颜色填充渲染目标的简单方法是使用直接上下文的ClearRenderTargetView()方法。