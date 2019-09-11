function data_randomly = permutations(data,iterations)

data_randomly = zeros(numel(data),1);


for i = 1:iterations;
rand_pos = randperm(length(data)); %array of random positions
% new array with original data randomly distributed 
for k = 1:length(data)
    data_randomly(k) = data(rand_pos(k));
    
end

end


end

%% Moises 04.09.19