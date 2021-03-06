function [ a, miu, sigmas, c, Qv ] = BaumWelch( a, miu, sigma, c, pi, obs, iterations )
    % iterations = 5;

    N = length(pi); % nr of states
    M = size(c,2); % nr of mixing components
    D = size(miu, 1); % dimension of multivariate normal variable
    T = size(obs, 2); % number of observations

    Qv = [];

    % multiplicate sigmas (initially they are the same for all states and components)
    % sigmas = [[sigma] x M x N] => M by N sigma
    sigmas = sigma_to_sigmas(sigma, N, M, D);


    for it=1:iterations
        % b
        b = b_cont( obs, miu, sigmas, c );
        % b component-wise
        b_c = b_cont_comp( obs, miu, sigmas, c );
        % alfa
        alfa = alfaf(obs, pi, a, b );
        % beta
    	Beta = betaf( obs, a, b );
        % xi
        xi = xif( obs, pi, a, miu, sigmas, b_c, c, alfa, Beta );
        % sum(sum(xi)) % = T, test ok
        % gama
        gama = gamaf(obs, a, b, alfa, Beta);
        % parametrii: a, miu, sigma, c

        % IN PROGRESS: check all indeces again

        % a*
        for i = 1:N
            for j = 1:N
                a(i, j) = sum(gama(i, j, :)) / sum(sum(gama(i, :, :)));
            end
        end
        
        % question: what about pi? 
        % daca in rest il folosim ca parte din a, cu o noua stare initiala.
        % aici ar trebui si el actualizat, nu?

        % c*
        for j = 1:N
            for k = 1:M
                [i_xi1, aux] = ij(1, j, 1, k, 1, M);
                [i_xi2, aux] = ij(1, j, 1, 1, 1, M);
                [i_xi3, aux] = ij(1, j, 1, M, 1, M);
                %c(j, k) = sum(xi((j - 1) * M + k, :)) /...
                %sum(sum(xi((j - 1) * M + 1 : j * M, :)));
                c(j, k) = sum(xi(i_xi1, :)) /...
                 sum(sum(xi(i_xi2:i_xi3, :))); % xi for all t and all components of state j
            end
        end    

        % miu*
        miu1 = zeros(D, N*M);
        for s = 1:N
            for k = 1:M
                % miu((s - 1) * M + k, :) = zeros(1, N*M);
                [aux, j_miu] = ij(s, 1, k, 1, M, D);
                for t = 1:T
                    [i_xi, j_xi] = ij(t, s, 1, k, 1, M);
                    %(xi(i_xi, j_xi) * obs(:, t));
                      miu1(:, j_miu) = miu1(:, j_miu) + (xi(i_xi, j_xi) * obs(:, t));
                end
                % miu1(:, j_miu);
                miu1(:, j_miu) = miu1(:, j_miu) / sum(xi(i_xi, :));
                % sum(xi(i_xi, :));
            end
        end
        miu = miu1; %??

        % sigma*
        sigmas1 = zeros(M*D, N*D);
        for s = 1:N
            for k = 1:M
                [i_s1, j_s1] = ij(s, k, 1, 1, D, D);
                [i_s2, j_s2] = ij(s, k, D, D, D, D);
                
                [aux, j_miu] = ij(s, 1, k, 1, M, D);
                % sigmas((k - 1) * D  + 1: k * D, (s - 1) * D + 1 : s * D) = sigma;
                for t = 1:T
                  [i_xi, j_xi] = ij(t, s, 1, k, 1, M);
                    sigmas1(i_s1:i_s2, j_s1:j_s2) = sigmas1(i_s1:i_s2, j_s1:j_s2) +...
                     xi(i_xi, j_xi) *...
                      ((obs(:, t) - miu(:, j_miu)) * ((obs(:, t) - miu(:, j_miu))'));
%                     sigmas1(i_s1:i_s2, j_s1:j_s2) = sigmas1(i_s1:i_s2, j_s1:j_s2) +...
%                         xi(i_xi, j_xi) * (obs(:,t)*obs(:,t)' - obs(:,t) * miu(:,j_miu)' - miu(:,j_miu)*obs(:,t)' + miu(:,j_miu)*miu(:,j_miu)');
                end
                sigmas1(i_s1:i_s2, j_s1:j_s2) = sigmas1(i_s1:i_s2, j_s1:j_s2) /...
                 sum(xi(i_xi, :));
            end
        end        
        sigmas = sigmas1; % ???
        %sigmas
        %xi


        % Q pt control - tre sa creasca (o sa fie negative)
        % Qam has the format of gama
%        Qam = zeros(N, N, T);
%         for i = 1:N
%             for j = 1:N
%                 for t = 1:T
%                     Qam(i, j, t) = gama(i, j, t) * log(a(i, j)); % this is ln
%                 end
%             end
%         end
%         Qa = sum(sum(sum(Qam)));
        Qa = sum(sum(sum(gama,3) .* log(a)));

        % Qbm has the format of xi
%         Qbm = zeros(N, T);
%         for s = 1:N
%             for k = 1:M
%                 for t = 1:T
%                     [i_xi, j_xi] = ij(t, s, 1, k, 1, M);
%                     [i_b, j_b] = ij(t, s, 1, k, 1, M); % same??
%                     Qbm(i_xi, t) = xi(i_xi, t) * log(b_c(i_b, t));
%                 end
%             end
%         end
%         Qb = sum(sum(Qbm));
        Qb = sum(sum(xi .* log(b_c)));
    
        % Qc has the format of xi
        Qcm = zeros(N*M, T);
        for s = 1:N
            for k = 1:M 
                for t = 1:T
                    [i_xi, j_xi] = ij(t, s, 1, k, 1, M);
                    Qcm(i_xi, t) = xi(i_xi, t) * log(c(s, k));
                end
            end
        end
        Qc = sum(sum(Qcm));
        
        Q = Qa + Qb + Qc;
        Qv = [Qv Q];

    end

   plot(1:iterations, Qv);
   

end

