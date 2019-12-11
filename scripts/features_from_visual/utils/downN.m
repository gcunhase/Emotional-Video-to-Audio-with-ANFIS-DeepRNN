function [output_data]=downN(data, N)
    output_data=imresize(data,[N,N]);
end