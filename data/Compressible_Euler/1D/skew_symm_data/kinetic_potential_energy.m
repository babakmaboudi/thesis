%% Compute kinetic and potential energy
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
    potential_energy = mesh.dx*sum(solution.pressure/(gamma-1));
    kinetic_energy = mesh.dx*sum(0.5*solution.mod_mom.^2);
    t = linspace(0,0.3,numel(potential_energy));
    plot(t,kinetic_energy); hold on 
    plot(t,potential_energy);
    % Save potential energy
    filename_energy_txt = strcat(['potential_energy_',num2str(n_basis(i)),'_',num2str(n_reduction(j)),'.txt']);
    fid = fopen(filename_energy_txt,'w');
    fprintf(fid,'%s\n',header_file);
    fclose(fid);
    dlmwrite(filename_energy_txt,[t' potential_energy'],'-append','delimiter',' ','precision',16);
    % Save total energy
    filename_energy_txt = strcat(['kinetic_energy_',num2str(n_basis(i)),'_',num2str(n_reduction(j)),'.txt']);
    fid = fopen(filename_energy_txt,'w');
    fprintf(fid,'%s\n',header_file);
    fclose(fid);
    dlmwrite(filename_energy_txt,[t' kinetic_energy'],'-append','delimiter',' ','precision',16);
  end
end
