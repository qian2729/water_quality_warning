function [descriptor]  = get_descriptor_from_cells(cell_h_state)
%input: h_state: 1*length cell, 
%output: 1*length cell, corresponding descriptor
    
    
    num=size(cell_h_state,2);
    descriptor=cell(1, num);
    
    for i=1:num
        length=size(cell_h_state{i},1);
        descriptor{1,i}=sum(squeeze(cell_h_state{i}))/length;
    end
    
    
end


