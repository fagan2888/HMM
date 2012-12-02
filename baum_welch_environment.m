sigma = [4 2; 2 3];
sigmas = sigma_to_sigmas(sigma, 3, 2, 2);
sigma2 = [2 1; 1 3];
%sigmas = [sigma, sigma2, sigma2; sigma, sigma, sigma2];

c = [0.2 0.8; 0.5 0.5; 0.7 0.3];%; 0.2 0.8; 0.1 0.9];

miu = [2 -1 1 0 0  2;       1  1 0 1 2 -2];
%miu = rand(2, 6) * 10;
%[a, pi] = random_model(3);
a = [0.1 0.2 0.7; 0.5 0.3 0.2; 0.9 0.05 0.05];

[a2, pi2] = random_model(3);
% miu2 = ones(2, 10) * 5;
miu2 = miu + rand(2, 6) * 3 * (rand() - 0.5);
sigma2 = [2 1; 1 3];
sigma2=sigma;
sigmas2 = sigma_to_sigmas(sigma2, 3, 2, 2);
c2 = [0.3 0.7; 0.3 0.7; 0.5 0.5];% 0.4 0.6; 0.6 0.4];

obs = generate_obs_cont(10, pi, a, miu, sigma, c);
%b = b_cont( obs, miu, sigmas, c );
%b_c = b_cont_comp( obs, miu, sigmas, c );
%b = b_cont( obs, miu2, sigmas2, c2 );
%alfa = alfaf( obs, pi, a, b );
%Beta = betaf( obs, a, b );
%gama = gamaf(obs, a, b, alfa, Beta);

% [ a1, miu1, sigmas1, c1, Qv] = BaumWelch(a2, miu2, sigma2, c2, pi, obs);
