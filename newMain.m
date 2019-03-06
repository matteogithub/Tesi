inDir='C:\Users\Emanuele\Desktop\Data_Set\www.physionet.org\pn4\eegmmidb\';
outDir= 'C:\Users\Emanuele\Desktop\risultati';

fil_sbj='S*';

cases=dir(fullfile(inDir,fil_sbj));
ts=["*R03.edf";"*R07.edf";"*R11.edf";"*R04.edf";"*R08.edf";"*R12.edf"];

for i=1:3%length(cases)
    for j=1:length(ts)
        fil_tsk=ts(j,:);
        curr_edf = dir(fullfile(strcat(inDir,cases(i).name),fil_tsk));
        cd (curr_edf.folder);
        file_to_open=(curr_edf.name);

         [eeg_signal,HDR] = ReadEDF(file_to_open);
         tmp = cell2mat(eeg_signal);
         EEG_Signal = tmp';
         clear('tmp');
         
         
         if (j <= 3)
            %Task 1 (open and close left or right fist)
            [Left,Right]=ExtractionTmp(EEG_Signal,HDR);
            [R_pxx,R_f]= pwelch(Right',[],[],[],160);
            [L_pxx,L_f]= pwelch(Left',[],[],[],160);  
            files = fullfile(outDir,'task1',strtok(file_to_open,'.') );
            save (files,'R_pxx','R_f','L_pxx','L_f')
         
         elseif (j > 3)
             %Task 2 (imagine opening and closing left or right fist)
             [Left,Right]=ExtractionTmp(EEG_Signal,HDR);                       
             [R_pxx,R_f]= pwelch(Right',[],[],[],160);
             [L_pxx,L_f]= pwelch(Left',[],[],[],160);
             files = fullfile(outDir,'task2',strtok(file_to_open,'.') );
             save (files,'R_pxx','R_f','L_pxx','L_f')
         end
              
        
        %save(): parametr il nome da salvare!!! 'variabile.mat' help save
        %strtok(,'.')         
        
    end  
    
end



