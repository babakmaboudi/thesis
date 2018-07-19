% n_basis = [ 24 51 75 102 126 153 177 201 225 252 276 303 327 351 375 402 426 450 ];
% n_reduction = [ 1 2 3 ];
n_basis = [ 24 102 201 ];
n_reduction = [ 1 ];

load('../../Data/mesh.mat');
load('../../Data/time.mat');
gamma = 1.4;

header_file = {'time','quantity'};
header_file = [header_file;repmat({' '},1,numel(header_file))]; 
header_file = header_file(:)';
header_file = cell2mat(header_file); 

for i=1:numel(n_basis)
  for j=1:numel(n_reduction)
    namefile = strcat(['data_',num2str(n_basis(i)),'_',num2str(n_reduction(j)),'.mat']);
    load(namefile);
    % Compute density and momemntum
    density = (solution.sqrt_density).^2;
    momentum = solution.mod_mom.*solution.sqrt_density;
    % Compute invariants
    mass = real(mesh.dx*sum(density));
    total_momentum = real(mesh.dx*sum(momentum));
    energy = real(mesh.dx*sum(solution.pressure/(gamma-1) + 0.5*solution.mod_mom.^2));
    mass(isnan(mass)) = 1000;
    total_momentum(isnan(total_momentum)) = 1000;
    energy(isnan(energy)) = 1000;
    mass(abs(mass)>100) = 100;
    total_momentum(abs(total_momentum)>100) = 100;
    energy(abs(energy)>100) = 100;
    t = linspace(0,0.3,numel(energy));
    % Save mass
    filename_mass_txt = strcat(['mass_',num2str(n_basis(i)),'_',num2str(n_reduction(j)),'.txt']);
    fid = fopen(filename_mass_txt,'w');
    fprintf(fid,'%s\n',header_file);
    fclose(fid);
    dlmwrite(filename_mass_txt,[t' mass'],'-append','delimiter',' ','precision',16);
    % Save momentum
    filename_momentum_txt = strcat(['momentum_',num2str(n_basis(i)),'_',num2str(n_reduction(j)),'.txt']);
    fid = fopen(filename_momentum_txt,'w');
    fprintf(fid,'%s\n',header_file);
    fclose(fid);
    dlmwrite(filename_momentum_txt,[t' total_momentum'],'-append','delimiter',' ','precision',16);
    % Save energy
    filename_energy_txt = strcat(['energy_',num2str(n_basis(i)),'_',num2str(n_reduction(j)),'.txt']);
    fid = fopen(filename_energy_txt,'w');
    fprintf(fid,'%s\n',header_file);
    fclose(fid);
    dlmwrite(filename_energy_txt,[t' energy'],'-append','delimiter',' ','precision',16);
  end
end