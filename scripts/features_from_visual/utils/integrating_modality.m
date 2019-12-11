function [ mu_t std_t ] = integrating_modality( mu_a, mu_b, std_a, std_b)
    mu_t = std_a.^2./(std_a.^2+std_b.^2).*mu_b  +  std_b.^2./(std_a.^2+std_b.^2).*mu_a;
    std_t = sqrt(1./(1./std_a.^2 + 1./std_b.^2));
end