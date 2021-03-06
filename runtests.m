nr_1 = 0;
nr_2 = 0;
nr_t = 1;
T = 100;
M = 10;
obs_size = 10;
nr_states = 5;
sum_prob1 = zeros(1, M);
sum_prob2 = zeros(1, M);
for i=1:nr_t
    [prob1, prob2] = test_models_both(M, T, obs_size, nr_states);
    sum_prob1 = sum_prob1 + prob1;
    sum_prob2 = sum_prob2 + prob2;
    if prob1(1) == max(prob1)
        nr_1 = nr_1 + 1;
    end
    if prob2(1) == max(prob2)
	nr_2 = nr_2 + 1;
    end
end

sum_prob1 = sum_prob1/nr_t;
sum_prob2 = sum_prob2/nr_t;
sum_prob1
sum_prob2
%sum(sum_prob1)
%sum(sum_prob2)
probab1=nr_1/nr_t
probab2=nr_2/nr_t
over1_1=probab1*M
over1_2=probab2*M

plot(sum_prob1, '-.ob', 'LineWidth', 2, 'MarkerSize', 15)
hold on
plot(sum_prob2, '-.or', 'LineWidth', 2, 'MarkerSize', 15)
hold off
