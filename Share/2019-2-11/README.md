# Go语言中管道堵塞+互斥死锁分析+dlv调试  

## 管道中的`<-`  

简单来说就是这样子的：接受者<-发送者。  

然而中间会多个管道，所以我借用Go语言圣经中的三处例子做解释  

```go
ch <- x  // x作为发送者发送给管道
x = <-ch // 管道作为发送者发送数据给接受者x
<-ch  // 管道发送数据，没有接收者，丢弃，同时造成管道堵塞，等待接收者
```

所以我们可以具体化刚才说的发送接收流程，它应该为：接收者 <- 管道 <- 发送者。如果缺了接收者或发送者，都会造成管道堵塞。  

## 互斥锁  

举个例子  

```go
import "sync"

var (
mu sync.Mutex   // guards balance
balance int
)

func Deposit(amount int) {
    mu.Lock()
    balance = balance + amount
    mu.Unlock()
}

func Balance() int {
    mu.Lock()
    b := balance
    mu.Unlock()
    return b
}
```
先Lock锁住，再使用Unlock解锁。  

如果Lock中再套一个Lock，就会造成死锁，需要将前一个Lock解开才行。  

笔记：在Lock和Unlock之间的代码段中的内容goroutine可以随便读取或者修改,这个代码段叫做临界区。goroutine在结束后释放锁是必要的,无论以哪条路径通过函数都需要释放,即使是在错误路径中,也要记得释放。  

## dlv调试  

dlv整体调试Go语言的流程如下  

```
1,./dlv debug xxxx(程序名)    ##启动dlv调试

2,r(restart)  

3,c(continue)

4,b(break)                   ##打断点，可以打函数名，也可以打文件下对应的行号

5,n(next)或s(step)           ##n按一次单步执行，后面只需一直按回车；遇到需要深究的函数按s进去查看

##如果碰到多线程，建议在线程内打个断点

6,bt(stack)                  ##查看堆栈

7,frame                      ##查看指定堆栈的内容

8,q(exit)                    ##退出调试
```
