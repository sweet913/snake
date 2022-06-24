#install.packages(beepr)
#����������

library(beepr)  # ��������
# ��ʼ����������
init<-function(){
  e<<-new.env()
  e$stage<-0 #������������
  e$width<-e$height<-20  #�зָ���
  e$step<-1/e$width #����
  e$m<-matrix(rep(0,e$width*e$height),nrow=e$width)  #�����
  e$dir<-e$lastd<-'up' # �ƶ�����
  e$head<-c(2,2) #��ʼ����ͷ
  e$lastx<-e$lasty<-2 # ��ʼ����ͷ��һ����
  e$tail<-data.frame(x=c(),y=c())#��ʼ��β
  
  e$col_bla<-1  # �����ϰ�����ɫ
  
  e$col_furit<-2 # ˮ����ɫ
  e$col_head<-4 # ��ͷ��ɫ
  e$col_tail<-8 # ��β��ɫ
  e$col_path<-0 # ·��ɫ
  e$eat_num<-0 # ���������Թ��Ӵ���
  
  e$bla<-c(10, 10)  # ��ʼ����ɫ�ϰ����λ������
  e$bla_lastx<-e$bla_lasty<-10  # ��ʼ����ɫλ��
  e$bla_A=1  # ���Ʒ���
  e$bla_B=1
}


# ��þ��������ֵ
index<-function(col) which(e$m==col)

# ��Ϸ��
stage1<-function(){
  e$stage<-1
  
  # �����ˮ����
  furit<-function(){
    if(length(index(e$col_furit))<=0){ #������ˮ��
      idx<-sample(index(e$col_path),1)
      
      fx<-ifelse(idx%%e$width==0,10,idx%%e$width)
      fy<-ceiling(idx/e$height)
      e$m[fx,fy]<-e$col_furit
      
      print(paste("furit idx",idx))
      print(paste("furit axis:",fx,fy))
    }
  }
  bla<-function(){
    e$bla_lastx<-e$bla[1]  # ��¼�ϰ���ԭ��λ��
    e$bla_lasty<-e$bla[2]
    e$bla[1]<-e$bla[1]-e$bla_A  # �ƶ�
    e$bla[2]<-e$bla[2]-e$bla_B
    if(e$m[e$bla[1], e$bla[2]] ==e$col_furit){
      e$bla[1] = e$bla[1] -1
    }  # �ж��Ƿ�����ˮ��
    if(e$bla[1] == 1 | e$bla[1] == 20) {
      e$bla_A=e$bla_A * -1  # ���ŷ�����
    }
    if(e$bla[2] == 1 | e$bla[2] == 20) {
      e$bla_B=e$bla_B * -1  # ���ŷ����򣬶����ϰ����ڻ����м��ƶ�
    }
  }
  # ���ʧ��
  fail<-function(){
    
    # ��ͷ���߽�
    if(length(which(e$head < 1))>0 | length(which(e$head > e$width))>0){
      print("game over: Out of ledge.")
      keydown('q')
      beep(3) # ��������������beepr���������������
      return(TRUE)
    }
    
    # ��ͷ������β
    if(e$m[e$head[1],e$head[2]]==e$col_tail){
      print("game over: head hit tail")
      keydown('q')
      beep(3)   # ��������������beepr���������������
      return(TRUE)
    }
    
    # �����β������ɫ�ϰ���Ҳ�������Ϸ
    if(e$m[e$bla[1], e$bla[2]] == e$col_tail){
      print("game over: tail hit black")
      keydown('q')
      beep(3) # ��������������beepr���������������
      return(TRUE)
    }
    
    # �����ͷ������ɫ�ϰ���Ҳ�������Ϸ
    if(e$head[1] == e$bla[1] & e$head[2]==e$bla[2]){ 
      print("game over: head hit black")
      keydown('q')
      beep(3)  # ��������������beepr���������������
      return(TRUE)
    }
    if(nrow(e$tail)>0){
      
    }
    
    return(FALSE)
  }
  
  
  # ��ͷ״̬
  head<-function(){
    e$lastx<-e$head[1]
    e$lasty<-e$head[2]
    
    # �������
    if(e$dir=='up') e$head[2]<-e$head[2]+1
    if(e$dir=='down') e$head[2]<-e$head[2]-1
    if(e$dir=='left') e$head[1]<-e$head[1]-1
    if(e$dir=='right') e$head[1]<-e$head[1]+1
    
  }
  
  # ��β״̬
  body<-function(){
    e$m[e$lastx,e$lasty]<-0
    e$m[e$bla_lastx, e$bla_lasty]<-0
    e$m[e$bla[1],e$bla[2]]<-e$col_bla
    e$m[e$head[1],e$head[2]]<-e$col_head 
    print(data.frame(x=e$lastx,y=e$lasty))
    if(e$eat_num == 3){  # e$eat_num�߱�ʾ����ˮ��������������������ˮ��
      e$tail<-rbind(e$tail,data.frame(x=e$lastx,y=e$lasty))  # ����ϲ�,���ӽ���
      e$eat_num<-0  # ���ó�ˮ������
    }
    if(length(index(e$col_furit))<=0){ #������ˮ��
      e$tail<-rbind(e$tail,data.frame(x=e$lastx,y=e$lasty))  # ����ϲ�
      beep(2)  # �������������õ���beepr���������������
      e$eat_num<-e$eat_num+1
    }
    
    
    if(nrow(e$tail)>0) { #�����β��
      e$tail<-rbind(e$tail,data.frame(x=e$lastx,y=e$lasty))
      e$m[e$tail[1,]$x,e$tail[1,]$y]<-e$col_path
      e$tail<-e$tail[-1,]
      e$m[e$lastx,e$lasty]<-e$col_tail
    }
    
    print(paste("snake idx",index(e$col_head)))
    print(paste("snake axis:",e$head[1],e$head[2]))
  }
  
  # ��������
  drawTable<-function(){
    plot(0,0,xlim=c(0,1),ylim=c(0,1),type='n',xaxs="i", yaxs="i")
  }
  
  # ���ݾ�������
  drawMatrix<-function(){
    idx<-which(e$m>0)
    px<- (ifelse(idx%%e$width==0,e$width,idx%%e$width)-1)/e$width+e$step/2
    py<- (ceiling(idx/e$height)-1)/e$height+e$step/2
    pxy<-data.frame(x=px,y=py,col=e$m[idx])
    points(pxy$x,pxy$y,col=pxy$col,pch=15,cex=4.4)
    text(0.5,0.8,label=paste("��ĵ÷�",nrow(e$tail)),cex=2,col=2)  
    # �����ĵ÷֣�ʹ�÷��ڻ�����ʵʱ��ʾ
  }
  
  furit()
  bla()
  head()
  if(!fail()){
    body()
    drawTable()
    drawMatrix()  
  }
}


# ������ͼ
stage0<-function(){
  e$stage<-0
  plot(0,0,xlim=c(0,1),ylim=c(0,1),type='n',xaxs="i", yaxs="i")
  text(0.5,0.7,label="Snake Game",cex=5)
  text(0.5,0.4,label="Any keyboard to start",cex=2,col=4)
  text(0.5,0.3,label="Up,Down,Left,Rigth to control direction",cex=2,col=2)
  text(0.2,0.05,label="Author:DanZhang",cex=1)
  text(0.5,0.05,label="http://blog.fens.me",cex=1)
}

# ������ͼ
stage2<-function(){
  e$stage<-2
  plot(0,0,xlim=c(0,1),ylim=c(0,1),type='n',xaxs="i", yaxs="i")
  text(0.5,0.7,label="Game Over",cex=5)
  text(0.5,0.4,label="Space to restart, q to quit.",cex=2,col=4)
  text(0.5,0.3,label=paste("Congratulations! You have eat",nrow(e$tail),"fruits!"),cex=2,col=2)
  text(0.2,0.05,label="Author:DanZhang",cex=1)
  text(0.5,0.05,label="http://blog.fens.me",cex=1)
}

# ��ͣ��ͼ
stage3<-function() {
  e$stage<-3
  plot(0,0,xlim=c(0,1),ylim=c(0,1),type='n',xaxs="i", yaxs="i")
  text(0.5,0.7,label="��Ϸ����ͣ",cex=5)
  text(0.5,0.4,label="����q�˳�������p����",cex=2,col=4)
  text(0.5,0.3,label=paste("Congratulations! You have eat",nrow(e$tail),"fruits!"),cex=2,col=2)
  text(0.2,0.05,label="Author:DanZhang",cex=1)
  text(0.5,0.05,label="http://blog.fens.me",cex=1)
}

# �����¼�
keydown<-function(K){
  print(paste("keydown:",K,",stage:",e$stage));
  
  if(e$stage==3) {# ��ͣ����
    if(K == "q"){
      stage2()  # �����q����������Ϸ
    } 
    if(K == "p"){
      stage1()  # �����p����������Ϸ
    }
    return(NULL)
  }
  
  if(e$stage==0){ # ��������
    init()
    stage1()
    return(NULL)
  }  
  
  if(e$stage==2){ # ��������
    if(K=="q") q()  
    else if(K==' ') stage0()  
    return(NULL)
  } 
  
  if(e$stage==1){ # ��Ϸ��
    if(K == "q") {
      stage2()  # �����q����������Ϸ
    } 
    if (K == "p") {
      stage3()  # �����p����������ͣ����
    } else {
      if(tolower(K) %in% c("up","down","left","right")){
        e$lastd<-e$dir
        e$dir<-tolower(K)
        stage1()  
      }
    }
  }
  
  
  return(NULL)
}

#######################################
# RUN  
#######################################  

run<-function(){
  par(mai=rep(0,4),oma=rep(0,4))
  e<<-new.env()
  stage0()
  
  # ע���¼�
  getGraphicsEvent(prompt="Snake Game",onKeybd=keydown)
}
x11()
run()
