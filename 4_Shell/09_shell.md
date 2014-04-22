---
## bash中的 $ 相关参数 
* $0 - 表示当前文件名
* $* - 以空格分离所有参数，形成一个字符串
* $@ - 以空格分离所有参数，形成一个字符串组合。与$*的不同表现在被""引用时，"$*"是一个字符串，而"$@"则包含多个字符串
* $# - 传递给进程的参数数目
* $? - 上一条命令的执行结果，没有错误时为0
* $$ - 本条命令的PID

### 测试脚本及输出
    $ cat test.sh 
    ```
        #!/bin/sh
        
        echo $0 $# $* $@
        echo '---------------'
        for arg in $*
        do
                echo $arg
        done
        echo '---------------'
        for arg in "$*"
        do
                echo $arg
        done
        echo '---------------'
        
        for arg in "$@"
        do
                echo $arg
        done
        echo '---------------'
        echo $? $$
    ```
    $ ./test.sh a b
    ```
        ./test.sh 2 a b a b
        ---------------
        a
        b
        ---------------
        a b
        ---------------
        a
        b
        ---------------
        0 27443
    ```

## Elementary bash comparison operators

String    Numeric    True if
x  = y    x -eq y    x is equal to y
x != y    x -ne y    x is not equal to y
x  < y    x -lt y    x is less than y
x <= y    x -le y    x is less than or equal to y
x  > y    x -gt y    x is greater than y
x >= y    x -ge y    x is greater than or equal to y
-n x         -       x is not null
-z x         -       x is null

## bash file evaluation operators

Operator             True if
-d file              file exists and is a directory
-e file              file exists 
-f file              file exists and is a regular file 
-r file              You have read permission on file 
-s file              file exists and is not empty
-w file              You have write permission on file
file1 -nt file2      file1 is newer than file2 
file1 -ot file2      file1 is older than file2

---
##  tar打包指定列表中列出的文件
    $ cat yourlist.lst  
        /etc/fstab  
        /home/admin/bin/somefile.sh  
        /home/mysql/somefile  
        ...  
    $ tar cvzf xxx.tar.gz -T yourlist.lst  

## REF
* [玩Linux五年积累的技巧(3) -- 系统（下）](http://blog.csdn.net/gaopenghigh/article/details/8654084)

---
## shell 命令制作
    ## 创建 hello 命令文件
    $ vim cmd_hello
    ## 简析 hello 命令
    $ cat cmd_hello
    ```
        #!/usr/bin/env bash
    
        echo 'hello'
    ```
    `#!/usr/bin/env bash` 表示通过 env 寻找 bash 来解释执行后面的脚本。
    `echo 'hello'` 通过标准输出字符串 hello 。    
    ## 添加执行权限
    $ chmod +x cmd_hello
    ## 运行命令
    $ ./cmd_hello
    ```
        hello
    ```

---
## sed 命令使用
    $ sed -e '/regexp/d' /path/to/my/test/file | more
    $ sed -n -e '/regexp/p' /path/to/my/test/file | more
    $ sed -n -e '/BEGIN/,/END/p' /my/test/file | more
### 常用正则表达式
    /./         将与包含至少一个字符的任何行匹配
    /../        将与包含至少两个字符的任何行匹配
    /^#/        将与以 '#' 开始的任何行匹配
    /^$/        将与所有空行匹配
    /}^/        将与以 '}'（无空格）结束的任何行匹配
    /} *^/      将与以 '}' 后面跟有 零或多个空格结束的任何行匹配
    /[abc]/     将与包含小写 'a'、'b' 或 'c' 的任何行匹配
    /^[abc]/    将与以 'a'、'b' 或 'c' 开始的任何行匹配 

---
## shell 功能命令
### 代码行数查看
    $ find ./ -name "*.c"  | xargs wc -l | sort -n
    ## 搜索 *.c, *.h, *.cc 三类文件
    $ find . \( -name "*.h" -o -name "*.c" -o -name "*.cc" \) -print | xargs wc -l 

---
## for / while loop
    $ cat ./for_test.sh
    ```
        #!/bin/sh
        
        ### for
        for file in $(ls $1) ; do
            ls -l $1$file
            echo "file name: $file"
        done
        
        ### while
        k=0
        end=5
        while [ $k -lt $end ]
        do
            printf "%d \n" $k
            k=$(expr $k + 1)
        done
    ```
    $ ./for_test.sh ./
    ```
        -rwxr-xr-x@ 1 apple  staff  180  5 29 20:58 ./for_test.sh
        file name: for_test.sh
        0 
        1 
        2 
        3 
        4 
    ```

---
## awk 打印文件内容
    awk "{print } " /proc/meminfo 

## ps 打印指定进程的线程信息

    ps -mp pid -o THREAD,tid,time

---
## 在当前目录的每个子文件夹下都创建一个同名文件(没有递归创建)
    $ for i in `ls`; do  if [ -d $i ]; then touch $i"/index.md"; fi; done
    
    for i in `ls`; do
        if [ -d $i ]; then
            touch $i"/index.md"
        fi
    done

---
## [我从其他Shell脚本中学到了什么？](http://www.csdn.net/article/2013-08-15/2816581-What-I-learned-from-other-s-shell-scripts)

### Colors your echo 
这里使用tput来设置颜色、文本设置并重置到正常颜色。想更多了解tput，请参阅[prompt-color-using-tput](http://linux.101hacks.com/ps1-examples/prompt-color-using-tput/)。

    #!/usr/bin/env bash

    NORMAL=$(tput sgr0)
    GREEN=$(tput setaf 2; tput bold)
    YELLOW=$(tput setaf 3)
    RED=$(tput setaf 1)
     
    function red() {
        echo -e "$RED$*$NORMAL"
    }
     
    function green() {
        echo -e "$GREEN$*$NORMAL"
    }
     
    function yellow() {
        echo -e "$YELLOW$*$NORMAL"
    }
     
    # To print success
    green "Task has been completed"
     
    # To print error
    red "The configuration file does not exist"
     
    # To print warning
    yellow "You have to use higher version."

---
## 非交互 ssh 密码验证
安装sshpass：
    
    $ sudo apt-get install sshpass # for ubuntu
    $ sudo port install sshpass    # for mac osx

安装完成后使用sshpass允许你用 -p 参数指定明文密码，然后直接登录远程服务器。例如：

    $ sshpass -p 'password' ssh username@serverip

用 '-p' 指定了密码后，还需要在后面跟上标准的 ssh 连接命令。

有了 sshpass 后远程执行命令将会非常方便，例如：

    $ sshpass -p 'password' ssh username@<serverip> 'uname'
    ```
        Linux
    ```
### REF
* [ssh自动输入密码登录服务器/ssh免输入密码登录/非交互ssh 密码验证](http://hi.baidu.com/sdusoul/item/6a69b6953853e630326eeb21)
* [SSH原理与运用（二）：远程操作与端口转发](http://www.ruanyifeng.com/blog/2011/12/ssh_port_forwarding.html)


## Some Tips

- shell 重定向
    
    ./command.sh > /dev/null 2>&1 # 命令不输出任何打印

- 文件追加
    
    echo "hello world" >> hello.txt
    echo "welcome" >> hello.txt
    cat hello.txt
    ```
        hello world
        welcome
    ```

- 算术运算

    i=0
    while [ $i -lt 5 ]
    do
        echo -n "$i, "
        i=`expr $i + 1`
    done
    ```
        0, 1, 2, 3, 4, 
    ```

---

## 加密文件

    $ openssl enc -aes-256-ofb -in file -out file.dat

## 解密文件

    $ openssl enc -aes-256-ofb -d -in file.dat > file

## 加密文件夹

    $ tar cz dic | openssl enc -aes-256-ofb -out dic.tar.gz.dat

## 解密文件夹

    $ openssl enc -aes-256-ofb -d -in dic.tar.gz.dat | tar xz

### REF

* [在Linux环境下使用OpenSSL对消息和文件进行加密](http://www.rising.com.cn/newsletter/news/2013-02-26/13227.html)

---
## shell 控制台设置

    # xTerm-256color
    export LS_OPTIONS='--color=auto'
    export CLICOLOR='Yes'
    #export LSCOLORS='Exfxcxdxbxegedabagacad'
    #http://imwuyu.me/blog/modify-mac-osx-terminal-prompt-and-color.html/
    #http://geoff.greer.fm/lscolors/
    export LSCOLORS='Cxfxcxdxbxegedabagacad'
    
    # Modify Terminal Prompt and Color
    case $(id -u) in
        0)
            STARTCOLOUR='\[\e[1;91m\]';
            ;;
        *)
            STARTCOLOUR='\[\e[1;93m\]';
            ;;
    esac
    ENDCOLOR="\[\e[0m\]"
    UNDERLINEBLUE="\[\e[0;32m\]"
    MYWORD="ϟSF-Hacking:"
    PS1="\n$STARTCOLOUR$MYWORD$ENDECOLOR $UNDERLINEBLUE\w$ENDCOLOR\n\$ ";

