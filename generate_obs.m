function [ obs ] = generate_obs (T, a, b, pi )
obs = zeros(1, T);
i = index(pi);
for t=1:T
    obs(t) = index(b(i,:)) - 1;
    i = index(a(i,:));
end
end
