function [ b ] = b_discrete (obs_size, nr_states)

b = [];
for i=1:nr_states
	b = [b; rand_prob_vect(obs_size)];
end

end
