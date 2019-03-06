function [Task_L,Task_R]=ExtractionTmp(EEG_Signal,HDR)
 m=1;
 n=1;
sample_duration = (HDR.annotation.duration)*(HDR.samplerate(1));
sample_starttime =(HDR.annotation.starttime)*(HDR.samplerate(1));

for k =1 :length(HDR.annotation.event)            
         if(HDR.annotation.event(k)== "T1")
            duration_eventT1(m) = sample_duration(k);
            starttime_eventT1(m)=sample_starttime(k); 
            m=m+1;
        elseif(HDR.annotation.event(k)== "T2")
            duration_eventT2(n) = sample_duration(k);
            starttime_eventT2(n) = sample_starttime(k);   
            n=n+1;
            
         end
end

%%
% Creation Masks event T1 (mask_T1)  end event T2 (mask_T2)

nn =size(EEG_Signal,2);
mask_T1 = zeros(1,nn);
mask_T2 = zeros(1,nn);

for tt = 1 : length(starttime_eventT1)
   mask_T1(1,(starttime_eventT1(tt) : starttime_eventT1(tt)+duration_eventT1(tt)))=1;
end

for tt = 1 : length(starttime_eventT2)
   mask_T2(1,(starttime_eventT2(tt) : starttime_eventT2(tt)+duration_eventT2(tt)))=1;
end

%% 
%   Creation  Matrix Task for all 64 channal with just the event T1 (Task_1_L) 
%   or T2 (Task_1_R)

Task_L =zeros(size(EEG_Signal,1),size(EEG_Signal,2));
Task_R =zeros(size(EEG_Signal,1),size(EEG_Signal,2));

 for i = 1 : size(EEG_Signal,1) 
 
    Task_L(i,:) = EEG_Signal(i,:).* mask_T1;
 
    Task_R(i,:) = EEG_Signal(i,:).* mask_T2;   
  end
end
 