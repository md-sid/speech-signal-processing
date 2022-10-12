function timitData = processTimitFile(timitFilename)
%timitData = processTimitFile(timitFilename) takes the filename along with
%the path and provides the processed data in a struct format
%
% Exanple input: timitData = processTimitFile('./SA1')
% 
% The output timitData contains the following 7 fields
% waveform
% % count
% orthoData
% wordTimeStamps
% wordData
% phonTimeStamps
% phonData
% 

wavFileName = timitFilename + ".WAV";
orthoFileName = timitFilename + ".TXT";
wordFileName = timitFilename + ".WRD";
phoneticFileName = timitFilename + ".PHN";

fid = fopen(wavFileName);
fseek(fid,1024, -1); % skip header
[timitData.waveform,timitData.count]=fread(fid,inf,'int16'); % read speech data
fclose(fid);

orthoID = fopen(orthoFileName, 'r');
orthoData = fscanf(orthoID, '%c');
timitData.orthoData = strip(regexprep(orthoData,'[\d"]',''));
fclose(orthoID);

wordID = fopen(wordFileName, 'r');
tmpLine = fgetl(wordID);    % gives cell array
n = 1;
timitData.wordTimeStamps = zeros;
timitData.wordData = string;
while ischar(tmpLine)
    wordLine = split(tmpLine);
    timitData.wordTimeStamps(n, 1) = str2double(wordLine{1});
    timitData.wordTimeStamps(n, 2) = str2double(wordLine{2});
    timitData.wordData(n) = string(wordLine{3});
    tmpLine = fgetl(wordID);
    n = n + 1;
end
fclose(wordID);


phonID = fopen(phoneticFileName, 'r');
tmpLine = fgetl(phonID);    % gives cell array
n = 1;
timitData.phonTimeStamps = zeros;
timitData.phonData = string;
while ischar(tmpLine)
    phonLine = split(tmpLine);
    timitData.phonTimeStamps(n, 1) = str2double(phonLine{1});
    timitData.phonTimeStamps(n, 2) = str2double(phonLine{2});
    timitData.phonData(n) = string(phonLine{3});
    tmpLine = fgetl(phonID);
    n = n + 1;
end
fclose(phonID);

end