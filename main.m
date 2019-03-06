clc
clear
inDir='/Users/matteo/www.physionet.org/pn4/eegmmidb/';
%outDir ... non salvi su inDir

fil_sbj='S*';

cases=dir(fullfile(inDir,fil_sbj));
%ts=['*R03.edf';'*R07.edf';'*R11.edf';'*R04.edf';'*R08.edf';'*R12.edf'];
ts=['*R03.edf';'*R07.edf';'*R11.edf'];

lf=13;
hf=30;
maxf=40;

fingerprint_t1=zeros(length(cases),length(ts),7,64);
fingerprint_t2=zeros(length(cases),length(ts),7,64);

for i=1:length(cases)
    i
    for j=1:size(ts,1)
        fil_tsk=ts(j,:);
        curr_edf=dir(fullfile(strcat(inDir,cases(i).name,'/'),fil_tsk));
        file_to_open=strcat(inDir,cases(i).name,'/',curr_edf.name);
        EEG=pop_biosig(file_to_open);
        [nodata, header]=ReadEDF(file_to_open);
        
        for ev=1:length(EEG.event)
            t1=0;
            t2=0;
            if strcmp(header.annotation.event{ev},'T1') && t1<8 
                t1=t1+1;
                my_curr_data=EEG.data(:,header.annotation.starttime(ev)*EEG.srate:header.annotation.starttime(ev)*EEG.srate+header.annotation.duration(ev)*EEG.srate);
                [Pxx,F] = pwelch(my_curr_data',[],[],[],EEG.srate);
                [low,indlow]=min(abs(F-lf));
                [high,indhigh]=min(abs(F-hf));
                [max,indmax]=min(abs(F-maxf));
                band_relative=sum(Pxx(indlow:indhigh,:))./sum(Pxx(1:indmax,:));
                fingerprint_t1(i,j,t1,:)=band_relative;
            end
            if strcmp(header.annotation.event{ev},'T2') && t2<8 
                t2=t2+1;
                my_curr_data=EEG.data(:,header.annotation.starttime(ev)*EEG.srate:header.annotation.starttime(ev)*EEG.srate+header.annotation.duration(ev)*EEG.srate);
                [Pxx,F] = pwelch(my_curr_data',[],[],[],EEG.srate);
                [low,indlow]=min(abs(F-lf));
                [high,indhigh]=min(abs(F-hf));
                [max,indmax]=min(abs(F-maxf));
                band_relative=sum(Pxx(indlow:indhigh,:))./sum(Pxx(1:indmax,:));
                fingerprint_t2(i,j,t2,:)=band_relative;
            end
        end    
    end       
end



