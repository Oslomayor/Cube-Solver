function [move] = kociemba(stateString)
% use the API of cube explorer
% make sure the web sever API is enabled
% Example:
% move = kociemba('uuuuuuuuurrrrrrrrrfffffffffdddddddddlllllllllbbbbbbbbb')
% Author£∫ duzhentao
% Date: 2019-01-11

head = 'http://127.0.0.1:8081/?';
url = [head, stateString];
res = urlread(url);
% ∆•≈‰≤ªµΩ L'
pat = '\w{1,2}''{0,1}\s\w[ \w'']*';
move = regexp(res, pat, 'match');
end