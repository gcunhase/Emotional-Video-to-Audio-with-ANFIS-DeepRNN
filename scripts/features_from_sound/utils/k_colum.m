function Y = k_colum(X,n)
% example 
%   X = [1 2 3 4 5 6 7 8 9 10]
%   Y = [1 2 3; 4 5 6; 7 8 9; 10]
l=length(X);
m=l/n;
if ceil(m)~=floor(m)
    disp('error')
    return
end

Y=zeros(m,n);

for i=1:m
    Y(i,:)=X(n*(i-1)+1:n*i);
end
end