function [descriptor]  = get_descriptor_from_h_state_of_one_activity(h_state)
%input: h_state: 1*length cell, each corresponds to l*1*num_base matrix
%output: 1*length cell, corresponding descriptor
    
    num=size(h_state,2);
    descriptor=cell(1, num);
    for i=1:num
        length=size(h_state{i},1);
        descriptor{1,i}=sum(squeeze(h_state{i}))/length;
    end
    
    
end


