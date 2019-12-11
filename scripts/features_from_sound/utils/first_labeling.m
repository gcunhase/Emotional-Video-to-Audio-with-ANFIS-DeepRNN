file_name=cell(80,1);
addpath ./sound
addpath ./coversongs
for i=1:40
    s=sprintf('po%d.wav' , i);
    file_name{i}=s;
end

for i=1:40
    s=sprintf('nega%d.wav' , i);
    file_name{40+i}=s;
end

% %% 3D Tensor data
n= 2646000;
sound_matrix=zeros(n,80);
for i=1:80
    raw_sou=wavread(file_name{i});
    sound_matrix(:,i)=raw_sou(1:n,1);
end